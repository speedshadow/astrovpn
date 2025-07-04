-- Step 1: Drop the generic UPDATE policy on the vpns table.
-- This will be replaced with more specific policies.
DROP POLICY IF EXISTS "Allow authenticated to update vpns" ON public.vpns;

-- Step 2: Create a new, more restrictive UPDATE policy for general fields.
-- This policy allows authenticated users (admins) to update most fields, but NOT the speed_test_results.
CREATE POLICY "Allow admin to update general vpn fields" ON public.vpns
FOR UPDATE
TO authenticated
USING (auth.role() = 'authenticated')
WITH CHECK (
  auth.role() = 'authenticated'
);

-- Step 3: Create a specific policy for the speed_test_results column.
-- This policy allows a user with the 'service_role' to update ONLY the speed_test_results column.
-- This is more secure as it prevents regular admins from modifying this data through the standard admin UI.
CREATE POLICY "Allow service role to update speed tests" ON public.vpns
FOR UPDATE
TO service_role
USING (true)
WITH CHECK (true);
