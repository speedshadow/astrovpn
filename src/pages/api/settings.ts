import type { APIRoute } from 'astro';
import { addNoCacheHeaders, getLatestSettings } from '@/utils/site-settings';

export const GET: APIRoute = async ({ locals, request }) => {
  const { supabase } = locals;
  const timestamp = new Date().getTime();
  const url = new URL(request.url);
  const forceRefresh = url.searchParams.has('force_refresh');

  // Usar a função unificada para buscar configurações
  const { data, error } = await getLatestSettings(supabase);

  if (error) {
    console.error('Erro ao buscar configurações:', error);
    return new Response(
      JSON.stringify({
        success: false,
        error: error.message,
        timestamp,
      }),
      {
        status: 500,
        headers: {
          'Content-Type': 'application/json',
          'Cache-Control': 'no-store, no-cache, must-revalidate',
          Pragma: 'no-cache',
          Expires: '0',
        },
      }
    );
  }

  return new Response(
    JSON.stringify({
      success: true,
      data,
      timestamp,
    }),
    {
      status: 200,
      headers: {
        'Content-Type': 'application/json',
        'Cache-Control':
          'no-store, no-cache, must-revalidate, proxy-revalidate',
        Pragma: 'no-cache',
        Expires: '0',
        'Surrogate-Control': 'no-store',
      },
    }
  );
};

export const POST: APIRoute = async ({ request, locals }) => {
  const { supabase } = locals;
  const timestamp = new Date().getTime();

  const {
    data: { session },
  } = await supabase.auth.getSession();

  if (!session) {
    return new Response(JSON.stringify({ message: 'Unauthorized' }), {
      status: 401,
    });
  }

  try {
    // Check authentication first
    if (!session) {
      return new Response(JSON.stringify({ message: 'Unauthorized' }), {
        status: 401,
      });
    }

    const formData = await request.json();

    // Validate required fields
    if (!formData.site_title) {
      return new Response(
        JSON.stringify({
          message: 'Site title is required',
        }),
        { status: 400 }
      );
    }

    // Save settings to database
    const { data, error } = await supabase
      .from('site_settings')
      .update(formData)
      .eq('id', 1)
      .select();

    if (error) {
      console.error('Error saving settings:', error);
      return new Response(
        JSON.stringify({
          message: `Failed to update settings: ${error.message}`,
        }),
        { status: 500 }
      );
    }

    // Force cache revalidation after update
    const response = new Response(
      JSON.stringify({
        message: 'Settings updated successfully!',
        timestamp: new Date().getTime(),
        data: data,
      }),
      {
        status: 200,
        headers: {
          'Content-Type': 'application/json',
          'Cache-Control':
            'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0',
          Pragma: 'no-cache',
          Expires: '0',
          'Surrogate-Control': 'no-store',
        },
      }
    );

    return response;
  } catch (error: any) {
    console.error('Error processing POST /api/settings:', error);

    return new Response(
      JSON.stringify({
        message: 'Failed to update settings',
        error: error.message,
      }),
      {
        status: 500,
        headers: {
          'Content-Type': 'application/json',
          'Cache-Control':
            'no-store, no-cache, must-revalidate, proxy-revalidate',
          Pragma: 'no-cache',
          Expires: '0',
          'Surrogate-Control': 'no-store',
        },
      }
    );
  }
};
