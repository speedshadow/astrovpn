import type { APIRoute } from 'astro';
import fs from 'fs/promises';
import path from 'path';

const configPath = path.resolve(
  process.cwd(),
  'supabase',
  'backup-config.json'
);

// Default configuration if the file doesn't exist
const defaultConfig = {
  schedule: 'daily',
  time: '02:00',
  storagePath: '/var/backups/supabase',
};

export const GET: APIRoute = async () => {
  try {
    const data = await fs.readFile(configPath, 'utf-8');
    return new Response(data, {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    // If the file doesn't exist, return the default configuration
    if (
      error &&
      typeof error === 'object' &&
      'code' in error &&
      error.code === 'ENOENT'
    ) {
      return new Response(JSON.stringify(defaultConfig), {
        status: 200, // It's not an error, just the first run
        headers: { 'Content-Type': 'application/json' },
      });
    }
    console.error('Failed to read backup config:', error);
    return new Response(
      JSON.stringify({ error: 'Failed to read configuration.' }),
      {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      }
    );
  }
};

export const POST: APIRoute = async ({ request }) => {
  try {
    const config = await request.json();

    // Basic validation
    if (!config.schedule || !config.time || !config.storagePath) {
      return new Response(
        JSON.stringify({ error: 'Invalid configuration data.' }),
        {
          status: 400,
          headers: { 'Content-Type': 'application/json' },
        }
      );
    }

    await fs.writeFile(configPath, JSON.stringify(config, null, 2), 'utf-8');

    return new Response(
      JSON.stringify({ message: 'Configuration saved successfully.' }),
      {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      }
    );
  } catch (error) {
    console.error('Failed to save backup config:', error);
    return new Response(
      JSON.stringify({ error: 'Failed to save configuration.' }),
      {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      }
    );
  }
};
