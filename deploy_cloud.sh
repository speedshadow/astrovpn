#!/bin/bash

# Cores para output
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_BLUE='\033[0;34m'
C_YELLOW='\033[0;33m'
C_NC='\033[0m' # No Color

echo -e "${C_BLUE}=== AstroVPN Deploy (Supabase Cloud + Astro) ===${C_NC}"

# --- 1. Verificar dependências ---
echo -e "${C_BLUE}--- Verificando dependências (Git, Node.js, npm) ---${C_NC}"
command -v git >/dev/null 2>&1 || { echo -e "${C_RED}Git não encontrado. Por favor instale Git.${C_NC}"; exit 1; }
command -v node >/dev/null 2>&1 || { echo -e "${C_RED}Node.js não encontrado. Por favor instale Node.js.${C_NC}"; exit 1; }
command -v npm >/dev/null 2>&1 || { echo -e "${C_RED}npm não encontrado. Por favor instale npm.${C_NC}"; exit 1; }
echo "Dependências OK."

# --- 2. Configurar variáveis de ambiente ---
echo -e "${C_BLUE}--- Configurando variáveis de ambiente ---${C_NC}"
echo -e "${C_YELLOW}Por favor, forneça as informações do seu projeto Supabase Cloud:${C_NC}"
read -p "URL do Supabase (ex: https://abcdefghijklm.supabase.co): " SUPABASE_URL
read -p "Chave anônima do Supabase (anon key): " SUPABASE_ANON_KEY

# Criar ou atualizar o arquivo .env
cat > .env << EOL
PUBLIC_SUPABASE_URL=${SUPABASE_URL}
PUBLIC_SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY}
EOL

echo -e "${C_GREEN}Arquivo .env criado com sucesso.${C_NC}"

# --- 3. Instalar dependências e construir o projeto ---
echo -e "${C_BLUE}--- Instalando dependências ---${C_NC}"
npm install

echo -e "${C_BLUE}--- Construindo o projeto ---${C_NC}"
npm run build

# --- 4. Configurar PM2 para o frontend ---
echo -e "${C_BLUE}--- Configurando PM2 ---${C_NC}"
command -v pm2 >/dev/null 2>&1 || { 
    echo -e "${C_YELLOW}PM2 não encontrado. Instalando...${C_NC}"
    npm install -g pm2
}

# Parar instância anterior se existir
pm2 stop astrovpn-frontend 2>/dev/null || true
pm2 delete astrovpn-frontend 2>/dev/null || true

# Iniciar com PM2
echo -e "${C_BLUE}--- Iniciando aplicação com PM2 ---${C_NC}"
pm2 start npm --name "astrovpn-frontend" -- start

# Salvar configuração do PM2
pm2 save

echo -e "${C_GREEN}=== Deploy concluído com sucesso! ===${C_NC}"
echo -e "${C_BLUE}Seu frontend Astro está rodando em: http://localhost:4322${C_NC}"
echo -e "${C_BLUE}Para acessar de fora, configure seu servidor web (Nginx/Caddy) para proxy reverso.${C_NC}"
echo -e "${C_YELLOW}Lembre-se de importar o schema SQL no seu projeto Supabase Cloud.${C_NC}"
