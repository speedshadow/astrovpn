/**
 * Utilitário unificado para gerenciar configurações do site
 * Este arquivo consolida todas as funcionalidades relacionadas a cache e atualização de configurações
 */

import { createServerClient } from '@supabase/ssr';

/**
 * Adiciona headers para prevenir cache em respostas HTTP
 */
export function addNoCacheHeaders(response: Response): Response {
  response.headers.set(
    'Cache-Control',
    'no-store, no-cache, must-revalidate, proxy-revalidate'
  );
  response.headers.set('Pragma', 'no-cache');
  response.headers.set('Expires', '0');
  response.headers.set('Surrogate-Control', 'no-store');
  return response;
}

/**
 * Força o recarregamento da página atual limpando o cache
 */
export function hardReload() {
  window.location.reload();
}

/**
 * Recarrega a página atual com um parâmetro para evitar cache
 */
export function reloadWithoutCache() {
  const timestamp = new Date().getTime();
  window.location.href = `${window.location.pathname}?refresh=${timestamp}`;
}

/**
 * Navega para a página inicial com um parâmetro para evitar cache
 */
export function navigateToHome() {
  const timestamp = new Date().getTime();
  window.location.href = `/?refresh=${timestamp}`;
}

/**
 * Busca as configurações mais recentes do site diretamente do banco de dados
 */
export async function getLatestSettings(supabase: any) {
  try {
    const { data, error } = await supabase
      .from('site_settings')
      .select('*')
      .eq('id', 1)
      .single();

    if (error) throw error;

    // Adicionar timestamp para invalidar cache
    const timestamp = new Date().getTime();
    const freshData = data ? { ...data, _timestamp: timestamp } : null; // All fields are included automatically from Supabase

    return { data: freshData, error: null };
  } catch (error: any) {
    console.error('Erro ao buscar configurações:', error);
    return { data: null, error };
  }
}

/**
 * Força a atualização das configurações do site (para uso no servidor)
 */
export async function forceRefreshSettings(cookies: any) {
  // Criar cliente Supabase com cookies adequados
  const supabase = createServerClient(
    import.meta.env.PUBLIC_SUPABASE_URL,
    import.meta.env.PUBLIC_SUPABASE_ANON_KEY,
    {
      cookies: {
        get: (name: string) => cookies.get(name)?.value ?? '',
        set: (name: string, value: string, options: any) => {
          cookies.set(name, value, options);
        },
        remove: (name: string, options: any) => {
          cookies.delete(name, options);
        },
      },
    }
  );

  // Buscar configurações atualizadas
  const { data, error } = await getLatestSettings(supabase);

  if (error) {
    console.error('Erro ao forçar atualização das configurações:', error);
  }

  return data;
}

/**
 * Limpa o cache local do navegador relacionado às configurações
 */
export function clearLocalCache() {
  sessionStorage.removeItem('site-settings');
  localStorage.removeItem('site-settings');
}

/**
 * Configura interceptadores de cliques para links da página inicial
 * para adicionar parâmetros de cache-busting sem modificar o DOM
 */
export function setupLinkInterceptors() {
  document.addEventListener('click', (e) => {
    // Verificar se o clique foi em um link para a página inicial
    const target = e.target as HTMLElement;
    if (!target) return;

    const link = target.closest('a[href="/"]');
    if (link) {
      // Prevenir a navegação padrão
      e.preventDefault();

      // Navegar para a página inicial com parâmetro de cache-busting
      navigateToHome();
    }
  });
}
