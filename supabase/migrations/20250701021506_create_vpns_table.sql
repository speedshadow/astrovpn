-- Create the 'vpns' table
CREATE TABLE vpns (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  logo_url TEXT,
  rating NUMERIC(2, 1),
  features TEXT[],
  platforms TEXT[],
  price_monthly NUMERIC(5, 2),
  website_url TEXT,
  categories TEXT[]
);