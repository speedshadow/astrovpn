#!/bin/bash

# === Supabase Self-Hosting Deployment Script ===
# Script super robusto e autônomo para configurar e iniciar o Supabase usando Docker Compose
# baseado na configuração oficial do Supabase.

# Definir cores para output
C_GREEN="\033[0;32m"
C_YELLOW="\033[1;33m"
C_RED="\033[0;31m"
C_BLUE="\033[0;34m"
C_NC="\033[0m" # No Color

# Obter o diretório absoluto onde o script está sendo executado
SCRIPT_DIR="$(pwd)"
echo -e "${C_BLUE}Executando no diretório: $SCRIPT_DIR${C_NC}"

# Verificar permissões de escrita no diretório atual
if [ ! -w "$SCRIPT_DIR" ]; then
    echo -e "${C_RED}ERRO: Sem permissões de escrita no diretório atual. Execute como root ou use sudo.${C_NC}"
    exit 1
fi

# Ativar modo de erro estrito
set -e
trap 'echo -e "${C_RED}ERRO na linha $LINENO: $BASH_COMMAND${C_NC}"' ERR

# Verificar se o Docker está instalado
if ! command -v docker &> /dev/null; then
    echo -e "${C_RED}Docker não está instalado. Por favor, instale o Docker primeiro.${C_NC}"
    exit 1
fi

# Verificar se o Docker Compose está instalado
if ! command -v docker compose &> /dev/null; then
    echo -e "${C_RED}Docker Compose não está instalado. Por favor, instale o Docker Compose primeiro.${C_NC}"
    exit 1
fi

# Confirmar antes de apagar tudo
echo -e "${C_YELLOW}AVISO: Este script irá parar e apagar TODOS os containers e volumes Docker existentes associados a este projeto para garantir um deploy limpo.${C_NC}"
read -p "Deseja continuar? (s/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo -e "${C_YELLOW}Operação cancelada pelo usuário.${C_NC}"
    exit 0
fi

echo -e "\n${C_BLUE}A parar e a remover containers e volumes antigos...${C_NC}"
docker compose down -v --remove-orphans || true

# Perguntar sobre o domínio
echo -e "\n${C_BLUE}Como pretende aceder ao Supabase?${C_NC}"
read -p "Vai usar um domínio (ex: supabase.meudominio.com)? (s/N) " HAS_DOMAIN
if [[ $HAS_DOMAIN =~ ^[Ss]$ ]]; then
    read -p "Insira o seu domínio para o Supabase: " DOMAIN
    SITE_URL="https://$DOMAIN"
else
    # Tenta obter o IP público (forçando IPv4) automaticamente
    IP_ADDRESS=$(curl -4 -s ifconfig.me || hostname -I | awk '{print $1}')
    SITE_URL="http://$IP_ADDRESS:8000"
    echo -e "${C_YELLOW}AVISO: O Supabase será exposto em $SITE_URL sem HTTPS. Use um domínio para produção.${C_NC}"
fi

# O serviço Vector é necessário para o funcionamento correto do Kong
DISABLE_VECTOR=false
echo "O serviço Vector será mantido para garantir o funcionamento correto do Kong."

# Obter a configuração oficial do Supabase
echo -e "\n${C_BLUE}A obter a configuração oficial do Supabase...${C_NC}"

# Criar diretório temporário
TMP_DIR=$(mktemp -d)
echo -e "${C_BLUE}Diretório temporário criado: $TMP_DIR${C_NC}"

# Obter apenas os ficheiros necessários do repositório Supabase
echo -e "${C_BLUE}Clonando repositório Supabase...${C_NC}"
git clone --filter=blob:none --no-checkout https://github.com/supabase/supabase "$TMP_DIR/supabase"
cd "$TMP_DIR/supabase"
git sparse-checkout set --cone docker
git checkout master

# Copiar os ficheiros para o diretório do projeto
echo -e "${C_BLUE}A copiar os ficheiros de configuração oficiais...${C_NC}"
cp -rf docker/* "$SCRIPT_DIR/"

# Voltar ao diretório original
cd "$SCRIPT_DIR"

# Limpar diretório temporário
echo -e "${C_BLUE}Removendo diretório temporário...${C_NC}"
rm -rf "$TMP_DIR"

# Corrigir problemas nos arquivos docker-compose.yml
echo -e "${C_BLUE}Corrigindo configurações do Docker Compose...${C_NC}"

# Função para usar o arquivo docker-compose.yml oficial do Supabase
fix_docker_compose_files() {
    echo -e "${C_BLUE}Configurando docker-compose.yml...${C_NC}"
    
    # Fazer backup do arquivo original se existir
    if [ -f "$SCRIPT_DIR/docker-compose.yml" ]; then
        cp "$SCRIPT_DIR/docker-compose.yml" "$SCRIPT_DIR/docker-compose.yml.original"
        echo -e "${C_YELLOW}Backup do arquivo original salvo como docker-compose.yml.original${C_NC}"
    fi

    # Criar arquivo .env com as variáveis de ambiente
    echo -e "${C_BLUE}Criando arquivo .env...${C_NC}"
    cat > "$SCRIPT_DIR/.env" << EOL
# Variáveis do Supabase
POSTGRES_PASSWORD="$POSTGRES_PASSWORD"
SITE_URL="$SITE_URL"
ANON_KEY="$ANON_KEY"
SERVICE_ROLE_KEY="$SERVICE_ROLE_KEY"
JWT_SECRET="$JWT_SECRET"
DISABLE_SIGNUP="$DISABLE_SIGNUP"

# Variáveis do Kong
KONG_DNS_ORDER="LAST,A,CNAME"
KONG_DATABASE="off"
KONG_DECLARATIVE_CONFIG="/var/lib/kong/kong.yml"

# Variáveis do GoTrue (Auth)
GOTRUE_SITE_URL="$SITE_URL"
GOTRUE_URI="http://auth:9999"
GOTRUE_JWT_SECRET="$JWT_SECRET"
GOTRUE_JWT_EXP=3600
GOTRUE_JWT_DEFAULT_GROUP_NAME="authenticated"
GOTRUE_DB_DRIVER="postgres"
GOTRUE_DB_HOST="db"
GOTRUE_DB_PORT="5432"
GOTRUE_DB_NAME="postgres"
GOTRUE_DB_USER="supabase_auth_admin"
GOTRUE_DB_PASSWORD="$POSTGRES_PASSWORD"
GOTRUE_API_HOST="0.0.0.0"
GOTRUE_API_PORT="9999"

# Variáveis do PostgREST
PGRST_DB_URI="postgres://authenticator:${POSTGRES_PASSWORD}@db:5432/postgres"
PGRST_DB_SCHEMA="public,storage"
PGRST_DB_ANON_ROLE="anon"
PGRST_JWT_SECRET="$JWT_SECRET"
PGRST_DB_USE_LEGACY_GUCS="false"

# Variáveis do Storage
STORAGE_BACKEND="file"
FILE_STORAGE_BACKEND_PATH="/var/lib/storage"
STORAGE_JWT_SECRET="$JWT_SECRET"
FILE_SIZE_LIMIT=52428800
DATA_API_PORT=5000

# Variáveis do Meta
PG_META_PORT=8080
PG_META_DB_HOST="db"
PG_META_DB_PASSWORD="$POSTGRES_PASSWORD"

# Variáveis do Studio
DASHBOARD_USERNAME="supabase"
DASHBOARD_PASSWORD="$POSTGRES_PASSWORD"
STUDIO_PG_META_URL="http://meta:8080"
SUPABASE_PUBLIC_URL="$SITE_URL"
SUPABASE_URL="$SITE_URL"
EOL
    
    # Usar o arquivo docker-compose.yml oficial do Supabase
    if [ -f "$TMP_DIR/supabase/docker/docker-compose.yml" ]; then
        echo -e "${C_BLUE}Usando arquivo docker-compose.yml oficial do Supabase...${C_NC}"
        cp "$TMP_DIR/supabase/docker/docker-compose.yml" "$SCRIPT_DIR/docker-compose.yml"
        
        # Garantir que o Kong está configurado corretamente
        echo -e "${C_BLUE}Configurando o Kong...${C_NC}"
        
        # Criar o diretório para o Kong
        mkdir -p "$SCRIPT_DIR/volumes/api"
        
        # Criar o arquivo kong.yml
        cat > "$SCRIPT_DIR/volumes/api/kong.yml" << EOL
_format_version: "2.1"

consumers:
  - username: anon
    keyauth_credentials:
      - key: ${ANON_KEY}
  - username: service_role
    keyauth_credentials:
      - key: ${SERVICE_ROLE_KEY}

services:
  - name: auth-v1
    url: http://auth:9999
    routes:
      - name: auth-v1-all
        strip_path: true
        paths:
          - /auth/v1
    plugins:
      - name: cors
      - name: key-auth
        config:
          hide_credentials: false

  - name: rest-v1
    url: http://rest:3000
    routes:
      - name: rest-v1-all
        strip_path: true
        paths:
          - /rest/v1
    plugins:
      - name: cors
      - name: key-auth
        config:
          hide_credentials: false

  - name: realtime-v1
    url: http://realtime:4000/socket
    routes:
      - name: realtime-v1-all
        strip_path: true
        paths:
          - /realtime/v1
    plugins:
      - name: cors
      - name: key-auth
        config:
          hide_credentials: false

  - name: storage-v1
    url: http://storage:5000
    routes:
      - name: storage-v1-all
        strip_path: true
        paths:
          - /storage/v1
    plugins:
      - name: cors
      - name: key-auth
        config:
          hide_credentials: false

  - name: meta
    url: http://meta:8080
    routes:
      - name: meta-all
        strip_path: true
        paths:
          - /pg
    plugins:
      - name: cors
      - name: key-auth
        config:
          hide_credentials: false

  - name: postgrest
    url: http://rest:3000
    routes:
      - name: postgrest-all
        strip_path: true
        paths:
          - /
    plugins:
      - name: cors
      - name: key-auth
        config:
          hide_credentials: false
EOL
        
        echo -e "${C_GREEN}Arquivo docker-compose.yml configurado com sucesso!${C_NC}"
    else
        echo -e "${C_RED}Erro: Arquivo docker-compose.yml oficial não encontrado!${C_NC}"
        exit 1
    fi
# Configurações do Supabase
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
SITE_URL=$SITE_URL
ANON_KEY=$ANON_KEY
SERVICE_ROLE_KEY=$SERVICE_ROLE_KEY
JWT_SECRET=$JWT_SECRET
DISABLE_SIGNUP=$DISABLE_SIGNUP
EOL
    echo -e "${C_GREEN}Arquivo .env criado com sucesso no diretório raiz!${C_NC}"
    
    # Substituir as variáveis de ambiente no arquivo docker-compose.yml
    sed -i "s/\${POSTGRES_PASSWORD}/$POSTGRES_PASSWORD/g" "$SCRIPT_DIR/docker-compose.yml"
    sed -i "s|\${SITE_URL}|$SITE_URL|g" "$SCRIPT_DIR/docker-compose.yml"
    sed -i "s/\${ANON_KEY}/$ANON_KEY/g" "$SCRIPT_DIR/docker-compose.yml"
    sed -i "s/\${SERVICE_ROLE_KEY}/$SERVICE_ROLE_KEY/g" "$SCRIPT_DIR/docker-compose.yml"
    sed -i "s/\${JWT_SECRET}/$JWT_SECRET/g" "$SCRIPT_DIR/docker-compose.yml"
    sed -i "s/\${DISABLE_SIGNUP}/$DISABLE_SIGNUP/g" "$SCRIPT_DIR/docker-compose.yml"
    
    echo -e "${C_GREEN}Arquivo docker-compose.yml simplificado criado com sucesso!${C_NC}"
}

# Executar a função de correção
fix_docker_compose_files

# Gerar o ficheiro .env
echo -e "\n${C_BLUE}A gerar o ficheiro .env com novos segredos...${C_NC}"

# Gerar senhas e chaves seguras
POSTGRES_PASSWORD=$(openssl rand -base64 32)
JWT_SECRET=$(openssl rand -base64 32)
ANON_KEY=$(openssl rand -hex 32)
SERVICE_ROLE_KEY=$(openssl rand -hex 32)
DASHBOARD_USERNAME=supabase
DASHBOARD_PASSWORD=$(openssl rand -base64 16)
POSTGRES_PORT=5432
STUDIO_PORT=3000
KONG_HTTP_PORT=8000
KONG_HTTPS_PORT=8443
API_EXTERNAL_URL="${SITE_URL}/rest/v1/"
GRAPHQL_EXTERNAL_URL="${SITE_URL}/graphql/v1/"
REALTIME_EXTERNAL_URL="${SITE_URL}/realtime/v1/"
STORAGE_EXTERNAL_URL="${SITE_URL}/storage/v1/"

# Variáveis adicionais necessárias
POSTGRES_HOST=db
POSTGRES_DB=postgres
DOCKER_SOCKET_LOCATION=/var/run/docker.sock
SUPABASE_PUBLIC_URL="${SITE_URL}"
JWT_EXPIRY=3600
ENABLE_EMAIL_SIGNUP=true
ENABLE_EMAIL_AUTOCONFIRM=true
ENABLE_PHONE_SIGNUP=true
ENABLE_PHONE_AUTOCONFIRM=true
ENABLE_ANONYMOUS_USERS=true
DISABLE_SIGNUP=false
STUDIO_DEFAULT_ORGANIZATION="Default Organization"
STUDIO_DEFAULT_PROJECT="Default Project"
SECRET_KEY_BASE=$(openssl rand -hex 32)
VAULT_ENC_KEY=$(openssl rand -hex 32)
POOLER_DEFAULT_POOL_SIZE=20
POOLER_MAX_CLIENT_CONN=20
POOLER_DB_POOL_SIZE=20
POOLER_TENANT_ID=stub
POOLER_PROXY_PORT_TRANSACTION=6432
LOGFLARE_PUBLIC_ACCESS_TOKEN=stub
LOGFLARE_PRIVATE_ACCESS_TOKEN=stub
ADDITIONAL_REDIRECT_URLS=""
FUNCTIONS_VERIFY_JWT=false
IMGPROXY_ENABLE_WEBP_DETECTION=true

# SMTP configurações (opcionais, mas evitam warnings)
SMTP_HOST=
SMTP_PORT=
SMTP_USER=
SMTP_PASS=
SMTP_SENDER_NAME="Supabase"
SMTP_ADMIN_EMAIL="admin@example.com"
MAILER_URLPATHS_CONFIRMATION="/auth/v1/verify"
MAILER_URLPATHS_INVITE="/auth/v1/verify"
MAILER_URLPATHS_RECOVERY="/auth/v1/verify"
MAILER_URLPATHS_EMAIL_CHANGE="/auth/v1/verify"

# Criar o arquivo .env diretamente com caminho absoluto
ENV_FILE="$SCRIPT_DIR/.env"
echo -e "${C_BLUE}Criando arquivo $ENV_FILE...${C_NC}"

# Testar se podemos escrever no arquivo
touch "$ENV_FILE" || { echo -e "${C_RED}ERRO: Não foi possível criar o arquivo .env. Verifique as permissões.${C_NC}"; exit 1; }

# Escrever conteúdo no arquivo .env linha por linha
echo "############" > "$ENV_FILE"
echo "# Secrets - Gere suas próprias chaves e segredos" >> "$ENV_FILE"
echo "############" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "POSTGRES_PASSWORD=$POSTGRES_PASSWORD" >> "$ENV_FILE"
echo "JWT_SECRET=$JWT_SECRET" >> "$ENV_FILE"
echo "ANON_KEY=$ANON_KEY" >> "$ENV_FILE"
echo "SERVICE_ROLE_KEY=$SERVICE_ROLE_KEY" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "############" >> "$ENV_FILE"
echo "# Database - Você pode alterar estas configurações" >> "$ENV_FILE"
echo "############" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "# Porta para conexão PostgreSQL" >> "$ENV_FILE"
echo "POSTGRES_PORT=$POSTGRES_PORT" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "############" >> "$ENV_FILE"
echo "# API Proxy - Configuração do Kong" >> "$ENV_FILE"
echo "############" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "KONG_HTTP_PORT=$KONG_HTTP_PORT" >> "$ENV_FILE"
echo "KONG_HTTPS_PORT=$KONG_HTTPS_PORT" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "############" >> "$ENV_FILE"
echo "# API - Configurações para PostgREST" >> "$ENV_FILE"
echo "############" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "PGRST_DB_SCHEMAS=public,storage,graphql_public" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "# Ativa a API REST" >> "$ENV_FILE"
echo "PGRST_ENABLED=true" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "# URL externa da API REST" >> "$ENV_FILE"
echo "API_EXTERNAL_URL=$API_EXTERNAL_URL" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "############" >> "$ENV_FILE"
echo "# GraphQL - Configurações para GraphQL" >> "$ENV_FILE"
echo "############" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "# Ativa GraphQL" >> "$ENV_FILE"
echo "GRAPHQL_ENABLED=true" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "# URL externa do GraphQL" >> "$ENV_FILE"
echo "GRAPHQL_EXTERNAL_URL=$GRAPHQL_EXTERNAL_URL" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "############" >> "$ENV_FILE"
echo "# Realtime - Configurações para Realtime" >> "$ENV_FILE"
echo "############" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "# Ativa Realtime" >> "$ENV_FILE"
echo "REALTIME_ENABLED=true" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "# URL externa do Realtime" >> "$ENV_FILE"
echo "REALTIME_EXTERNAL_URL=$REALTIME_EXTERNAL_URL" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "############" >> "$ENV_FILE"
echo "# Storage - Configurações para Storage" >> "$ENV_FILE"
echo "############" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "# Ativa Storage" >> "$ENV_FILE"
echo "STORAGE_ENABLED=true" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "# URL externa do Storage" >> "$ENV_FILE"
echo "STORAGE_EXTERNAL_URL=$STORAGE_EXTERNAL_URL" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "############" >> "$ENV_FILE"
echo "# Dashboard - Configurações para o Studio" >> "$ENV_FILE"
echo "############" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "STUDIO_PORT=$STUDIO_PORT" >> "$ENV_FILE"
echo "DASHBOARD_USERNAME=$DASHBOARD_USERNAME" >> "$ENV_FILE"
echo "DASHBOARD_PASSWORD=$DASHBOARD_PASSWORD" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "############" >> "$ENV_FILE"
echo "# Configurações gerais" >> "$ENV_FILE"
echo "############" >> "$ENV_FILE"
echo "" >> "$ENV_FILE"
echo "# URL do site (usada para redirecionamentos e emails)" >> "$ENV_FILE"
echo "SITE_URL=$SITE_URL" >> "$ENV_FILE"

# Variáveis adicionais para evitar warnings
echo "POSTGRES_HOST=$POSTGRES_HOST" >> "$ENV_FILE"
echo "POSTGRES_DB=$POSTGRES_DB" >> "$ENV_FILE"
echo "DOCKER_SOCKET_LOCATION=$DOCKER_SOCKET_LOCATION" >> "$ENV_FILE"
echo "SUPABASE_PUBLIC_URL=$SUPABASE_PUBLIC_URL" >> "$ENV_FILE"
echo "JWT_EXPIRY=$JWT_EXPIRY" >> "$ENV_FILE"
echo "ENABLE_EMAIL_SIGNUP=$ENABLE_EMAIL_SIGNUP" >> "$ENV_FILE"
echo "ENABLE_EMAIL_AUTOCONFIRM=$ENABLE_EMAIL_AUTOCONFIRM" >> "$ENV_FILE"
echo "ENABLE_PHONE_SIGNUP=$ENABLE_PHONE_SIGNUP" >> "$ENV_FILE"
echo "ENABLE_PHONE_AUTOCONFIRM=$ENABLE_PHONE_AUTOCONFIRM" >> "$ENV_FILE"
echo "ENABLE_ANONYMOUS_USERS=$ENABLE_ANONYMOUS_USERS" >> "$ENV_FILE"
echo "DISABLE_SIGNUP=$DISABLE_SIGNUP" >> "$ENV_FILE"
echo "STUDIO_DEFAULT_ORGANIZATION=$STUDIO_DEFAULT_ORGANIZATION" >> "$ENV_FILE"
echo "STUDIO_DEFAULT_PROJECT=$STUDIO_DEFAULT_PROJECT" >> "$ENV_FILE"
echo "SECRET_KEY_BASE=$SECRET_KEY_BASE" >> "$ENV_FILE"
echo "VAULT_ENC_KEY=$VAULT_ENC_KEY" >> "$ENV_FILE"
echo "POOLER_DEFAULT_POOL_SIZE=$POOLER_DEFAULT_POOL_SIZE" >> "$ENV_FILE"
echo "POOLER_MAX_CLIENT_CONN=$POOLER_MAX_CLIENT_CONN" >> "$ENV_FILE"
echo "POOLER_DB_POOL_SIZE=$POOLER_DB_POOL_SIZE" >> "$ENV_FILE"
echo "POOLER_TENANT_ID=$POOLER_TENANT_ID" >> "$ENV_FILE"
echo "POOLER_PROXY_PORT_TRANSACTION=$POOLER_PROXY_PORT_TRANSACTION" >> "$ENV_FILE"
echo "LOGFLARE_PUBLIC_ACCESS_TOKEN=$LOGFLARE_PUBLIC_ACCESS_TOKEN" >> "$ENV_FILE"
echo "LOGFLARE_PRIVATE_ACCESS_TOKEN=$LOGFLARE_PRIVATE_ACCESS_TOKEN" >> "$ENV_FILE"
echo "ADDITIONAL_REDIRECT_URLS=$ADDITIONAL_REDIRECT_URLS" >> "$ENV_FILE"
echo "FUNCTIONS_VERIFY_JWT=$FUNCTIONS_VERIFY_JWT" >> "$ENV_FILE"
echo "IMGPROXY_ENABLE_WEBP_DETECTION=$IMGPROXY_ENABLE_WEBP_DETECTION" >> "$ENV_FILE"

# SMTP configurações
echo "SMTP_HOST=$SMTP_HOST" >> "$ENV_FILE"
echo "SMTP_PORT=$SMTP_PORT" >> "$ENV_FILE"
echo "SMTP_USER=$SMTP_USER" >> "$ENV_FILE"
echo "SMTP_PASS=$SMTP_PASS" >> "$ENV_FILE"
echo "SMTP_SENDER_NAME=$SMTP_SENDER_NAME" >> "$ENV_FILE"
echo "SMTP_ADMIN_EMAIL=$SMTP_ADMIN_EMAIL" >> "$ENV_FILE"
echo "MAILER_URLPATHS_CONFIRMATION=$MAILER_URLPATHS_CONFIRMATION" >> "$ENV_FILE"
echo "MAILER_URLPATHS_INVITE=$MAILER_URLPATHS_INVITE" >> "$ENV_FILE"
echo "MAILER_URLPATHS_RECOVERY=$MAILER_URLPATHS_RECOVERY" >> "$ENV_FILE"
echo "MAILER_URLPATHS_EMAIL_CHANGE=$MAILER_URLPATHS_EMAIL_CHANGE" >> "$ENV_FILE"

echo -e "${C_GREEN}Arquivo .env gerado com sucesso em $ENV_FILE!${C_NC}"
echo -e "${C_GREEN}URL do site: $SITE_URL${C_NC}"
echo -e "${C_GREEN}Credenciais do Dashboard:${C_NC}"
echo -e "${C_GREEN}  Usuário: $DASHBOARD_USERNAME${C_NC}"
echo -e "${C_GREEN}  Senha: $DASHBOARD_PASSWORD${C_NC}"

# Iniciar os serviços
echo -e "\n${C_BLUE}A iniciar todos os serviços do Supabase com Docker Compose...${C_NC}"
docker compose pull
docker compose up -d

# Verificação de estado dos serviços críticos
echo -e "\n${C_BLUE}A verificar o estado dos serviços críticos...${C_NC}"
sleep 10 # Dar tempo para os containers iniciarem

CRITICAL_CONTAINERS=("supabase-db" "supabase-kong" "supabase-auth" "supabase-rest" "supabase-storage")

for container in "${CRITICAL_CONTAINERS[@]}"; do
    STATUS=$(docker inspect --format '{{.State.Status}}' "$container" 2>/dev/null || echo "não encontrado")
    if [[ "$STATUS" == "running" ]]; then
        HEALTH=$(docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}N/A{{end}}' "$container" 2>/dev/null)
        echo -e "  - ${C_GREEN}$container está a correr${C_NC} (saúde: $HEALTH)"
    else
        echo -e "  - ${C_YELLOW}$container: $STATUS${C_NC}"
    fi
done

# Obter e mostrar as chaves de API
ANON_KEY=$(grep ANON_KEY .env | cut -d '=' -f2)
SERVICE_ROLE_KEY=$(grep SERVICE_ROLE_KEY .env | cut -d '=' -f2)

echo -e "\n${C_GREEN}Deploy do Supabase concluído!${C_NC}"
echo -e "\n${C_BLUE}Informações importantes:${C_NC}"
echo -e "  URL do Supabase: ${C_YELLOW}$SITE_URL${C_NC}"
echo -e "  ANON_KEY: ${C_YELLOW}$ANON_KEY${C_NC}"
echo -e "  SERVICE_ROLE_KEY: ${C_YELLOW}$SERVICE_ROLE_KEY${C_NC}"
echo -e "\n${C_BLUE}Para aceder ao Dashboard do Supabase:${C_NC} ${C_YELLOW}$SITE/dashboard${C_NC}"
echo -e "${C_BLUE}Credenciais padrão:${C_NC} Verifique DASHBOARD_USERNAME e DASHBOARD_PASSWORD no ficheiro .env"
