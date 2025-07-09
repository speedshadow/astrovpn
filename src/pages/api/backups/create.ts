import type { APIRoute } from 'astro';
import { exec } from 'child_process';
import { promises as fs } from 'fs';
import path from 'path';
import util from 'util';

const execPromise = util.promisify(exec);
const backupDir = path.resolve(process.cwd(), 'backup');

const ensureBackupDir = async () => {
  try {
    await fs.access(backupDir);
  } catch (error) {
    await fs.mkdir(backupDir, { recursive: true });
  }
};

export const POST: APIRoute = async ({ locals }) => {
  try {
    const { session } = locals;
    if (!session) {
      return new Response(JSON.stringify({ message: 'Não autorizado' }), {
        status: 401,
      });
    }

    const dbUrl = process.env.DATABASE_URL;
    if (!dbUrl) {
      console.error(
        'CRITICAL: DATABASE_URL is not defined in the server environment.'
      );
      return new Response(
        JSON.stringify({
          message:
            'Configuração do servidor incompleta: DATABASE_URL em falta.',
        }),
        { status: 500 }
      );
    }

    await ensureBackupDir();

    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const fileName = `backup-${timestamp}.sql`;
    const filePath = path.join(backupDir, fileName);

    const url = new URL(dbUrl);
    const password = url.password;
    const user = url.username;
    const host = url.hostname;
    const port = url.port;
    const database = url.pathname.slice(1);

    const command = `pg_dump -U ${user} -h ${host} -p ${port} -d ${database} --no-password > "${filePath}"`;

    const { stderr } = await execPromise(command, {
      env: {
        ...process.env,
        PGPASSWORD: password,
      },
    });

    if (stderr) {
      console.error(`pg_dump error: ${stderr}`);
      // Attempt to delete the empty/partial backup file on error
      try {
        await fs.unlink(filePath);
      } catch (unlinkError) {
        // Ignore errors if the file can't be deleted
      }
      return new Response(
        JSON.stringify({ message: `Erro ao executar o backup: ${stderr}` }),
        { status: 500 }
      );
    }

    return new Response(
      JSON.stringify({
        message: 'Backup criado com sucesso!',
        filename: fileName,
      }),
      { status: 201 }
    );
  } catch (error: any) {
    console.error('Catastrophic error during backup creation:', error);
    return new Response(
      JSON.stringify({
        message: 'Ocorreu um erro inesperado no servidor.',
        details: error.message,
      }),
      { status: 500 }
    );
  }
};
