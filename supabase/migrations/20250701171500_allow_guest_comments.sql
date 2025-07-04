-- 1. Add a column to store the guest's name.
ALTER TABLE public.blog_comments
ADD COLUMN guest_name TEXT CHECK (char_length(guest_name) > 0);

COMMENT ON COLUMN public.blog_comments.guest_name IS 'The name of the commenter if they are not a registered user.';

-- 2. Make the author_id nullable to allow for guest comments.
ALTER TABLE public.blog_comments
ALTER COLUMN author_id DROP NOT NULL;

-- 3. Update the RLS policy for inserting comments.
-- Drop the old policy first.
DROP POLICY IF EXISTS "Allow authenticated users to insert comments" ON public.blog_comments;
DROP POLICY IF EXISTS "Allow authenticated and guest comments" ON public.blog_comments;

-- Create a new, more permissive policy.
CREATE POLICY "Allow authenticated and guest comments"
ON public.blog_comments
FOR INSERT
WITH CHECK (
  -- Logged-in users can comment as themselves.
  (auth.role() = 'authenticated' AND author_id = auth.uid()) OR
  -- Guests (not logged in) can comment if they provide a name and no author_id.
  (auth.role() = 'anon' AND author_id IS NULL AND guest_name IS NOT NULL)
);

-- 4. Add policies for reading, updating, and deleting comments.
CREATE POLICY "Public can read all comments"
ON public.blog_comments
FOR SELECT
USING (true);

CREATE POLICY "Users can update their own comments"
ON public.blog_comments
FOR UPDATE
TO authenticated
USING (auth.uid() = author_id)
WITH CHECK (auth.uid() = author_id);

CREATE POLICY "Users can delete their own comments"
ON public.blog_comments
FOR DELETE
TO authenticated
USING (auth.uid() = author_id);
