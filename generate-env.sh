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
