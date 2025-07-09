--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.5 (Ubuntu 17.5-1.pgdg24.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: _realtime; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA _realtime;


ALTER SCHEMA _realtime OWNER TO postgres;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pg_net; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_net; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_net IS 'Async HTTP';


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: supabase_functions; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA supabase_functions;


ALTER SCHEMA supabase_functions OWNER TO supabase_admin;

--
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA supabase_migrations;


ALTER SCHEMA supabase_migrations OWNER TO postgres;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: moddatetime; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS moddatetime WITH SCHEMA extensions;


--
-- Name: EXTENSION moddatetime; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION moddatetime IS 'functions for tracking last modification time';


--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

    REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
    REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

    GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
begin
    raise debug 'PgBouncer auth request: %', p_usename;

    return query
    select 
        rolname::text, 
        case when rolvaliduntil < now() 
            then null 
            else rolpassword::text 
        end 
    from pg_authid 
    where rolname=$1 and rolcanlogin;
end;
$_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: get_monthly_visitors_count(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_monthly_visitors_count() RETURNS bigint
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
BEGIN
  RETURN (
    SELECT COUNT(DISTINCT session_id)
    FROM public.page_views
    WHERE created_at >= DATE_TRUNC('month', NOW())
  );
END;
$$;


ALTER FUNCTION public.get_monthly_visitors_count() OWNER TO postgres;

--
-- Name: get_online_visitors_count(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_online_visitors_count() RETURNS bigint
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
BEGIN
  RETURN (
    SELECT COUNT(DISTINCT session_id)
    FROM public.page_views
    WHERE created_at > NOW() - INTERVAL '5 minutes'
  );
END;
$$;


ALTER FUNCTION public.get_online_visitors_count() OWNER TO postgres;

--
-- Name: get_review_page_details(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_review_page_details(page_slug text) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    page_record record;
    vpns_jsonb jsonb;
BEGIN
    -- Fetch the review page fields we actually need
    SELECT slug, title, introduction, conclusion, vpn_ids INTO page_record FROM review_pages WHERE slug = page_slug;

    IF NOT FOUND THEN
        RETURN NULL;
    END IF;

    -- Fetch and order only the necessary VPN fields
    SELECT jsonb_agg(v_row)
    INTO vpns_jsonb
    FROM (
        SELECT 
            v.id, v.name, v.slug, v.logo_url, v.star_rating, v.affiliate_link, 
            v.pros, v.cons, v.based_in_country_name, v.full_review, v.price_monthly_usd
        FROM vpns v
        JOIN unnest(page_record.vpn_ids) WITH ORDINALITY AS u(vpn_id, ord) ON v.id = u.vpn_id
        ORDER BY u.ord
    ) AS v_row;

    -- Combine the page data with the VPNs data
    RETURN to_jsonb(page_record) || jsonb_build_object('vpns', COALESCE(vpns_jsonb, '[]'::jsonb));
END;
$$;


ALTER FUNCTION public.get_review_page_details(page_slug text) OWNER TO postgres;

--
-- Name: get_today_visitors_count(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_today_visitors_count() RETURNS bigint
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
BEGIN
  RETURN (
    SELECT COUNT(DISTINCT session_id)
    FROM public.page_views
    WHERE created_at >= DATE_TRUNC('day', NOW())
  );
END;
$$;


ALTER FUNCTION public.get_today_visitors_count() OWNER TO postgres;

--
-- Name: get_total_affiliate_clicks(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_total_affiliate_clicks() RETURNS bigint
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
BEGIN
  RETURN (
    SELECT COUNT(*) FROM public.affiliate_clicks
  );
END;
$$;


ALTER FUNCTION public.get_total_affiliate_clicks() OWNER TO postgres;

--
-- Name: get_total_blog_post_views(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_total_blog_post_views() RETURNS bigint
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
BEGIN
  RETURN (
    SELECT COUNT(*)
    FROM public.page_views
    WHERE path LIKE '/blog/%' AND path NOT LIKE '/blog/page/%' AND path != '/blog'
  );
END;
$$;


ALTER FUNCTION public.get_total_blog_post_views() OWNER TO postgres;

--
-- Name: get_yearly_visitors_count(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_yearly_visitors_count() RETURNS bigint
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
BEGIN
  RETURN (
    SELECT COUNT(DISTINCT session_id)
    FROM public.page_views
    WHERE created_at >= DATE_TRUNC('year', NOW())
  );
END;
$$;


ALTER FUNCTION public.get_yearly_visitors_count() OWNER TO postgres;

--
-- Name: handle_blog_post_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_blog_post_update() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.handle_blog_post_update() OWNER TO postgres;

--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, avatar_url)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'avatar_url');
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.handle_new_user() OWNER TO postgres;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  BEGIN
    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (payload, event, topic, private, extension)
    VALUES (payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      PERFORM pg_notify(
          'realtime:system',
          jsonb_build_object(
              'error', SQLERRM,
              'function', 'realtime.send',
              'event', event,
              'topic', topic,
              'private', private
          )::text
      );
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: add_prefixes(text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.add_prefixes(_bucket_id text, _name text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    prefixes text[];
BEGIN
    prefixes := "storage"."get_prefixes"("_name");

    IF array_length(prefixes, 1) > 0 THEN
        INSERT INTO storage.prefixes (name, bucket_id)
        SELECT UNNEST(prefixes) as name, "_bucket_id" ON CONFLICT DO NOTHING;
    END IF;
END;
$$;


ALTER FUNCTION storage.add_prefixes(_bucket_id text, _name text) OWNER TO supabase_storage_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: delete_prefix(text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_prefix(_bucket_id text, _name text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Check if we can delete the prefix
    IF EXISTS(
        SELECT FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name") + 1
          AND "prefixes"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    )
    OR EXISTS(
        SELECT FROM "storage"."objects"
        WHERE "objects"."bucket_id" = "_bucket_id"
          AND "storage"."get_level"("objects"."name") = "storage"."get_level"("_name") + 1
          AND "objects"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    ) THEN
    -- There are sub-objects, skip deletion
    RETURN false;
    ELSE
        DELETE FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name")
          AND "prefixes"."name" = "_name";
        RETURN true;
    END IF;
END;
$$;


ALTER FUNCTION storage.delete_prefix(_bucket_id text, _name text) OWNER TO supabase_storage_admin;

--
-- Name: delete_prefix_hierarchy_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_prefix_hierarchy_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    prefix text;
BEGIN
    prefix := "storage"."get_prefix"(OLD."name");

    IF coalesce(prefix, '') != '' THEN
        PERFORM "storage"."delete_prefix"(OLD."bucket_id", prefix);
    END IF;

    RETURN OLD;
END;
$$;


ALTER FUNCTION storage.delete_prefix_hierarchy_trigger() OWNER TO supabase_storage_admin;

--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    SELECT string_to_array(name, '/') INTO _parts;
    SELECT _parts[array_length(_parts,1)] INTO _filename;
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_level(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_level(name text) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT array_length(string_to_array("name", '/'), 1);
$$;


ALTER FUNCTION storage.get_level(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_prefix(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_prefix(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT
    CASE WHEN strpos("name", '/') > 0 THEN
             regexp_replace("name", '[\/]{1}[^\/]+\/?$', '')
         ELSE
             ''
        END;
$_$;


ALTER FUNCTION storage.get_prefix(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_prefixes(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_prefixes(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
DECLARE
    parts text[];
    prefixes text[];
    prefix text;
BEGIN
    -- Split the name into parts by '/'
    parts := string_to_array("name", '/');
    prefixes := '{}';

    -- Construct the prefixes, stopping one level below the last part
    FOR i IN 1..array_length(parts, 1) - 1 LOOP
            prefix := array_to_string(parts[1:i], '/');
            prefixes := array_append(prefixes, prefix);
    END LOOP;

    RETURN prefixes;
END;
$$;


ALTER FUNCTION storage.get_prefixes(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) OWNER TO supabase_storage_admin;

--
-- Name: objects_insert_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_insert_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    NEW.level := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_insert_prefix_trigger() OWNER TO supabase_storage_admin;

--
-- Name: objects_update_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_update_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    old_prefixes TEXT[];
BEGIN
    -- Ensure this is an update operation and the name has changed
    IF TG_OP = 'UPDATE' AND (NEW."name" <> OLD."name" OR NEW."bucket_id" <> OLD."bucket_id") THEN
        -- Retrieve old prefixes
        old_prefixes := "storage"."get_prefixes"(OLD."name");

        -- Remove old prefixes that are only used by this object
        WITH all_prefixes as (
            SELECT unnest(old_prefixes) as prefix
        ),
        can_delete_prefixes as (
             SELECT prefix
             FROM all_prefixes
             WHERE NOT EXISTS (
                 SELECT 1 FROM "storage"."objects"
                 WHERE "bucket_id" = OLD."bucket_id"
                   AND "name" <> OLD."name"
                   AND "name" LIKE (prefix || '%')
             )
         )
        DELETE FROM "storage"."prefixes" WHERE name IN (SELECT prefix FROM can_delete_prefixes);

        -- Add new prefixes
        PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    END IF;
    -- Set the new level
    NEW."level" := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_update_prefix_trigger() OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: prefixes_insert_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.prefixes_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.prefixes_insert_trigger() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql
    AS $$
declare
    can_bypass_rls BOOLEAN;
begin
    SELECT rolbypassrls
    INTO can_bypass_rls
    FROM pg_roles
    WHERE rolname = coalesce(nullif(current_setting('role', true), 'none'), current_user);

    IF can_bypass_rls THEN
        RETURN QUERY SELECT * FROM storage.search_v1_optimised(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    ELSE
        RETURN QUERY SELECT * FROM storage.search_legacy_v1(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    END IF;
end;
$$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_legacy_v1(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select path_tokens[$1] as folder
           from storage.objects
             where objects.name ilike $2 || $3 || ''%''
               and bucket_id = $4
               and array_length(objects.path_tokens, 1) <> $1
           group by folder
           order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_v1_optimised(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v1_optimised(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select (string_to_array(name, ''/''))[level] as name
           from storage.prefixes
             where lower(prefixes.name) like lower($2 || $3) || ''%''
               and bucket_id = $4
               and level = $1
           order by name ' || v_sort_order || '
     )
     (select name,
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[level] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where lower(objects.name) like lower($2 || $3) || ''%''
       and bucket_id = $4
       and level = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search_v1_optimised(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_v2(text, text, integer, integer, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
BEGIN
    RETURN query EXECUTE
        $sql$
        SELECT * FROM (
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name || '/' AS name,
                    NULL::uuid AS id,
                    NULL::timestamptz AS updated_at,
                    NULL::timestamptz AS created_at,
                    NULL::jsonb AS metadata
                FROM storage.prefixes
                WHERE name COLLATE "C" LIKE $1 || '%'
                AND bucket_id = $2
                AND level = $4
                AND name COLLATE "C" > $5
                ORDER BY prefixes.name COLLATE "C" LIMIT $3
            )
            UNION ALL
            (SELECT split_part(name, '/', $4) AS key,
                name,
                id,
                updated_at,
                created_at,
                metadata
            FROM storage.objects
            WHERE name COLLATE "C" LIKE $1 || '%'
                AND bucket_id = $2
                AND level = $4
                AND name COLLATE "C" > $5
            ORDER BY name COLLATE "C" LIMIT $3)
        ) obj
        ORDER BY name COLLATE "C" LIMIT $3;
        $sql$
        USING prefix, bucket_name, limits, levels, start_after;
END;
$_$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

--
-- Name: http_request(); Type: FUNCTION; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE FUNCTION supabase_functions.http_request() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'supabase_functions'
    AS $$
  DECLARE
    request_id bigint;
    payload jsonb;
    url text := TG_ARGV[0]::text;
    method text := TG_ARGV[1]::text;
    headers jsonb DEFAULT '{}'::jsonb;
    params jsonb DEFAULT '{}'::jsonb;
    timeout_ms integer DEFAULT 1000;
  BEGIN
    IF url IS NULL OR url = 'null' THEN
      RAISE EXCEPTION 'url argument is missing';
    END IF;

    IF method IS NULL OR method = 'null' THEN
      RAISE EXCEPTION 'method argument is missing';
    END IF;

    IF TG_ARGV[2] IS NULL OR TG_ARGV[2] = 'null' THEN
      headers = '{"Content-Type": "application/json"}'::jsonb;
    ELSE
      headers = TG_ARGV[2]::jsonb;
    END IF;

    IF TG_ARGV[3] IS NULL OR TG_ARGV[3] = 'null' THEN
      params = '{}'::jsonb;
    ELSE
      params = TG_ARGV[3]::jsonb;
    END IF;

    IF TG_ARGV[4] IS NULL OR TG_ARGV[4] = 'null' THEN
      timeout_ms = 1000;
    ELSE
      timeout_ms = TG_ARGV[4]::integer;
    END IF;

    CASE
      WHEN method = 'GET' THEN
        SELECT http_get INTO request_id FROM net.http_get(
          url,
          params,
          headers,
          timeout_ms
        );
      WHEN method = 'POST' THEN
        payload = jsonb_build_object(
          'old_record', OLD,
          'record', NEW,
          'type', TG_OP,
          'table', TG_TABLE_NAME,
          'schema', TG_TABLE_SCHEMA
        );

        SELECT http_post INTO request_id FROM net.http_post(
          url,
          payload,
          params,
          headers,
          timeout_ms
        );
      ELSE
        RAISE EXCEPTION 'method argument % is invalid', method;
    END CASE;

    INSERT INTO supabase_functions.hooks
      (hook_table_id, hook_name, request_id)
    VALUES
      (TG_RELID, TG_NAME, request_id);

    RETURN NEW;
  END
$$;


ALTER FUNCTION supabase_functions.http_request() OWNER TO supabase_functions_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: extensions; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.extensions (
    id uuid NOT NULL,
    type text,
    settings jsonb,
    tenant_external_id text,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE _realtime.extensions OWNER TO supabase_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE _realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: tenants; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.tenants (
    id uuid NOT NULL,
    name text,
    external_id text,
    jwt_secret text,
    max_concurrent_users integer DEFAULT 200 NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    max_events_per_second integer DEFAULT 100 NOT NULL,
    postgres_cdc_default text DEFAULT 'postgres_cdc_rls'::text,
    max_bytes_per_second integer DEFAULT 100000 NOT NULL,
    max_channels_per_client integer DEFAULT 100 NOT NULL,
    max_joins_per_second integer DEFAULT 500 NOT NULL,
    suspend boolean DEFAULT false,
    jwt_jwks jsonb,
    notify_private_alpha boolean DEFAULT false,
    private_only boolean DEFAULT false NOT NULL,
    migrations_ran integer DEFAULT 0,
    broadcast_adapter character varying(255) DEFAULT 'phoenix'::character varying
);


ALTER TABLE _realtime.tenants OWNER TO supabase_admin;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: affiliate_clicks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.affiliate_clicks (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    vpn_id bigint,
    session_id uuid NOT NULL
);


ALTER TABLE public.affiliate_clicks OWNER TO postgres;

--
-- Name: affiliate_clicks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.affiliate_clicks ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.affiliate_clicks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: blog_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blog_categories (
    id bigint NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.blog_categories OWNER TO postgres;

--
-- Name: TABLE blog_categories; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.blog_categories IS 'Stores categories for blog posts.';


--
-- Name: blog_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.blog_categories ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.blog_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: blog_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blog_comments (
    id bigint NOT NULL,
    post_id bigint NOT NULL,
    author_id uuid,
    content text NOT NULL,
    parent_comment_id bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    guest_name text,
    CONSTRAINT blog_comments_content_check CHECK ((char_length(content) > 0)),
    CONSTRAINT blog_comments_guest_name_check CHECK ((char_length(guest_name) > 0))
);


ALTER TABLE public.blog_comments OWNER TO postgres;

--
-- Name: COLUMN blog_comments.guest_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.blog_comments.guest_name IS 'The name of the commenter if they are not a registered user.';


--
-- Name: blog_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.blog_comments ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.blog_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: blog_posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blog_posts (
    id bigint NOT NULL,
    title text NOT NULL,
    slug text NOT NULL,
    content text,
    excerpt text,
    featured_image_url text,
    author_id uuid,
    category_id bigint,
    likes_count integer DEFAULT 0,
    allow_comments boolean DEFAULT true,
    show_cta boolean DEFAULT true,
    meta_title text,
    meta_description text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    published_at timestamp with time zone
);


ALTER TABLE public.blog_posts OWNER TO postgres;

--
-- Name: TABLE blog_posts; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.blog_posts IS 'Stores blog posts, including content, social features, and affiliate settings.';


--
-- Name: COLUMN blog_posts.content; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.blog_posts.content IS 'HTML content generated by a rich text editor like CKEditor 5.';


--
-- Name: COLUMN blog_posts.show_cta; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.blog_posts.show_cta IS 'Controls the visibility of call-to-action components for affiliate links.';


--
-- Name: blog_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.blog_posts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.blog_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: page_views; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.page_views (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    path text NOT NULL,
    session_id uuid NOT NULL
);


ALTER TABLE public.page_views OWNER TO postgres;

--
-- Name: page_views_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.page_views ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.page_views_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    full_name text,
    avatar_url text,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- Name: TABLE profiles; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.profiles IS 'Public profile information for each user.';


--
-- Name: review_pages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review_pages (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    title text NOT NULL,
    slug text NOT NULL,
    description text,
    introduction text,
    conclusion text,
    vpn_ids integer[]
);


ALTER TABLE public.review_pages OWNER TO postgres;

--
-- Name: review_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.review_pages ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.review_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: site_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.site_settings (
    id uuid DEFAULT '00000000-0000-0000-0000-000000000001'::uuid NOT NULL,
    site_name text NOT NULL,
    site_tagline text,
    site_url text NOT NULL,
    contact_email text,
    default_title text,
    default_description text,
    default_keywords text,
    analytics_id text,
    logo_url text,
    favicon_url text,
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT only_one_row CHECK ((id = '00000000-0000-0000-0000-000000000001'::uuid))
);


ALTER TABLE public.site_settings OWNER TO postgres;

--
-- Name: vpns; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vpns (
    id bigint NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    logo_url text,
    star_rating numeric(3,1),
    price_monthly_usd numeric(5,2),
    affiliate_link text,
    categories text[],
    description text,
    price_yearly_usd numeric(6,2),
    price_monthly_eur numeric(6,2),
    price_yearly_eur numeric(6,2),
    detailed_ratings jsonb,
    supported_devices jsonb,
    pros text[],
    cons text[],
    keeps_logs boolean DEFAULT true NOT NULL,
    has_court_proof boolean DEFAULT false NOT NULL,
    court_proof_content text,
    has_double_vpn boolean DEFAULT false NOT NULL,
    based_in_country_name text,
    based_in_country_flag text,
    has_coupon boolean DEFAULT false NOT NULL,
    coupon_code text,
    coupon_validity date,
    show_on_homepage boolean DEFAULT false NOT NULL,
    full_review text,
    has_p2p boolean DEFAULT false NOT NULL,
    has_kill_switch boolean DEFAULT false NOT NULL,
    has_ad_blocker boolean DEFAULT false NOT NULL,
    has_split_tunneling boolean DEFAULT false NOT NULL,
    simultaneous_connections integer,
    server_count integer DEFAULT 0,
    country_count integer DEFAULT 0
);


ALTER TABLE public.vpns OWNER TO postgres;

--
-- Name: COLUMN vpns.detailed_ratings; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vpns.detailed_ratings IS 'Store detailed ratings like { "speed": 9.5, "privacy": 8.0, "streaming": 9.0 }';


--
-- Name: COLUMN vpns.supported_devices; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vpns.supported_devices IS 'Store device support status like { "windows": true, "macos": true, "linux": false }';


--
-- Name: vpns_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.vpns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.vpns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: messages_2025_07_01; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_07_01 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_07_01 OWNER TO supabase_admin;

--
-- Name: messages_2025_07_02; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_07_02 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_07_02 OWNER TO supabase_admin;

--
-- Name: messages_2025_07_03; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_07_03 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_07_03 OWNER TO supabase_admin;

--
-- Name: messages_2025_07_04; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_07_04 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_07_04 OWNER TO supabase_admin;

--
-- Name: messages_2025_07_05; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_07_05 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_07_05 OWNER TO supabase_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb,
    level integer
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: prefixes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.prefixes (
    bucket_id text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    level integer GENERATED ALWAYS AS (storage.get_level(name)) STORED NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE storage.prefixes OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: hooks; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.hooks (
    id bigint NOT NULL,
    hook_table_id integer NOT NULL,
    hook_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    request_id bigint
);


ALTER TABLE supabase_functions.hooks OWNER TO supabase_functions_admin;

--
-- Name: TABLE hooks; Type: COMMENT; Schema: supabase_functions; Owner: supabase_functions_admin
--

COMMENT ON TABLE supabase_functions.hooks IS 'Supabase Functions Hooks: Audit trail for triggered hooks.';


--
-- Name: hooks_id_seq; Type: SEQUENCE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE SEQUENCE supabase_functions.hooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE supabase_functions.hooks_id_seq OWNER TO supabase_functions_admin;

--
-- Name: hooks_id_seq; Type: SEQUENCE OWNED BY; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER SEQUENCE supabase_functions.hooks_id_seq OWNED BY supabase_functions.hooks.id;


--
-- Name: migrations; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.migrations (
    version text NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE supabase_functions.migrations OWNER TO supabase_functions_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: postgres
--

CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text
);


ALTER TABLE supabase_migrations.schema_migrations OWNER TO postgres;

--
-- Name: seed_files; Type: TABLE; Schema: supabase_migrations; Owner: postgres
--

CREATE TABLE supabase_migrations.seed_files (
    path text NOT NULL,
    hash text NOT NULL
);


ALTER TABLE supabase_migrations.seed_files OWNER TO postgres;

--
-- Name: messages_2025_07_01; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_07_01 FOR VALUES FROM ('2025-07-01 00:00:00') TO ('2025-07-02 00:00:00');


--
-- Name: messages_2025_07_02; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_07_02 FOR VALUES FROM ('2025-07-02 00:00:00') TO ('2025-07-03 00:00:00');


--
-- Name: messages_2025_07_03; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_07_03 FOR VALUES FROM ('2025-07-03 00:00:00') TO ('2025-07-04 00:00:00');


--
-- Name: messages_2025_07_04; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_07_04 FOR VALUES FROM ('2025-07-04 00:00:00') TO ('2025-07-05 00:00:00');


--
-- Name: messages_2025_07_05; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_07_05 FOR VALUES FROM ('2025-07-05 00:00:00') TO ('2025-07-06 00:00:00');


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: hooks id; Type: DEFAULT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks ALTER COLUMN id SET DEFAULT nextval('supabase_functions.hooks_id_seq'::regclass);


--
-- Data for Name: extensions; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.extensions (id, type, settings, tenant_external_id, inserted_at, updated_at) FROM stdin;
68dc3ec0-9a2e-4ce3-b127-3741d9298d39	postgres_cdc_rls	{"region": "us-east-1", "db_host": "qkIDOH5Oh28jR0eUJsDzhfZhh2pxq8/9+Nogxe5i3Y0=", "db_name": "sWBpZNdjggEPTQVlI52Zfw==", "db_port": "+enMDFi1J/3IrrquHHwUmA==", "db_user": "uxbEq/zz8DXVD53TOI1zmw==", "slot_name": "supabase_realtime_replication_slot", "db_password": "sWBpZNdjggEPTQVlI52Zfw==", "publication": "supabase_realtime", "ssl_enforced": false, "poll_interval_ms": 100, "poll_max_changes": 100, "poll_max_record_bytes": 1048576}	realtime-dev	2025-07-02 18:42:46	2025-07-02 18:42:46
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.schema_migrations (version, inserted_at) FROM stdin;
20210706140551	2025-07-02 15:00:49
20220329161857	2025-07-02 15:00:49
20220410212326	2025-07-02 15:00:49
20220506102948	2025-07-02 15:00:49
20220527210857	2025-07-02 15:00:49
20220815211129	2025-07-02 15:00:49
20220815215024	2025-07-02 15:00:49
20220818141501	2025-07-02 15:00:49
20221018173709	2025-07-02 15:00:49
20221102172703	2025-07-02 15:00:49
20221223010058	2025-07-02 15:00:49
20230110180046	2025-07-02 15:00:49
20230810220907	2025-07-02 15:00:49
20230810220924	2025-07-02 15:00:49
20231024094642	2025-07-02 15:00:49
20240306114423	2025-07-02 15:00:49
20240418082835	2025-07-02 15:00:49
20240625211759	2025-07-02 15:00:49
20240704172020	2025-07-02 15:00:49
20240902173232	2025-07-02 15:00:49
20241106103258	2025-07-02 15:00:49
20250424203323	2025-07-02 15:00:49
20250613072131	2025-07-02 15:00:49
\.


--
-- Data for Name: tenants; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.tenants (id, name, external_id, jwt_secret, max_concurrent_users, inserted_at, updated_at, max_events_per_second, postgres_cdc_default, max_bytes_per_second, max_channels_per_client, max_joins_per_second, suspend, jwt_jwks, notify_private_alpha, private_only, migrations_ran, broadcast_adapter) FROM stdin;
8d81d597-d0e9-4c68-b9ba-c5017b201dd1	realtime-dev	realtime-dev	iNjicxc4+llvc9wovDvqymwfnj9teWMlyOIbJ8Fh6j2WNU8CIJ2ZgjR6MUIKqSmeDmvpsKLsZ9jgXJmQPpwL8w==	200	2025-07-02 18:42:46	2025-07-02 18:42:46	100	postgres_cdc_rls	100000	100	100	f	{"keys": [{"k": "c3VwZXItc2VjcmV0LWp3dC10b2tlbi13aXRoLWF0LWxlYXN0LTMyLWNoYXJhY3RlcnMtbG9uZw", "kty": "oct"}]}	f	f	62	phoenix
\.


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
00000000-0000-0000-0000-000000000000	47658af7-a3af-4481-9654-c90c6a776d21	{"action":"user_signedup","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"admin@admin.com","user_id":"283b74b6-f606-4e97-b13d-04a56aee96a7","user_phone":""}}	2025-07-02 15:03:59.926472+00	
00000000-0000-0000-0000-000000000000	4e942a28-9e5f-48d5-9115-5a50183d5dca	{"action":"login","actor_id":"283b74b6-f606-4e97-b13d-04a56aee96a7","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-07-02 15:04:09.955661+00	
00000000-0000-0000-0000-000000000000	a321dcfe-6a20-4e77-accb-8730b3c13367	{"action":"token_refreshed","actor_id":"283b74b6-f606-4e97-b13d-04a56aee96a7","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-02 16:02:22.16544+00	
00000000-0000-0000-0000-000000000000	e0e5c241-9149-42bd-aebf-550020387b32	{"action":"token_revoked","actor_id":"283b74b6-f606-4e97-b13d-04a56aee96a7","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-02 16:02:22.165911+00	
00000000-0000-0000-0000-000000000000	c639afd9-74ec-4c22-8a48-3c4915713966	{"action":"token_refreshed","actor_id":"283b74b6-f606-4e97-b13d-04a56aee96a7","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-02 17:02:06.71232+00	
00000000-0000-0000-0000-000000000000	8ce71177-0b82-4977-ad30-9bdbf03e8990	{"action":"token_revoked","actor_id":"283b74b6-f606-4e97-b13d-04a56aee96a7","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-02 17:02:06.714129+00	
00000000-0000-0000-0000-000000000000	a2e881e0-657a-4887-a1b2-5865aa8e12a6	{"action":"token_refreshed","actor_id":"283b74b6-f606-4e97-b13d-04a56aee96a7","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-02 18:19:23.434468+00	
00000000-0000-0000-0000-000000000000	c1668d97-ded5-4df1-a8d3-39c60c49e3f7	{"action":"token_refreshed","actor_id":"283b74b6-f606-4e97-b13d-04a56aee96a7","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-02 19:18:19.444332+00	
00000000-0000-0000-0000-000000000000	483633cb-d9d4-49f2-9697-899c818e6d30	{"action":"token_revoked","actor_id":"283b74b6-f606-4e97-b13d-04a56aee96a7","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-02 19:18:19.446703+00	
00000000-0000-0000-0000-000000000000	aacfaf43-1ba1-484c-b611-c5f64e585885	{"action":"token_refreshed","actor_id":"283b74b6-f606-4e97-b13d-04a56aee96a7","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-02 19:18:26.415917+00	
00000000-0000-0000-0000-000000000000	362689a0-0cfe-46e1-a540-8c704583122b	{"action":"token_refreshed","actor_id":"283b74b6-f606-4e97-b13d-04a56aee96a7","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-02 19:18:51.336003+00	
00000000-0000-0000-0000-000000000000	fdf7c5f1-306c-421c-b798-eddaee2b0341	{"action":"token_refreshed","actor_id":"283b74b6-f606-4e97-b13d-04a56aee96a7","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-02 19:20:37.946741+00	
00000000-0000-0000-0000-000000000000	cae22c25-4fe8-4fd6-93fb-b88ac6eaff62	{"action":"token_refreshed","actor_id":"283b74b6-f606-4e97-b13d-04a56aee96a7","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-02 20:20:37.906439+00	
00000000-0000-0000-0000-000000000000	f12eb0e1-cab9-4a02-b4e5-a7b3d1af7f35	{"action":"token_revoked","actor_id":"283b74b6-f606-4e97-b13d-04a56aee96a7","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-02 20:20:37.906832+00	
00000000-0000-0000-0000-000000000000	8d4070a6-8ee9-4e79-aec1-db290cde6f53	{"action":"token_refreshed","actor_id":"911f0a12-0166-4d36-aac0-ee5c2f3460d5","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-02 20:20:39.158288+00	
00000000-0000-0000-0000-000000000000	aed862d8-5f56-42a6-831b-4c3233e91140	{"action":"token_revoked","actor_id":"911f0a12-0166-4d36-aac0-ee5c2f3460d5","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-02 20:20:39.158759+00	
00000000-0000-0000-0000-000000000000	80bd953e-e60d-423d-887f-77c7f7f2b7d8	{"action":"token_refreshed","actor_id":"283b74b6-f606-4e97-b13d-04a56aee96a7","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-02 20:20:39.393333+00	
00000000-0000-0000-0000-000000000000	966801c2-df9f-409f-809c-90b4e781b527	{"action":"token_refreshed","actor_id":"283b74b6-f606-4e97-b13d-04a56aee96a7","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-02 21:47:06.888939+00	
00000000-0000-0000-0000-000000000000	5f5226b9-3759-4751-8b90-26600750721f	{"action":"token_revoked","actor_id":"283b74b6-f606-4e97-b13d-04a56aee96a7","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-02 21:47:06.889827+00	
00000000-0000-0000-0000-000000000000	5ef177ff-7d1e-497b-bdfc-b96d99fb0bba	{"action":"token_refreshed","actor_id":"911f0a12-0166-4d36-aac0-ee5c2f3460d5","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-02 21:47:10.506447+00	
00000000-0000-0000-0000-000000000000	2b3c25ff-370f-40a7-96ee-23ea98927833	{"action":"token_revoked","actor_id":"911f0a12-0166-4d36-aac0-ee5c2f3460d5","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-02 21:47:10.507928+00	
00000000-0000-0000-0000-000000000000	999681b8-959f-4651-aca9-3ec0d376846b	{"action":"token_refreshed","actor_id":"bab5117c-16a9-4874-8042-2e71516d6b1e","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-02 22:39:05.451+00	
00000000-0000-0000-0000-000000000000	255e0698-935b-4207-a61d-31d08e0601be	{"action":"token_revoked","actor_id":"bab5117c-16a9-4874-8042-2e71516d6b1e","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-02 22:39:05.451522+00	
00000000-0000-0000-0000-000000000000	1e527d16-9d26-4cc4-8d63-58d62879ca8a	{"action":"token_refreshed","actor_id":"911f0a12-0166-4d36-aac0-ee5c2f3460d5","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-02 22:45:22.162544+00	
00000000-0000-0000-0000-000000000000	c9b2a548-d710-44e1-852a-538211eef0ba	{"action":"token_revoked","actor_id":"911f0a12-0166-4d36-aac0-ee5c2f3460d5","actor_username":"","actor_via_sso":false,"log_type":"token"}	2025-07-02 22:45:22.162796+00	
00000000-0000-0000-0000-000000000000	ff56e249-cd4b-4c42-9527-63f3e2b7b900	{"action":"token_refreshed","actor_id":"283b74b6-f606-4e97-b13d-04a56aee96a7","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-02 22:46:36.988572+00	
00000000-0000-0000-0000-000000000000	759843ba-bb16-4c00-9379-6aa49057def1	{"action":"token_revoked","actor_id":"283b74b6-f606-4e97-b13d-04a56aee96a7","actor_username":"admin@admin.com","actor_via_sso":false,"log_type":"token"}	2025-07-02 22:46:36.98886+00	
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
283b74b6-f606-4e97-b13d-04a56aee96a7	283b74b6-f606-4e97-b13d-04a56aee96a7	{"sub": "283b74b6-f606-4e97-b13d-04a56aee96a7", "email": "admin@admin.com", "email_verified": false, "phone_verified": false}	email	2025-07-02 15:03:59.925699+00	2025-07-02 15:03:59.925747+00	2025-07-02 15:03:59.925747+00	e50144e1-5f77-49a5-9d29-1312d1197733
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
5b07f913-521c-4d95-8757-bd6c02da1974	2025-07-02 15:04:09.958617+00	2025-07-02 15:04:09.958617+00	password	f0efcafa-ffda-43c2-868a-d7f30b1a0418
32a407a1-5818-4262-98d3-dfd045c09d5f	2025-07-02 19:17:59.006628+00	2025-07-02 19:17:59.006628+00	anonymous	84cd6bb7-e053-4573-8f8d-0b292856bed4
0c1691b9-e832-4ade-80b6-1e2250b274f3	2025-07-02 19:18:25.774841+00	2025-07-02 19:18:25.774841+00	anonymous	c2baaf2b-4cb2-41c1-9255-dc0faf1bfb2c
e9e6855a-1892-48c7-9bd6-35acb686a08f	2025-07-02 19:18:28.686087+00	2025-07-02 19:18:28.686087+00	anonymous	6cb30d70-a48e-46af-b750-2b3fd86a39b3
eade3b82-1afd-41bd-9d3d-7b60027ad4c6	2025-07-02 20:34:25.601724+00	2025-07-02 20:34:25.601724+00	anonymous	79869dd0-a8ce-4681-9312-72024e8fd507
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	1	borgr36vynzt	283b74b6-f606-4e97-b13d-04a56aee96a7	t	2025-07-02 15:04:09.95727+00	2025-07-02 16:02:22.166161+00	\N	5b07f913-521c-4d95-8757-bd6c02da1974
00000000-0000-0000-0000-000000000000	2	m3jwd24cyazm	283b74b6-f606-4e97-b13d-04a56aee96a7	t	2025-07-02 16:02:22.166534+00	2025-07-02 17:02:06.716135+00	borgr36vynzt	5b07f913-521c-4d95-8757-bd6c02da1974
00000000-0000-0000-0000-000000000000	4	kjgwyw2hpksp	3f5e2665-1772-4ddc-8b66-744ad25f465e	f	2025-07-02 19:17:59.003036+00	2025-07-02 19:17:59.003036+00	\N	32a407a1-5818-4262-98d3-dfd045c09d5f
00000000-0000-0000-0000-000000000000	3	6aczestmbuio	283b74b6-f606-4e97-b13d-04a56aee96a7	t	2025-07-02 17:02:06.717164+00	2025-07-02 19:18:19.447472+00	m3jwd24cyazm	5b07f913-521c-4d95-8757-bd6c02da1974
00000000-0000-0000-0000-000000000000	6	xo33zrdklcwp	ca274d9f-1caf-4603-b5c0-86b3ffd2302d	f	2025-07-02 19:18:25.772456+00	2025-07-02 19:18:25.772456+00	\N	0c1691b9-e832-4ade-80b6-1e2250b274f3
00000000-0000-0000-0000-000000000000	5	cxvfjdmodcwb	283b74b6-f606-4e97-b13d-04a56aee96a7	t	2025-07-02 19:18:19.449676+00	2025-07-02 20:20:37.907199+00	6aczestmbuio	5b07f913-521c-4d95-8757-bd6c02da1974
00000000-0000-0000-0000-000000000000	7	khjbmlpzw2kw	911f0a12-0166-4d36-aac0-ee5c2f3460d5	t	2025-07-02 19:18:28.683787+00	2025-07-02 20:20:39.159189+00	\N	e9e6855a-1892-48c7-9bd6-35acb686a08f
00000000-0000-0000-0000-000000000000	8	sdikkxl7ljqy	283b74b6-f606-4e97-b13d-04a56aee96a7	t	2025-07-02 20:20:37.907433+00	2025-07-02 21:47:06.890956+00	cxvfjdmodcwb	5b07f913-521c-4d95-8757-bd6c02da1974
00000000-0000-0000-0000-000000000000	9	5nfrbkjkgpad	911f0a12-0166-4d36-aac0-ee5c2f3460d5	t	2025-07-02 20:20:39.159535+00	2025-07-02 21:47:10.509399+00	khjbmlpzw2kw	e9e6855a-1892-48c7-9bd6-35acb686a08f
00000000-0000-0000-0000-000000000000	10	3oc3fqrk5pqk	bab5117c-16a9-4874-8042-2e71516d6b1e	t	2025-07-02 20:34:25.598264+00	2025-07-02 22:39:05.451998+00	\N	eade3b82-1afd-41bd-9d3d-7b60027ad4c6
00000000-0000-0000-0000-000000000000	13	a5qmidcwomjj	bab5117c-16a9-4874-8042-2e71516d6b1e	f	2025-07-02 22:39:05.452318+00	2025-07-02 22:39:05.452318+00	3oc3fqrk5pqk	eade3b82-1afd-41bd-9d3d-7b60027ad4c6
00000000-0000-0000-0000-000000000000	12	6vxrbsxcbgzc	911f0a12-0166-4d36-aac0-ee5c2f3460d5	t	2025-07-02 21:47:10.510248+00	2025-07-02 22:45:22.162973+00	5nfrbkjkgpad	e9e6855a-1892-48c7-9bd6-35acb686a08f
00000000-0000-0000-0000-000000000000	14	cqm2okgyt6he	911f0a12-0166-4d36-aac0-ee5c2f3460d5	f	2025-07-02 22:45:22.163089+00	2025-07-02 22:45:22.163089+00	6vxrbsxcbgzc	e9e6855a-1892-48c7-9bd6-35acb686a08f
00000000-0000-0000-0000-000000000000	11	antlbrkajiu7	283b74b6-f606-4e97-b13d-04a56aee96a7	t	2025-07-02 21:47:06.891634+00	2025-07-02 22:46:36.989088+00	sdikkxl7ljqy	5b07f913-521c-4d95-8757-bd6c02da1974
00000000-0000-0000-0000-000000000000	15	l5ignxysej3l	283b74b6-f606-4e97-b13d-04a56aee96a7	f	2025-07-02 22:46:36.989231+00	2025-07-02 22:46:36.989231+00	antlbrkajiu7	5b07f913-521c-4d95-8757-bd6c02da1974
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag) FROM stdin;
32a407a1-5818-4262-98d3-dfd045c09d5f	3f5e2665-1772-4ddc-8b66-744ad25f465e	2025-07-02 19:17:58.999495+00	2025-07-02 19:17:58.999495+00	\N	aal1	\N	\N	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36	192.168.96.1	\N
0c1691b9-e832-4ade-80b6-1e2250b274f3	ca274d9f-1caf-4603-b5c0-86b3ffd2302d	2025-07-02 19:18:25.771023+00	2025-07-02 19:18:25.771023+00	\N	aal1	\N	\N	Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0	192.168.96.1	\N
eade3b82-1afd-41bd-9d3d-7b60027ad4c6	bab5117c-16a9-4874-8042-2e71516d6b1e	2025-07-02 20:34:25.596346+00	2025-07-02 22:39:05.454246+00	\N	aal1	\N	2025-07-02 22:39:05.454155	Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0	192.168.96.1	\N
e9e6855a-1892-48c7-9bd6-35acb686a08f	911f0a12-0166-4d36-aac0-ee5c2f3460d5	2025-07-02 19:18:28.682477+00	2025-07-02 22:45:22.163776+00	\N	aal1	\N	2025-07-02 22:45:22.163741	Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0	192.168.96.1	\N
5b07f913-521c-4d95-8757-bd6c02da1974	283b74b6-f606-4e97-b13d-04a56aee96a7	2025-07-02 15:04:09.95638+00	2025-07-02 22:46:36.990011+00	\N	aal1	\N	2025-07-02 22:46:36.989972	node	192.168.96.1	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	3f5e2665-1772-4ddc-8b66-744ad25f465e	authenticated	authenticated	\N		\N	\N		\N		\N			\N	2025-07-02 19:17:58.999365+00	{}	{}	\N	2025-07-02 19:17:58.987393+00	2025-07-02 19:17:59.005933+00	\N	\N			\N		0	\N		\N	f	\N	t
00000000-0000-0000-0000-000000000000	ca274d9f-1caf-4603-b5c0-86b3ffd2302d	authenticated	authenticated	\N		\N	\N		\N		\N			\N	2025-07-02 19:18:25.77082+00	{}	{}	\N	2025-07-02 19:18:25.765454+00	2025-07-02 19:18:25.774338+00	\N	\N			\N		0	\N		\N	f	\N	t
00000000-0000-0000-0000-000000000000	bab5117c-16a9-4874-8042-2e71516d6b1e	authenticated	authenticated	\N		\N	\N		\N		\N			\N	2025-07-02 20:34:25.596108+00	{}	{}	\N	2025-07-02 20:34:25.588135+00	2025-07-02 22:39:05.453252+00	\N	\N			\N		0	\N		\N	f	\N	t
00000000-0000-0000-0000-000000000000	911f0a12-0166-4d36-aac0-ee5c2f3460d5	authenticated	authenticated	\N		\N	\N		\N		\N			\N	2025-07-02 19:18:28.682285+00	{}	{}	\N	2025-07-02 19:18:28.677864+00	2025-07-02 22:45:22.163434+00	\N	\N			\N		0	\N		\N	f	\N	t
00000000-0000-0000-0000-000000000000	283b74b6-f606-4e97-b13d-04a56aee96a7	authenticated	authenticated	admin@admin.com	$2a$10$goPbsvZzV3cWxfnv23XnH.bIOjxwa6VqTNdzE7ooVXD8KbPi1PQbu	2025-07-02 15:03:59.927753+00	\N		\N		\N			\N	2025-07-02 15:04:09.95631+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2025-07-02 15:03:59.923554+00	2025-07-02 22:46:36.989629+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: affiliate_clicks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.affiliate_clicks (id, created_at, vpn_id, session_id) FROM stdin;
\.


--
-- Data for Name: blog_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.blog_categories (id, name, slug, description, created_at) FROM stdin;
1	Online Security	online-security	Tips and best practices for staying safe online.	2025-07-02 15:01:08.251836+00
2	Streaming	streaming	How to unblock and watch your favorite streaming services from anywhere.	2025-07-02 15:01:08.251836+00
3	VPN Reviews	vpn-reviews	In-depth reviews of the top VPN providers.	2025-07-02 15:01:08.251836+00
\.


--
-- Data for Name: blog_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.blog_comments (id, post_id, author_id, content, parent_comment_id, created_at, updated_at, guest_name) FROM stdin;
\.


--
-- Data for Name: blog_posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.blog_posts (id, title, slug, content, excerpt, featured_image_url, author_id, category_id, likes_count, allow_comments, show_cta, meta_title, meta_description, created_at, updated_at, published_at) FROM stdin;
1	The Ultimate Guide to Online Privacy in 2025	ultimate-guide-online-privacy-2025	<p>In an increasingly digital world, protecting your privacy is more important than ever. This guide covers everything you need to know...</p>	A comprehensive look at the tools and techniques to safeguard your digital footprint.	\N	\N	1	0	t	t	Ultimate Guide to Online Privacy 2025 | AstroVPN	Learn how to protect your online privacy with our ultimate guide for 2025. We cover VPNs, secure browsers, and more.	2025-07-02 15:01:08.251836+00	2025-07-02 15:01:08.251836+00	2025-07-02 15:01:08.251836+00
2	How to Watch US Netflix from Anywhere	how-to-watch-us-netflix-anywhere	<p>Tired of geo-restrictions? A good VPN is the key to unlocking a world of content. Here’s how to get started...</p>	Unblock the full US Netflix library from anywhere in the world with these simple steps.	\N	\N	2	0	t	t	How to Watch US Netflix from Anywhere | AstroVPN	Follow our simple guide to use a VPN to watch the US Netflix library from any country.	2025-07-02 15:01:08.251836+00	2025-07-02 15:01:08.251836+00	2025-07-02 15:01:08.251836+00
\.


--
-- Data for Name: page_views; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.page_views (id, created_at, path, session_id) FROM stdin;
1	2025-07-02 15:01:39.697911+00	/reviews/streaming	972354b6-cb63-408c-b102-a962a76a9317
2	2025-07-02 15:01:39.736748+00	/reviews/streaming	972354b6-cb63-408c-b102-a962a76a9317
3	2025-07-02 15:03:22.459582+00	/	972354b6-cb63-408c-b102-a962a76a9317
4	2025-07-02 15:03:22.925507+00	/reviews/streaming	972354b6-cb63-408c-b102-a962a76a9317
5	2025-07-02 15:03:40.219874+00	/	972354b6-cb63-408c-b102-a962a76a9317
6	2025-07-02 15:04:37.637527+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
7	2025-07-02 15:04:51.438021+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
8	2025-07-02 15:05:11.127021+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
9	2025-07-02 15:05:12.043434+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
10	2025-07-02 15:07:06.084033+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
11	2025-07-02 15:07:06.132531+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
12	2025-07-02 15:07:27.38604+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
13	2025-07-02 15:07:46.470734+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
14	2025-07-02 15:08:55.339557+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
15	2025-07-02 15:10:03.021382+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
16	2025-07-02 15:13:09.990615+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
17	2025-07-02 15:13:31.387687+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
18	2025-07-02 15:14:36.254732+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
19	2025-07-02 15:15:56.168284+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
20	2025-07-02 15:16:57.558697+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
21	2025-07-02 15:17:38.381591+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
22	2025-07-02 15:21:02.586232+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
23	2025-07-02 15:21:48.656685+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
24	2025-07-02 15:21:50.993517+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
25	2025-07-02 15:21:53.156586+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
26	2025-07-02 15:22:45.79267+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
27	2025-07-02 15:22:45.91246+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
28	2025-07-02 15:23:08.244573+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
29	2025-07-02 15:25:17.410422+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
30	2025-07-02 15:25:17.427318+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
31	2025-07-02 15:25:54.685114+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
32	2025-07-02 15:25:54.738347+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
33	2025-07-02 15:26:12.732835+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
34	2025-07-02 15:26:12.840078+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
35	2025-07-02 15:26:25.381858+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
36	2025-07-02 15:26:25.448787+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
37	2025-07-02 15:27:12.814295+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
38	2025-07-02 15:27:12.882115+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
39	2025-07-02 15:27:57.657913+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
40	2025-07-02 15:27:57.678522+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
41	2025-07-02 15:28:32.140495+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
42	2025-07-02 15:29:39.012285+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
43	2025-07-02 15:29:39.063286+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
44	2025-07-02 15:30:09.089792+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
45	2025-07-02 15:31:23.577218+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
46	2025-07-02 15:32:06.92055+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
47	2025-07-02 15:32:25.985216+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
48	2025-07-02 15:33:00.550105+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
49	2025-07-02 15:33:38.97689+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
50	2025-07-02 15:34:13.407961+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
51	2025-07-02 15:35:10.892964+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
52	2025-07-02 15:37:41.442327+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
53	2025-07-02 15:42:41.180402+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
54	2025-07-02 15:42:50.023381+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
55	2025-07-02 15:42:51.195671+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
56	2025-07-02 15:42:54.740397+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
57	2025-07-02 15:42:56.912466+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
58	2025-07-02 15:42:58.127506+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
59	2025-07-02 15:43:18.010744+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
60	2025-07-02 15:44:38.403612+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
61	2025-07-02 15:47:02.116635+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
62	2025-07-02 15:55:03.399992+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
63	2025-07-02 15:56:46.438037+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
64	2025-07-02 15:58:53.653916+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
65	2025-07-02 15:58:56.011327+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
66	2025-07-02 16:02:27.910915+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
67	2025-07-02 16:02:43.416896+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
68	2025-07-02 16:02:54.996395+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
69	2025-07-02 16:19:21.945781+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
70	2025-07-02 16:19:32.087937+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
71	2025-07-02 16:19:53.717727+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
72	2025-07-02 16:24:03.629949+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
73	2025-07-02 16:26:30.926061+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
74	2025-07-02 16:26:40.178382+00	/vpn/expressvpn	283b74b6-f606-4e97-b13d-04a56aee96a7
75	2025-07-02 16:27:00.215988+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
76	2025-07-02 16:29:45.469855+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
77	2025-07-02 16:31:04.219343+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
78	2025-07-02 16:32:09.126644+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
79	2025-07-02 16:32:56.842469+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
80	2025-07-02 16:33:11.050591+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
81	2025-07-02 16:35:41.293398+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
82	2025-07-02 16:36:18.105654+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
83	2025-07-02 16:36:29.087271+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
84	2025-07-02 16:41:15.271992+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
85	2025-07-02 16:41:36.058698+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
86	2025-07-02 16:42:31.518338+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
87	2025-07-02 16:43:18.842879+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
88	2025-07-02 16:44:45.686288+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
89	2025-07-02 16:45:14.929467+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
90	2025-07-02 16:48:54.774224+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
91	2025-07-02 16:59:12.323961+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
92	2025-07-02 18:23:00.64869+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
93	2025-07-02 18:23:52.845114+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
94	2025-07-02 18:23:53.437896+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
95	2025-07-02 18:25:04.497122+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
96	2025-07-02 18:25:24.433266+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
97	2025-07-02 18:26:18.742694+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
98	2025-07-02 18:27:51.072187+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
99	2025-07-02 18:43:59.573992+00	/	283b74b6-f606-4e97-b13d-04a56aee96a7
100	2025-07-02 18:44:02.964671+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
101	2025-07-02 18:45:30.426335+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
102	2025-07-02 18:45:50.50699+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
103	2025-07-02 18:46:16.899879+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
104	2025-07-02 18:47:10.402882+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
105	2025-07-02 18:47:24.773834+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
106	2025-07-02 18:48:08.281276+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
107	2025-07-02 18:48:21.534876+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
108	2025-07-02 18:49:21.043716+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
109	2025-07-02 18:51:30.622586+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
110	2025-07-02 18:51:52.114654+00	/reviews/streaming	283b74b6-f606-4e97-b13d-04a56aee96a7
111	2025-07-02 19:17:59.032099+00	/	3f5e2665-1772-4ddc-8b66-744ad25f465e
112	2025-07-02 19:18:03.371341+00	/	3f5e2665-1772-4ddc-8b66-744ad25f465e
113	2025-07-02 19:18:28.786974+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
114	2025-07-02 19:18:52.444159+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
115	2025-07-02 19:20:43.265631+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
116	2025-07-02 19:22:03.869164+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
117	2025-07-02 19:37:41.263047+00	/	3f5e2665-1772-4ddc-8b66-744ad25f465e
118	2025-07-02 19:37:50.171133+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
119	2025-07-02 19:37:53.765458+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
120	2025-07-02 19:39:43.39874+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
121	2025-07-02 19:41:30.894992+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
122	2025-07-02 19:41:33.337854+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
123	2025-07-02 19:41:35.777672+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
124	2025-07-02 19:41:39.951254+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
125	2025-07-02 19:41:41.616132+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
126	2025-07-02 19:41:43.578937+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
127	2025-07-02 19:41:49.145379+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
128	2025-07-02 19:42:23.366345+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
129	2025-07-02 19:42:31.43666+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
130	2025-07-02 19:42:56.293942+00	/blog	911f0a12-0166-4d36-aac0-ee5c2f3460d5
131	2025-07-02 19:42:57.818353+00	/blog	911f0a12-0166-4d36-aac0-ee5c2f3460d5
132	2025-07-02 19:43:02.119027+00	/blog	911f0a12-0166-4d36-aac0-ee5c2f3460d5
133	2025-07-02 19:43:05.49852+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
134	2025-07-02 19:49:37.728704+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
135	2025-07-02 19:50:36.943704+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
136	2025-07-02 19:51:45.584294+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
137	2025-07-02 19:51:56.985736+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
138	2025-07-02 19:55:10.449234+00	/blog	911f0a12-0166-4d36-aac0-ee5c2f3460d5
139	2025-07-02 19:55:13.457109+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
140	2025-07-02 19:56:33.281422+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
141	2025-07-02 19:56:35.124585+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
142	2025-07-02 19:56:46.93808+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
143	2025-07-02 19:58:34.06899+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
144	2025-07-02 19:58:37.596887+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
145	2025-07-02 19:59:15.009713+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
146	2025-07-02 19:59:21.99983+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
147	2025-07-02 19:59:25.282253+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
148	2025-07-02 19:59:40.414165+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
149	2025-07-02 20:00:50.102444+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
150	2025-07-02 20:04:57.280351+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
151	2025-07-02 20:05:00.850983+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
152	2025-07-02 20:05:09.592388+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
153	2025-07-02 20:05:13.153141+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
154	2025-07-02 20:07:09.283867+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
155	2025-07-02 20:07:12.297564+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
156	2025-07-02 20:07:34.164792+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
157	2025-07-02 20:08:24.423112+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
158	2025-07-02 20:09:50.337908+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
159	2025-07-02 20:10:26.378005+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
160	2025-07-02 20:10:38.01377+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
161	2025-07-02 20:11:03.50306+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
162	2025-07-02 20:11:12.458968+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
163	2025-07-02 20:11:56.855221+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
164	2025-07-02 20:12:07.126169+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
165	2025-07-02 20:12:14.056061+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
166	2025-07-02 20:12:49.512436+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
167	2025-07-02 20:12:56.763844+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
168	2025-07-02 20:13:06.267865+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
169	2025-07-02 20:13:10.83229+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
170	2025-07-02 20:13:32.537602+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
171	2025-07-02 20:13:48.240732+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
172	2025-07-02 20:13:49.443764+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
173	2025-07-02 20:14:08.279557+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
174	2025-07-02 20:15:07.719659+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
175	2025-07-02 20:15:43.164472+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
176	2025-07-02 20:15:49.204205+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
177	2025-07-02 20:15:58.571406+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
178	2025-07-02 20:16:11.37201+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
179	2025-07-02 20:16:18.283291+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
180	2025-07-02 20:16:29.486957+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
181	2025-07-02 20:20:39.419146+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
182	2025-07-02 20:21:20.840261+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
183	2025-07-02 20:34:26.196567+00	/	bab5117c-16a9-4874-8042-2e71516d6b1e
184	2025-07-02 20:43:17.869709+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
185	2025-07-02 20:45:46.259267+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
186	2025-07-02 20:46:12.641055+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
187	2025-07-02 20:46:23.431858+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
188	2025-07-02 20:46:44.835206+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
189	2025-07-02 20:47:53.780442+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
190	2025-07-02 20:48:41.089345+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
191	2025-07-02 20:48:58.163846+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
192	2025-07-02 20:50:16.881786+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
193	2025-07-02 20:50:25.01715+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
194	2025-07-02 20:50:31.234903+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
195	2025-07-02 20:50:46.75027+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
196	2025-07-02 20:53:25.951101+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
197	2025-07-02 20:54:02.816752+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
198	2025-07-02 20:54:06.402826+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
199	2025-07-02 21:47:22.93097+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
200	2025-07-02 21:47:23.796226+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
201	2025-07-02 21:47:55.70095+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
202	2025-07-02 21:47:59.761834+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
203	2025-07-02 21:48:12.100951+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
204	2025-07-02 22:06:17.639591+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
205	2025-07-02 22:23:03.173789+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
206	2025-07-02 22:25:26.62352+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
207	2025-07-02 22:25:27.917914+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
208	2025-07-02 22:26:34.809662+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
209	2025-07-02 22:26:40.198642+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
210	2025-07-02 22:26:41.606829+00	/reviews/streaming	911f0a12-0166-4d36-aac0-ee5c2f3460d5
211	2025-07-02 22:26:45.332503+00	/	911f0a12-0166-4d36-aac0-ee5c2f3460d5
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (id, full_name, avatar_url, updated_at) FROM stdin;
283b74b6-f606-4e97-b13d-04a56aee96a7	\N	\N	2025-07-02 15:03:59.923287+00
3f5e2665-1772-4ddc-8b66-744ad25f465e	\N	\N	2025-07-02 19:17:58.986772+00
ca274d9f-1caf-4603-b5c0-86b3ffd2302d	\N	\N	2025-07-02 19:18:25.764877+00
911f0a12-0166-4d36-aac0-ee5c2f3460d5	\N	\N	2025-07-02 19:18:28.677024+00
bab5117c-16a9-4874-8042-2e71516d6b1e	\N	\N	2025-07-02 20:34:25.587165+00
\.


--
-- Data for Name: review_pages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.review_pages (id, created_at, title, slug, description, introduction, conclusion, vpn_ids) FROM stdin;
1	2025-07-02 15:04:30.537751+00	streaming	streaming				{2,1}
\.


--
-- Data for Name: site_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.site_settings (id, site_name, site_tagline, site_url, contact_email, default_title, default_description, default_keywords, analytics_id, logo_url, favicon_url, updated_at) FROM stdin;
00000000-0000-0000-0000-000000000001	AstroVPN	\N	https://astrovpn.com	\N	\N	\N	\N	\N	\N	\N	2025-07-02 15:01:08.238132+00
\.


--
-- Data for Name: vpns; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vpns (id, name, slug, logo_url, star_rating, price_monthly_usd, affiliate_link, categories, description, price_yearly_usd, price_monthly_eur, price_yearly_eur, detailed_ratings, supported_devices, pros, cons, keeps_logs, has_court_proof, court_proof_content, has_double_vpn, based_in_country_name, based_in_country_flag, has_coupon, coupon_code, coupon_validity, show_on_homepage, full_review, has_p2p, has_kill_switch, has_ad_blocker, has_split_tunneling, simultaneous_connections, server_count, country_count) FROM stdin;
1	NordVPN	nordvpn	https://cdn.worldvectorlogo.com/logos/nordvpn-1.svg	4.9	12.99	https://go.nordvpn.net/aff_c?offer_id=15&aff_id=12345	\N	A top-tier VPN known for its speed, security, and large server network.	59.88	\N	\N	{"speed": 9.8, "privacy": 9.9, "features": 9.7, "streaming": 9.5, "torrenting": 9.2, "user_experience": 9.5}	{"tv": true, "ios": true, "linux": true, "macos": true, "router": true, "android": true, "windows": true}	{"Blazing fast speeds with NordLynx","Threat Protection feature","Audited no-logs policy","Over 5000 servers worldwide"}	{"App can be slow to connect at times","Shared IP addresses only"}	f	t	NordVPN's no-logs policy was verified by PricewaterhouseCoopers AG in Switzerland.	t	Panama	🇵🇦	t	WINTERDEAL	2025-12-31	t	<h3>Full NordVPN Review</h3><p>NordVPN is a powerhouse in the VPN industry, and for good reason...</p>	f	f	f	f	\N	0	0
2	ExpressVPN	expressvpn	https://www.expressvpn.com/assets/images/logo/expressvpn-logo-red.svg	4.8	12.95	https://www.expressvpn.com/order?a_aid=12345	\N	A premium VPN service with a strong focus on privacy and unblocking content.	99.95	\N	\N	{"speed": 9.5, "privacy": 9.9, "features": 9.2, "streaming": 9.8, "torrenting": 9.5, "user_experience": 9.7}	{"tv": true, "ios": true, "linux": true, "macos": true, "router": true, "android": true, "windows": true}	{"TrustedServer technology (RAM-only)","Excellent for unblocking streaming sites","Very easy to use apps","24/7 live chat support"}	{"More expensive than competitors","Fewer simultaneous connections"}	f	t	ExpressVPN's privacy policy and TrustedServer technology have been independently audited by Cure53 and PwC.	f	British Virgin Islands	🇻🇬	f	\N	\N	t	<h3>Full ExpressVPN Review</h3><p>ExpressVPN consistently ranks as one of the best VPNs available...</p>	f	f	f	f	\N	0	0
3	Surfshark	surfshark	https://surfshark.com/wp-content/uploads/Surfshark-Logo-1-2.svg	4.7	12.95	https://surfshark.com/deals?coupon=Ssharkdeal&a_id=12345	\N	An affordable VPN that offers unlimited simultaneous connections and great features.	47.88	\N	\N	{"speed": 9.2, "privacy": 9.5, "features": 9.8, "streaming": 9.4, "torrenting": 9.0, "user_experience": 9.4}	{"tv": true, "ios": true, "linux": true, "macos": true, "router": false, "android": true, "windows": true}	{"Unlimited simultaneous connections","Very budget-friendly","CleanWeb ad-blocker included","Static IP and MultiHop options"}	{"Server network is smaller than rivals","Customer support can be slow"}	f	t	Surfshark underwent an independent audit by Cure53, which confirmed its no-logs claims.	t	Netherlands	🇳🇱	t	SURFSHARKDEAL	2025-10-31	t	<h3>Full Surfshark Review</h3><p>Surfshark has quickly become a fan favorite for its combination of price and features...</p>	f	f	f	f	\N	0	0
\.


--
-- Data for Name: messages_2025_07_01; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_07_01 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_07_02; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_07_02 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_07_03; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_07_03 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_07_04; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_07_04 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_07_05; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_07_05 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-07-02 15:00:57
20211116045059	2025-07-02 15:00:57
20211116050929	2025-07-02 15:00:57
20211116051442	2025-07-02 15:00:57
20211116212300	2025-07-02 15:00:57
20211116213355	2025-07-02 15:00:57
20211116213934	2025-07-02 15:00:57
20211116214523	2025-07-02 15:00:57
20211122062447	2025-07-02 15:00:57
20211124070109	2025-07-02 15:00:57
20211202204204	2025-07-02 15:00:57
20211202204605	2025-07-02 15:00:57
20211210212804	2025-07-02 15:00:57
20211228014915	2025-07-02 15:00:57
20220107221237	2025-07-02 15:00:57
20220228202821	2025-07-02 15:00:57
20220312004840	2025-07-02 15:00:57
20220603231003	2025-07-02 15:00:57
20220603232444	2025-07-02 15:00:57
20220615214548	2025-07-02 15:00:57
20220712093339	2025-07-02 15:00:57
20220908172859	2025-07-02 15:00:57
20220916233421	2025-07-02 15:00:57
20230119133233	2025-07-02 15:00:57
20230128025114	2025-07-02 15:00:57
20230128025212	2025-07-02 15:00:57
20230227211149	2025-07-02 15:00:57
20230228184745	2025-07-02 15:00:57
20230308225145	2025-07-02 15:00:57
20230328144023	2025-07-02 15:00:57
20231018144023	2025-07-02 15:00:57
20231204144023	2025-07-02 15:00:57
20231204144024	2025-07-02 15:00:57
20231204144025	2025-07-02 15:00:57
20240108234812	2025-07-02 15:00:57
20240109165339	2025-07-02 15:00:57
20240227174441	2025-07-02 15:00:57
20240311171622	2025-07-02 15:00:57
20240321100241	2025-07-02 15:00:57
20240401105812	2025-07-02 15:00:57
20240418121054	2025-07-02 15:00:57
20240523004032	2025-07-02 15:00:57
20240618124746	2025-07-02 15:00:57
20240801235015	2025-07-02 15:00:57
20240805133720	2025-07-02 15:00:57
20240827160934	2025-07-02 15:00:57
20240919163303	2025-07-02 15:00:58
20240919163305	2025-07-02 15:00:58
20241019105805	2025-07-02 15:00:58
20241030150047	2025-07-02 15:00:58
20241108114728	2025-07-02 15:00:58
20241121104152	2025-07-02 15:00:58
20241130184212	2025-07-02 15:00:58
20241220035512	2025-07-02 15:00:58
20241220123912	2025-07-02 15:00:58
20241224161212	2025-07-02 15:00:58
20250107150512	2025-07-02 15:00:58
20250110162412	2025-07-02 15:00:58
20250123174212	2025-07-02 15:00:58
20250128220012	2025-07-02 15:00:58
20250506224012	2025-07-02 15:00:58
20250523164012	2025-07-02 15:00:58
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id) FROM stdin;
vpn-assets	vpn-assets	\N	2025-07-02 15:01:08.207885+00	2025-07-02 15:01:08.207885+00	t	f	\N	\N	\N
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-07-02 15:01:06.901602
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-07-02 15:01:06.9071
2	storage-schema	5c7968fd083fcea04050c1b7f6253c9771b99011	2025-07-02 15:01:06.908993
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-07-02 15:01:06.920161
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-07-02 15:01:06.926254
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-07-02 15:01:06.928235
6	change-column-name-in-get-size	f93f62afdf6613ee5e7e815b30d02dc990201044	2025-07-02 15:01:06.932797
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-07-02 15:01:06.937563
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-07-02 15:01:06.939538
9	fix-search-function	3a0af29f42e35a4d101c259ed955b67e1bee6825	2025-07-02 15:01:06.942009
10	search-files-search-function	68dc14822daad0ffac3746a502234f486182ef6e	2025-07-02 15:01:06.945186
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-07-02 15:01:06.948575
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-07-02 15:01:06.952019
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-07-02 15:01:06.954329
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-07-02 15:01:06.956578
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-07-02 15:01:06.971303
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-07-02 15:01:06.974412
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-07-02 15:01:06.976653
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-07-02 15:01:06.979645
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-07-02 15:01:06.983229
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-07-02 15:01:06.985391
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-07-02 15:01:06.989319
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-07-02 15:01:06.996913
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-07-02 15:01:07.004381
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-07-02 15:01:07.006908
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2025-07-02 15:01:07.009151
26	objects-prefixes	ef3f7871121cdc47a65308e6702519e853422ae2	2025-07-02 15:01:07.011201
27	search-v2	33b8f2a7ae53105f028e13e9fcda9dc4f356b4a2	2025-07-02 15:01:07.020038
28	object-bucket-name-sorting	ba85ec41b62c6a30a3f136788227ee47f311c436	2025-07-02 15:01:07.062917
29	create-prefixes	a7b1a22c0dc3ab630e3055bfec7ce7d2045c5b7b	2025-07-02 15:01:07.068837
30	update-object-levels	6c6f6cc9430d570f26284a24cf7b210599032db7	2025-07-02 15:01:07.074426
31	objects-level-index	33f1fef7ec7fea08bb892222f4f0f5d79bab5eb8	2025-07-02 15:01:07.079542
32	backward-compatible-index-on-objects	2d51eeb437a96868b36fcdfb1ddefdf13bef1647	2025-07-02 15:01:07.085192
33	backward-compatible-index-on-prefixes	fe473390e1b8c407434c0e470655945b110507bf	2025-07-02 15:01:07.089994
34	optimize-search-function-v1	82b0e469a00e8ebce495e29bfa70a0797f7ebd2c	2025-07-02 15:01:07.091085
35	add-insert-trigger-prefixes	63bb9fd05deb3dc5e9fa66c83e82b152f0caf589	2025-07-02 15:01:07.094989
36	optimise-existing-functions	81cf92eb0c36612865a18016a38496c530443899	2025-07-02 15:01:07.097114
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2025-07-02 15:01:07.102405
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata, level) FROM stdin;
\.


--
-- Data for Name: prefixes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.prefixes (bucket_id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: hooks; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--

COPY supabase_functions.hooks (id, hook_table_id, hook_name, created_at, request_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--

COPY supabase_functions.migrations (version, inserted_at) FROM stdin;
initial	2025-07-02 15:00:39.212672+00
20210809183423_update_grants	2025-07-02 15:00:39.212672+00
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: supabase_migrations; Owner: postgres
--

COPY supabase_migrations.schema_migrations (version, statements, name) FROM stdin;
20250701021506	{"-- Create the 'vpns' table\nCREATE TABLE vpns (\n  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,\n  name TEXT NOT NULL,\n  slug TEXT NOT NULL UNIQUE,\n  logo_url TEXT,\n  rating NUMERIC(2, 1),\n  features TEXT[],\n  platforms TEXT[],\n  price_monthly NUMERIC(5, 2),\n  website_url TEXT,\n  categories TEXT[]\n)"}	create_vpns_table
20250701022044	{"-- Add the 'description' column to the 'vpns' table\nALTER TABLE vpns\nADD COLUMN description TEXT"}	add_description_to_vpns
20250701031935	{"-- Rename existing columns for clarity and consistency\nALTER TABLE public.vpns RENAME COLUMN rating TO star_rating","ALTER TABLE public.vpns RENAME COLUMN website_url TO affiliate_link","-- Drop old, generic columns that will be replaced by more specific ones\nALTER TABLE public.vpns DROP COLUMN IF EXISTS features","ALTER TABLE public.vpns DROP COLUMN IF EXISTS platforms","-- Add new detailed columns based on user specification\n\n-- Price (assuming yearly and monthly for both currencies)\nALTER TABLE public.vpns RENAME COLUMN price_monthly TO price_monthly_usd","ALTER TABLE public.vpns ADD COLUMN price_yearly_usd NUMERIC(6, 2)","ALTER TABLE public.vpns ADD COLUMN price_monthly_eur NUMERIC(6, 2)","ALTER TABLE public.vpns ADD COLUMN price_yearly_eur NUMERIC(6, 2)","-- Detailed Ratings (using JSONB for flexibility)\nALTER TABLE public.vpns ADD COLUMN detailed_ratings JSONB","COMMENT ON COLUMN public.vpns.detailed_ratings IS 'Store detailed ratings like { \\"speed\\": 9.5, \\"privacy\\": 8.0, \\"streaming\\": 9.0 }'","-- Supported Devices (using JSONB for toggle switches)\nALTER TABLE public.vpns ADD COLUMN supported_devices JSONB","COMMENT ON COLUMN public.vpns.supported_devices IS 'Store device support status like { \\"windows\\": true, \\"macos\\": true, \\"linux\\": false }'","-- Pros and Cons\nALTER TABLE public.vpns ADD COLUMN pros TEXT[]","ALTER TABLE public.vpns ADD COLUMN cons TEXT[]","-- Logs & Court Proof\nALTER TABLE public.vpns ADD COLUMN keeps_logs BOOLEAN NOT NULL DEFAULT TRUE","ALTER TABLE public.vpns ADD COLUMN has_court_proof BOOLEAN NOT NULL DEFAULT FALSE","ALTER TABLE public.vpns ADD COLUMN court_proof_content TEXT","-- Features\nALTER TABLE public.vpns ADD COLUMN has_double_vpn BOOLEAN NOT NULL DEFAULT FALSE","-- Location\nALTER TABLE public.vpns ADD COLUMN based_in_country_name TEXT","ALTER TABLE public.vpns ADD COLUMN based_in_country_flag TEXT","-- For emoji or country code\n\n-- Coupon\nALTER TABLE public.vpns ADD COLUMN has_coupon BOOLEAN NOT NULL DEFAULT FALSE","ALTER TABLE public.vpns ADD COLUMN coupon_code TEXT","ALTER TABLE public.vpns ADD COLUMN coupon_validity DATE","-- Visibility\nALTER TABLE public.vpns ADD COLUMN show_on_homepage BOOLEAN NOT NULL DEFAULT FALSE"}	update_vpns_table_with_detailed_fields
20250701044500	{"-- Create the blog_categories table\nCREATE TABLE IF NOT EXISTS blog_categories (\n    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,\n    name TEXT NOT NULL UNIQUE,\n    slug TEXT NOT NULL UNIQUE,\n    description TEXT,\n    created_at TIMESTAMPTZ DEFAULT NOW()\n)","-- Create the blog_posts table\nCREATE TABLE IF NOT EXISTS blog_posts (\n    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,\n    title TEXT NOT NULL,\n    slug TEXT NOT NULL UNIQUE,\n    content TEXT, -- For CKEditor 5 content\n    excerpt TEXT,\n    featured_image_url TEXT,\n    author_id UUID REFERENCES auth.users(id),\n    category_id BIGINT REFERENCES blog_categories(id),\n    \n    -- Social and engagement fields\n    likes_count INT DEFAULT 0,\n    allow_comments BOOLEAN DEFAULT TRUE,\n    \n    -- Affiliate marketing fields\n    show_cta BOOLEAN DEFAULT TRUE,\n    \n    -- SEO fields\n    meta_title TEXT,\n    meta_description TEXT,\n    \n    -- Timestamps\n    created_at TIMESTAMPTZ DEFAULT NOW(),\n    updated_at TIMESTAMPTZ DEFAULT NOW(),\n    published_at TIMESTAMPTZ\n)","-- Add comments to explain the purpose of the tables and columns\nCOMMENT ON TABLE blog_categories IS 'Stores categories for blog posts.'","COMMENT ON TABLE blog_posts IS 'Stores blog posts, including content, social features, and affiliate settings.'","COMMENT ON COLUMN blog_posts.content IS 'HTML content generated by a rich text editor like CKEditor 5.'","COMMENT ON COLUMN blog_posts.show_cta IS 'Controls the visibility of call-to-action components for affiliate links.'","-- Create a trigger to automatically update the updated_at timestamp\nCREATE OR REPLACE FUNCTION handle_blog_post_update()\nRETURNS TRIGGER AS $$\nBEGIN\n    NEW.updated_at = NOW();\n    RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql","CREATE TRIGGER on_blog_post_update\n    BEFORE UPDATE ON blog_posts\n    FOR EACH ROW\n    EXECUTE PROCEDURE handle_blog_post_update()"}	create_blog_tables
20250701044501	{"CREATE TABLE blog_comments (\n    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,\n    post_id BIGINT NOT NULL REFERENCES blog_posts(id) ON DELETE CASCADE,\n    author_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,\n    content TEXT NOT NULL CHECK (char_length(content) > 0),\n    parent_comment_id BIGINT REFERENCES blog_comments(id) ON DELETE CASCADE, -- For threaded comments\n    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,\n    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL\n)","-- Add index for faster comment lookups\nCREATE INDEX ON blog_comments (post_id)","-- RLS Policies for comments\nALTER TABLE blog_comments ENABLE ROW LEVEL SECURITY","-- Allow public read access\nCREATE POLICY \\"Allow public read access to comments\\"\nON blog_comments\nFOR SELECT\nUSING (true)","-- Allow authenticated users to insert comments\nCREATE POLICY \\"Allow authenticated users to insert comments\\"\nON blog_comments\nFOR INSERT\nWITH CHECK (auth.role() = 'authenticated' AND author_id = auth.uid())","-- Allow users to update their own comments\nCREATE POLICY \\"Allow users to update their own comments\\"\nON blog_comments\nFOR UPDATE\nUSING (auth.uid() = author_id)","-- Allow users to delete their own comments\nCREATE POLICY \\"Allow users to delete their own comments\\"\nON blog_comments\nFOR DELETE\nUSING (auth.uid() = author_id)","-- Import the moddatetime extension if it doesn't exist\nCREATE EXTENSION IF NOT EXISTS moddatetime WITH SCHEMA extensions","-- Trigger to update 'updated_at' timestamp\nCREATE TRIGGER handle_updated_at\nBEFORE UPDATE ON blog_comments\nFOR EACH ROW\nEXECUTE PROCEDURE extensions.moddatetime (updated_at)"}	create_comments_table
20250701141400	{"-- Tabela para guardar todos os eventos de visualização de página\nCREATE TABLE public.page_views (\n  id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,\n  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,\n  path TEXT NOT NULL,\n  session_id UUID NOT NULL\n)","-- Ativar Segurança a Nível de Linha (RLS)\nALTER TABLE public.page_views ENABLE ROW LEVEL SECURITY","-- Política para permitir que qualquer visitante (anónimo ou não) insira um registo de visualização.\n-- Isto é seguro porque eles não conseguem ler ou modificar os dados de outros.\nCREATE POLICY \\"Allow public insert\\" ON public.page_views\n  FOR INSERT\n  WITH CHECK (TRUE)","-- Política para permitir que apenas administradores (você) possam ler todos os dados para as estatísticas.\nCREATE POLICY \\"Allow admin read access\\" ON public.page_views\n  FOR SELECT\n  USING (auth.role() = 'service_role')","-- Tabela para guardar todos os eventos de clique em links de afiliados\nCREATE TABLE public.affiliate_clicks (\n  id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,\n  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,\n  vpn_id BIGINT REFERENCES public.vpns(id) ON DELETE SET NULL, -- Usamos SET NULL para não perder o registo do clique se a VPN for apagada\n  session_id UUID NOT NULL\n)","-- Ativar Segurança a Nível de Linha (RLS)\nALTER TABLE public.affiliate_clicks ENABLE ROW LEVEL SECURITY","-- Política para permitir que qualquer visitante insira um registo de clique.\nCREATE POLICY \\"Allow public insert\\" ON public.affiliate_clicks\n  FOR INSERT\n  WITH CHECK (TRUE)","-- Política para permitir que apenas administradores (você) possam ler todos os dados.\nCREATE POLICY \\"Allow admin read access\\" ON public.affiliate_clicks\n  FOR SELECT\n  USING (auth.role() = 'service_role')"}	create_analytics_tables
20250701141500	{"-- As funções são definidas com SECURITY DEFINER para que possam contornar as políticas de RLS\n-- e ler os dados das tabelas de analytics, mesmo quando chamadas por um utilizador com menos privilégios (como 'authenticated').\n-- Isto é seguro porque as funções apenas devolvem contagens agregadas e não os dados brutos.\n\n-- Function to get unique visitors in the last 5 minutes (approximates online users)\nCREATE OR REPLACE FUNCTION get_online_visitors_count()\nRETURNS BIGINT AS $$\nBEGIN\n  RETURN (\n    SELECT COUNT(DISTINCT session_id)\n    FROM public.page_views\n    WHERE created_at > NOW() - INTERVAL '5 minutes'\n  );\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","-- Function to get unique visitors today (since midnight in the current timezone)\nCREATE OR REPLACE FUNCTION get_today_visitors_count()\nRETURNS BIGINT AS $$\nBEGIN\n  RETURN (\n    SELECT COUNT(DISTINCT session_id)\n    FROM public.page_views\n    WHERE created_at >= DATE_TRUNC('day', NOW())\n  );\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","-- Function to get unique visitors this month\nCREATE OR REPLACE FUNCTION get_monthly_visitors_count()\nRETURNS BIGINT AS $$\nBEGIN\n  RETURN (\n    SELECT COUNT(DISTINCT session_id)\n    FROM public.page_views\n    WHERE created_at >= DATE_TRUNC('month', NOW())\n  );\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","-- Function to get unique visitors this year\nCREATE OR REPLACE FUNCTION get_yearly_visitors_count()\nRETURNS BIGINT AS $$\nBEGIN\n  RETURN (\n    SELECT COUNT(DISTINCT session_id)\n    FROM public.page_views\n    WHERE created_at >= DATE_TRUNC('year', NOW())\n  );\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","-- Function to get total affiliate clicks\nCREATE OR REPLACE FUNCTION get_total_affiliate_clicks()\nRETURNS BIGINT AS $$\nBEGIN\n  RETURN (\n    SELECT COUNT(*) FROM public.affiliate_clicks\n  );\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","-- Function to get total blog post views (excluding index and pagination pages)\nCREATE OR REPLACE FUNCTION get_total_blog_post_views()\nRETURNS BIGINT AS $$\nBEGIN\n  RETURN (\n    SELECT COUNT(*)\n    FROM public.page_views\n    WHERE path LIKE '/blog/%' AND path NOT LIKE '/blog/page/%' AND path != '/blog'\n  );\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER"}	create_analytics_functions
20250701152500	{"-- Adiciona a coluna full_review à tabela de VPNs para guardar a análise completa em formato de texto (HTML).\nALTER TABLE public.vpns\nADD COLUMN full_review TEXT"}	add_full_review_to_vpns
20250701164900	{"-- Enable RLS on the tables. It's idempotent, so no harm in running it again.\nALTER TABLE public.blog_posts ENABLE ROW LEVEL SECURITY","ALTER TABLE public.blog_categories ENABLE ROW LEVEL SECURITY","-- Drop existing policies to ensure a clean state, just in case.\nDROP POLICY IF EXISTS \\"Public can read published blog posts\\" ON public.blog_posts","DROP POLICY IF EXISTS \\"Public can read blog categories\\" ON public.blog_categories","-- Create a policy to allow public read access to published posts.\n-- This allows anyone (anon, authenticated) to view posts that have a `published_at` date.\nCREATE POLICY \\"Public can read published blog posts\\"\nON public.blog_posts\nFOR SELECT\nTO anon, authenticated\nUSING (published_at IS NOT NULL)","-- Create a policy to allow public read access to all categories.\nCREATE POLICY \\"Public can read blog categories\\"\nON public.blog_categories\nFOR SELECT\nTO anon, authenticated\nUSING (true)","-- Policies for content management by authenticated users\nCREATE POLICY \\"Allow authenticated to create posts\\" \nON public.blog_posts \nFOR INSERT \nTO authenticated \nWITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Allow authenticated to update posts\\" \nON public.blog_posts \nFOR UPDATE \nTO authenticated \nUSING (auth.role() = 'authenticated') \nWITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Allow authenticated to delete posts\\" \nON public.blog_posts \nFOR DELETE \nTO authenticated \nUSING (auth.role() = 'authenticated')","-- Policies for category management by authenticated users\nCREATE POLICY \\"Allow authenticated to create categories\\" \nON public.blog_categories \nFOR INSERT \nTO authenticated \nWITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Allow authenticated to update categories\\" \nON public.blog_categories \nFOR UPDATE \nTO authenticated \nUSING (auth.role() = 'authenticated') \nWITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Allow authenticated to delete categories\\" \nON public.blog_categories \nFOR DELETE \nTO authenticated \nUSING (auth.role() = 'authenticated')"}	add_rls_policies_for_blog
20250701165500	{"-- 1. Create the profiles table to store public user data\nCREATE TABLE public.profiles (\n  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,\n  full_name TEXT,\n  avatar_url TEXT,\n  updated_at TIMESTAMPTZ DEFAULT NOW()\n)","COMMENT ON TABLE public.profiles IS 'Public profile information for each user.'","-- 2. Set up Row Level Security (RLS) for the profiles table\nALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY","CREATE POLICY \\"Public profiles are viewable by everyone.\\" \nON public.profiles FOR SELECT \nUSING (true)","CREATE POLICY \\"Users can insert their own profile.\\" \nON public.profiles FOR INSERT \nWITH CHECK (auth.uid() = id)","CREATE POLICY \\"Users can update their own profile.\\" \nON public.profiles FOR UPDATE \nUSING (auth.uid() = id)","-- 3. Create a trigger function to automatically create a profile for new users\nCREATE OR REPLACE FUNCTION public.handle_new_user()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER SET search_path = public\nAS $$\nBEGIN\n  INSERT INTO public.profiles (id, full_name, avatar_url)\n  VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'avatar_url');\n  RETURN NEW;\nEND;\n$$","-- 4. Create the trigger that fires after a new user is inserted into auth.users\nCREATE TRIGGER on_auth_user_created\n  AFTER INSERT ON auth.users\n  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user()","-- 5. Modify blog_comments table to reference profiles instead of auth.users\n-- First, drop the old foreign key constraint\nALTER TABLE public.blog_comments DROP CONSTRAINT IF EXISTS blog_comments_author_id_fkey","-- Then, add the new foreign key constraint referencing public.profiles\n-- This ensures comment authors are always valid, public profiles.\nALTER TABLE public.blog_comments\nADD CONSTRAINT blog_comments_author_id_fkey\nFOREIGN KEY (author_id) REFERENCES public.profiles(id) ON DELETE CASCADE"}	create_profiles_and_update_comments
20250701171500	{"-- 1. Add a column to store the guest's name.\nALTER TABLE public.blog_comments\nADD COLUMN guest_name TEXT CHECK (char_length(guest_name) > 0)","COMMENT ON COLUMN public.blog_comments.guest_name IS 'The name of the commenter if they are not a registered user.'","-- 2. Make the author_id nullable to allow for guest comments.\nALTER TABLE public.blog_comments\nALTER COLUMN author_id DROP NOT NULL","-- 3. Update the RLS policy for inserting comments.\n-- Drop the old policy first.\nDROP POLICY IF EXISTS \\"Allow authenticated users to insert comments\\" ON public.blog_comments","DROP POLICY IF EXISTS \\"Allow authenticated and guest comments\\" ON public.blog_comments","-- Create a new, more permissive policy.\nCREATE POLICY \\"Allow authenticated and guest comments\\"\nON public.blog_comments\nFOR INSERT\nWITH CHECK (\n  -- Logged-in users can comment as themselves.\n  (auth.role() = 'authenticated' AND author_id = auth.uid()) OR\n  -- Guests (not logged in) can comment if they provide a name and no author_id.\n  (auth.role() = 'anon' AND author_id IS NULL AND guest_name IS NOT NULL)\n)","-- 4. Add policies for reading, updating, and deleting comments.\nCREATE POLICY \\"Public can read all comments\\"\nON public.blog_comments\nFOR SELECT\nUSING (true)","CREATE POLICY \\"Users can update their own comments\\"\nON public.blog_comments\nFOR UPDATE\nTO authenticated\nUSING (auth.uid() = author_id)\nWITH CHECK (auth.uid() = author_id)","CREATE POLICY \\"Users can delete their own comments\\"\nON public.blog_comments\nFOR DELETE\nTO authenticated\nUSING (auth.uid() = author_id)"}	allow_guest_comments
20250701174800	{"alter table public.vpns\n  add column has_p2p boolean not null default false,\n  add column has_kill_switch boolean not null default false,\n  add column has_ad_blocker boolean not null default false,\n  add column has_split_tunneling boolean not null default false,\n  add column simultaneous_connections integer"}	add_vpn_feature_fields
20250701175800	{"-- Alter the star_rating column to allow values up to 10.0\nALTER TABLE public.vpns\n  ALTER COLUMN star_rating TYPE NUMERIC(3, 1)"}	fix_star_rating_precision
20250701193259	{"-- Create the review_pages table\ncreate table \\"public\\".\\"review_pages\\" (\n    \\"id\\" bigint generated by default as identity not null,\n    \\"created_at\\" timestamp with time zone not null default now(),\n    \\"title\\" text not null,\n    \\"slug\\" text not null,\n    \\"description\\" text,\n    \\"introduction\\" text,\n    \\"conclusion\\" text,\n    \\"vpn_ids\\" integer[]\n)","-- Enable Row Level Security\nalter table \\"public\\".\\"review_pages\\" enable row level security","-- Create indexes and primary key\nCREATE UNIQUE INDEX review_pages_pkey ON public.review_pages USING btree (id)","CREATE UNIQUE INDEX review_pages_slug_key ON public.review_pages USING btree (slug)","alter table \\"public\\".\\"review_pages\\" add constraint \\"review_pages_pkey\\" PRIMARY KEY using index \\"review_pages_pkey\\"","alter table \\"public\\".\\"review_pages\\" add constraint \\"review_pages_slug_key\\" UNIQUE using index \\"review_pages_slug_key\\"","-- Grant permissions\ngrant delete on table \\"public\\".\\"review_pages\\" to \\"anon\\"","grant insert on table \\"public\\".\\"review_pages\\" to \\"anon\\"","grant references on table \\"public\\".\\"review_pages\\" to \\"anon\\"","grant select on table \\"public\\".\\"review_pages\\" to \\"anon\\"","grant trigger on table \\"public\\".\\"review_pages\\" to \\"anon\\"","grant truncate on table \\"public\\".\\"review_pages\\" to \\"anon\\"","grant update on table \\"public\\".\\"review_pages\\" to \\"anon\\"","grant delete on table \\"public\\".\\"review_pages\\" to \\"authenticated\\"","grant insert on table \\"public\\".\\"review_pages\\" to \\"authenticated\\"","grant references on table \\"public\\".\\"review_pages\\" to \\"authenticated\\"","grant select on table \\"public\\".\\"review_pages\\" to \\"authenticated\\"","grant trigger on table \\"public\\".\\"review_pages\\" to \\"authenticated\\"","grant truncate on table \\"public\\".\\"review_pages\\" to \\"authenticated\\"","grant update on table \\"public\\".\\"review_pages\\" to \\"authenticated\\"","grant delete on table \\"public\\".\\"review_pages\\" to \\"service_role\\"","grant insert on table \\"public\\".\\"review_pages\\" to \\"service_role\\"","grant references on table \\"public\\".\\"review_pages\\" to \\"service_role\\"","grant select on table \\"public\\".\\"review_pages\\" to \\"service_role\\"","grant trigger on table \\"public\\".\\"review_pages\\" to \\"service_role\\"","grant truncate on table \\"public\\".\\"review_pages\\" to \\"service_role\\"","grant update on table \\"public\\".\\"review_pages\\" to \\"service_role\\"","-- Create idempotent RLS policies\nDROP POLICY IF EXISTS \\"Allow READ for everyone\\" ON public.review_pages","CREATE POLICY \\"Allow READ for everyone\\" ON public.review_pages FOR SELECT USING (true)","DROP POLICY IF EXISTS \\"Allow INSERT for authenticated users\\" ON public.review_pages","CREATE POLICY \\"Allow INSERT for authenticated users\\" ON public.review_pages FOR INSERT TO authenticated WITH CHECK (auth.role() = 'authenticated')","DROP POLICY IF EXISTS \\"Allow UPDATE for authenticated users\\" ON public.review_pages","CREATE POLICY \\"Allow UPDATE for authenticated users\\" ON public.review_pages FOR UPDATE TO authenticated USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated')","DROP POLICY IF EXISTS \\"Allow DELETE for authenticated users\\" ON public.review_pages","CREATE POLICY \\"Allow DELETE for authenticated users\\" ON public.review_pages FOR DELETE TO authenticated USING (auth.role() = 'authenticated')"}	create_review_pages_and_policies
20250701211500	{"-- 1. Enable Row Level Security on the vpns table\nALTER TABLE public.vpns ENABLE ROW LEVEL SECURITY","-- 2. Add policies for VPN management\n-- Allow public read access to all VPNs\nCREATE POLICY \\"Public can read all vpns\\"\nON public.vpns\nFOR SELECT\nTO anon, authenticated\nUSING (true)","-- Allow admin users to create, update, and delete VPNs\nCREATE POLICY \\"Allow authenticated to create vpns\\"\nON public.vpns\nFOR INSERT\nTO authenticated\nWITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Allow authenticated to update vpns\\"\nON public.vpns\nFOR UPDATE\nTO authenticated\nUSING (auth.role() = 'authenticated')\nWITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Allow authenticated to delete vpns\\"\nON public.vpns\nFOR DELETE\nTO authenticated\nUSING (auth.role() = 'authenticated')"}	add_rls_to_vpns
20250701220941	{"-- Create the 'vpn-assets' bucket if it doesn't exist.\nINSERT INTO storage.buckets (id, name, public)\nVALUES ('vpn-assets', 'vpn-assets', true)\nON CONFLICT (id) DO NOTHING","-- Set up Row Level Security (RLS) policies for the 'vpn-assets' bucket.\n\n-- 1. Allow public, anonymous read access to all objects in the bucket.\nDROP POLICY IF EXISTS \\"Public read access for vpn-assets\\" ON storage.objects","CREATE POLICY \\"Public read access for vpn-assets\\"\n    ON storage.objects FOR SELECT\n    TO anon, authenticated\n    USING (bucket_id = 'vpn-assets')","-- 2. Allow authenticated users to upload (insert) objects.\nDROP POLICY IF EXISTS \\"Authenticated users can insert vpn-assets\\" ON storage.objects","CREATE POLICY \\"Authenticated users can insert vpn-assets\\"\n    ON storage.objects FOR INSERT\n    TO authenticated\n    WITH CHECK (bucket_id = 'vpn-assets')","-- 3. Allow authenticated users to update objects.\nDROP POLICY IF EXISTS \\"Authenticated users can update vpn-assets\\" ON storage.objects","CREATE POLICY \\"Authenticated users can update vpn-assets\\"\n    ON storage.objects FOR UPDATE\n    TO authenticated\n    USING (bucket_id = 'vpn-assets')","-- 4. Allow authenticated users to delete objects.\nDROP POLICY IF EXISTS \\"Authenticated users can delete vpn-assets\\" ON storage.objects","CREATE POLICY \\"Authenticated users can delete vpn-assets\\"\n    ON storage.objects FOR DELETE\n    TO authenticated\n    USING (bucket_id = 'vpn-assets')"}	create_vpn_assets_bucket
20250701234800	{"ALTER TABLE public.vpns\nADD COLUMN IF NOT EXISTS server_count INTEGER DEFAULT 0,\nADD COLUMN IF NOT EXISTS country_count INTEGER DEFAULT 0","-- Reset the RLS policies for the vpns table to apply changes\nDROP POLICY IF EXISTS \\"Enable read access for all users\\" ON public.vpns","CREATE POLICY \\"Enable read access for all users\\" ON public.vpns\nAS PERMISSIVE FOR SELECT\nTO public\nUSING (true)","DROP POLICY IF EXISTS \\"Allow authorized users to insert\\" ON public.vpns","CREATE POLICY \\"Allow authorized users to insert\\" ON public.vpns\nAS PERMISSIVE FOR INSERT\nTO authenticated\nWITH CHECK (true)","DROP POLICY IF EXISTS \\"Allow authorized users to update\\" ON public.vpns","CREATE POLICY \\"Allow authorized users to update\\" ON public.vpns\nAS PERMISSIVE FOR UPDATE\nTO authenticated\nUSING (true)\nWITH CHECK (true)","DROP POLICY IF EXISTS \\"Allow authorized users to delete\\" ON public.vpns","CREATE POLICY \\"Allow authorized users to delete\\" ON public.vpns\nAS PERMISSIVE FOR DELETE\nTO authenticated\nUSING (true)"}	add_server_and_country_counts_to_vpns
20250702012000	{"-- Generated by Cascade to optimize RLS policies based on Supabase Performance Advisor\n\n-- Step 1: Clean up duplicate policies on 'blog_comments'\nDROP POLICY IF EXISTS \\"Users can delete their own comments\\" ON public.blog_comments","DROP POLICY IF EXISTS \\"Users can update their own comments\\" ON public.blog_comments","DROP POLICY IF EXISTS \\"Public can read all comments\\" ON public.blog_comments","-- Step 2: Clean up duplicate policies on 'vpns'\nDROP POLICY IF EXISTS \\"Public can read all vpns\\" ON public.vpns","DROP POLICY IF EXISTS \\"Allow authorized users to delete\\" ON public.vpns","DROP POLICY IF EXISTS \\"Allow authorized users to insert\\" ON public.vpns","DROP POLICY IF EXISTS \\"Allow authorized users to update\\" ON public.vpns","-- Step 3: Re-create and optimize all policies flagged by the advisor.\n\n-- == Table: public.blog_comments ==\n-- Drop old policies before recreating them optimized\nDROP POLICY IF EXISTS \\"Allow users to update their own comments\\" ON public.blog_comments","DROP POLICY IF EXISTS \\"Allow users to delete their own comments\\" ON public.blog_comments","DROP POLICY IF EXISTS \\"Allow authenticated and guest comments\\" ON public.blog_comments","DROP POLICY IF EXISTS \\"Allow public read access to comments\\" ON public.blog_comments","-- Create optimized policies for blog_comments\nCREATE POLICY \\"Allow public read access to comments\\" ON public.blog_comments FOR SELECT USING (true)","CREATE POLICY \\"Allow authenticated and guest comments\\" ON public.blog_comments FOR INSERT WITH CHECK ((select auth.uid()) IS NOT NULL)","CREATE POLICY \\"Allow users to update their own comments\\" ON public.blog_comments FOR UPDATE USING (((select auth.uid()) = author_id)) WITH CHECK (((select auth.uid()) = author_id))","CREATE POLICY \\"Allow users to delete their own comments\\" ON public.blog_comments FOR DELETE USING (((select auth.uid()) = author_id))","-- == Table: public.page_views ==\nDROP POLICY IF EXISTS \\"Allow admin read access\\" ON public.page_views","CREATE POLICY \\"Allow admin read access\\" ON public.page_views FOR SELECT USING (((select auth.role()) = 'authenticated'::text))","-- == Table: public.affiliate_clicks ==\nDROP POLICY IF EXISTS \\"Allow admin read access\\" ON public.affiliate_clicks","CREATE POLICY \\"Allow admin read access\\" ON public.affiliate_clicks FOR SELECT USING (((select auth.role()) = 'authenticated'::text))","-- == Table: public.blog_posts ==\nDROP POLICY IF EXISTS \\"Allow authenticated to create posts\\" ON public.blog_posts","DROP POLICY IF EXISTS \\"Allow authenticated to update posts\\" ON public.blog_posts","DROP POLICY IF EXISTS \\"Allow authenticated to delete posts\\" ON public.blog_posts","CREATE POLICY \\"Allow authenticated to create posts\\" ON public.blog_posts FOR INSERT WITH CHECK (((select auth.role()) = 'authenticated'::text))","CREATE POLICY \\"Allow authenticated to update posts\\" ON public.blog_posts FOR UPDATE USING (((select auth.uid()) = author_id)) WITH CHECK (((select auth.uid()) = author_id))","CREATE POLICY \\"Allow authenticated to delete posts\\" ON public.blog_posts FOR DELETE USING (((select auth.uid()) = author_id))","-- == Table: public.blog_categories ==\nDROP POLICY IF EXISTS \\"Allow authenticated to create categories\\" ON public.blog_categories","DROP POLICY IF EXISTS \\"Allow authenticated to update categories\\" ON public.blog_categories","DROP POLICY IF EXISTS \\"Allow authenticated to delete categories\\" ON public.blog_categories","CREATE POLICY \\"Allow authenticated to create categories\\" ON public.blog_categories FOR INSERT WITH CHECK (((select auth.role()) = 'authenticated'::text))","CREATE POLICY \\"Allow authenticated to update categories\\" ON public.blog_categories FOR UPDATE USING (((select auth.role()) = 'authenticated'::text)) WITH CHECK (((select auth.role()) = 'authenticated'::text))","CREATE POLICY \\"Allow authenticated to delete categories\\" ON public.blog_categories FOR DELETE USING (((select auth.role()) = 'authenticated'::text))","-- == Table: public.profiles ==\nDROP POLICY IF EXISTS \\"Users can insert their own profile.\\" ON public.profiles","DROP POLICY IF EXISTS \\"Users can update their own profile.\\" ON public.profiles","CREATE POLICY \\"Users can insert their own profile.\\" ON public.profiles FOR INSERT WITH CHECK ( (select auth.uid()) = id )","CREATE POLICY \\"Users can update their own profile.\\" ON public.profiles FOR UPDATE USING ( (select auth.uid()) = id ) WITH CHECK ( (select auth.uid()) = id )","-- == Table: public.review_pages ==\nDROP POLICY IF EXISTS \\"Allow INSERT for authenticated users\\" ON public.review_pages","DROP POLICY IF EXISTS \\"Allow UPDATE for authenticated users\\" ON public.review_pages","DROP POLICY IF EXISTS \\"Allow DELETE for authenticated users\\" ON public.review_pages","CREATE POLICY \\"Allow INSERT for authenticated users\\" ON public.review_pages FOR INSERT WITH CHECK (((select auth.role()) = 'authenticated'::text))","CREATE POLICY \\"Allow UPDATE for authenticated users\\" ON public.review_pages FOR UPDATE USING (((select auth.role()) = 'authenticated'::text)) WITH CHECK (((select auth.role()) = 'authenticated'::text))","CREATE POLICY \\"Allow DELETE for authenticated users\\" ON public.review_pages FOR DELETE USING (((select auth.role()) = 'authenticated'::text))","-- == Table: public.vpns ==\n-- Drop old policies before recreating them optimized\nDROP POLICY IF EXISTS \\"Allow authenticated to create vpns\\" ON public.vpns","DROP POLICY IF EXISTS \\"Allow authenticated to update vpns\\" ON public.vpns","DROP POLICY IF EXISTS \\"Allow authenticated to delete vpns\\" ON public.vpns","DROP POLICY IF EXISTS \\"Enable read access for all users\\" ON public.vpns","-- Create optimized policies for vpns\nCREATE POLICY \\"Enable read access for all users\\" ON public.vpns FOR SELECT USING (true)","CREATE POLICY \\"Allow authenticated to create vpns\\" ON public.vpns FOR INSERT WITH CHECK (((select auth.role()) = 'authenticated'::text))","CREATE POLICY \\"Allow authenticated to update vpns\\" ON public.vpns FOR UPDATE USING (((select auth.role()) = 'authenticated'::text)) WITH CHECK (((select auth.role()) = 'authenticated'::text))","CREATE POLICY \\"Allow authenticated to delete vpns\\" ON public.vpns FOR DELETE USING (((select auth.role()) = 'authenticated'::text))"}	optimize_rls_policies
20250702040000	{"-- Recreates 8 functions with a secure, empty search_path to resolve the\n-- \\"Function Search Path Mutable\\" linter warning from Supabase.\n-- This approach is required by the linter, which expects the search_path\n-- to be set in the function's definition rather than via ALTER FUNCTION.\n\n-- From migration 20250701141500_create_analytics_functions.sql\nCREATE OR REPLACE FUNCTION public.get_online_visitors_count()\nRETURNS BIGINT\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = ''\nAS $$\nBEGIN\n  RETURN (\n    SELECT COUNT(DISTINCT session_id)\n    FROM public.page_views\n    WHERE created_at > NOW() - INTERVAL '5 minutes'\n  );\nEND;\n$$","CREATE OR REPLACE FUNCTION public.get_today_visitors_count()\nRETURNS BIGINT\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = ''\nAS $$\nBEGIN\n  RETURN (\n    SELECT COUNT(DISTINCT session_id)\n    FROM public.page_views\n    WHERE created_at >= DATE_TRUNC('day', NOW())\n  );\nEND;\n$$","CREATE OR REPLACE FUNCTION public.get_monthly_visitors_count()\nRETURNS BIGINT\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = ''\nAS $$\nBEGIN\n  RETURN (\n    SELECT COUNT(DISTINCT session_id)\n    FROM public.page_views\n    WHERE created_at >= DATE_TRUNC('month', NOW())\n  );\nEND;\n$$","CREATE OR REPLACE FUNCTION public.get_yearly_visitors_count()\nRETURNS BIGINT\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = ''\nAS $$\nBEGIN\n  RETURN (\n    SELECT COUNT(DISTINCT session_id)\n    FROM public.page_views\n    WHERE created_at >= DATE_TRUNC('year', NOW())\n  );\nEND;\n$$","CREATE OR REPLACE FUNCTION public.get_total_affiliate_clicks()\nRETURNS BIGINT\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = ''\nAS $$\nBEGIN\n  RETURN (\n    SELECT COUNT(*) FROM public.affiliate_clicks\n  );\nEND;\n$$","CREATE OR REPLACE FUNCTION public.get_total_blog_post_views()\nRETURNS BIGINT\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = ''\nAS $$\nBEGIN\n  RETURN (\n    SELECT COUNT(*)\n    FROM public.page_views\n    WHERE path LIKE '/blog/%' AND path NOT LIKE '/blog/page/%' AND path != '/blog'\n  );\nEND;\n$$","-- From migration 20250701044500_create_blog_tables.sql\nCREATE OR REPLACE FUNCTION public.handle_blog_post_update()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSET search_path = ''\nAS $$\nBEGIN\n    NEW.updated_at = NOW();\n    RETURN NEW;\nEND;\n$$","-- From migration 20250701165500_create_profiles_and_update_comments.sql\nCREATE OR REPLACE FUNCTION public.handle_new_user()\nRETURNS TRIGGER\nLANGUAGE plpgsql\nSECURITY DEFINER\nSET search_path = ''\nAS $$\nBEGIN\n  INSERT INTO public.profiles (id, full_name, avatar_url)\n  VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'avatar_url');\n  RETURN NEW;\nEND;\n$$"}	recreate_functions_with_secure_search_path
20250702050210	{"-- Criação da tabela site_settings para configurações globais do site\n-- Estrutura simples: uma linha única, campos explícitos para cada setting\n\n-- Só permite uma linha, com id fixo\ncreate table if not exists site_settings (\n    id uuid primary key default '00000000-0000-0000-0000-000000000001',\n    site_name text not null,\n    site_tagline text,\n    site_url text not null,\n    contact_email text,\n    default_title text,\n    default_description text,\n    default_keywords text,\n    analytics_id text,\n    logo_url text,\n    favicon_url text,\n    updated_at timestamptz default now(),\n    constraint only_one_row check (id = '00000000-0000-0000-0000-000000000001')\n)","insert into site_settings (id, site_name, site_url)\nvalues ('00000000-0000-0000-0000-000000000001', 'AstroVPN', 'https://astrovpn.com')\non conflict (id) do nothing"}	site_settings
20250702154624	{"create or replace function get_populated_review_page(page_slug text)\nreturns jsonb\nlanguage plpgsql\nas $$\ndeclare\n    page_record review_pages;\n    vpns_jsonb jsonb;\nbegin\n    -- Fetch the review page\n    select * into page_record from review_pages where slug = page_slug;\n\n    if not found then\n        return null;\n    end if;\n\n    -- Fetch and order the associated VPNs\n    select jsonb_agg(v_row)\n    into vpns_jsonb\n    from (\n        select v.*\n        from vpns v\n        join unnest(page_record.vpn_ids) with ordinality as u(vpn_id, ord) on v.id = u.vpn_id\n        order by u.ord\n    ) as v_row;\n\n    -- Combine the page data with the VPNs data\n    return to_jsonb(page_record) || jsonb_build_object('vpns', coalesce(vpns_jsonb, '[]'::jsonb));\nend;\n$$"}	create_get_populated_review_page
20250702160000	{"-- Drop the old, inefficient function\nDROP FUNCTION IF EXISTS get_populated_review_page(text)","-- Create the new, optimized function\nCREATE OR REPLACE FUNCTION get_review_page_details(page_slug text)\nRETURNS jsonb\nLANGUAGE plpgsql\nAS $$\nDECLARE\n    page_record record;\n    vpns_jsonb jsonb;\nBEGIN\n    -- Fetch the review page fields we actually need\n    SELECT slug, title, introduction, conclusion, vpn_ids INTO page_record FROM review_pages WHERE slug = page_slug;\n\n    IF NOT FOUND THEN\n        RETURN NULL;\n    END IF;\n\n    -- Fetch and order only the necessary VPN fields\n    SELECT jsonb_agg(v_row)\n    INTO vpns_jsonb\n    FROM (\n        SELECT \n            v.id, v.name, v.slug, v.logo_url, v.star_rating, v.affiliate_link, \n            v.pros, v.cons, v.based_in_country_name, v.full_review, v.price_monthly_usd\n        FROM vpns v\n        JOIN unnest(page_record.vpn_ids) WITH ORDINALITY AS u(vpn_id, ord) ON v.id = u.vpn_id\n        ORDER BY u.ord\n    ) AS v_row;\n\n    -- Combine the page data with the VPNs data\n    RETURN to_jsonb(page_record) || jsonb_build_object('vpns', COALESCE(vpns_jsonb, '[]'::jsonb));\nEND;\n$$"}	optimize_get_populated_review_page
\.


--
-- Data for Name: seed_files; Type: TABLE DATA; Schema: supabase_migrations; Owner: postgres
--

COPY supabase_migrations.seed_files (path, hash) FROM stdin;
supabase/seed.sql	68f9c21b5c19f960149846992ed946a752a3e3e30d92d309c5daecdcbd7c5b26
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 15, true);


--
-- Name: affiliate_clicks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.affiliate_clicks_id_seq', 1, false);


--
-- Name: blog_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.blog_categories_id_seq', 3, true);


--
-- Name: blog_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.blog_comments_id_seq', 1, false);


--
-- Name: blog_posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.blog_posts_id_seq', 2, true);


--
-- Name: page_views_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.page_views_id_seq', 211, true);


--
-- Name: review_pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.review_pages_id_seq', 1, true);


--
-- Name: vpns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vpns_id_seq', 3, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: hooks_id_seq; Type: SEQUENCE SET; Schema: supabase_functions; Owner: supabase_functions_admin
--

SELECT pg_catalog.setval('supabase_functions.hooks_id_seq', 1, false);


--
-- Name: extensions extensions_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: affiliate_clicks affiliate_clicks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.affiliate_clicks
    ADD CONSTRAINT affiliate_clicks_pkey PRIMARY KEY (id);


--
-- Name: blog_categories blog_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog_categories
    ADD CONSTRAINT blog_categories_name_key UNIQUE (name);


--
-- Name: blog_categories blog_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog_categories
    ADD CONSTRAINT blog_categories_pkey PRIMARY KEY (id);


--
-- Name: blog_categories blog_categories_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog_categories
    ADD CONSTRAINT blog_categories_slug_key UNIQUE (slug);


--
-- Name: blog_comments blog_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog_comments
    ADD CONSTRAINT blog_comments_pkey PRIMARY KEY (id);


--
-- Name: blog_posts blog_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog_posts
    ADD CONSTRAINT blog_posts_pkey PRIMARY KEY (id);


--
-- Name: blog_posts blog_posts_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog_posts
    ADD CONSTRAINT blog_posts_slug_key UNIQUE (slug);


--
-- Name: page_views page_views_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page_views
    ADD CONSTRAINT page_views_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: review_pages review_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_pages
    ADD CONSTRAINT review_pages_pkey PRIMARY KEY (id);


--
-- Name: review_pages review_pages_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_pages
    ADD CONSTRAINT review_pages_slug_key UNIQUE (slug);


--
-- Name: site_settings site_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site_settings
    ADD CONSTRAINT site_settings_pkey PRIMARY KEY (id);


--
-- Name: vpns vpns_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vpns
    ADD CONSTRAINT vpns_pkey PRIMARY KEY (id);


--
-- Name: vpns vpns_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vpns
    ADD CONSTRAINT vpns_slug_key UNIQUE (slug);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_07_01 messages_2025_07_01_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_07_01
    ADD CONSTRAINT messages_2025_07_01_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_07_02 messages_2025_07_02_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_07_02
    ADD CONSTRAINT messages_2025_07_02_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_07_03 messages_2025_07_03_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_07_03
    ADD CONSTRAINT messages_2025_07_03_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_07_04 messages_2025_07_04_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_07_04
    ADD CONSTRAINT messages_2025_07_04_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_07_05 messages_2025_07_05_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_07_05
    ADD CONSTRAINT messages_2025_07_05_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: prefixes prefixes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (bucket_id, level, name);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: hooks hooks_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks
    ADD CONSTRAINT hooks_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (version);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: postgres
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: seed_files seed_files_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: postgres
--

ALTER TABLE ONLY supabase_migrations.seed_files
    ADD CONSTRAINT seed_files_pkey PRIMARY KEY (path);


--
-- Name: extensions_tenant_external_id_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE INDEX extensions_tenant_external_id_index ON _realtime.extensions USING btree (tenant_external_id);


--
-- Name: extensions_tenant_external_id_type_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX extensions_tenant_external_id_type_index ON _realtime.extensions USING btree (tenant_external_id, type);


--
-- Name: tenants_external_id_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX tenants_external_id_index ON _realtime.tenants USING btree (external_id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: blog_comments_post_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX blog_comments_post_id_idx ON public.blog_comments USING btree (post_id);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_name_bucket_level_unique; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_name_bucket_level_unique ON storage.objects USING btree (name COLLATE "C", bucket_id, level);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_lower_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_lower_name ON storage.objects USING btree ((path_tokens[level]), lower(name) text_pattern_ops, bucket_id, level);


--
-- Name: idx_prefixes_lower_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_prefixes_lower_name ON storage.prefixes USING btree (bucket_id, level, ((string_to_array(name, '/'::text))[level]), lower(name) text_pattern_ops);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: objects_bucket_id_level_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX objects_bucket_id_level_idx ON storage.objects USING btree (bucket_id, level, name COLLATE "C");


--
-- Name: supabase_functions_hooks_h_table_id_h_name_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_h_table_id_h_name_idx ON supabase_functions.hooks USING btree (hook_table_id, hook_name);


--
-- Name: supabase_functions_hooks_request_id_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_request_id_idx ON supabase_functions.hooks USING btree (request_id);


--
-- Name: messages_2025_07_01_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_07_01_pkey;


--
-- Name: messages_2025_07_02_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_07_02_pkey;


--
-- Name: messages_2025_07_03_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_07_03_pkey;


--
-- Name: messages_2025_07_04_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_07_04_pkey;


--
-- Name: messages_2025_07_05_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_07_05_pkey;


--
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- Name: blog_comments handle_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public.blog_comments FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime('updated_at');


--
-- Name: blog_posts on_blog_post_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_blog_post_update BEFORE UPDATE ON public.blog_posts FOR EACH ROW EXECUTE FUNCTION public.handle_blog_post_update();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: objects objects_delete_delete_prefix; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_delete_delete_prefix AFTER DELETE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- Name: objects objects_insert_create_prefix; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_insert_create_prefix BEFORE INSERT ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.objects_insert_prefix_trigger();


--
-- Name: objects objects_update_create_prefix; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_update_create_prefix BEFORE UPDATE ON storage.objects FOR EACH ROW WHEN (((new.name <> old.name) OR (new.bucket_id <> old.bucket_id))) EXECUTE FUNCTION storage.objects_update_prefix_trigger();


--
-- Name: prefixes prefixes_create_hierarchy; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER prefixes_create_hierarchy BEFORE INSERT ON storage.prefixes FOR EACH ROW WHEN ((pg_trigger_depth() < 1)) EXECUTE FUNCTION storage.prefixes_insert_trigger();


--
-- Name: prefixes prefixes_delete_hierarchy; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER prefixes_delete_hierarchy AFTER DELETE ON storage.prefixes FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: extensions extensions_tenant_external_id_fkey; Type: FK CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_tenant_external_id_fkey FOREIGN KEY (tenant_external_id) REFERENCES _realtime.tenants(external_id) ON DELETE CASCADE;


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: affiliate_clicks affiliate_clicks_vpn_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.affiliate_clicks
    ADD CONSTRAINT affiliate_clicks_vpn_id_fkey FOREIGN KEY (vpn_id) REFERENCES public.vpns(id) ON DELETE SET NULL;


--
-- Name: blog_comments blog_comments_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog_comments
    ADD CONSTRAINT blog_comments_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: blog_comments blog_comments_parent_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog_comments
    ADD CONSTRAINT blog_comments_parent_comment_id_fkey FOREIGN KEY (parent_comment_id) REFERENCES public.blog_comments(id) ON DELETE CASCADE;


--
-- Name: blog_comments blog_comments_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog_comments
    ADD CONSTRAINT blog_comments_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.blog_posts(id) ON DELETE CASCADE;


--
-- Name: blog_posts blog_posts_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog_posts
    ADD CONSTRAINT blog_posts_author_id_fkey FOREIGN KEY (author_id) REFERENCES auth.users(id);


--
-- Name: blog_posts blog_posts_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blog_posts
    ADD CONSTRAINT blog_posts_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.blog_categories(id);


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: prefixes prefixes_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT "prefixes_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: review_pages Allow DELETE for authenticated users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow DELETE for authenticated users" ON public.review_pages FOR DELETE USING ((( SELECT auth.role() AS role) = 'authenticated'::text));


--
-- Name: review_pages Allow INSERT for authenticated users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow INSERT for authenticated users" ON public.review_pages FOR INSERT WITH CHECK ((( SELECT auth.role() AS role) = 'authenticated'::text));


--
-- Name: review_pages Allow READ for everyone; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow READ for everyone" ON public.review_pages FOR SELECT USING (true);


--
-- Name: review_pages Allow UPDATE for authenticated users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow UPDATE for authenticated users" ON public.review_pages FOR UPDATE USING ((( SELECT auth.role() AS role) = 'authenticated'::text)) WITH CHECK ((( SELECT auth.role() AS role) = 'authenticated'::text));


--
-- Name: affiliate_clicks Allow admin read access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow admin read access" ON public.affiliate_clicks FOR SELECT USING ((( SELECT auth.role() AS role) = 'authenticated'::text));


--
-- Name: page_views Allow admin read access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow admin read access" ON public.page_views FOR SELECT USING ((( SELECT auth.role() AS role) = 'authenticated'::text));


--
-- Name: blog_comments Allow authenticated and guest comments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated and guest comments" ON public.blog_comments FOR INSERT WITH CHECK ((( SELECT auth.uid() AS uid) IS NOT NULL));


--
-- Name: blog_categories Allow authenticated to create categories; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated to create categories" ON public.blog_categories FOR INSERT WITH CHECK ((( SELECT auth.role() AS role) = 'authenticated'::text));


--
-- Name: blog_posts Allow authenticated to create posts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated to create posts" ON public.blog_posts FOR INSERT WITH CHECK ((( SELECT auth.role() AS role) = 'authenticated'::text));


--
-- Name: vpns Allow authenticated to create vpns; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated to create vpns" ON public.vpns FOR INSERT WITH CHECK ((( SELECT auth.role() AS role) = 'authenticated'::text));


--
-- Name: blog_categories Allow authenticated to delete categories; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated to delete categories" ON public.blog_categories FOR DELETE USING ((( SELECT auth.role() AS role) = 'authenticated'::text));


--
-- Name: blog_posts Allow authenticated to delete posts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated to delete posts" ON public.blog_posts FOR DELETE USING ((( SELECT auth.uid() AS uid) = author_id));


--
-- Name: vpns Allow authenticated to delete vpns; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated to delete vpns" ON public.vpns FOR DELETE USING ((( SELECT auth.role() AS role) = 'authenticated'::text));


--
-- Name: blog_categories Allow authenticated to update categories; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated to update categories" ON public.blog_categories FOR UPDATE USING ((( SELECT auth.role() AS role) = 'authenticated'::text)) WITH CHECK ((( SELECT auth.role() AS role) = 'authenticated'::text));


--
-- Name: blog_posts Allow authenticated to update posts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated to update posts" ON public.blog_posts FOR UPDATE USING ((( SELECT auth.uid() AS uid) = author_id)) WITH CHECK ((( SELECT auth.uid() AS uid) = author_id));


--
-- Name: vpns Allow authenticated to update vpns; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated to update vpns" ON public.vpns FOR UPDATE USING ((( SELECT auth.role() AS role) = 'authenticated'::text)) WITH CHECK ((( SELECT auth.role() AS role) = 'authenticated'::text));


--
-- Name: affiliate_clicks Allow public insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow public insert" ON public.affiliate_clicks FOR INSERT WITH CHECK (true);


--
-- Name: page_views Allow public insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow public insert" ON public.page_views FOR INSERT WITH CHECK (true);


--
-- Name: blog_comments Allow public read access to comments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow public read access to comments" ON public.blog_comments FOR SELECT USING (true);


--
-- Name: blog_comments Allow users to delete their own comments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow users to delete their own comments" ON public.blog_comments FOR DELETE USING ((( SELECT auth.uid() AS uid) = author_id));


--
-- Name: blog_comments Allow users to update their own comments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow users to update their own comments" ON public.blog_comments FOR UPDATE USING ((( SELECT auth.uid() AS uid) = author_id)) WITH CHECK ((( SELECT auth.uid() AS uid) = author_id));


--
-- Name: vpns Enable read access for all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all users" ON public.vpns FOR SELECT USING (true);


--
-- Name: blog_categories Public can read blog categories; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Public can read blog categories" ON public.blog_categories FOR SELECT TO authenticated, anon USING (true);


--
-- Name: blog_posts Public can read published blog posts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Public can read published blog posts" ON public.blog_posts FOR SELECT TO authenticated, anon USING ((published_at IS NOT NULL));


--
-- Name: profiles Public profiles are viewable by everyone.; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Public profiles are viewable by everyone." ON public.profiles FOR SELECT USING (true);


--
-- Name: profiles Users can insert their own profile.; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own profile." ON public.profiles FOR INSERT WITH CHECK ((( SELECT auth.uid() AS uid) = id));


--
-- Name: profiles Users can update their own profile.; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update their own profile." ON public.profiles FOR UPDATE USING ((( SELECT auth.uid() AS uid) = id)) WITH CHECK ((( SELECT auth.uid() AS uid) = id));


--
-- Name: affiliate_clicks; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.affiliate_clicks ENABLE ROW LEVEL SECURITY;

--
-- Name: blog_categories; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.blog_categories ENABLE ROW LEVEL SECURITY;

--
-- Name: blog_comments; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.blog_comments ENABLE ROW LEVEL SECURITY;

--
-- Name: blog_posts; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.blog_posts ENABLE ROW LEVEL SECURITY;

--
-- Name: page_views; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.page_views ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: review_pages; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.review_pages ENABLE ROW LEVEL SECURITY;

--
-- Name: vpns; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.vpns ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: objects Authenticated users can delete vpn-assets; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Authenticated users can delete vpn-assets" ON storage.objects FOR DELETE TO authenticated USING ((bucket_id = 'vpn-assets'::text));


--
-- Name: objects Authenticated users can insert vpn-assets; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Authenticated users can insert vpn-assets" ON storage.objects FOR INSERT TO authenticated WITH CHECK ((bucket_id = 'vpn-assets'::text));


--
-- Name: objects Authenticated users can update vpn-assets; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Authenticated users can update vpn-assets" ON storage.objects FOR UPDATE TO authenticated USING ((bucket_id = 'vpn-assets'::text));


--
-- Name: objects Public read access for vpn-assets; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Public read access for vpn-assets" ON storage.objects FOR SELECT TO authenticated, anon USING ((bucket_id = 'vpn-assets'::text));


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: prefixes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.prefixes ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA net; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA net TO supabase_functions_admin;
GRANT USAGE ON SCHEMA net TO postgres;
GRANT USAGE ON SCHEMA net TO anon;
GRANT USAGE ON SCHEMA net TO authenticated;
GRANT USAGE ON SCHEMA net TO service_role;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA supabase_functions; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA supabase_functions TO postgres;
GRANT USAGE ON SCHEMA supabase_functions TO anon;
GRANT USAGE ON SCHEMA supabase_functions TO authenticated;
GRANT USAGE ON SCHEMA supabase_functions TO service_role;
GRANT ALL ON SCHEMA supabase_functions TO supabase_functions_admin;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION moddatetime(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.moddatetime() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer); Type: ACL; Schema: net; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO postgres;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO anon;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO authenticated;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO service_role;


--
-- Name: FUNCTION http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer); Type: ACL; Schema: net; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO postgres;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO anon;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO authenticated;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO postgres;


--
-- Name: FUNCTION get_monthly_visitors_count(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_monthly_visitors_count() TO anon;
GRANT ALL ON FUNCTION public.get_monthly_visitors_count() TO authenticated;
GRANT ALL ON FUNCTION public.get_monthly_visitors_count() TO service_role;


--
-- Name: FUNCTION get_online_visitors_count(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_online_visitors_count() TO anon;
GRANT ALL ON FUNCTION public.get_online_visitors_count() TO authenticated;
GRANT ALL ON FUNCTION public.get_online_visitors_count() TO service_role;


--
-- Name: FUNCTION get_review_page_details(page_slug text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_review_page_details(page_slug text) TO anon;
GRANT ALL ON FUNCTION public.get_review_page_details(page_slug text) TO authenticated;
GRANT ALL ON FUNCTION public.get_review_page_details(page_slug text) TO service_role;


--
-- Name: FUNCTION get_today_visitors_count(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_today_visitors_count() TO anon;
GRANT ALL ON FUNCTION public.get_today_visitors_count() TO authenticated;
GRANT ALL ON FUNCTION public.get_today_visitors_count() TO service_role;


--
-- Name: FUNCTION get_total_affiliate_clicks(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_total_affiliate_clicks() TO anon;
GRANT ALL ON FUNCTION public.get_total_affiliate_clicks() TO authenticated;
GRANT ALL ON FUNCTION public.get_total_affiliate_clicks() TO service_role;


--
-- Name: FUNCTION get_total_blog_post_views(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_total_blog_post_views() TO anon;
GRANT ALL ON FUNCTION public.get_total_blog_post_views() TO authenticated;
GRANT ALL ON FUNCTION public.get_total_blog_post_views() TO service_role;


--
-- Name: FUNCTION get_yearly_visitors_count(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_yearly_visitors_count() TO anon;
GRANT ALL ON FUNCTION public.get_yearly_visitors_count() TO authenticated;
GRANT ALL ON FUNCTION public.get_yearly_visitors_count() TO service_role;


--
-- Name: FUNCTION handle_blog_post_update(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.handle_blog_post_update() TO anon;
GRANT ALL ON FUNCTION public.handle_blog_post_update() TO authenticated;
GRANT ALL ON FUNCTION public.handle_blog_post_update() TO service_role;


--
-- Name: FUNCTION handle_new_user(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.handle_new_user() TO anon;
GRANT ALL ON FUNCTION public.handle_new_user() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_user() TO service_role;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION http_request(); Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

REVOKE ALL ON FUNCTION supabase_functions.http_request() FROM PUBLIC;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO postgres;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO anon;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO authenticated;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO service_role;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;


--
-- Name: TABLE affiliate_clicks; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.affiliate_clicks TO anon;
GRANT ALL ON TABLE public.affiliate_clicks TO authenticated;
GRANT ALL ON TABLE public.affiliate_clicks TO service_role;


--
-- Name: SEQUENCE affiliate_clicks_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.affiliate_clicks_id_seq TO anon;
GRANT ALL ON SEQUENCE public.affiliate_clicks_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.affiliate_clicks_id_seq TO service_role;


--
-- Name: TABLE blog_categories; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.blog_categories TO anon;
GRANT ALL ON TABLE public.blog_categories TO authenticated;
GRANT ALL ON TABLE public.blog_categories TO service_role;


--
-- Name: SEQUENCE blog_categories_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.blog_categories_id_seq TO anon;
GRANT ALL ON SEQUENCE public.blog_categories_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.blog_categories_id_seq TO service_role;


--
-- Name: TABLE blog_comments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.blog_comments TO anon;
GRANT ALL ON TABLE public.blog_comments TO authenticated;
GRANT ALL ON TABLE public.blog_comments TO service_role;


--
-- Name: SEQUENCE blog_comments_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.blog_comments_id_seq TO anon;
GRANT ALL ON SEQUENCE public.blog_comments_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.blog_comments_id_seq TO service_role;


--
-- Name: TABLE blog_posts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.blog_posts TO anon;
GRANT ALL ON TABLE public.blog_posts TO authenticated;
GRANT ALL ON TABLE public.blog_posts TO service_role;


--
-- Name: SEQUENCE blog_posts_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.blog_posts_id_seq TO anon;
GRANT ALL ON SEQUENCE public.blog_posts_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.blog_posts_id_seq TO service_role;


--
-- Name: TABLE page_views; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.page_views TO anon;
GRANT ALL ON TABLE public.page_views TO authenticated;
GRANT ALL ON TABLE public.page_views TO service_role;


--
-- Name: SEQUENCE page_views_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.page_views_id_seq TO anon;
GRANT ALL ON SEQUENCE public.page_views_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.page_views_id_seq TO service_role;


--
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


--
-- Name: TABLE review_pages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.review_pages TO anon;
GRANT ALL ON TABLE public.review_pages TO authenticated;
GRANT ALL ON TABLE public.review_pages TO service_role;


--
-- Name: SEQUENCE review_pages_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.review_pages_id_seq TO anon;
GRANT ALL ON SEQUENCE public.review_pages_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.review_pages_id_seq TO service_role;


--
-- Name: TABLE site_settings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.site_settings TO anon;
GRANT ALL ON TABLE public.site_settings TO authenticated;
GRANT ALL ON TABLE public.site_settings TO service_role;


--
-- Name: TABLE vpns; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.vpns TO anon;
GRANT ALL ON TABLE public.vpns TO authenticated;
GRANT ALL ON TABLE public.vpns TO service_role;


--
-- Name: SEQUENCE vpns_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.vpns_id_seq TO anon;
GRANT ALL ON SEQUENCE public.vpns_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.vpns_id_seq TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE messages_2025_07_01; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_07_01 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_07_01 TO dashboard_user;


--
-- Name: TABLE messages_2025_07_02; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_07_02 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_07_02 TO dashboard_user;


--
-- Name: TABLE messages_2025_07_03; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_07_03 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_07_03 TO dashboard_user;


--
-- Name: TABLE messages_2025_07_04; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_07_04 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_07_04 TO dashboard_user;


--
-- Name: TABLE messages_2025_07_05; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_07_05 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_07_05 TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- Name: TABLE prefixes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.prefixes TO service_role;
GRANT ALL ON TABLE storage.prefixes TO authenticated;
GRANT ALL ON TABLE storage.prefixes TO anon;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE hooks; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON TABLE supabase_functions.hooks TO postgres;
GRANT ALL ON TABLE supabase_functions.hooks TO anon;
GRANT ALL ON TABLE supabase_functions.hooks TO authenticated;
GRANT ALL ON TABLE supabase_functions.hooks TO service_role;


--
-- Name: SEQUENCE hooks_id_seq; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO postgres;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO anon;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO authenticated;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO service_role;


--
-- Name: TABLE migrations; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON TABLE supabase_functions.migrations TO postgres;
GRANT ALL ON TABLE supabase_functions.migrations TO anon;
GRANT ALL ON TABLE supabase_functions.migrations TO authenticated;
GRANT ALL ON TABLE supabase_functions.migrations TO service_role;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

