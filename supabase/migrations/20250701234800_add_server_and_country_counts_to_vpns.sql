ALTER TABLE public.vpns
ADD COLUMN IF NOT EXISTS server_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS country_count INTEGER DEFAULT 0;

-- Reset the RLS policies for the vpns table to apply changes
DROP POLICY IF EXISTS "Enable read access for all users" ON public.vpns;
CREATE POLICY "Enable read access for all users" ON public.vpns
AS PERMISSIVE FOR SELECT
TO public
USING (true);

DROP POLICY IF EXISTS "Allow authorized users to insert" ON public.vpns;
CREATE POLICY "Allow authorized users to insert" ON public.vpns
AS PERMISSIVE FOR INSERT
TO authenticated
WITH CHECK (true);

DROP POLICY IF EXISTS "Allow authorized users to update" ON public.vpns;
CREATE POLICY "Allow authorized users to update" ON public.vpns
AS PERMISSIVE FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

DROP POLICY IF EXISTS "Allow authorized users to delete" ON public.vpns;
CREATE POLICY "Allow authorized users to delete" ON public.vpns
AS PERMISSIVE FOR DELETE
TO authenticated
USING (true);
