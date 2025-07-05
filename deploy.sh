#!/bin/bash

# Cores para mensagens
C_BLUE='\033[0;34m'
C_GREEN='\033[0;32m'
C_RED='\033[0;31m'
C_YELLOW='\033[1;33m'
C_NC='\033[0m' # No Color

set -e

# --- 1. Verificar dependências ---
echo -e "${C_BLUE}--- Verificando dependências (Git, Docker)... ---${C_NC}"
if ! command -v git &> /dev/null; then
    echo -e "${C_RED}Erro: Git não está instalado.${C_NC}"
    exit 1
fi
if ! command -v docker &> /dev/null; then
    echo -e "${C_RED}Erro: Docker não está instalado.${C_NC}"
    exit 1
fi

echo -e "${C_GREEN}Dependências OK.${C_NC}"

# --- 2. Clonar Supabase se necessário ---
if [ ! -d "supabase" ]; then
    echo -e "${C_BLUE}A clonar o Supabase oficial...${C_NC}"
    git clone --depth 1 https://github.com/supabase/supabase
fi

# --- 3. Preparar diretório do projeto Supabase ---
if [ ! -d "supabase-project" ]; then
    mkdir supabase-project
fi
cp -rf supabase/docker/* supabase-project
cp supabase/docker/.env.example supabase-project/.env

# --- 3.1. Copiar código do frontend Astro para dentro do projeto Supabase ---
if [ -d "supabase-project/astro-frontend" ]; then
    rm -rf supabase-project/astro-frontend
fi
mkdir supabase-project/astro-frontend
rsync -av --exclude 'supabase' --exclude 'supabase-project' --exclude 'node_modules' --exclude '.git' ./ supabase-project/astro-frontend/

# Garantir Dockerfile do frontend
cp ./supabase-project/astro-frontend/Dockerfile ./supabase-project/astro-frontend/Dockerfile

# Garantir docker-compose.yml atualizado
cp ./supabase-project/docker-compose.yml ./supabase-project/docker-compose.yml

# --- 4. Gerar segredos e configurar CORS ---
POSTGRES_PASSWORD=$(openssl rand -hex 16)
JWT_SECRET=$(openssl rand -hex 32)
STUDIO_PASSWORD=$(openssl rand -hex 16)

read -p "Vai usar domínio? (s/N): " HAS_DOMAIN
if [[ "$HAS_DOMAIN" =~ ^[Ss]$ ]]; then
    read -p "Digite o domínio (ex: www.seusite.com): " DOMAIN
    APP_URL="https://$DOMAIN"
else
    read -p "Digite o IP público do VPS: " IP
    APP_URL="http://$IP:4322"
fi

# Editar .env com segredos e CORS
sed -i "s/^POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=$POSTGRES_PASSWORD/" supabase-project/.env
sed -i "s/^JWT_SECRET=.*/JWT_SECRET=$JWT_SECRET/" supabase-project/.env
sed -i "s/^STUDIO_PASSWORD=.*/STUDIO_PASSWORD=$STUDIO_PASSWORD/" supabase-project/.env
sed -i "s|^ADDITIONAL_CORS_ORIGINS=.*|ADDITIONAL_CORS_ORIGINS=$APP_URL|" supabase-project/.env

# --- 5. Integrar schema.sql se existir ---
if [ -f "schema.sql" ]; then
    mkdir -p supabase-project/volumes/db/init
    cp schema.sql supabase-project/volumes/db/init/00-schema.sql
    echo -e "${C_GREEN}Schema SQL integrado.${C_NC}"
fi

# --- 6. Iniciar Supabase ---
cd supabase-project
echo -e "${C_BLUE}A fazer pull das imagens Docker oficiais...${C_NC}"
docker compose pull
echo -e "${C_BLUE}A iniciar todos os serviços...${C_NC}"
docker compose up -d

# --- 7. Mostrar instruções finais ---
echo -e "\n${C_GREEN}SUCESSO! Supabase self-hosted está a correr.${C_NC}"
echo -e "Aceda ao Supabase Studio em: ${C_YELLOW}http://<SEU_IP>:8000${C_NC} (user: supabase, password: $STUDIO_PASSWORD)"
echo -e "O seu frontend Astro deve usar:\nPUBLIC_SUPABASE_URL=http://<SEU_IP>:8000\nPUBLIC_SUPABASE_ANON_KEY=$(grep ANON_KEY .env | cut -d '=' -f2)"
echo -e "Para logs: ${C_YELLOW}docker compose logs -f${C_NC}"
