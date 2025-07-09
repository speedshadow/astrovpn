#!/bin/bash

# === Supabase Self-Hosting Deployment Script ===
# Este script configura e inicia o Supabase usando Docker Compose
# baseado na configuração oficial do Supabase.

# Definir cores para output
C_GREEN="\033[0;32m"
C_YELLOW="\033[1;33m"
C_RED="\033[0;31m"
C_BLUE="\033[0;34m"
C_NC="\033[0m" # No Color

# Ativar modo de erro estrito
set -e
trap 'echo -e "${C_RED}ERRO na linha $LINENO: $BASH_COMMAND${C_NC}"' ERR

# Mudar para o diretório onde o script está localizado
cd "$(dirname "$0")"

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

# Obter a configuração oficial do Supabase
echo -e "\n${C_BLUE}A obter a configuração oficial do Supabase...${C_NC}"

# Criar diretório temporário
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# Obter apenas os ficheiros necessários do repositório Supabase
git clone --filter=blob:none --no-checkout https://github.com/supabase/supabase
cd supabase
git sparse-checkout set --cone docker
git checkout master
cd ..

# Copiar os ficheiros para o diretório do projeto
echo -e "${C_BLUE}A copiar os ficheiros de configuração oficiais...${C_NC}"
cp -rf supabase/docker/* "$(dirname "$0")/"

# Voltar ao diretório do projeto
cd "$(dirname "$0")"

# Limpar diretório temporário
rm -rf "$TMP_DIR"

# Gerar o ficheiro .env
echo -e "\n${C_BLUE}A gerar o ficheiro .env com novos segredos...${C_NC}"

# Criar o script generate-env.sh diretamente
cat > generate-env.sh << 'EOFSCRIPT'
#!/bin/bash

# Script para gerar o arquivo .env para o Supabase
# Baseado na documentação oficial: https://supabase.com/docs/guides/self-hosting/docker

# Verifica se o URL do site foi fornecido
if [ -z "$1" ]; then
  echo "Uso: $0 <SITE_URL>"
  echo "Exemplo: $0 https://supabase.meudominio.com"
  exit 1
fi

SITE_URL=$1

# Função para percent-encode (URL encode) strings
urlencode() {
  local LANG=C
  local length="${#1}"
  for (( i = 0; i < length; i++ )); do
    local c="${1:i:1}"
    case $c in
      [a-zA-Z0-9.~_-]) printf "$c" ;;
      *) printf '%%%02X' "'${c}" ;;
    esac
  done
}

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

# Gerar arquivo .env
cat > .env << EOF
############
# Secrets - Gere suas próprias chaves e segredos
############

POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
JWT_SECRET=${JWT_SECRET}
ANON_KEY=${ANON_KEY}
SERVICE_ROLE_KEY=${SERVICE_ROLE_KEY}

############
# Database - Você pode alterar estas configurações
############

# Porta para conexão PostgreSQL
POSTGRES_PORT=${POSTGRES_PORT}

############
# API Proxy - Configuração do Kong
############

KONG_HTTP_PORT=${KONG_HTTP_PORT}
KONG_HTTPS_PORT=${KONG_HTTPS_PORT}

############
# API - Configurações para PostgREST
############

PGRST_DB_SCHEMAS=public,storage,graphql_public

# Ativa a API REST
PGRST_ENABLED=true

# URL externa da API REST
API_EXTERNAL_URL=${API_EXTERNAL_URL}

############
# GraphQL - Configurações para GraphQL
############

# Ativa GraphQL
GRAPHQL_ENABLED=true

# URL externa do GraphQL
GRAPHQL_EXTERNAL_URL=${GRAPHQL_EXTERNAL_URL}

############
# Realtime - Configurações para Realtime
############

# Ativa Realtime
REALTIME_ENABLED=true

# URL externa do Realtime
REALTIME_EXTERNAL_URL=${REALTIME_EXTERNAL_URL}

############
# Storage - Configurações para Storage
############

# Ativa Storage
STORAGE_ENABLED=true

# URL externa do Storage
STORAGE_EXTERNAL_URL=${STORAGE_EXTERNAL_URL}

############
# Dashboard - Configurações para o Studio
############

STUDIO_PORT=${STUDIO_PORT}
DASHBOARD_USERNAME=${DASHBOARD_USERNAME}
DASHBOARD_PASSWORD=${DASHBOARD_PASSWORD}

############
# Configurações gerais
############

# URL do site (usada para redirecionamentos e emails)
SITE_URL=${SITE_URL}
EOF

echo "Arquivo .env gerado com sucesso!"
echo "URL do site: ${SITE_URL}"
echo "Credenciais do Dashboard:"
echo "  Usuário: ${DASHBOARD_USERNAME}"
echo "  Senha: ${DASHBOARD_PASSWORD}"
EOFSCRIPT

# Tornar o script executável
chmod +x generate-env.sh

# Executar o script para gerar o .env
./generate-env.sh "$SITE_URL"

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
