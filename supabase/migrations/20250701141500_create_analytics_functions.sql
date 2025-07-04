-- As funções são definidas com SECURITY DEFINER para que possam contornar as políticas de RLS
-- e ler os dados das tabelas de analytics, mesmo quando chamadas por um utilizador com menos privilégios (como 'authenticated').
-- Isto é seguro porque as funções apenas devolvem contagens agregadas e não os dados brutos.

-- Function to get unique visitors in the last 5 minutes (approximates online users)
CREATE OR REPLACE FUNCTION get_online_visitors_count()
RETURNS BIGINT AS $$
BEGIN
  RETURN (
    SELECT COUNT(DISTINCT session_id)
    FROM public.page_views
    WHERE created_at > NOW() - INTERVAL '5 minutes'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get unique visitors today (since midnight in the current timezone)
CREATE OR REPLACE FUNCTION get_today_visitors_count()
RETURNS BIGINT AS $$
BEGIN
  RETURN (
    SELECT COUNT(DISTINCT session_id)
    FROM public.page_views
    WHERE created_at >= DATE_TRUNC('day', NOW())
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get unique visitors this month
CREATE OR REPLACE FUNCTION get_monthly_visitors_count()
RETURNS BIGINT AS $$
BEGIN
  RETURN (
    SELECT COUNT(DISTINCT session_id)
    FROM public.page_views
    WHERE created_at >= DATE_TRUNC('month', NOW())
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get unique visitors this year
CREATE OR REPLACE FUNCTION get_yearly_visitors_count()
RETURNS BIGINT AS $$
BEGIN
  RETURN (
    SELECT COUNT(DISTINCT session_id)
    FROM public.page_views
    WHERE created_at >= DATE_TRUNC('year', NOW())
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get total affiliate clicks
CREATE OR REPLACE FUNCTION get_total_affiliate_clicks()
RETURNS BIGINT AS $$
BEGIN
  RETURN (
    SELECT COUNT(*) FROM public.affiliate_clicks
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get total blog post views (excluding index and pagination pages)
CREATE OR REPLACE FUNCTION get_total_blog_post_views()
RETURNS BIGINT AS $$
BEGIN
  RETURN (
    SELECT COUNT(*)
    FROM public.page_views
    WHERE path LIKE '/blog/%' AND path NOT LIKE '/blog/page/%' AND path != '/blog'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
