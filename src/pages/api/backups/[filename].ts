import type { APIRoute } from 'astro';
import { promises as fs } from 'fs';
import path from 'path';

const backupDir = path.resolve(process.cwd(), 'backup');

// GET: Descarrega um ficheiro de backup específico
export const GET: APIRoute = async ({ params }) => {
  const { filename } = params;

  if (!filename || !/^[a-zA-Z0-9_.-]+\.sql$/.test(filename)) {
    return new Response('Nome de ficheiro inválido.', { status: 400 });
  }

  const filePath = path.join(backupDir, filename);

  try {
    await fs.access(filePath); // Verifica se o ficheiro existe
    const fileStream = await fs.readFile(filePath);

    return new Response(fileStream, {
      status: 200,
      headers: {
        'Content-Type': 'application/sql',
        'Content-Disposition': `attachment; filename="${filename}"`,
      },
    });
  } catch (error) {
    console.error(`Ficheiro de backup não encontrado: ${filename}`, error);
    return new Response('Ficheiro de backup não encontrado.', { status: 404 });
  }
};

// DELETE: Apaga um ficheiro de backup específico
export const DELETE: APIRoute = async ({ params }) => {
  const { filename } = params;

  if (!filename || !/^[a-zA-Z0-9_.-]+\.sql$/.test(filename)) {
    return new Response('Nome de ficheiro inválido.', { status: 400 });
  }

  const filePath = path.join(backupDir, filename);

  try {
    await fs.access(filePath); // Verifica se o ficheiro existe
    await fs.unlink(filePath); // Apaga o ficheiro


    return new Response(JSON.stringify({ message: 'Backup apagado com sucesso.' }), {
      status: 200,
    });
  } catch (error) {
    console.error(`Falha ao apagar o backup: ${filename}`, error);
    return new Response('Ficheiro de backup não encontrado ou falha ao apagar.', { status: 404 });
  }
};
