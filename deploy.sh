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
echo -e "${C_BLUE}Vou configurar o Supabase, o seu site e o HTTPS automaticamente.${C_NC}"

# Verificar se o script está a ser executado como root
if [ "$(id -u)" -ne 0 ]; then
  echo -e "${C_RED}Erro: Este script precisa de ser executado como root. Por favor, use 'sudo ./deploy.sh'${C_NC}"
  exit 1
fi

# Instalar dependências essenciais
echo -e "\n${C_BLUE}A instalar dependências (Docker, Git, Caddy...)${C_NC}"
apt-get update
apt-get install -y docker.io docker-compose-v2 git curl

# Instalar Caddy (Reverse Proxy com HTTPS automático)
echo -e "\n${C_BLUE}A instalar o Caddy...${C_NC}"
apt-get install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
apt-get update
apt-get install -y caddy

# --- 2. Recolher Informação do Utilizador ---
echo -e "\n${C_YELLOW}Preciso de alguma informação sua:${C_NC}"
read -p "Qual é o URL do seu repositório Git (ex: https://github.com/seu_usuario/astrovpn.git)? " GIT_REPO_URL
if [ -z "$GIT_REPO_URL" ]; then
    echo -e "${C_RED}Erro: O URL do repositório é obrigatório.${C_NC}"
    exit 1
fi

read -p "Qual é o seu nome de domínio (ex: astrovpn.com)? " DOMAIN_NAME
if [ -z "$DOMAIN_NAME" ]; then
    echo -e "${C_RED}Erro: O nome de domínio é obrigatório para produção.${C_NC}"
    exit 1
fi
read -p "Qual é o seu email (para o certificado SSL da Let's Encrypt)? " LETSENCRYPT_EMAIL
if [ -z "$LETSENCRYPT_EMAIL" ]; then
    echo -e "${C_RED}Erro: O email é obrigatório para o SSL.${C_NC}"
    exit 1
fi

# --- 3. Gerar Segredos de Produção ---
echo -e "\n${C_BLUE}A gerar segredos de produção seguros...${C_NC}"
DB_PASSWORD=$(openssl rand -base64 32)
JWT_SECRET=$(openssl rand -base64 32)
ANON_KEY=$(openssl rand -hex 32)
SERVICE_KEY=$(openssl rand -hex 32)

# --- 4. Configurar e Iniciar o Supabase ---
echo -e "\n${C_BLUE}A configurar e a iniciar o Supabase via Docker...${C_NC}"
SUPABASE_DIR="/opt/supabase-prod"
rm -rf $SUPABASE_DIR # Limpar o diretório antigo, se existir
git clone --depth 1 https://github.com/supabase/docker.git $SUPABASE_DIR
cd $SUPABASE_DIR/docker

# Criar o ficheiro .env do Supabase
cp .env.example .env
sed -i "s/POSTGRES_PASSWORD=postgres/POSTGRES_PASSWORD=$DB_PASSWORD/g" .env
sed -i "s/JWT_SECRET=super-secret-jwt-token-with-at-least-32-characters-long/JWT_SECRET=$JWT_SECRET/g" .env
sed -i "s/ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQw54bKwuK0GJ8uYwR4so/ANON_KEY=$ANON_KEY/g" .env
sed -i "s/SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.M--toB_3_0i4HPeAq1Jsn02cpU9EVt8ie+IFclNfUoM/SERVICE_ROLE_KEY=$SERVICE_KEY/g" .env

# Iniciar os contentores Supabase
echo -e "\n${C_BLUE}A iniciar os contentores do Supabase... (Isto pode demorar alguns minutos na primeira vez)${C_NC}"
docker compose up -d

# --- 5. Configurar Aplicação Astro ---
echo -e "\n${C_BLUE}A configurar a aplicação Astro...${C_NC}"

# Instalar NVM (Node Version Manager) e Node.js
export NVM_DIR="$HOME/.nvm" && (git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR" && cd "$NVM_DIR" && git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`)
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
source $HOME/.bashrc || true # Usar 'true' para não falhar em shells não-interativos
nvm install 20 # Instalar Node.js v20 (LTS)
nvm use 20

# Instalar PM2 globalmente
npm install -g pm2

# Clonar o repositório
APP_DIR="/var/www/astrovpn"
echo -e "\n${C_BLUE}A clonar o repositório para ${APP_DIR}...${C_NC}"
rm -rf $APP_DIR # Limpar o diretório antigo, se existir
git clone $GIT_REPO_URL $APP_DIR
cd $APP_DIR

# Criar o ficheiro .env
echo -e "\n${C_BLUE}A criar o ficheiro .env...${C_NC}"
cat << EOF > .env
# Supabase
# A aplicação Astro e o Supabase estão no mesmo servidor, por isso usamos localhost.
PUBLIC_SUPABASE_URL=http://localhost:8000
PUBLIC_SUPABASE_ANON_KEY=$ANON_KEY

# Outras variáveis (se necessário)
# Ex: GOOGLE_ANALYTICS_ID=...
EOF

# Instalar dependências e fazer o build
echo -e "\n${C_BLUE}A instalar dependências NPM e a fazer o build...${C_NC}"
npm install
npm run build

# --- 6. Configurar Caddy e Iniciar Aplicação ---
echo -e "\n${C_BLUE}A configurar o Caddy (Reverse Proxy)...${C_NC}"

# Criar o Caddyfile
cat << EOF > /etc/caddy/Caddyfile
$DOMAIN_NAME {
    reverse_proxy localhost:4321
    encode gzip
    tls $LETSENCRYPT_EMAIL

    # Headers de segurança recomendados
    header {
        # Ativar HSTS
        Strict-Transport-Security "max-age=31536000;"
        # Prevenir clickjacking
        X-Frame-Options "DENY"
        # Prevenir XSS
        X-XSS-Protection "1; mode=block"
        # Definir política de conteúdo
        X-Content-Type-Options "nosniff"
        # Remover a assinatura do servidor
        -Server
    }
}
EOF

# Reiniciar o Caddy para aplicar as alterações
systemctl reload caddy

# Iniciar a aplicação com PM2
echo -e "\n${C_BLUE}A iniciar a aplicação com PM2...${C_NC}"
cd $APP_DIR
pm2 start npm --name astrovpn -- run start
pm2 startup
pm2 save

# --- 7. Conclusão ---
echo -e "\n${C_GREEN}🎉 Implementação concluída com sucesso! 🎉${C_NC}"
echo -e "O seu site deve estar acessível em: ${C_YELLOW}https://$DOMAIN_NAME${C_NC}"
echo -e "Pode monitorizar a sua aplicação com o comando: ${C_YELLOW}pm2 monit${C_NC}"

