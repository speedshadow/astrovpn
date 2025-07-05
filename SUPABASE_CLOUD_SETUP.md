# Guia de Configuração do Supabase Cloud para AstroVPN

Este guia explica como configurar o Supabase Cloud para o projeto AstroVPN e conectá-lo ao frontend Astro.

## 1. Criar uma conta no Supabase Cloud

1. Acesse [https://supabase.com](https://supabase.com)
2. Clique em "Start your project" ou "Sign up"
3. Faça login com GitHub ou crie uma conta

## 2. Criar um novo projeto

1. No dashboard do Supabase, clique em "New Project"
2. Escolha uma organização ou crie uma nova
3. Preencha os detalhes do projeto:
   - **Nome**: AstroVPN
   - **Database Password**: Crie uma senha forte
   - **Region**: Escolha a região mais próxima do seu público-alvo
4. Clique em "Create new project"
5. Aguarde a criação do projeto (pode levar alguns minutos)

## 3. Importar o schema do banco de dados

1. No menu lateral, vá para "SQL Editor"
2. Clique em "New Query"
3. Cole o conteúdo do arquivo `backup_clean.sql` do seu projeto
4. Clique em "Run" para executar o SQL e criar as tabelas

## 4. Obter as credenciais de API

1. No menu lateral, vá para "Project Settings" > "API"
2. Você verá duas chaves importantes:
   - **URL**: `https://[seu-projeto].supabase.co`
   - **anon public**: A chave anônima para acesso público
   - **service_role**: NÃO use esta chave no frontend (apenas para backend seguro)

## 5. Configurar autenticação (opcional)

1. No menu lateral, vá para "Authentication" > "Providers"
2. Habilite os métodos de autenticação desejados (Email, OAuth, etc.)
3. Configure os redirecionamentos para seu domínio

## 6. Configurar armazenamento (opcional)

1. No menu lateral, vá para "Storage"
2. Crie um novo bucket chamado "images" para armazenar imagens do site
3. Configure as permissões de acesso conforme necessário

## 7. Conectar ao frontend Astro

Use o script `deploy_cloud.sh` para configurar automaticamente o frontend com suas credenciais do Supabase Cloud:

```bash
chmod +x deploy_cloud.sh
./deploy_cloud.sh
```

O script solicitará:
- URL do Supabase (ex: https://abcdefghijklm.supabase.co)
- Chave anônima do Supabase (anon key)

## 8. Verificar a conexão

1. Após o deploy, acesse seu frontend
2. Verifique se os dados estão sendo carregados corretamente
3. Teste as funcionalidades de autenticação e armazenamento

## Solução de problemas

- **Erro CORS**: No Supabase, vá para "Project Settings" > "API" > "CORS" e adicione seu domínio
- **Erro de autenticação**: Verifique se as chaves de API estão corretas no arquivo `.env`
- **Tabelas não encontradas**: Verifique se o schema SQL foi importado corretamente
