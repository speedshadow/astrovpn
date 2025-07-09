import type { APIRoute } from 'astro';
import type { SupabaseClient } from '@supabase/supabase-js';

interface Locals {
  supabase: SupabaseClient;
}
import fs from 'node:fs/promises';
import path from 'node:path';

const backupsDir = path.resolve(process.cwd(), 'supabase', 'backups');

// Função auxiliar para verificar autenticação
const checkAuth = async (locals: Locals) => {
  const { supabase } = locals;
  const {
    data: { session },
  } = await supabase.auth.getSession();

  if (!session) {
    throw new Error('Unauthorized');
  }
};

export const GET: APIRoute = async ({ params, locals }) => {
  try {
    await checkAuth(locals);

    const filename = params.filename;
    if (!filename) {
      return new Response('Nome do arquivo não especificado', { status: 400 });
    }

    // Validar nome do arquivo para evitar path traversal
    if (filename.includes('..') || filename.includes('/')) {
      return new Response('Nome do arquivo inválido', { status: 400 });
    }

    const filePath = path.join(backupsDir, filename);

    try {
      const fileContent = await fs.readFile(filePath);

      return new Response(fileContent, {
        status: 200,
        headers: {
          'Content-Type': 'application/sql',
          'Content-Disposition': `attachment; filename="${filename}"`,
        },
      });
    } catch (error) {
      console.error('Erro ao ler arquivo:', error);
      return new Response('Arquivo não encontrado', { status: 404 });
    }
  } catch (error: any) {
    console.error('Erro ao processar download:', error);
    const status = error.message === 'Unauthorized' ? 401 : 500;
    return new Response(error.message, { status });
  }
};
