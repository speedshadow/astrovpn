// This file contains shared TypeScript types for the project.

// The detailed type definition for a VPN, matching the Supabase schema.
export interface Vpn {
  id: number;
  name: string;
  slug: string;
  logo_url: string | null;
  description: string | null;
  categories: string[] | null;
  star_rating: number | null;
  affiliate_link: string | null;
  price_monthly_usd: number | null;
  price_yearly_usd: number | null;
  price_monthly_eur: number | null;
  price_yearly_eur: number | null;
  detailed_ratings: Record<string, number> | null;
  supported_devices: Record<string, boolean> | null;
  pros: string[] | null;
  cons: string[] | null;
  keeps_logs: boolean;
  has_court_proof: boolean;
  has_double_vpn: boolean;
  has_coupon: boolean;
  show_on_homepage: boolean;
  court_proof_content: string | null;
  based_in_country_name: string | null;
  based_in_country_flag: string | null;
  coupon_code: string | null;
  coupon_validity: string | null;
  full_review: string | null;
  has_p2p: boolean;
  has_kill_switch: boolean;
  has_ad_blocker: boolean;
  has_split_tunneling: boolean;
  simultaneous_connections: number | null;
  speed_test_results?: { country: string; speed: number | null }[];
  server_count: number | null;
  country_count: number | null;
  optimizedLogo?: { src: string; srcset: string; attributes: Record<string, any> };
}

// The type definition for a Review Page.
export interface ReviewPage {
  id: number;
  created_at: string;
  title: string;
  slug: string;
  description: string | null;
  introduction: string | null;
  conclusion: string | null;
  vpn_ids: number[] | null;
}

// A more complete type for a Review Page that includes the full VPN objects
export interface PopulatedReviewPage extends Omit<ReviewPage, 'vpn_ids'> {
  vpns: Vpn[];
}
