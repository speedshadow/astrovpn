-- Create the site_settings table to store global configuration
CREATE TABLE public.site_settings (
    id smallint PRIMARY KEY DEFAULT 1,
    site_title text,
    site_tagline text,
    favicon_url text,
    meta_description text,
    meta_keywords text,
    meta_author text,
    social_preview_image_url text,
    twitter_handle text,
    updated_at timestamptz DEFAULT now(),
    CONSTRAINT singleton_check CHECK (id = 1)
);

-- Add comments for clarity
COMMENT ON TABLE public.site_settings IS 'Stores global site-wide settings. This is a singleton table and should only ever have one row.';
COMMENT ON COLUMN public.site_settings.id IS 'Singleton ID, always 1.';
COMMENT ON COLUMN public.site_settings.site_title IS 'The main title of the website, used in <title> tags.';
COMMENT ON COLUMN public.site_settings.site_tagline IS 'A short, descriptive tagline for the site.';
COMMENT ON COLUMN public.site_settings.favicon_url IS 'URL for the site''s favicon.';
COMMENT ON COLUMN public.site_settings.meta_description IS 'Default meta description for SEO.';
COMMENT ON COLUMN public.site_settings.meta_keywords IS 'Default comma-separated meta keywords for SEO.';
COMMENT ON COLUMN public.site_settings.meta_author IS 'Default author for blog posts and pages.';
COMMENT ON COLUMN public.site_settings.social_preview_image_url IS 'Default image for social media link previews (e.g., Open Graph).';
COMMENT ON COLUMN public.site_settings.twitter_handle IS 'The site''s official Twitter handle (e.g., @username).';

-- Enable Row Level Security
ALTER TABLE public.site_settings ENABLE ROW LEVEL SECURITY;

-- RLS Policies
-- 1. Allow public read-only access to everyone
CREATE POLICY "Allow public read-only access" ON public.site_settings
FOR SELECT USING (true);

-- 2. Allow admin users (authenticated role) to update the settings
CREATE POLICY "Allow admin update access" ON public.site_settings
FOR UPDATE USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

-- Insert the single default row with some sensible defaults
INSERT INTO public.site_settings (id, site_title, site_tagline, meta_description, meta_keywords, meta_author)
VALUES (1, 'AstroVPN', 'Your Ultimate VPN Guide', 'Discover the best VPNs for privacy, streaming, and security. In-depth reviews and comparisons to help you choose.', 'vpn, security, privacy, review, streaming, best vpn', 'AstroVPN Team');

-- Function and Trigger to automatically update the 'updated_at' timestamp
CREATE OR REPLACE FUNCTION public.update_settings_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_settings_update
BEFORE UPDATE ON public.site_settings
FOR EACH ROW
EXECUTE FUNCTION public.update_settings_timestamp();
