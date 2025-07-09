import type { APIRoute } from 'astro';
import fs from 'node:fs/promises';
import path from 'node:path';
import { supabase } from '../../../lib/supabase';

const BACKUP_DIR = path.resolve(process.cwd(), 'supabase/backups');

export const GET: APIRoute = async ({ request }) => {
  // 1. Authentication from Authorization header
  const authHeader = request.headers.get('Authorization');
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return new Response(
      JSON.stringify({ details: 'Authorization header missing or malformed' }),
      { status: 401, headers: { 'Content-Type': 'application/json' } }
    );
  }
  const token = authHeader.split(' ')[1];

  const {
    data: { user },
    error: authError,
  } = await supabase.auth.getUser(token);

  if (authError || !user) {
    return new Response(
      JSON.stringify({ details: 'Authentication error: Invalid token' }),
      { status: 401, headers: { 'Content-Type': 'application/json' } }
    );
  }

  // 2. Get filename from query params
  const url = new URL(request.url);
  const filename = url.searchParams.get('filename');

  if (!filename) {
    return new Response(JSON.stringify({ details: 'Missing filename' }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  // 3. Security check for filename to prevent path traversal
  if (path.basename(filename) !== filename) {
    return new Response(JSON.stringify({ details: 'Invalid filename' }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  try {
    // 4. Construct file path and check existence
    const filePath = path.join(BACKUP_DIR, filename);
    await fs.access(filePath); // Throws if file doesn't exist

    // 5. Read file and stream it
    const fileContents = await fs.readFile(filePath);

    return new Response(fileContents, {
      status: 200,
      headers: {
        'Content-Type': 'application/octet-stream',
        'Content-Disposition': `attachment; filename="${filename}"`,
      },
    });
  } catch (error: any) {
    console.error('Download failed:', error);
    if (error.code === 'ENOENT') {
      return new Response(JSON.stringify({ details: 'File not found' }), {
        status: 404,
        headers: { 'Content-Type': 'application/json' },
      });
    }
    return new Response(JSON.stringify({ details: 'Could not read file' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};
