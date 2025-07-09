#!/bin/bash

# === AstroVPN & Supabase Production Deployment Script ===
# Este script automatiza a implementação completa da sua aplicação e do Supabase
# num servidor VPS Linux limpo (como Ubuntu 22.04).
# Executa como root para instalar dependências.

set -e
set -x
trap 'echo -e "${C_RED}ERRO na linha $LINENO: $BASH_COMMAND${C_NC}"' ERR

# Cores e helpers
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_BLUE='\033[0;34m'
C_YELLOW='\033[1;33m'
C_NC='\033[0m'

# Garante que o script corre no diretório onde ele se encontra
cd "$(dirname "$0")"

# --- 1. Boas-vindas e Confirmação ---
echo -e "${C_BLUE}Bem-vindo ao Deploy Automatizado do AstroVPN com Supabase!${C_NC}"
echo -e "${C_YELLOW}AVISO: Este script irá parar e apagar TODOS os containers e volumes Docker existentes associados a este projeto para garantir um deploy limpo.${C_NC}"
read -p "Deseja continuar? (s/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Deploy cancelado."
    exit 1
fi

# --- 2. Limpeza Total ---
echo -e "\n${C_BLUE}A parar e a remover containers e volumes antigos...${C_NC}"
docker compose down -v --remove-orphans || true

# --- 3. Configuração do Domínio/IP ---
echo -e "\n${C_BLUE}Como pretende aceder ao Supabase?${C_NC}"
read -p "Vai usar um domínio (ex: supabase.meudominio.com)? (s/N) " HAS_DOMAIN

if [[ "$HAS_DOMAIN" =~ ^[Ss]$ ]]; then
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

# --- 4. Geração do .env ---
echo -e "\n${C_BLUE}A gerar o ficheiro .env com novos segredos...${C_NC}"
chmod +x ./generate-env.sh
./generate-env.sh "$SITE_URL"

# --- 5. Deploy com Docker Compose ---
echo -e "\n${C_BLUE}A iniciar todos os serviços do Supabase com Docker Compose...${C_NC}"
docker compose pull
docker compose up -d --build

# --- 6. Verificação de Estado e Conclusão ---
echo -e "\n${C_BLUE}A aguardar que os serviços principais fiquem saudáveis...${C_NC}"
sleep 10 # Dá tempo para os containers arrancarem

CRITICAL_CONTAINERS=("supabase-db" "supabase-kong" "supabase-auth" "supabase-rest" "supabase-storage")
ALL_HEALTHY=true

for service in "${CRITICAL_CONTAINERS[@]}"; do
    HEALTH_STATUS=$(docker inspect --format '{{.State.Health.Status}}' "$service" 2>/dev/null || echo "no-health-check")
    if [[ "$HEALTH_STATUS" == "healthy" ]] || [[ "$HEALTH_STATUS" == "no-health-check" ]]; then
        echo -e "  - ${C_GREEN}$service está operacional.${C_NC}"
    elif [[ "$HEALTH_STATUS" == "starting" ]]; then
        echo -e "  - ${C_YELLOW}$service está a arrancar... (isto é normal)${C_NC}"
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

echo -e "\n${C_GREEN}Deploy do Supabase concluído!${C_NC}"
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
