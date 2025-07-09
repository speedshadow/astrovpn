import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.PUBLIC_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.PUBLIC_SUPABASE_ANON_KEY;

const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function getOrCreateSession() {
  const {
    data: { session },
    error: getSessionError,
  } = await supabase.auth.getSession();

  if (getSessionError) {
    console.error('[Analytics] Error getting session:', getSessionError);
    return null;
  }

  if (session) {
    return session;
  }

  const { data: signInData, error: signInError } =
    await supabase.auth.signInAnonymously();

  if (signInError) {
    console.error('[Analytics] Anonymous sign-in error:', signInError);
    return null;
  }

  if (signInData?.session) {
    return signInData.session;
  }

  console.error('[Analytics] Anonymous sign-in did not return a session.');
  return null;
}

export async function trackPageView() {
  const path = window.location.pathname;

  if (path.startsWith('/admin')) {
    return;
  }

  try {
    const session = await getOrCreateSession();
    if (!session) {
      console.error(
        '[Analytics] Could not get or create a session. Aborting page view track.'
      );
      return;
    }

    const { error } = await supabase.from('page_views').insert({
      path: path,
      session_id: session.user.id,
    });

    if (error) {
      console.error('[Analytics] Error inserting page view:', error);
    }
  } catch (e) {
    console.error('[Analytics] A critical error occurred in trackPageView:', e);
  }
}

export async function trackAffiliateClick(vpnId: number) {
  try {
    const session = await getOrCreateSession();
    if (!session) {
      console.error(
        '[Analytics] Could not get or create a session. Aborting affiliate click track.'
      );
      return;
    }

    const { error } = await supabase.from('affiliate_clicks').insert({
      vpn_id: vpnId,
      session_id: session.user.id,
    });

    if (error) {
      console.error('[Analytics] Error tracking affiliate click:', error);
    }
  } catch (e) {
    console.error(
      '[Analytics] A critical error occurred in trackAffiliateClick:',
      e
    );
  }
}
