-- Enable RLS on the tables. It's idempotent, so no harm in running it again.
ALTER TABLE public.blog_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.blog_categories ENABLE ROW LEVEL SECURITY;

-- Drop existing policies to ensure a clean state, just in case.
DROP POLICY IF EXISTS "Public can read published blog posts" ON public.blog_posts;
DROP POLICY IF EXISTS "Public can read blog categories" ON public.blog_categories;

-- Create a policy to allow public read access to published posts.
-- This allows anyone (anon, authenticated) to view posts that have a `published_at` date.
CREATE POLICY "Public can read published blog posts"
ON public.blog_posts
FOR SELECT
TO anon, authenticated
USING (published_at IS NOT NULL);

-- Create a policy to allow public read access to all categories.
CREATE POLICY "Public can read blog categories"
ON public.blog_categories
FOR SELECT
TO anon, authenticated
USING (true);

-- Policies for content management by authenticated users
CREATE POLICY "Allow authenticated to create posts" 
ON public.blog_posts 
FOR INSERT 
TO authenticated 
WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated to update posts" 
ON public.blog_posts 
FOR UPDATE 
TO authenticated 
USING (auth.role() = 'authenticated') 
WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated to delete posts" 
ON public.blog_posts 
FOR DELETE 
TO authenticated 
USING (auth.role() = 'authenticated');

-- Policies for category management by authenticated users
CREATE POLICY "Allow authenticated to create categories" 
ON public.blog_categories 
FOR INSERT 
TO authenticated 
WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated to update categories" 
ON public.blog_categories 
FOR UPDATE 
TO authenticated 
USING (auth.role() = 'authenticated') 
WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated to delete categories" 
ON public.blog_categories 
FOR DELETE 
TO authenticated 
USING (auth.role() = 'authenticated');
