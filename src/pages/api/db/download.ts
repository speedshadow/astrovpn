import type { APIRoute } from 'astro';
import fs from 'node:fs/promises';
import path from 'node:path';

const backupsDir = path.resolve(process.cwd(), 'supabase/backups');

export const GET: APIRoute = async ({ request }) => {
  const url = new URL(request.url);
  const fileName = url.searchParams.get('file');

  if (!fileName || !/^[a-zA-Z0-9_.-]+\.sql$/.test(fileName)) {
    return new Response('Invalid filename', { status: 400 });
  }

  const filePath = path.join(backupsDir, fileName);

  try {
    const fileStat = await fs.stat(filePath);
    if (!fileStat.isFile()) {
      return new Response('Not a file', { status: 400 });
    }

    const fileContents = await fs.readFile(filePath);

    return new Response(fileContents, {
      status: 200,
      headers: {
        'Content-Type': 'application/sql',
        'Content-Disposition': `attachment; filename="${fileName}"`,
      },
    });
  } catch (error) {
    if (
      error &&
      typeof error === 'object' &&
      'code' in error &&
      error.code === 'ENOENT'
    ) {
      return new Response('File not found', { status: 404 });
    }
    console.error('Download failed:', error);
    return new Response('Failed to download file', { status: 500 });
  }
};
