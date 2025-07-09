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
  } catch {
    await fs.mkdir(backupDir, { recursive: true });
  }
};

export const GET: APIRoute = async () => {
  await ensureBackupDir();
  try {
    const files = await fs.readdir(backupDir);
    const backupFiles = await Promise.all(
      files
        .filter((file) => file.endsWith('.sql'))
        .map(async (file) => {
          const stats = await fs.stat(path.join(backupDir, file));
          return {
            name: file,
            size: `${(stats.size / 1024 / 1024).toFixed(2)} MB`,
            date: stats.mtime.toISOString(),
          };
        })
    );
    backupFiles.sort(
      (a, b) => new Date(b.date).getTime() - new Date(a.date).getTime()
    );
    return new Response(JSON.stringify(backupFiles), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Erro ao listar backups:', error);
    return new Response(
      JSON.stringify({ message: 'Falha ao listar backups' }),
      { status: 500 }
    );
  }
};
