import cron from 'node-cron';
import { exec } from 'child_process';
import { promises as fs } from 'fs';
import path from 'path';
import util from 'util';

const execPromise = util.promisify(exec);
const backupDir = path.resolve(process.cwd(), 'backup');
const MAX_BACKUPS = 7; // Número máximo de backups automáticos a manter

/**
 * Garante que o diretório de backup exista.
 */
const ensureBackupDir = async () => {
  try {
    await fs.access(backupDir);
  } catch {
    await fs.mkdir(backupDir, { recursive: true });
  }
};

/**
 * Cria um novo ficheiro de backup da base de dados.
 */
const createBackup = async () => {
  await ensureBackupDir();

  // Carrega as variáveis de ambiente (necessário ao executar como um script separado)
  // Para o Supabase, a DATABASE_URL já deve estar no ambiente do processo
  const dbUrl = process.env.DATABASE_URL || import.meta.env.DATABASE_URL;

  if (!dbUrl) {
    console.error(
      '[AutoBackup] Falha: A variável de ambiente DATABASE_URL não está definida.'
    );
    return;
  }

  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const fileName = `auto-backup-${timestamp}.sql`;
  const filePath = path.join(backupDir, fileName);
  const command = `pg_dump "${dbUrl}" > "${filePath}"`;

  try {
    const { stderr } = await execPromise(command);
    if (stderr) {
      console.warn('[AutoBackup] pg_dump stderr:', stderr);
    }
  } catch (error) {
    console.error('[AutoBackup] Falha ao criar backup automático:', error);
  }
};

/**
 * Apaga os backups automáticos mais antigos, mantendo apenas o número definido em MAX_BACKUPS.
 */
const cleanupOldBackups = async () => {
  await ensureBackupDir();

  try {
    const files = await fs.readdir(backupDir);
    const autoBackups = (
      await Promise.all(
        files
          .filter(
            (file) => file.startsWith('auto-backup-') && file.endsWith('.sql')
          )
          .map(async (file) => ({
            name: file,
            time: (await fs.stat(path.join(backupDir, file))).mtime.getTime(),
          }))
      )
    ).sort((a, b) => b.time - a.time); // Ordena do mais recente para o mais antigo

    if (autoBackups.length > MAX_BACKUPS) {
      const filesToDelete = autoBackups.slice(MAX_BACKUPS);

      for (const file of filesToDelete) {
        await fs.unlink(path.join(backupDir, file.name));
      }
    }
  } catch (error) {
    console.error('[AutoBackup] Falha ao limpar backups antigos:', error);
  }
};

/**
 * Inicia o agendador de tarefas de backup.
 */
export const startBackupScheduler = () => {
  // Agenda a criação de backup para todos os dias às 2:00 da manhã.
  cron.schedule(
    '0 2 * * *',
    () => {
      createBackup();
    },
    { timezone: 'Europe/Lisbon' }
  );

  // Agenda a limpeza de backups para todos os dias às 3:00 da manhã.
  cron.schedule(
    '0 3 * * *',
    () => {
      cleanupOldBackups();
    },
    { timezone: 'Europe/Lisbon' }
  );
};
