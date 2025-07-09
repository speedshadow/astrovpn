#!/bin/bash

# Cores para output
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_BLUE='\033[0;34m'
C_YELLOW='\033[0;33m'
C_NC='\033[0m'

# Diretório do script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Função para gerar senha aleatória
generate_random_password() {
    openssl rand -base64 24
}

# Função para gerar JWT secret
generate_jwt_secret() {
    openssl rand -hex 32
}

# Verificar dependências
check_dependencies() {
    echo -e "\n${C_BLUE}Verificando dependências...${C_NC}"
    
    if ! command -v docker &>/dev/null; then
        echo -e "${C_RED}Docker não está instalado. Por favor, instale o Docker primeiro:${C_NC}"
        echo "https://docs.docker.com/engine/install/"
        exit 1
    fi

    if ! command -v docker compose &>/dev/null; then
        echo -e "${C_RED}Docker Compose não está instalado. Por favor, instale o Docker Compose primeiro:${C_NC}"
        echo "https://docs.docker.com/compose/install/"
        exit 1
    fi

    if ! command -v git &>/dev/null; then
        echo -e "${C_RED}Git não está instalado. Por favor, instale o Git primeiro:${C_NC}"
        echo "sudo apt-get install git"
        exit 1
    fi
}

# Função para configurar o ambiente
setup_environment() {
    echo -e "\n${C_BLUE}Configurando ambiente...${C_NC}"

    # Gerar senhas e secrets
    POSTGRES_PASSWORD=$(generate_random_password)
    JWT_SECRET=$(generate_jwt_secret)
    ANON_KEY=$(generate_jwt_secret)
    SERVICE_ROLE_KEY=$(generate_jwt_secret)
    DASHBOARD_PASSWORD=$(generate_random_password)

    # Perguntar sobre o domínio/IP
    echo -e "\n${C_BLUE}Como você vai acessar o Supabase?${C_NC}"
    read -p "Você tem um domínio para usar? (ex: supabase.seudominio.com)? (s/N) " HAS_DOMAIN

    if [[ $HAS_DOMAIN =~ ^[Ss]$ ]]; then
        read -p "Digite seu domínio (ex: supabase.seudominio.com): " SITE_URL
        SITE_URL="https://$SITE_URL"
    else
        # Pegar IP público automaticamente
        PUBLIC_IP=$(curl -s https://api.ipify.org)
        SITE_URL="http://$PUBLIC_IP:8000"
    fi

    # Configurar portas
    POSTGRES_PORT=5432
    KONG_HTTP_PORT=8000
    KONG_HTTPS_PORT=8443

    # Criar diretório do projeto se não existir
    PROJECT_DIR="$SCRIPT_DIR/supabase"
    mkdir -p "$PROJECT_DIR"

    echo -e "\n${C_BLUE}Baixando configurações oficiais do Supabase...${C_NC}"
    
    # Clonar apenas os arquivos necessários do Supabase
    git clone --filter=blob:none --no-checkout https://github.com/supabase/supabase "$PROJECT_DIR/temp"
    cd "$PROJECT_DIR/temp"
    git sparse-checkout set --cone docker
    git checkout master

    # Copiar arquivos necessários
    cp -rf docker/* "$PROJECT_DIR/"
    cp docker/.env.example "$PROJECT_DIR/.env"
    cd "$PROJECT_DIR"
    rm -rf temp

    # Configurar .env
    echo -e "\n${C_BLUE}Configurando variáveis de ambiente...${C_NC}"
    cat > "$PROJECT_DIR/.env" << EOL
############
# Secrets
############

POSTGRES_PASSWORD=$POSTGRES_PASSWORD
JWT_SECRET=$JWT_SECRET
ANON_KEY=$ANON_KEY
SERVICE_ROLE_KEY=$SERVICE_ROLE_KEY
DASHBOARD_USERNAME=supabase
DASHBOARD_PASSWORD=$DASHBOARD_PASSWORD

############
# Database
############

POSTGRES_PORT=$POSTGRES_PORT

############
# API Proxy
############

KONG_HTTP_PORT=$KONG_HTTP_PORT
KONG_HTTPS_PORT=$KONG_HTTPS_PORT

############
# API Services
############

SITE_URL=$SITE_URL
ADDITIONAL_REDIRECT_URLS=
JWT_EXPIRY=3600
DISABLE_SIGNUP=false
API_EXTERNAL_URL=$SITE_URL
SUPABASE_PUBLIC_URL=$SITE_URL

############
# Studio
############

STUDIO_DEFAULT_ORGANIZATION=Default
STUDIO_DEFAULT_PROJECT=Default

############
# Supavisor
############

POOLER_TENANT_ID=your-tenant-id
POOLER_PROXY_PORT_TRANSACTION=6543
EOL

    # Criar arquivo .env no root para o frontend
    echo -e "\n${C_BLUE}Criando arquivo .env para o frontend...${C_NC}"
    cat > "$SCRIPT_DIR/.env" << EOL
VITE_SUPABASE_URL=$SITE_URL
VITE_SUPABASE_ANON_KEY=$ANON_KEY
EOL

    echo -e "${C_GREEN}Ambiente configurado com sucesso!${C_NC}"
}

# Função para iniciar os serviços
start_services() {
    echo -e "\n${C_BLUE}Iniciando serviços do Supabase...${C_NC}"
    
    cd "$PROJECT_DIR"

    echo -e "\n${C_BLUE}Baixando imagens mais recentes...${C_NC}"
    docker compose pull

    echo -e "\n${C_BLUE}Iniciando containers...${C_NC}"
    docker compose up -d

    echo -e "\n${C_BLUE}Aguardando serviços iniciarem...${C_NC}"
    sleep 10

    # Verificar status dos containers
    if docker compose ps | grep -q "unhealthy\|exited"; then
        echo -e "${C_RED}Alguns serviços não iniciaram corretamente:${C_NC}"
        docker compose ps
        exit 1
    fi

    echo -e "${C_GREEN}Todos os serviços iniciados com sucesso!${C_NC}"
}

# Função principal
main() {
    echo -e "${C_BLUE}=== Instalação do Supabase ===${C_NC}"
    
    # Verificar se está rodando como root
    if [ "$EUID" -ne 0 ]; then
        echo -e "${C_RED}Por favor, execute este script como root (sudo).${C_NC}"
        exit 1
    fi

    check_dependencies
    setup_environment
    start_services

    echo -e "\n${C_GREEN}=== Instalação concluída! ===${C_NC}"
    echo -e "\nAcesse o Supabase Studio em: ${C_BLUE}$SITE_URL${C_NC}"
    echo -e "\nCredenciais do Dashboard:"
    echo -e "  Usuário: ${C_YELLOW}supabase${C_NC}"
    echo -e "  Senha: ${C_YELLOW}$DASHBOARD_PASSWORD${C_NC}"
    echo -e "\nCredenciais salvas em:"
    echo -e "  Supabase: ${C_YELLOW}$PROJECT_DIR/.env${C_NC}"
    echo -e "  Frontend: ${C_YELLOW}$SCRIPT_DIR/.env${C_NC}"
    
    echo -e "\n${C_YELLOW}IMPORTANTE: Guarde suas credenciais em um local seguro!${C_NC}"
}

# Executar script
main
