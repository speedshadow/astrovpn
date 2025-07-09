import type { APIRoute } from 'astro';
import { exec } from 'child_process';
import { promises as fs } from 'fs';
import path from 'path';
import os from 'os';
import util from 'util';

const execPromise = util.promisify(exec);

export const POST: APIRoute = async ({ request }) => {
  const dbUrl = import.meta.env.DATABASE_URL;

  if (!dbUrl) {
    return new Response(
      JSON.stringify({ message: 'DATABASE_URL não configurada.' }),
      { status: 500 }
    );
  }

  try {
    const formData = await request.formData();
    const file = formData.get('backupFile') as File | null;

    if (!file || !(file instanceof File)) {
      return new Response(
        JSON.stringify({ message: 'Nenhum ficheiro de backup enviado.' }),
        { status: 400 }
      );
    }

    const tempDir = os.tmpdir();
    const tempFilePath = path.join(tempDir, file.name);
    const fileBuffer = Buffer.from(await file.arrayBuffer());

    await fs.writeFile(tempFilePath, fileBuffer);

    // IMPORTANTE: Este comando apaga os dados existentes antes de restaurar.
    // O `psql` deve estar no PATH do sistema.
    const command = `psql "${dbUrl}" -f "${tempFilePath}"`;

    const { stderr } = await execPromise(command);

    if (stderr) {
      console.warn('psql stderr:', stderr);
    }

    // Limpa o ficheiro temporário após o restauro
    await fs.unlink(tempFilePath);

    return new Response(
      JSON.stringify({ message: 'Base de dados restaurada com sucesso.' }),
      { status: 200 }
    );
  } catch (error) {
    console.error('Falha no restauro:', error);
    return new Response(
      JSON.stringify({
        message: 'Falha ao restaurar a base de dados.',
        error: (error as Error).message,
      }),
      {
        status: 500,
      }
    );
  }
};
