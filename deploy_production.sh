#!/bin/bash

# Termina o script imediatamente se um comando falhar
set -e

# Imprime cada comando antes de o executar para depuração
set -x

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
  echo -e "${C_RED}Erro: Este script precisa de ser executado como root. Por favor, use 'sudo ./deploy_production.sh'${C_NC}"
  exit 1
fi

# Instalar Docker, Docker Compose e Git
echo -e "\n${C_BLUE}A instalar dependências (Docker, Git...)${C_NC}"
apt-get update > /dev/null
apt-get install -y docker.io docker-compose-v2 git > /dev/null

# Instalar NVM e Node.js
echo -e "${C_BLUE}A instalar NVM e Node.js v20...${C_NC}"
# O `nvm` é instalado no diretório HOME do utilizador que executa o script (root)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash > /dev/null
export NVM_DIR="/root/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Carregar o nvm na sessão atual
nvm install 20 > /dev/null
nvm use 20 > /dev/null
source /root/.nvm/nvm.sh # Garantir que o nvm está disponível para os próximos comandos

# --- 2.A Configurar Firewall ---
echo -e "${C_BLUE}A configurar o firewall (UFW)...${C_NC}"
apt-get install -y ufw > /dev/null
ufw allow ssh   # Manter o acesso SSH
ufw allow http  # Para o Caddy obter certificados
ufw allow https # Para o tráfego do site
ufw --force enable > /dev/null

# --- 2. Recolher Informação do Utilizador ---
echo -e "\n${C_YELLOW}Preciso de alguma informação sua:${C_NC}"
# Define the application repository URL (hardcoded for public access)
GIT_REPO_URL="https://github.com/speedshadow/astrovpn.git"
echo -e "${C_BLUE}Using public repository: $GIT_REPO_URL${C_NC}"

read -p "Você tem um nome de domínio para usar (s/n)? " HAS_DOMAIN

# --- 3. Gerar Segredos de Produção ---
echo -e "\n${C_BLUE}A gerar segredos de produção seguros...${C_NC}"
DB_PASSWORD=$(openssl rand -base64 32)
JWT_SECRET=$(openssl rand -base64 32)
ANON_KEY=$(openssl rand -hex 32)
SERVICE_KEY=$(openssl rand -hex 32)

# --- 4. Configurar e Iniciar o Supabase ---
echo -e "\n${C_BLUE}A configurar o Supabase...${C_NC}"
mkdir -p /opt # Garante que o diretório existe
cd /opt
if [ -d "supabase-prod" ]; then
    echo "A diretoria 'supabase-prod' já existe. A saltar o clone."
else
    # Anular qualquer auxiliar de credenciais que possa interferir com um clone público
    git config --global --unset-all credential.helper
    git clone --depth 1 https://github.com/supabase/docker.git supabase-prod
    if [ $? -ne 0 ]; then
        echo -e "${C_RED}Erro: Falha ao clonar o repositório do Supabase.${C_NC}"
        exit 1
    fi
fi
cd supabase-prod
cp docker/example.env docker/.env

# Substituir os segredos no ficheiro .env do Supabase
sed -i "s|POSTGRES_PASSWORD=postgres|POSTGRES_PASSWORD=$DB_PASSWORD|g" docker/.env
sed -i "s|JWT_SECRET=super-secret-jwt-token-with-at-least-32-characters-long|JWT_SECRET=$JWT_SECRET|g" docker/.env
# As chaves no example.env são longas, por isso usamos um delimitador diferente no sed
sed -i "s|ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0|ANON_KEY=$ANON_KEY|g" docker/.env
sed -i "s|SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU|SERVICE_ROLE_KEY=$SERVICE_KEY|g" docker/.env

echo -e "${C_BLUE}A iniciar os contentores do Supabase... (Isto pode demorar alguns minutos)${C_NC}"
docker compose -f docker/docker-compose.yml up -d > /dev/null

# --- 5. Configurar a Aplicação Astro ---
echo -e "\n${C_BLUE}A configurar a sua aplicação Astro...${C_NC}"
cd /opt
git clone "$GIT_REPO_URL" app > /dev/null
cd app

# --- 5.A Aplicar Schema da Base de Dados ---
echo -e "\n${C_BLUE}A aguardar que a base de dados do Supabase esteja pronta...${C_NC}"
sleep 30 # Dar tempo para o contentor da BD iniciar completamente

echo -e "${C_BLUE}A instalar o cliente PostgreSQL...${C_NC}"
apt-get install -y postgresql-client-common postgresql-client > /dev/null

MIGRATION_DB_URL="postgresql://postgres:$DB_PASSWORD@127.0.0.1:54322/postgres"

echo -e "${C_BLUE}A aplicar o schema da base de dados (schema.sql)...${C_NC}"
if [ -f "schema.sql" ]; then
    PGPASSWORD=$DB_PASSWORD psql "$MIGRATION_DB_URL" -f schema.sql > /dev/null
    echo -e "${C_GREEN}Schema da base de dados aplicado com sucesso.${C_NC}"
else
    echo -e "${C_YELLOW}Aviso: Ficheiro schema.sql não encontrado. A saltar a migração da base de dados.${C_NC}"
fi

# --- Lógica Condicional para Domínio ou IP ---
if [[ "$HAS_DOMAIN" =~ ^[Ss]$ ]]; then
    # --- 5.1 Configuração com Domínio (RECOMENDADO) ---
    read -p "Qual é o seu nome de domínio (ex: astrovpn.com)? " DOMAIN_NAME
    read -p "Qual é o seu email para o certificado SSL (ex: eu@exemplo.com)? " SSL_EMAIL
    if [ -z "$DOMAIN_NAME" ] || [ -z "$SSL_EMAIL" ]; then
        echo -e "${C_RED}Erro: O nome de domínio e o email são obrigatórios.${C_NC}"
        exit 1
    fi

    SUPABASE_URL="https://supabase.$DOMAIN_NAME"
    APP_URL="https://$DOMAIN_NAME"

    # Criar o ficheiro .env para a aplicação Astro
    cat <<EOL > .env
PUBLIC_SUPABASE_URL=$SUPABASE_URL
PUBLIC_SUPABASE_ANON_KEY=$ANON_KEY
SUPABASE_DB_PASSWORD=$DB_PASSWORD
DATABASE_URL=postgresql://postgres:$DB_PASSWORD@127.0.0.1:54322/postgres
PORT=4321
EOL

    echo -e "${C_BLUE}A instalar dependências e a compilar o site...${C_NC}"
    npm install > /dev/null
    npm run build > /dev/null

    echo -e "${C_BLUE}A iniciar o servidor da aplicação Astro...${C_NC}"
    echo -e "${C_BLUE}A instalar o gestor de processos PM2...${C_NC}"
    npm install -g pm2 > /dev/null

    echo -e "${C_BLUE}A iniciar o servidor da aplicação Astro com PM2...${C_NC}"
    pm2 start ./dist/server/entry.mjs --name astrovpn
    pm2 startup
    pm2 save


    # Configurar o Web Server (Caddy) com HTTPS Automático
    echo -e "${C_BLUE}A configurar o web server Caddy com HTTPS...${C_NC}"
    cd /opt

    cat <<EOL > Caddyfile
{
    email $SSL_EMAIL
}
supabase.$DOMAIN_NAME {
    reverse_proxy supabase-prod-kong-1:8000
}
$DOMAIN_NAME {
    reverse_proxy 127.0.0.1:4321
}
EOL

    cat <<EOL > docker-compose.caddy.yml
version: '3.8'
services:
  caddy:
    image: caddy:2-alpine
    restart: unless-stopped
    ports: ["80:80", "443:443"]
    volumes: ["./Caddyfile:/etc/caddy/Caddyfile", "/opt/app:/opt/app", "caddy_data:/data", "caddy_config:/config"]
    networks: ["supabase-prod_default"]
volumes:
  caddy_data:
  caddy_config:
networks:
  supabase-prod_default:
    external: true
EOL

    echo -e "${C_BLUE}A iniciar o Caddy...${C_NC}"
    docker compose -f docker-compose.caddy.yml up -d > /dev/null

else
    # --- 5.2 Configuração com IP (NÃO SEGURO) ---
    read -p "Qual é o endereço IP público do seu VPS? " IP_ADDRESS
    if [ -z "$IP_ADDRESS" ]; then
        echo -e "${C_RED}Erro: O endereço IP é obrigatório.${C_NC}"
        exit 1
    fi
    echo -e "\n${C_RED}AVISO: Você escolheu usar um IP. O seu site NÃO TERÁ HTTPS e usará a porta 4322.${C_NC}"
    echo -e "${C_RED}Esta configuração é INSEGURA e só deve ser usada para testes.${C_NC}"
    read -p "Pressione [Enter] para continuar se compreende os riscos."

    SUPABASE_URL="http://$IP_ADDRESS:8000"
    APP_URL="http://$IP_ADDRESS:4322"

    # Criar o ficheiro .env para a aplicação Astro
    cat <<EOL > .env
PUBLIC_SUPABASE_URL=$SUPABASE_URL
PUBLIC_SUPABASE_ANON_KEY=$ANON_KEY
SUPABASE_DB_PASSWORD=$DB_PASSWORD
DATABASE_URL=postgresql://postgres:$DB_PASSWORD@127.0.0.1:54322/postgres
PORT=4322
EOL

    # Expor a porta do Supabase Kong
    sed -i '/kong:/,/^\s*$/s/#- 8000:8000/- 8000:8000/' /opt/supabase-prod/docker/docker-compose.yml
    echo -e "${C_BLUE}A reiniciar o Supabase para expor a porta 8000...${C_NC}"
    cd /opt/supabase-prod && docker compose -f docker/docker-compose.yml up -d --force-recreate > /dev/null
    cd /opt/app

    echo -e "${C_BLUE}A instalar dependências e a iniciar o site em modo de produção...${C_NC}"
    npm install > /dev/null
    npm run build > /dev/null
    echo -e "${C_BLUE}A instalar o gestor de processos PM2...${C_NC}"
    npm install -g pm2 > /dev/null

    echo -e "${C_BLUE}A iniciar o servidor da aplicação Astro com PM2...${C_NC}"
    pm2 start ./dist/server/entry.mjs --name astrovpn -- --port 4322
    pm2 startup
    pm2 save

fi

# --- 6. Conclusão e Informação Importante ---
echo -e "\n${C_GREEN}=====================================================${C_NC}"
echo -e "${C_GREEN}  🎉 IMPLEMENTAÇÃO CONCLUÍDA COM SUCESSO! 🎉  ${C_NC}"
echo -e "${C_GREEN}=====================================================${C_NC}"

echo -e "\nO seu site está disponível em: ${C_YELLOW}$APP_URL${C_NC}"
echo -e "A sua API do Supabase está disponível em: ${C_YELLOW}$SUPABASE_URL${C_NC}"

echo -e "\n${C_RED}ATENÇÃO: GUARDE ESTES SEGREDOS NUM LOCAL SEGURO (ex: gestor de passwords).${C_NC}"
echo -e "${C_RED}Estes são os conteúdos do seu ficheiro .env do Supabase em /opt/supabase-prod/docker/.env${C_NC}"
echo -e "-----------------------------------------------------"
cat /opt/supabase-prod/docker/.env
echo -e "-----------------------------------------------------"

if [[ "$HAS_DOMAIN" =~ ^[Ss]$ ]]; then
    echo -e "\nPara ver os logs do Caddy, corra: ${C_YELLOW}cd /opt && docker compose -f docker-compose.caddy.yml logs -f${C_NC}"
else
    echo -e "\nPara ver os logs do seu site, corra: ${C_YELLOW}cat /opt/app/astro.log${C_NC}"
fi
echo -e "Para ver os logs do Supabase, corra: ${C_YELLOW}cd /opt/supabase-prod && docker compose -f docker/docker-compose.yml logs -f${C_NC}"

