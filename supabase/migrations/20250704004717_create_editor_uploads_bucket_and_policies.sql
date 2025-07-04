-- Create the public bucket for editor uploads.
-- We are setting public to true so that anyone can view the images.
INSERT INTO storage.buckets (id, name, public)
VALUES ('editor-uploads', 'editor-uploads', true)
ON CONFLICT (id) DO NOTHING;

-- Create the policy for public read access (SELECT).
-- This allows anyone to view the files in the bucket.
CREATE POLICY "Public Read Access"
ON storage.objects FOR SELECT
USING (bucket_id = 'editor-uploads');

-- Create the policy for authenticated write access (INSERT).
-- This allows only logged-in users to upload new files.
CREATE POLICY "Authenticated Upload Access"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'editor-uploads' AND auth.role() = 'authenticated');
