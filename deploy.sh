#!/bin/bash

# Cores para uma melhor legibilidade
C_BLUE='\033[0;34m'
C_GREEN='\033[0;32m'
C_RED='\033[0;31m'
C_YELLOW='\033[1;33m'
C_NC='\033[0m' # No Color

# --- Etapa 1: Verificação de Dependências ---
echo -e "${C_BLUE}--- Etapa 1: A verificar dependências (Git, Docker)... ---${C_NC}"

# Verificar Git
if ! command -v git &> /dev/null; then
    echo -e "${C_RED}Erro: Git não está instalado. Por favor, instale o Git e tente novamente.${C_NC}"
    exit 1
fi

# Verificar Docker
if ! command -v docker &> /dev/null; then
    echo -e "${C_RED}Erro: Docker não está instalado. Por favor, instale o Docker e tente novamente.${C_NC}"
    exit 1
fi

echo -e "${C_GREEN}Dependências encontradas.${C_NC}"

# --- Etapa 2: Preparar o Ambiente Supabase ---
echo -e "\n${C_BLUE}--- Etapa 2: A preparar o ambiente Supabase... ---${C_NC}"

if [ ! -d "supabase/docker" ]; then
    echo "A clonar o repositório oficial do Supabase para a pasta 'supabase'..."
    # Clonar para uma pasta temporária e mover para evitar problemas com git submodules
    git clone --depth 1 https://github.com/supabase/supabase.git _tmp_supabase && \
    mv _tmp_supabase supabase && \
    rm -rf _tmp_supabase || { echo -e "${C_RED}Erro ao clonar o repositório do Supabase.${C_NC}"; exit 1; }
else
    echo -e "${C_YELLOW}O directório 'supabase' já existe. A saltar a clonagem.${C_NC}"
fi

# Copiar o schema da base de dados para o local correto para ser auto-importado
cp ./schema.sql ./supabase/docker/volumes/db/init/00-schema.sql

echo -e "${C_GREEN}Ambiente Supabase preparado.${C_NC}"

# --- Etapa 3: Configuração do Domínio/IP e Segredos ---
echo -e "\n${C_BLUE}--- Etapa 3: A configurar o acesso e os segredos... ---${C_NC}"

read -p "Você tem um nome de domínio a apontar para o IP deste VPS? (s/N) " HAS_DOMAIN

# Gerar segredos
POSTGRES_PASSWORD=$(openssl rand -hex 16)
JWT_SECRET=$(openssl rand -hex 32)

# Obter a ANON_KEY do ficheiro de exemplo do Supabase
ANON_KEY=$(grep 'ANON_KEY=' ./supabase/docker/.env.example | cut -d '=' -f2)

# Criar o ficheiro .env principal que será usado pelo docker-compose
cat <<EOL > .env
# Segredos para a Base de Dados e API
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
JWT_SECRET=${JWT_SECRET}

# Chaves da API (a ANON_KEY é pública e segura para expor)
ANON_KEY=${ANON_KEY}

# Configuração de portas (não alterar)
KONG_HTTP_PORT=8000
EOL

if [[ "$HAS_DOMAIN" =~ ^[Ss]$ ]]; then
    read -p "Por favor, introduza o seu nome de domínio (ex: www.omeusite.com): " DOMAIN_NAME
    
    echo -e "${C_GREEN}A configurar para o domínio: ${DOMAIN_NAME}${C_NC}"

    # Criar o Caddyfile para HTTPS automático
    cat <<EOL > Caddyfile
${DOMAIN_NAME} {
    reverse_proxy app:4322
}
EOL

    # Adicionar o serviço Caddy ao docker-compose.yml
    cat <<EOL >> docker-compose.yml

  caddy:
    image: caddy:2-alpine
    container_name: astrovpn_caddy
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile
      - caddy_data:/data
EOL
    # Adicionar o volume do Caddy
    echo -e "\nvolumes:\n  caddy_data:" >> docker-compose.yml

    APP_URL="https://${DOMAIN_NAME}"
else
    read -p "Por favor, introduza o endereço IP público do seu VPS: " IP_ADDRESS
    echo -e "${C_YELLOW}A configurar para o IP: ${IP_ADDRESS}. O site NÃO terá HTTPS.${C_NC}"
    APP_URL="http://${IP_ADDRESS}:4322"
fi

# --- Etapa 4: Lançar a Aplicação ---
echo -e "\n${C_BLUE}--- Etapa 4: A construir e a iniciar todos os serviços... ---${C_NC}"
echo "Isto pode demorar vários minutos na primeira vez."

docker compose up --build -d

if [ $? -eq 0 ]; then
    echo -e "\n${C_GREEN}SUCESSO! A sua aplicação está a ser executada.${C_NC}"
    echo -e "O seu site deverá estar acessível em: ${C_YELLOW}${APP_URL}${C_NC}"
    echo -e "\nPara ver os logs da sua aplicação, corra: ${C_YELLOW}docker compose logs -f app${C_NC}"
    echo -e "Para ver os logs do Supabase, corra: ${C_YELLOW}docker compose logs -f db${C_NC}"
else
    echo -e "\n${C_RED}ERRO: Ocorreu um problema ao iniciar os contentores.${C_NC}"
    echo -e "Por favor, verifique os logs com o comando: ${C_YELLOW}docker compose logs${C_NC}"
fi
