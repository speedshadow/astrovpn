import { createClient, SupabaseClient } from '@supabase/supabase-js';

// Use a singleton pattern to ensure we only initialize the client once.
let supabase: SupabaseClient | null = null;

const getSupabase = () => {
  // If the client is already created, return it.
  if (supabase) {
    return supabase;
  }

  // Otherwise, create it for the first time.
  const supabaseUrl = import.meta.env.PUBLIC_SUPABASE_URL;
  const supabaseAnonKey = import.meta.env.PUBLIC_SUPABASE_ANON_KEY;

  if (!supabaseUrl || !supabaseAnonKey) {
    // This is not a critical error, so we just log it and disable tracking.
    console.log('Analytics info: Supabase credentials not set. Event tracking is disabled.');
    return null;
  }

  // Assign the new client to the singleton variable.
  supabase = createClient(supabaseUrl, supabaseAnonKey);
  return supabase;
};

async function getOrCreateSession() {
  const supabaseClient = getSupabase();
  if (!supabaseClient) return null;

  // First, try to get the current session
  const { data: { session }, error: getSessionError } = await supabaseClient.auth.getSession();

  if (getSessionError) {
    console.error('[Analytics] Error getting session:', getSessionError);
    return null;
  }

  // If a session exists, return it
  if (session) {
    return session;
  }

  // If no session, sign in anonymously to create one
  const { data: signInData, error: signInError } = await supabaseClient.auth.signInAnonymously();
  
  if (signInError) {
    console.error('[Analytics] Error signing in anonymously:', signInError);
    return null;
  }

  return signInData?.session ?? null;
}

export const trackEvent = async (eventName: string, eventData: any) => {
  const supabaseClient = getSupabase();
  if (!supabaseClient) {
    return; // Silently fail if Supabase is not configured.
  }

  try {
    const session = await getOrCreateSession();
    if (!session) {
      // This can happen if the anonymous sign-in fails. Not critical.
      return;
    }

    const { error } = await supabaseClient.from('analytics_events').insert([
      {
        event_name: eventName,
        event_data: eventData,
        // Use the user ID from the session for consistent tracking
        session_id: session.user.id, 
      },
    ]);

    if (error) {
      console.error('Error tracking event:', error);
    }
  } catch (err) {
    console.error('Failed to track event:', err);
  }
};

export async function trackPageView() {
  // Ensure this code only runs on the client-side
  if (typeof window === 'undefined') return;

  const path = window.location.pathname;

  // Don't track admin pages
  if (path.startsWith('/admin')) {
    return;
  }

  await trackEvent('page_view', { path });
}

export async function trackAffiliateClick(vpnId: number) {
  await trackEvent('affiliate_click', { vpn_id: vpnId });
}
