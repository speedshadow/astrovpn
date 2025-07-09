-- Rename existing columns for clarity and consistency
ALTER TABLE public.vpns RENAME COLUMN rating TO star_rating;
ALTER TABLE public.vpns RENAME COLUMN website_url TO affiliate_link;

-- Drop old, generic columns that will be replaced by more specific ones
ALTER TABLE public.vpns DROP COLUMN IF EXISTS features;
ALTER TABLE public.vpns DROP COLUMN IF EXISTS platforms;

-- Add new detailed columns based on user specification

-- Price (assuming yearly and monthly for both currencies)
ALTER TABLE public.vpns RENAME COLUMN price_monthly TO price_monthly_usd;
ALTER TABLE public.vpns ADD COLUMN price_yearly_usd NUMERIC(6, 2);
ALTER TABLE public.vpns ADD COLUMN price_monthly_eur NUMERIC(6, 2);
ALTER TABLE public.vpns ADD COLUMN price_yearly_eur NUMERIC(6, 2);

-- Detailed Ratings (using JSONB for flexibility)
ALTER TABLE public.vpns ADD COLUMN detailed_ratings JSONB;
COMMENT ON COLUMN public.vpns.detailed_ratings IS 'Store detailed ratings like { "speed": 9.5, "privacy": 8.0, "streaming": 9.0 }';

-- Supported Devices (using JSONB for toggle switches)
ALTER TABLE public.vpns ADD COLUMN supported_devices JSONB;
COMMENT ON COLUMN public.vpns.supported_devices IS 'Store device support status like { "windows": true, "macos": true, "linux": false }';

-- Pros and Cons
ALTER TABLE public.vpns ADD COLUMN pros TEXT[];
ALTER TABLE public.vpns ADD COLUMN cons TEXT[];

-- Logs & Court Proof
ALTER TABLE public.vpns ADD COLUMN keeps_logs BOOLEAN NOT NULL DEFAULT TRUE;
ALTER TABLE public.vpns ADD COLUMN has_court_proof BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE public.vpns ADD COLUMN court_proof_content TEXT;

-- Features
ALTER TABLE public.vpns ADD COLUMN has_double_vpn BOOLEAN NOT NULL DEFAULT FALSE;

-- Location
ALTER TABLE public.vpns ADD COLUMN based_in_country_name TEXT;
ALTER TABLE public.vpns ADD COLUMN based_in_country_flag TEXT; -- For emoji or country code

-- Coupon
ALTER TABLE public.vpns ADD COLUMN has_coupon BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE public.vpns ADD COLUMN coupon_code TEXT;
ALTER TABLE public.vpns ADD COLUMN coupon_validity DATE;

-- Visibility
ALTER TABLE public.vpns ADD COLUMN show_on_homepage BOOLEAN NOT NULL DEFAULT FALSE;
