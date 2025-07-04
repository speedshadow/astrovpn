-- Alter the star_rating column to allow values up to 10.0
ALTER TABLE public.vpns
  ALTER COLUMN star_rating TYPE NUMERIC(3, 1);
