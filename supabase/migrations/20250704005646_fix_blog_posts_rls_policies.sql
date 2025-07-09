-- 1. Enable Row Level Security for the blog_posts table.
-- This ensures that the policies below will be enforced.
ALTER TABLE public.blog_posts ENABLE ROW LEVEL SECURITY;

-- 2. Create a policy to allow full access to authenticated users.
-- This policy grants SELECT, INSERT, UPDATE, and DELETE permissions
-- to any user who is logged in (i.e., has the 'authenticated' role).
CREATE POLICY "Allow full access for authenticated users" 
ON public.blog_posts
FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);
