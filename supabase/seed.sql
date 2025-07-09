-- supabase/seed.sql
-- This script seeds the database with initial data for development.
-- It is executed automatically when you run `supabase db reset`.

-- Use ON CONFLICT DO NOTHING to avoid errors if data already exists.

-- Seed Blog Categories
INSERT INTO public.blog_categories (name, slug, description) VALUES
('Online Security', 'online-security', 'Tips and best practices for staying safe online.'),
('Streaming', 'streaming', 'How to unblock and watch your favorite streaming services from anywhere.'),
('VPN Reviews', 'vpn-reviews', 'In-depth reviews of the top VPN providers.')
ON CONFLICT (slug) DO NOTHING;

-- Seed Blog Posts
-- Note: author_id is left NULL. You should register a user in the app,
-- get their UUID from the Supabase Studio (Authentication > Users),
-- and manually update this field.
INSERT INTO public.blog_posts (title, slug, content, excerpt, category_id, meta_title, meta_description, published_at) VALUES
(
  'The Ultimate Guide to Online Privacy in 2025',
  'ultimate-guide-online-privacy-2025',
  '<p>In an increasingly digital world, protecting your privacy is more important than ever. This guide covers everything you need to know...</p>',
  'A comprehensive look at the tools and techniques to safeguard your digital footprint.',
  (SELECT id from public.blog_categories WHERE slug = 'online-security'),
  'Ultimate Guide to Online Privacy 2025 | AstroVPN',
  'Learn how to protect your online privacy with our ultimate guide for 2025. We cover VPNs, secure browsers, and more.',
  NOW()
),
(
  'How to Watch US Netflix from Anywhere',
  'how-to-watch-us-netflix-anywhere',
  '<p>Tired of geo-restrictions? A good VPN is the key to unlocking a world of content. Here’s how to get started...</p>',
  'Unblock the full US Netflix library from anywhere in the world with these simple steps.',
  (SELECT id from public.blog_categories WHERE slug = 'streaming'),
  'How to Watch US Netflix from Anywhere | AstroVPN',
  'Follow our simple guide to use a VPN to watch the US Netflix library from any country.',
  NOW()
)
ON CONFLICT (slug) DO NOTHING;

-- Seed VPNs
INSERT INTO public.vpns (
  name, slug, logo_url, description, star_rating, affiliate_link,
  price_monthly_usd, price_yearly_usd,
  detailed_ratings, supported_devices,
  pros, cons,
  keeps_logs, has_court_proof, court_proof_content, has_double_vpn,
  based_in_country_name, based_in_country_flag,
  has_coupon, coupon_code, coupon_validity,
  show_on_homepage, full_review
) VALUES
(
  'NordVPN', 'nordvpn', 'https://cdn.worldvectorlogo.com/logos/nordvpn-1.svg', 'A top-tier VPN known for its speed, security, and large server network.',
  4.9, 'https://go.nordvpn.net/aff_c?offer_id=15&aff_id=12345',
  12.99, 59.88,
  '{"speed": 9.8, "streaming": 9.5, "privacy": 9.9, "torrenting": 9.2, "features": 9.7, "user_experience": 9.5}',
  '{"windows": true, "macos": true, "linux": true, "android": true, "ios": true, "router": true, "tv": true}',
  ARRAY['Blazing fast speeds with NordLynx', 'Threat Protection feature', 'Audited no-logs policy', 'Over 5000 servers worldwide'],
  ARRAY['App can be slow to connect at times', 'Shared IP addresses only'],
  FALSE, TRUE, 'NordVPN''s no-logs policy was verified by PricewaterhouseCoopers AG in Switzerland.', TRUE,
  'Panama', '🇵🇦',
  TRUE, 'WINTERDEAL', '2025-12-31',
  TRUE, '<h3>Full NordVPN Review</h3><p>NordVPN is a powerhouse in the VPN industry, and for good reason...</p>'
),
(
  'ExpressVPN', 'expressvpn', 'https://www.expressvpn.com/assets/images/logo/expressvpn-logo-red.svg', 'A premium VPN service with a strong focus on privacy and unblocking content.',
  4.8, 'https://www.expressvpn.com/order?a_aid=12345',
  12.95, 99.95,
  '{"speed": 9.5, "streaming": 9.8, "privacy": 9.9, "torrenting": 9.5, "features": 9.2, "user_experience": 9.7}',
  '{"windows": true, "macos": true, "linux": true, "android": true, "ios": true, "router": true, "tv": true}',
  ARRAY['TrustedServer technology (RAM-only)', 'Excellent for unblocking streaming sites', 'Very easy to use apps', '24/7 live chat support'],
  ARRAY['More expensive than competitors', 'Fewer simultaneous connections'],
  FALSE, TRUE, 'ExpressVPN''s privacy policy and TrustedServer technology have been independently audited by Cure53 and PwC.', FALSE,
  'British Virgin Islands', '🇻🇬',
  FALSE, NULL, NULL,
  TRUE, '<h3>Full ExpressVPN Review</h3><p>ExpressVPN consistently ranks as one of the best VPNs available...</p>'
),
(
  'Surfshark', 'surfshark', 'https://surfshark.com/wp-content/uploads/Surfshark-Logo-1-2.svg', 'An affordable VPN that offers unlimited simultaneous connections and great features.',
  4.7, 'https://surfshark.com/deals?coupon=Ssharkdeal&a_id=12345',
  12.95, 47.88,
  '{"speed": 9.2, "streaming": 9.4, "privacy": 9.5, "torrenting": 9.0, "features": 9.8, "user_experience": 9.4}',
  '{"windows": true, "macos": true, "linux": true, "android": true, "ios": true, "router": false, "tv": true}',
  ARRAY['Unlimited simultaneous connections', 'Very budget-friendly', 'CleanWeb ad-blocker included', 'Static IP and MultiHop options'],
  ARRAY['Server network is smaller than rivals', 'Customer support can be slow'],
  FALSE, TRUE, 'Surfshark underwent an independent audit by Cure53, which confirmed its no-logs claims.', TRUE,
  'Netherlands', '🇳🇱',
  TRUE, 'SURFSHARKDEAL', '2025-10-31',
  TRUE, '<h3>Full Surfshark Review</h3><p>Surfshark has quickly become a fan favorite for its combination of price and features...</p>'
)
ON CONFLICT (slug) DO NOTHING;
