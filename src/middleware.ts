import { createServerClient, type CookieOptions } from '@supabase/ssr';
import type { MiddlewareHandler } from 'astro';
import { startBackupScheduler } from './lib/backup-scheduler';

// Define a global flag to ensure the scheduler starts only once.
// This is a common pattern to run code only on server startup in a serverless environment.
declare global {
  var isBackupSchedulerStarted: boolean;
}

// Start the backup scheduler only once.
// We check for `import.meta.env.PROD` to run it only in the production environment,
// avoiding multiple initializations during development with HMR (Hot Module Replacement).
if (import.meta.env.PROD && !global.isBackupSchedulerStarted) {
  startBackupScheduler();
  global.isBackupSchedulerStarted = true;
}

export const onRequest: MiddlewareHandler = async (context, next) => {
  const { locals, request, cookies, redirect } = context;
  const pathname = new URL(request.url).pathname;

  // Initialize Supabase client for all server-side requests
  locals.supabase = createServerClient(import.meta.env.PUBLIC_SUPABASE_URL, import.meta.env.PUBLIC_SUPABASE_ANON_KEY, {
    cookies: {
      get(key: string) {
        return cookies.get(key)?.value;
      },
      set(key: string, value: string, options: CookieOptions) {
        cookies.set(key, value, options);
      },
      remove(key: string, options: CookieOptions) {
        cookies.delete(key, options);
      },
    },
  });

  const { data: { session } } = await locals.supabase.auth.getSession();
  locals.session = session;
  locals.user = session?.user ?? null;

  // Only run auth checks for admin routes
  if (pathname.startsWith('/admin')) {
    // User is not logged in and is trying to access a protected route
    if (!session && pathname !== '/admin/login') {
      return redirect('/admin/login');
    }

    // User is logged in and tries to access the login page
    if (session && pathname === '/admin/login') {
      return redirect('/admin/dashboard');
    }
  }

  return next();
};
