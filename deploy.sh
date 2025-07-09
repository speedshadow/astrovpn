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
chmod +x ./generate-env.sh
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
