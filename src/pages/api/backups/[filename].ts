import type { APIRoute } from 'astro';
import { promises as fs } from 'fs';
import path from 'path';

const backupDir = path.resolve(process.cwd(), 'backup');

// GET: Descarrega um ficheiro de backup específico
export const GET: APIRoute = async ({ params }) => {
  // Sanitize the filename to prevent path traversal attacks
  const sanitizedFilename = path.basename(params.filename as string);

  if (!sanitizedFilename || !/^[a-zA-Z0-9_.-]+\.sql$/.test(sanitizedFilename)) {
    return new Response('Nome de ficheiro inválido.', { status: 400 });
  }

  const filePath = path.join(backupDir, sanitizedFilename);

  try {
    await fs.access(filePath); // Verifica se o ficheiro existe
    const fileStream = await fs.readFile(filePath);

    return new Response(fileStream, {
      status: 200,
      headers: {
        'Content-Type': 'application/sql',
        'Content-Disposition': `attachment; filename="${sanitizedFilename}"`,
      },
    });
  } catch (error) {
    console.error(`Ficheiro de backup não encontrado: ${sanitizedFilename}`, error);
    return new Response('Ficheiro de backup não encontrado.', { status: 404 });
  }
};

// DELETE: Apaga um ficheiro de backup específico
export const DELETE: APIRoute = async ({ params }) => {
  // Sanitize the filename to prevent path traversal attacks
  const sanitizedFilename = path.basename(params.filename as string);

  if (!sanitizedFilename || !/^[a-zA-Z0-9_.-]+\.sql$/.test(sanitizedFilename)) {
    return new Response('Nome de ficheiro inválido.', { status: 400 });
  }

  const filePath = path.join(backupDir, sanitizedFilename);

  try {
    await fs.access(filePath); // Verifica se o ficheiro existe
    await fs.unlink(filePath); // Apaga o ficheiro

    return new Response(
      JSON.stringify({ message: 'Backup apagado com sucesso.' }),
      {
        status: 200,
      }
    );
  } catch (error) {
    console.error(`Falha ao apagar o backup: ${sanitizedFilename}`, error);
    return new Response(
      'Ficheiro de backup não encontrado ou falha ao apagar.',
      { status: 404 }
    );
  }
};
