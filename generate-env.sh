#!/bin/bash
set -e
DOMAIN_OR_IP="$1"

gen_secret() { openssl rand -base64 32; }
gen_hex() { openssl rand -hex 32; }

cat > .env <<EOF
POSTGRES_PASSWORD=$(gen_secret)
JWT_SECRET=$(gen_secret)
ANON_KEY=$(gen_hex)
SERVICE_ROLE_KEY=$(gen_hex)
AUTHENTICATOR_PASSWORD=$(gen_secret)
ANON_PASSWORD=$(gen_secret)
SUPABASE_AUTH_ADMIN_PASSWORD=$(gen_secret)
DASHBOARD_PASSWORD=$(gen_secret)
SECRET_KEY_BASE=$(gen_secret)
VAULT_ENC_KEY=$(gen_secret)
SITE_URL=${DOMAIN_OR_IP}
EOF
