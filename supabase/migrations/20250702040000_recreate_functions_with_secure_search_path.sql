-- Recreates 8 functions with a secure, empty search_path to resolve the
-- "Function Search Path Mutable" linter warning from Supabase.
-- This approach is required by the linter, which expects the search_path
-- to be set in the function's definition rather than via ALTER FUNCTION.

-- From migration 20250701141500_create_analytics_functions.sql
CREATE OR REPLACE FUNCTION public.get_online_visitors_count()
RETURNS BIGINT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  RETURN (
    SELECT COUNT(DISTINCT session_id)
    FROM public.page_views
    WHERE created_at > NOW() - INTERVAL '5 minutes'
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.get_today_visitors_count()
RETURNS BIGINT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  RETURN (
    SELECT COUNT(DISTINCT session_id)
    FROM public.page_views
    WHERE created_at >= DATE_TRUNC('day', NOW())
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.get_monthly_visitors_count()
RETURNS BIGINT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  RETURN (
    SELECT COUNT(DISTINCT session_id)
    FROM public.page_views
    WHERE created_at >= DATE_TRUNC('month', NOW())
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.get_yearly_visitors_count()
RETURNS BIGINT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  RETURN (
    SELECT COUNT(DISTINCT session_id)
    FROM public.page_views
    WHERE created_at >= DATE_TRUNC('year', NOW())
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.get_total_affiliate_clicks()
RETURNS BIGINT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  RETURN (
    SELECT COUNT(*) FROM public.affiliate_clicks
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.get_total_blog_post_views()
RETURNS BIGINT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  RETURN (
    SELECT COUNT(*)
    FROM public.page_views
    WHERE path LIKE '/blog/%' AND path NOT LIKE '/blog/page/%' AND path != '/blog'
  );
END;
$$;

-- From migration 20250701044500_create_blog_tables.sql
CREATE OR REPLACE FUNCTION public.handle_blog_post_update()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = ''
AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

-- From migration 20250701165500_create_profiles_and_update_comments.sql
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, avatar_url)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'avatar_url');
  RETURN NEW;
END;
$$;
