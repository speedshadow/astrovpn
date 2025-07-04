import type { APIRoute } from 'astro';
import { createClient } from '@supabase/supabase-js';

// Do not expose sensitive data here, this is a public endpoint
const supabaseUrl = import.meta.env.PUBLIC_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.PUBLIC_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Supabase URL or anonymous key is not set.');
}

const supabase = createClient(supabaseUrl, supabaseAnonKey);

export const GET: APIRoute = async () => {
  const { data: vpns, error } = await supabase
    .from('vpns')
    .select('id, name, slug, logo_url, star_rating, affiliate_link, pros, cons, categories, simultaneous_connections, server_count, country_count, has_kill_switch, has_double_vpn, keeps_logs, supported_devices, price_monthly_usd, price_monthly_eur, has_p2p, has_ad_blocker')
    .eq('show_on_homepage', true);

  if (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  return new Response(JSON.stringify(vpns),
    {
      status: 200,
      headers: {
        'Content-Type': 'application/json',
      },
    }
  );
};
