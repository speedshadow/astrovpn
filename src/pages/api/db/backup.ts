import type { APIRoute } from 'astro';
import { exec } from 'child_process';
import { promisify } from 'util';
import fs from 'fs/promises';
import path from 'path';
import { supabase } from '../../../lib/supabase';

const execPromise = promisify(exec);

const CONTAINER_NAME = 'supabase_db_astrovpn';
const BACKUP_DIR = path.resolve(process.cwd(), 'supabase/backups');

export const POST: APIRoute = async ({ request }) => {
  const PGPASSWORD = import.meta.env.SUPABASE_DB_PASSWORD;
  // 1. Authentication
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

  // Ensure backup directory exists
  try {
    await fs.mkdir(BACKUP_DIR, { recursive: true });
  } catch (error) {
    console.error('Failed to create backup directory:', error);
    return new Response(
      JSON.stringify({ error: 'Failed to create backup directory' }),
      { status: 500 }
    );
  }

  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const backupFileName = `backup-${timestamp}.dump`;
  const backupFilePath = path.join(BACKUP_DIR, backupFileName);

  // 2. Create backup using pg_dump in custom format (-Fc)
  const backupCommand = `docker exec -e PGPASSWORD=${PGPASSWORD} ${CONTAINER_NAME} pg_dump -U postgres -d postgres -Fc`;

  try {
    // We need to capture binary stdout, so we specify the encoding as 'buffer'
    const { stdout, stderr } = await execPromise(backupCommand, {
      encoding: 'buffer',
    });

    if (stderr && stderr.length > 0) {
      const stderrStr = stderr.toString();
      // pg_dump often writes informational messages to stderr, so we only throw an error if it's a real error
      if (stderrStr.toLowerCase().includes('error')) {
        console.error('pg_dump stderr:', stderrStr);
        throw new Error(`pg_dump failed: ${stderrStr}`);
      }
    }

    await fs.writeFile(backupFilePath, stdout);

    return new Response(
      JSON.stringify({
        message: 'Backup created successfully',
        fileName: backupFileName,
      }),
      { status: 200 }
    );
  } catch (error: any) {
    console.error('Backup failed:', error);
    return new Response(
      JSON.stringify({
        error: 'Backup creation failed',
        details: error.message,
      }),
      { status: 500 }
    );
  }
};
