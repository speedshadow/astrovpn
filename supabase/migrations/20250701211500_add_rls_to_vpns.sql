-- 1. Enable Row Level Security on the vpns table
ALTER TABLE public.vpns ENABLE ROW LEVEL SECURITY;

-- 2. Add policies for VPN management
-- Allow public read access to all VPNs
CREATE POLICY "Public can read all vpns"
ON public.vpns
FOR SELECT
TO anon, authenticated
USING (true);

-- Allow admin users to create, update, and delete VPNs
CREATE POLICY "Allow authenticated to create vpns"
ON public.vpns
FOR INSERT
TO authenticated
WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated to update vpns"
ON public.vpns
FOR UPDATE
TO authenticated
USING (auth.role() = 'authenticated')
WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated to delete vpns"
ON public.vpns
FOR DELETE
TO authenticated
USING (auth.role() = 'authenticated');
