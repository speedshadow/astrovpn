'use client';

import { QueryProvider } from '@/lib/query-provider';
import { HomepageContent } from './HomepageContent';
import { VpnComparator } from './VpnComparator';

/**
 * This component acts as the main entrypoint for the interactive
 * homepage section. It wraps all homepage components with the QueryClientProvider
 * so they can share the same query cache.
 */
export function Homepage() {
  return (
    <QueryProvider>
      <HomepageContent />
      <VpnComparator />
    </QueryProvider>
  );
}
