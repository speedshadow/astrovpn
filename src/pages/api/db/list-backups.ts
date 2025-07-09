import type { APIRoute } from 'astro';
import { supabase } from '@/lib/supabase';
import fs from 'fs/promises';
import path from 'path';

// Define o caminho absoluto para a diretoria de backups
const BACKUPS_DIR = path.resolve(process.cwd(), 'supabase/backups');

export const GET: APIRoute = async ({ request }) => {
  // Autenticação do utilizador via Supabase
  const authHeader = request.headers.get('Authorization');
  if (!authHeader) {
    return new Response(JSON.stringify({ error: 'Unauthorized' }), {
      status: 401,
    });
  }
  const token = authHeader.split(' ')[1];
  const {
    data: { user },
    error: userError,
  } = await supabase.auth.getUser(token);

  if (userError || !user) {
    return new Response(JSON.stringify({ error: 'Unauthorized' }), {
      status: 401,
    });
  }

  try {
    // Garante que a diretoria de backups existe, criando-a se não existir
    await fs.mkdir(BACKUPS_DIR, { recursive: true });

    // Lê todos os ficheiros na diretoria
    const allFiles = await fs.readdir(BACKUPS_DIR);

    // Filtra para incluir apenas ficheiros .dump e ordena por data (mais recentes primeiro)
    const backupFiles = allFiles
      .filter((file) => file.endsWith('.dump'))
      .sort((a, b) => b.localeCompare(a)); // Ordenação alfabética descendente funciona para nomes com timestamp

    return new Response(JSON.stringify({ backups: backupFiles }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (err) {
    console.error('Error listing backups:', err);
    return new Response(
      JSON.stringify({
        error: 'Failed to list backups',
        details: (err as Error).message,
      }),
      {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      }
    );
  }
};
