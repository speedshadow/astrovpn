#!/bin/bash

# === AstroVPN & Supabase Production Deployment Script ===
# Este script automatiza a implementação completa da sua aplicação e do Supabase
# num servidor VPS Linux limpo (como Ubuntu 22.04).
# Executa como root para instalar dependências.

set -e
set -x
trap 'echo -e "${C_RED}ERRO na linha $LINENO: $BASH_COMMAND${C_NC}"' ERR

# --- Validação de acesso à internet e DNS ---
echo -e "${C_BLUE}A validar ligação à internet e DNS...${C_NC}"
ping -c 1 8.8.8.8 >/dev/null 2>&1 || { echo -e "${C_RED}ERRO: Sem acesso à internet (falha no ping a 8.8.8.8)${C_NC}"; exit 2; }
ping -c 1 github.com >/dev/null 2>&1 || { echo -e "${C_RED}ERRO: Sem acesso DNS a github.com${C_NC}"; exit 2; }

# --- Cores para uma melhor legibilidade ---
C_BLUE='\033[0;34m'
C_GREEN='\033[0;32m'
C_RED='\033[0;31m'
C_YELLOW='\033[1;33m'
C_NC='\033[0m' # No Color

echo -e "${C_BLUE}Bem-vindo ao script de implementação de produção do AstroVPN!${C_NC}"

# Verificar se o script está a ser executado como root
if [ "$(id -u)" -ne 0 ]; then
  echo -e "${C_RED}Erro: Este script precisa de ser executado como root. Por favor, use 'sudo ./deploy.sh'${C_NC}"
  exit 1
fi

echo "Você tem domínio? (s/N)"
read HAS_DOMAIN
if [[ "$HAS_DOMAIN" =~ ^[Ss]$ ]]; then
  read -p "Indique o domínio: " DOMAIN
  DOMAIN_OR_IP="https://$DOMAIN"
else
  DOMAIN_OR_IP="http://$(curl -s ifconfig.me):8000"
  echo "AVISO: O Supabase ficará exposto no IP público sem HTTPS!"
fi

./generate-env.sh "$DOMAIN_OR_IP"

docker compose up -d --build

echo "Deploy concluído. Aceda em: $DOMAIN_OR_IP"

# --- 4. Configurar e Iniciar o Supabase (Método Oficial 2024+) ---
echo -e "\n${C_BLUE}A configurar e a iniciar o Supabase via Docker (método oficial)...${C_NC}"
SUPABASE_DIR="/opt/supabase"
rm -rf $SUPABASE_DIR || { echo -e "${C_RED}ERRO: Falha ao remover $SUPABASE_DIR${C_NC}"; exit 2; }
mkdir -p $SUPABASE_DIR || { echo -e "${C_RED}ERRO: Falha ao criar $SUPABASE_DIR${C_NC}"; exit 2; }
cd $SUPABASE_DIR || { echo -e "${C_RED}ERRO: Falha ao aceder a $SUPABASE_DIR${C_NC}"; exit 2; }

# --- Reset total dos volumes Docker do Supabase para garantir sincronização de utilizadores/passwords ---
echo -e "${C_YELLOW}A remover todos os volumes Docker do Supabase para reset total...${C_NC}"
if [ -f docker-compose.yml ]; then
  docker compose down -v || true
fi
docker volume ls -q | grep supabase | xargs -r docker volume rm 2>/dev/null || true

# Obter ficheiros do Supabase via git clone (método oficial 2025)
git clone --depth 1 https://github.com/supabase/supabase.git $SUPABASE_DIR || { echo -e "${C_RED}ERRO: Falha ao clonar o repositório Supabase${C_NC}"; exit 2; }
cd $SUPABASE_DIR/docker || { echo -e "${C_RED}ERRO: Falha ao aceder à pasta docker${C_NC}"; exit 2; }
cp .env.example .env || { echo -e "${C_RED}ERRO: Falha ao copiar .env.example${C_NC}"; exit 2; }

# --- Garante que todas as variáveis críticas de password e segredos estão presentes no .env ---
add_env_if_missing() {
  VAR="$1"
  VAL="$2"
  grep -q "^$VAR=" .env || echo "$VAR=$VAL" >> .env
}

# Lista de variáveis sensíveis do .env.example oficial do Supabase
for v in \
  POSTGRES_PASSWORD JWT_SECRET ANON_KEY SERVICE_ROLE_KEY DASHBOARD_PASSWORD SECRET_KEY_BASE VAULT_ENC_KEY \
  LOGFLARE_PUBLIC_ACCESS_TOKEN LOGFLARE_PRIVATE_ACCESS_TOKEN \
  SMTP_PASS \
  ; do
  add_env_if_missing "$v" "PLACEHOLDER"
done

# Adiciona variáveis de password comuns de serviços Supabase
for v in AUTHENTICATOR_PASSWORD ANON_PASSWORD SUPABASE_AUTH_ADMIN_PASSWORD; do
  add_env_if_missing "$v" "PLACEHOLDER"
done

# Função para percent-encode (URL encode) passwords/secrets
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

# Gerar e substituir segredos automaticamente para todas as variáveis sensíveis
for var in $(grep -o '^[A-Z0-9_]*_PASSWORD' .env | sort | uniq); do
  RAW=$(openssl rand -base64 32)
  ENC=$(urlencode "$RAW")
  sed -i "s|^$var=.*|$var=$ENC|g" .env
done
for var in $(grep -o '^[A-Z0-9_]*_KEY' .env | sort | uniq); do
  RAW=$(openssl rand -hex 32)
  ENC=$(urlencode "$RAW")
  sed -i "s|^$var=.*|$var=$ENC|g" .env
done
for var in $(grep -o '^[A-Z0-9_]*_SECRET' .env | sort | uniq); do
  RAW=$(openssl rand -base64 32)
  ENC=$(urlencode "$RAW")
  sed -i "s|^$var=.*|$var=$ENC|g" .env
done
for var in $(grep -o '^[A-Z0-9_]*_TOKEN' .env | sort | uniq); do
  RAW=$(openssl rand -hex 32)
  ENC=$(urlencode "$RAW")
  sed -i "s|^$var=.*|$var=$ENC|g" .env
done
# Segredos específicos
JWT_SECRET=$(openssl rand -base64 32)
sed -i "s|^JWT_SECRET=.*|JWT_SECRET=$JWT_SECRET|g" .env
ANON_KEY=$(openssl rand -hex 32)
sed -i "s|^ANON_KEY=.*|ANON_KEY=$ANON_KEY|g" .env
SERVICE_ROLE_KEY=$(openssl rand -hex 32)
sed -i "s|^SERVICE_ROLE_KEY=.*|SERVICE_ROLE_KEY=$SERVICE_ROLE_KEY|g" .env
SECRET_KEY_BASE=$(openssl rand -base64 64)
sed -i "s|^SECRET_KEY_BASE=.*|SECRET_KEY_BASE=$SECRET_KEY_BASE|g" .env
VAULT_ENC_KEY=$(openssl rand -base64 32)
sed -i "s|^VAULT_ENC_KEY=.*|VAULT_ENC_KEY=$VAULT_ENC_KEY|g" .env
LOGFLARE_PUBLIC_ACCESS_TOKEN=$(openssl rand -hex 32)
sed -i "s|^LOGFLARE_PUBLIC_ACCESS_TOKEN=.*|LOGFLARE_PUBLIC_ACCESS_TOKEN=$LOGFLARE_PUBLIC_ACCESS_TOKEN|g" .env
LOGFLARE_PRIVATE_ACCESS_TOKEN=$(openssl rand -hex 32)
sed -i "s|^LOGFLARE_PRIVATE_ACCESS_TOKEN=.*|LOGFLARE_PRIVATE_ACCESS_TOKEN=$LOGFLARE_PRIVATE_ACCESS_TOKEN|g" .env
DASHBOARD_PASSWORD=$(openssl rand -base64 32)
sed -i "s|^DASHBOARD_PASSWORD=.*|DASHBOARD_PASSWORD=$DASHBOARD_PASSWORD|g" .env
SMTP_PASS=$(openssl rand -base64 32)
sed -i "s|^SMTP_PASS=.*|SMTP_PASS=$SMTP_PASS|g" .env

# Se não tiver domínio, expor a porta do Supabase publicamente
if [[ ! "$HAS_DOMAIN" =~ ^[Ss]$ ]]; then
    echo -e "${C_YELLOW}A expor a porta 8000 do Supabase, pois não foi fornecido um domínio.${C_NC}"
    echo -e "${C_RED}AVISO DE SEGURANÇA: O Supabase ficará acessível publicamente em http://<IP>:8000. Não use em produção sem HTTPS ou firewall!${C_NC}"
    sed -i '/kong:/,/^\s*$/s/#- 8000:8000/- 8000:8000/' ./docker-compose.yml
fi

echo -e "\n${C_BLUE}A iniciar os contentores do Supabase...${C_NC}"
if ! docker compose up -d; then
  echo -e "${C_YELLOW}AVISO: Um ou mais serviços falharam ao iniciar, mas o deploy vai continuar. Verifica os logs abaixo!${C_NC}"
  echo -e "${C_YELLOW}Logs do supabase-analytics (últimos 50):${C_NC}"
  docker logs --tail=50 supabase-analytics || echo -e "${C_YELLOW}Não foi possível obter logs do supabase-analytics.${C_NC}"
fi

# Espera ativa pelos containers críticos ficarem running/healthy
MAX_WAIT=90
WAITED=0
SLEEP_STEP=5
echo -e "${C_BLUE}A aguardar até 90s pelos containers críticos ficarem prontos...${C_NC}"
CRITICAL_CONTAINERS=(supabase-db supabase-rest supabase-auth supabase-storage supabase-kong)
while true; do
  ALL_READY=1
  for cname in "${CRITICAL_CONTAINERS[@]}"; do
    STATUS=$(docker inspect -f '{{.State.Status}}' $cname 2>/dev/null || echo "unknown")
    HEALTH=$(docker inspect -f '{{.State.Health.Status}}' $cname 2>/dev/null || echo "unknown")
    if [[ "$STATUS" != "running" ]]; then
      ALL_READY=0
      break
    fi
    if [[ "$HEALTH" == "unhealthy" ]]; then
      ALL_READY=0
      break
    fi
  done
  if [[ $ALL_READY -eq 1 ]]; then
    break
  fi
  if [[ $WAITED -ge $MAX_WAIT ]]; then
    echo -e "${C_YELLOW}AVISO: Alguns containers podem não estar prontos após ${MAX_WAIT}s. O deploy vai continuar, mas verifica os logs se algo falhar.${C_NC}"
    break
  fi
  sleep $SLEEP_STEP
  WAITED=$((WAITED+SLEEP_STEP))
done

# --- 5. Diagnóstico automático dos containers ---
echo -e "\n${C_BLUE}A verificar o estado dos containers Supabase...${C_NC}"
ALL_OK=1

for cname in "${CRITICAL_CONTAINERS[@]}"; do
  STATUS=$(docker inspect -f '{{.State.Status}}' $cname 2>/dev/null || echo "unknown")
  HEALTH=$(docker inspect -f '{{.State.Health.Status}}' $cname 2>/dev/null || echo "unknown")

  if [[ "$STATUS" != "running" ]]; then
    echo -e "${C_RED}ERRO: Container $cname não está a correr (status: $STATUS). Tentando correção automática...${C_NC}"
    if [[ "$cname" == "supabase-db" ]]; then
      echo -e "${C_YELLOW}Corrigindo permissões da base de dados...${C_NC}"
      sudo chown -R 70:70 $SUPABASE_DIR/volumes/db 2>/dev/null || true
    fi
    docker restart $cname
    sleep 5
    STATUS2=$(docker inspect -f '{{.State.Status}}' $cname 2>/dev/null || echo "unknown")
    if [[ "$STATUS2" != "running" ]]; then
      echo -e "${C_RED}Container $cname continua parado ($STATUS2). Últimos logs:${C_NC}"
      docker logs --tail=20 $cname
      ALL_OK=0
    else
      echo -e "${C_GREEN}Container $cname recuperado!${C_NC}"
    fi
  elif [[ "$HEALTH" == "unhealthy" ]]; then
    echo -e "${C_RED}ERRO: Container $cname está unhealthy! Tentando correção automática...${C_NC}"
    docker restart $cname
    sleep 5
    HEALTH2=$(docker inspect -f '{{.State.Health.Status}}' $cname 2>/dev/null || echo "unknown")
    if [[ "$HEALTH2" == "unhealthy" ]]; then
      echo -e "${C_RED}Container $cname continua unhealthy. Últimos logs:${C_NC}"
      docker logs --tail=20 $cname
      ALL_OK=0
    else
      echo -e "${C_GREEN}Container $cname recuperado!${C_NC}"
    fi
  elif [[ "$HEALTH" == "starting" || "$HEALTH" == "unknown" ]]; then
    echo -e "${C_YELLOW}AVISO: Container $cname está $STATUS/$HEALTH. Pode demorar a ficar saudável ou não ter healthcheck definido.${C_NC}"
  else
    echo -e "${C_GREEN}Container $cname está saudável (${STATUS}/${HEALTH})${C_NC}"
  fi
done

if [[ $ALL_OK -eq 0 ]]; then
  echo -e "\n${C_RED}Erro: Um ou mais serviços críticos do Supabase não iniciaram corretamente. Veja os logs acima e verifique memória, permissões e configuração do .env.${C_NC}"
  exit 1
else
  echo -e "\n${C_GREEN}Todos os serviços críticos do Supabase estão a correr!${C_NC}"
fi

# --- 5. Configurar Aplicação Astro ---
echo -e "\n${C_BLUE}A configurar a aplicação Astro...${C_NC}"

# Instalar NVM e Node.js
export NVM_DIR="/root/.nvm"
if [ ! -d "$NVM_DIR/.git" ]; then
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR" || { echo -e "${C_RED}ERRO: Falha ao clonar NVM${C_NC}"; exit 2; }
  cd "$NVM_DIR"
else
  cd "$NVM_DIR"
  git fetch --tags || { echo -e "${C_RED}ERRO: Falha ao atualizar NVM${C_NC}"; exit 2; }
fi
git checkout "$(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))" || { echo -e "${C_RED}ERRO: Falha ao fazer checkout do último tag do NVM${C_NC}"; exit 2; }
true
nvm install 20
nvm use 20

# Instalar PM2
npm install -g pm2

# Usar o código já presente na pasta atual
APP_DIR="$(pwd)"
cd $APP_DIR

# --- 6. Configuração Específica (Domínio vs IP) ---
if [[ "$HAS_DOMAIN" =~ ^[Ss]$ ]]; then
    # --- Configuração com Domínio (HTTPS) ---
    read -p "Qual é o seu nome de domínio (ex: astrovpn.com)? " DOMAIN_NAME
    read -p "Qual é o seu email (para o certificado SSL)? " LETSENCRYPT_EMAIL

    echo -e "\n${C_BLUE}A criar o ficheiro .env para o domínio...${C_NC}"
    cat << EOF > .env
PUBLIC_SUPABASE_URL=http://localhost:8000
PUBLIC_SUPABASE_ANON_KEY=$ANON_KEY
EOF

    npm install
    npm run build

    echo -e "\n${C_BLUE}A instalar e configurar o Caddy...${C_NC}"
    apt-get install -y debian-keyring debian-archive-keyring apt-transport-https
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
    apt-get update
    apt-get install -y caddy

    cat << EOF > /etc/caddy/Caddyfile
$DOMAIN_NAME {
    reverse_proxy localhost:4321
    encode gzip
    tls $LETSENCRYPT_EMAIL
}
EOF
    systemctl reload caddy

    pm2 start npm --name astrovpn -- run start
    pm2 startup
    pm2 save

    echo -e "\n${C_GREEN}🎉 Implementação com domínio concluída! 🎉${C_NC}"
    echo -e "O seu site deve estar acessível em: ${C_YELLOW}https://$DOMAIN_NAME${C_NC}"

else
    # --- Configuração com IP (HTTP) ---
    read -p "Qual é o endereço IP público do seu servidor? " IP_ADDRESS
    echo -e "\n${C_RED}AVISO: O site será executado em HTTP, que não é seguro para produção.${C_NC}"

    echo -e "\n${C_BLUE}A criar o ficheiro .env para o IP...${C_NC}"
    cat << EOF > .env
PUBLIC_SUPABASE_URL=http://$IP_ADDRESS:8000
PUBLIC_SUPABASE_ANON_KEY=$ANON_KEY
EOF

    npm install
    npm run build

    pm2 start npm --name astrovpn -- run start
    pm2 startup
    pm2 save

    echo -e "\n${C_GREEN}🎉 Implementação com IP concluída! 🎉${C_NC}"
    echo -e "O seu site deve estar acessível em: ${C_YELLOW}http://$IP_ADDRESS:4321${C_NC}"
fi

echo -e "Pode monitorizar a sua aplicação com o comando: ${C_YELLOW}pm2 monit${C_NC}"

