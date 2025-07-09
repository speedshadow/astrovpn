#!/bin/bash
set -e

# URL do site passado como primeiro argumento
SITE_URL=${1:-"http://localhost:8000"}

# Funções para gerar segredos de forma segura
gen_secret() { openssl rand -base64 32 | tr -d "+/="; }
gen_key() { openssl rand -hex 32; }

# --- Geração do Ficheiro .env ---
# Este ficheiro contém a configuração para um setup minimalista do Supabase.
# Inclui apenas os serviços essenciais: db, auth, rest, storage, kong.

cat > .env <<EOF
# --- Configuração Geral ---
SITE_URL=$SITE_URL
SUPABASE_PUBLIC_URL=$SITE_URL

# --- Chaves de API (geradas aleatoriamente) ---
ANON_KEY=$(gen_key)
SERVICE_ROLE_KEY=$(gen_key)

# --- Segredo para os JWTs (gerado aleatoriamente) ---
JWT_SECRET=$(gen_secret)

# --- Configuração da Base de Dados ---
POSTGRES_DB=postgres
POSTGRES_USER=supabase
POSTGRES_PASSWORD=$(gen_secret)
# A porta interna do Postgres. Não mude.
POSTGRES_PORT=5432

# --- Configuração do Kong (API Gateway) ---
# A porta interna do Kong. Não mude.
KONG_HTTP_LISTEN=/var/run/kong/kong.sock

# --- Variáveis Adicionais (não precisam de ser alteradas para um setup básico) ---
GOTRUE_JWT_EXP=3600
GOTRUE_SITE_URL=$SITE_URL
POSTGREST_DB_SCHEMA=public,storage

# --- Segredos para serviços internos (gerados aleatoriamente) ---
# Estes não são expostos diretamente, mas são usados para a comunicação entre serviços.
SUPABASE_AUTH_ADMIN_PASSWORD=$(gen_secret)

EOF

echo ".env gerado com sucesso para o URL: $SITE_URL"
