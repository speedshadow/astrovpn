-- Create the 'vpn-assets' bucket if it doesn't exist.
INSERT INTO storage.buckets (id, name, public)
VALUES ('vpn-assets', 'vpn-assets', true)
ON CONFLICT (id) DO NOTHING;

-- Set up Row Level Security (RLS) policies for the 'vpn-assets' bucket.

-- 1. Allow public, anonymous read access to all objects in the bucket.
DROP POLICY IF EXISTS "Public read access for vpn-assets" ON storage.objects;
CREATE POLICY "Public read access for vpn-assets"
    ON storage.objects FOR SELECT
    TO anon, authenticated
    USING (bucket_id = 'vpn-assets');

-- 2. Allow authenticated users to upload (insert) objects.
DROP POLICY IF EXISTS "Authenticated users can insert vpn-assets" ON storage.objects;
CREATE POLICY "Authenticated users can insert vpn-assets"
    ON storage.objects FOR INSERT
    TO authenticated
    WITH CHECK (bucket_id = 'vpn-assets');

-- 3. Allow authenticated users to update objects.
DROP POLICY IF EXISTS "Authenticated users can update vpn-assets" ON storage.objects;
CREATE POLICY "Authenticated users can update vpn-assets"
    ON storage.objects FOR UPDATE
    TO authenticated
    USING (bucket_id = 'vpn-assets');

-- 4. Allow authenticated users to delete objects.
DROP POLICY IF EXISTS "Authenticated users can delete vpn-assets" ON storage.objects;
CREATE POLICY "Authenticated users can delete vpn-assets"
    ON storage.objects FOR DELETE
    TO authenticated
    USING (bucket_id = 'vpn-assets');
