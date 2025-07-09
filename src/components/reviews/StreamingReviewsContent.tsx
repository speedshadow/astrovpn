'use client';

import { useQuery } from '@tanstack/react-query';
import { memo } from 'react';
import { fetchReviewPageBySlug } from '@/lib/vpn-api';
import type { PopulatedReviewPage } from '@/types';
import { ReviewVpnCard } from '@/components/vpn/ReviewVpnCard';
import { Info, CheckCircle } from 'lucide-react';

interface StreamingReviewsContentProps {
  initialData?: PopulatedReviewPage;
}

function StreamingReviewsContentComponent({
  initialData,
}: StreamingReviewsContentProps) {
  // Use TanStack Query with initialData to prevent unnecessary fetching
  const { data: pageData, isLoading } = useQuery({
    queryKey: ['reviewPage', 'streaming'],
    queryFn: () => fetchReviewPageBySlug('streaming'),
    initialData,
    staleTime: 5 * 60 * 1000, // 5 minutes
    gcTime: 10 * 60 * 1000, // 10 minutes
  });

  if (isLoading && !initialData) {
    return (
      <div className="flex justify-center items-center py-20">
        <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-primary"></div>
      </div>
    );
  }

  if (!pageData) {
    return (
      <div className="text-center py-20">
        <p className="text-xl text-muted-foreground">Review page not found</p>
      </div>
    );
  }

  const { title, description, introduction, conclusion, vpns } = pageData;

  // Format the title for display (e.g., 'best-vpn' -> 'Best Vpn')
  const displayTitle = title
    .split('-')
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ');

  return (
    <main className="container mx-auto px-4 py-12">
      {/* Page Header */}
      <header className="relative mb-12 py-20 md:py-28 text-center overflow-hidden rounded-3xl border bg-background">
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_50%_120%,rgba(var(--primary-rgb),0.1),transparent_40%)]"></div>
        <div className="absolute inset-0 bg-[url('/assets/dot-grid.svg')] bg-center [mask-image:linear-gradient(180deg,white,rgba(255,255,255,0))]" />
        <div className="relative container mx-auto px-4">
          <h1 className="text-5xl md:text-7xl font-extrabold mb-4 text-transparent bg-clip-text bg-gradient-to-r from-primary to-secondary">
            {displayTitle}
          </h1>
        </div>
      </header>

      {/* Introduction Card */}
      {introduction && (
        <section className="mb-16 not-prose">
          <div className="bg-muted/50 border rounded-2xl p-8 flex items-start gap-6">
            <div className="text-primary flex-shrink-0 mt-1">
              <Info size={28} />
            </div>
            <div className="prose prose-xl max-w-none text-muted-foreground">
              <p className="lead">{introduction}</p>
            </div>
          </div>
        </section>
      )}

      <div className="lg:grid lg:grid-cols-[1fr_280px] lg:gap-12 items-start">
        <article className="prose lg:prose-xl max-w-none">
          {/* Table of Contents (Mobile) */}
          <div className="lg:hidden mb-12 p-6 bg-muted/50 rounded-lg border">
            <h2 className="text-2xl font-bold mb-4">Table of Contents</h2>
            <ul className="space-y-2 list-none p-0">
              {vpns.map((vpn, index) => (
                <li key={vpn.id} className="p-0 m-0">
                  <a
                    href={`#vpn-${vpn.slug}`}
                    className="flex items-center text-lg text-foreground hover:text-primary transition-colors"
                  >
                    <span className="font-bold text-primary mr-4">
                      {index + 1}
                    </span>
                    <span>{vpn.name}</span>
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* VPN Reviews Section */}
          <section className="space-y-16">
            {vpns.map((vpn, index) => (
              <div key={vpn.id} id={`vpn-${vpn.slug}`} className="scroll-mt-24">
                <h2 className="text-3xl font-bold border-b pb-2 mb-6">
                  <span className="text-primary">#{index + 1}</span> -{' '}
                  {vpn.name}
                </h2>
                <ReviewVpnCard vpn={vpn} rank={index + 1} />
              </div>
            ))}
          </section>

          {/* Conclusion Card */}
          {conclusion && (
            <section className="mt-16 pt-8 border-t not-prose">
              <div className="bg-muted/50 border rounded-2xl p-8">
                <div className="flex items-start gap-6">
                  <div className="text-primary flex-shrink-0 mt-1">
                    <CheckCircle size={28} />
                  </div>
                  <div>
                    <h2 className="text-3xl font-bold mb-4">Conclusion</h2>
                    <div className="prose prose-xl max-w-none text-muted-foreground">
                      <p>{conclusion}</p>
                    </div>
                  </div>
                </div>
              </div>
            </section>
          )}
        </article>

        <aside className="hidden lg:block sticky top-24">
          <div
            id="table-of-contents"
            className="p-6 bg-muted/50 rounded-lg border"
          >
            <h3 className="text-xl font-bold mb-4">Table of Contents</h3>
            <ul className="space-y-2 list-none p-0">
              {vpns.map((vpn, index) => (
                <li key={vpn.id} className="p-0 m-0">
                  <a
                    href={`#vpn-${vpn.slug}`}
                    className="flex items-center text-foreground hover:text-primary transition-colors"
                  >
                    <span className="font-bold text-primary mr-3 w-6 text-center">
                      {index + 1}
                    </span>
                    <span className="flex-1">{vpn.name}</span>
                  </a>
                </li>
              ))}
            </ul>
          </div>
        </aside>
      </div>
    </main>
  );
}

// Memoize the component to prevent unnecessary re-renders
export const StreamingReviewsContent = memo(StreamingReviewsContentComponent);
