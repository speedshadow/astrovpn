'use client';

import { QueryProvider } from '@/lib/query-provider';
import { StreamingReviewsContent } from '@/components/reviews/StreamingReviewsContent';
import type { PopulatedReviewPage } from '@/types';

interface StreamingReviewsPageProps {
  initialData?: PopulatedReviewPage;
}

/**
 * This component acts as a single entrypoint for the React-based
 * streaming reviews page. It wraps the content with the necessary
 * QueryClientProvider to ensure the context is available to all
 * child components.
 */
export function StreamingReviewsPage({
  initialData,
}: StreamingReviewsPageProps) {
  return (
    <QueryProvider>
      <StreamingReviewsContent initialData={initialData} />
    </QueryProvider>
  );
}
