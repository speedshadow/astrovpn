import type { APIRoute } from 'astro';
import { exec } from 'child_process';
import { promisify } from 'util';
import fs from 'fs/promises';
import path from 'path';
import { supabase } from '../../../lib/supabase';

const execPromise = promisify(exec);

const CONTAINER_NAME = 'supabase_db_astrovpn';
const UPLOAD_DIR = path.resolve(process.cwd(), 'uploads');
const MAX_FILE_SIZE = 50 * 1024 * 1024; // 50 MB

// Helper to run command with logging
async function runCommand(command: string, options = {}) {
  try {
    const { stdout, stderr } = await execPromise(command, options);
    if (stderr) {
      // pg_restore logs to stderr, so we log it as info unless an error occurs
    }
    if (stdout) {
    }
    return { stdout, stderr };
  } catch (error: any) {
    console.error(`Error executing command: ${command}`);
    console.error(`Error details: ${error.message}`);
    // The stderr from the failed command is often the most useful info
    console.error(`Stderr: ${error.stderr}`);
    throw error;
  }
}

export const POST: APIRoute = async ({ request }) => {
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

  // 2. File Upload Handling
  let tempFilePath = '';
  try {
    const formData = await request.formData();
    const file = formData.get('backupFile') as File;

    if (!file) {
      return new Response(JSON.stringify({ error: 'No file uploaded' }), {
        status: 400,
      });
    }

    // Validate file type and size
    if (!file.name.endsWith('.dump')) {
      return new Response(
        JSON.stringify({
          error: 'Invalid file type. Only .dump files are allowed.',
        }),
        { status: 400 }
      );
    }

    if (file.size > MAX_FILE_SIZE) {
      return new Response(
        JSON.stringify({
          error: `File size exceeds the limit of ${MAX_FILE_SIZE / 1024 / 1024} MB`,
        }),
        { status: 400 }
      );
    }

    // Create a temporary file to store the upload
    await fs.mkdir(UPLOAD_DIR, { recursive: true });
    tempFilePath = path.join(UPLOAD_DIR, `restore-${Date.now()}.dump`);
    const buffer = Buffer.from(await file.arrayBuffer());
    await fs.writeFile(tempFilePath, buffer);

    // 3. Restore using pg_restore

    // This command is much safer. It cleans the DB before restoring.
    // --clean: Drops database objects before recreating them.
    // --if-exists: Avoids errors if objects don't exist.
    // --no-owner / --no-privileges: Avoids permission errors in Supabase.
    const PGPASSWORD = import.meta.env.SUPABASE_DB_PASSWORD;
    // Use a safer restore command that only targets public data and avoids touching system tables.
    const restoreCommand = `cat "${tempFilePath}" | docker exec -i -e PGPASSWORD=${PGPASSWORD} ${CONTAINER_NAME} pg_restore --verbose --data-only --schema=public --disable-triggers -U supabase_admin -d postgres`;

    await runCommand(restoreCommand);

    return new Response(
      JSON.stringify({ message: 'Database restored successfully' }),
      { status: 200 }
    );
  } catch (error: any) {
    console.error('Restore failed:', error);
    // Provide the detailed stderr from pg_restore in the response
    const errorDetails = error.stderr || error.message;
    return new Response(
      JSON.stringify({ error: 'Restore failed', details: errorDetails }),
      { status: 500 }
    );
  } finally {
    // 4. Cleanup
    if (tempFilePath) {
      try {
        await fs.unlink(tempFilePath);
      } catch (cleanupError) {
        console.error(
          `Failed to clean up temporary file ${tempFilePath}:`,
          cleanupError
        );
      }
    }
  }
};
