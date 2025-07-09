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
  locals.supabase = createServerClient(
    import.meta.env.PUBLIC_SUPABASE_URL,
    import.meta.env.PUBLIC_SUPABASE_ANON_KEY,
    {
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
    }
  );

  const {
    data: { session },
  } = await locals.supabase.auth.getSession();
  locals.session = session;
  locals.user = session?.user ?? null;

  // Only run auth checks for admin routes
  if (pathname.startsWith('/admin')) {
    // If the user is logged in, check their role
    if (session) {
      // Temporary admin check using email until a proper role system is in place
      const isAdmin = session.user?.email === 'admin@admin.com';

      // If they are an admin and on the login page, redirect to the dashboard
      if (isAdmin && pathname === '/admin/login') {
        return redirect('/admin/dashboard');
      }

      // If they are NOT an admin, redirect them away from any admin page
      if (!isAdmin) {
        return redirect('/');
      }
    } else {
      // User is not logged in. Redirect to login page if they are not already there.
      if (pathname !== '/admin/login') {
        return redirect('/admin/login');
      }
    }
  }

  return next();
};
