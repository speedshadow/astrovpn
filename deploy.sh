#!/bin/bash

# === AstroVPN & Supabase Production Deployment Script ===
# Este script automatiza a implementação completa da sua aplicação e do Supabase
# num servidor VPS Linux limpo (como Ubuntu 22.04).
# Executa como root para instalar dependências.

set -e # Termina o script imediatamente se um comando falhar

# --- Cores para uma melhor legibilidade ---
C_BLUE='\033[0;34m'
C_GREEN='\033[0;32m'
C_RED='\033[0;31m'
C_YELLOW='\033[1;33m'
C_NC='\033[0m' # No Color

# --- 1. Boas-vindas e Verificação de Pré-requisitos ---
echo -e "${C_BLUE}Bem-vindo ao script de implementação de produção do AstroVPN!${C_NC}"

# Verificar se o script está a ser executado como root
if [ "$(id -u)" -ne 0 ]; then
  echo -e "${C_RED}Erro: Este script precisa de ser executado como root. Por favor, use 'sudo ./deploy.sh'${C_NC}"
  exit 1
fi

# Instalar dependências essenciais
echo -e "\n${C_BLUE}A instalar dependências (Docker, Git...)${C_NC}"
apt-get update
apt-get install -y docker.io docker-compose-v2 git curl

# --- 2. Recolher Informação do Utilizador ---
echo -e "\n${C_YELLOW}Preciso de alguma informação sua:${C_NC}"
read -p "Qual é o URL do seu repositório Git? " GIT_REPO_URL
if [ -z "$GIT_REPO_URL" ]; then
    echo -e "${C_RED}Erro: O URL do repositório é obrigatório.${C_NC}"
    exit 1
fi

read -p "Você tem um nome de domínio pronto a usar? (s/N) " HAS_DOMAIN

# --- 3. Gerar Segredos de Produção ---
echo -e "\n${C_BLUE}A gerar segredos de produção seguros...${C_NC}"
DB_PASSWORD=$(openssl rand -base64 32)
JWT_SECRET=$(openssl rand -base64 32)
ANON_KEY=$(openssl rand -hex 32)
SERVICE_KEY=$(openssl rand -hex 32)

# --- 4. Configurar e Iniciar o Supabase ---
echo -e "\n${C_BLUE}A configurar e a iniciar o Supabase via Docker...${C_NC}"
SUPABASE_DIR="/opt/supabase-prod"
rm -rf $SUPABASE_DIR
git clone --depth 1 https://github.com/supabase/docker.git $SUPABASE_DIR
cd $SUPABASE_DIR/docker

cp .env.example .env
sed -i "s/POSTGRES_PASSWORD=postgres/POSTGRES_PASSWORD=$DB_PASSWORD/g" .env
sed -i "s/JWT_SECRET=super-secret-jwt-token-with-at-least-32-characters-long/JWT_SECRET=$JWT_SECRET/g" .env
sed -i "s|ANON_KEY=.*|ANON_KEY=$ANON_KEY|g" .env
sed -i "s|SERVICE_ROLE_KEY=.*|SERVICE_ROLE_KEY=$SERVICE_KEY|g" .env

# Se não tiver domínio, expor a porta do Supabase publicamente
if [[ ! "$HAS_DOMAIN" =~ ^[Ss]$ ]]; then
    echo -e "${C_YELLOW}A expor a porta 8000 do Supabase, pois não foi fornecido um domínio.${C_NC}"
    sed -i '/kong:/,/^\s*$/s/#- 8000:8000/- 8000:8000/' ./docker-compose.yml
fi

echo -e "\n${C_BLUE}A iniciar os contentores do Supabase...${C_NC}"
docker compose up -d

# --- 5. Configurar Aplicação Astro ---
echo -e "\n${C_BLUE}A configurar a aplicação Astro...${C_NC}"

# Instalar NVM e Node.js
export NVM_DIR="$HOME/.nvm" && (git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR" && cd "$NVM_DIR" && git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`)
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
source $HOME/.bashrc || true
nvm install 20
nvm use 20

# Instalar PM2
npm install -g pm2

# Clonar o repositório
APP_DIR="/var/www/astrovpn"
rm -rf $APP_DIR
git clone $GIT_REPO_URL $APP_DIR
cd $APP_DIR

# --- 6. Configuração Específica (Domínio vs IP) ---
if [[ "$HAS_DOMAIN" =~ ^[Ss]$ ]]; then
    # --- Configuração com Domínio (HTTPS) ---
    read -p "Qual é o seu nome de domínio (ex: astrovpn.com)? " DOMAIN_NAME
    read -p "Qual é o seu email (para o certificado SSL)? " LETSENCRYPT_EMAIL

    echo -e "\n${C_BLUE}A criar o ficheiro .env para o domínio...${C_NC}"
    cat << EOF > .env
PUBLIC_SUPABASE_URL=http://localhost:8000
PUBLIC_SUPABASE_ANON_KEY=$ANON_KEY
EOF

    npm install
    npm run build

    echo -e "\n${C_BLUE}A instalar e configurar o Caddy...${C_NC}"
    apt-get install -y debian-keyring debian-archive-keyring apt-transport-https
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
    apt-get update
    apt-get install -y caddy

    cat << EOF > /etc/caddy/Caddyfile
$DOMAIN_NAME {
    reverse_proxy localhost:4321
    encode gzip
    tls $LETSENCRYPT_EMAIL
}
EOF
    systemctl reload caddy

    pm2 start npm --name astrovpn -- run start
    pm2 startup
    pm2 save

    echo -e "\n${C_GREEN}🎉 Implementação com domínio concluída! 🎉${C_NC}"
    echo -e "O seu site deve estar acessível em: ${C_YELLOW}https://$DOMAIN_NAME${C_NC}"

else
    # --- Configuração com IP (HTTP) ---
    read -p "Qual é o endereço IP público do seu servidor? " IP_ADDRESS
    echo -e "\n${C_RED}AVISO: O site será executado em HTTP, que não é seguro para produção.${C_NC}"

    echo -e "\n${C_BLUE}A criar o ficheiro .env para o IP...${C_NC}"
    cat << EOF > .env
PUBLIC_SUPABASE_URL=http://$IP_ADDRESS:8000
PUBLIC_SUPABASE_ANON_KEY=$ANON_KEY
EOF

    npm install
    npm run build

    pm2 start npm --name astrovpn -- run start
    pm2 startup
    pm2 save

    echo -e "\n${C_GREEN}🎉 Implementação com IP concluída! 🎉${C_NC}"
    echo -e "O seu site deve estar acessível em: ${C_YELLOW}http://$IP_ADDRESS:4321${C_NC}"
fi

echo -e "Pode monitorizar a sua aplicação com o comando: ${C_YELLOW}pm2 monit${C_NC}"

