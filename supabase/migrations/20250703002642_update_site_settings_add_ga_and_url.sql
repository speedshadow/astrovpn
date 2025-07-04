-- Migration: Add google_analytics_id and site_url columns to site_settings
ALTER TABLE public.site_settings
  ADD COLUMN IF NOT EXISTS google_analytics_id TEXT,
  ADD COLUMN IF NOT EXISTS site_url TEXT;

-- Optionally, ensure twitter_handle is present (should already exist, but safe to add)
ALTER TABLE public.site_settings
  ADD COLUMN IF NOT EXISTS twitter_handle TEXT;

-- Add comments for new columns
COMMENT ON COLUMN public.site_settings.google_analytics_id IS 'Google Analytics Measurement ID for site tracking.';
COMMENT ON COLUMN public.site_settings.site_url IS 'Canonical base URL for the site (e.g., https://example.com).';
COMMENT ON COLUMN public.site_settings.twitter_handle IS 'The site''s official Twitter handle (e.g., @username).';
