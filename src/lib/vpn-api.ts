import { createBrowserClient } from '@supabase/ssr';
import type { PopulatedReviewPage, Vpn } from '@/types';

// Create a lightweight Supabase client for browser use
const supabaseUrl = import.meta.env.PUBLIC_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.PUBLIC_SUPABASE_ANON_KEY;

export const supabase = createBrowserClient(supabaseUrl, supabaseAnonKey);

// Fetch a review page by slug
export async function fetchReviewPageBySlug(
  slug: string
): Promise<PopulatedReviewPage | null> {
  // 1. Fetch the review page data
  const { data: page, error: pageError } = await supabase
    .from('review_pages')
    .select('*')
    .eq('slug', slug)
    .single();

  if (pageError || !page) {
    console.error('Error fetching review page:', pageError);
    return null;
  }

  let orderedVpns: Vpn[] = [];

  // 2. If the page has associated VPNs, fetch their full data
  if (page.vpn_ids && page.vpn_ids.length > 0) {
    const { data: vpnData, error: vpnError } = await supabase
      .from('vpns')
      .select(
        'id,name,slug,logo_url,description,categories,star_rating,affiliate_link,price_monthly_usd,price_yearly_usd,price_monthly_eur,price_yearly_eur,detailed_ratings,supported_devices,pros,cons,keeps_logs,has_court_proof,has_double_vpn,has_coupon,show_on_homepage,court_proof_content,based_in_country_name,based_in_country_flag,coupon_code,coupon_validity,full_review,has_p2p,has_kill_switch,has_ad_blocker,has_split_tunneling,simultaneous_connections,server_count,country_count'
      )
      .in('id', page.vpn_ids);

    if (vpnError) {
      console.error('Error fetching VPNs for review page:', vpnError);
    } else if (vpnData) {
      // Order the fetched VPNs according to the vpn_ids array
      orderedVpns = page.vpn_ids
        .map((id) => vpnData.find((vpn) => vpn.id === id))
        .filter((vpn): vpn is Vpn => vpn !== undefined);
    }
  }

  // Create the final page object with populated VPNs
  return {
    ...page,
    vpns: orderedVpns,
  };
}
