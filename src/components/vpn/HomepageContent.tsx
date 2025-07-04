'use client';

import { useState, useMemo } from 'react';
import { useQuery } from '@tanstack/react-query';
import type { Vpn } from '@/types';
import { VpnCard } from './VpnCard';
import { Award, Tv, ShieldCheck, Globe, List, Sparkles } from 'lucide-react';

// Define the categories directly in the component
const categories = [
  { name: 'All', icon: List, category: 'all' },
  { name: 'Best VPNs', icon: Award, category: 'best-vpn' },
  { name: 'Streaming', icon: Tv, category: 'streaming' },
  { name: 'Privacy', icon: ShieldCheck, category: 'privacy' },
  { name: 'China', icon: Globe, category: 'china' },
];

// API fetching function
async function fetchHomepageVpns(): Promise<Vpn[]> {
  const response = await fetch('/api/homepage-vpns');
  if (!response.ok) {
    throw new Error('Failed to fetch VPNs');
  }
  return response.json();
}

export function HomepageContent() {
  const [activeCategory, setActiveCategory] = useState('all');

  const { data: vpns, isLoading, error } = useQuery<Vpn[]>({
    queryKey: ['homepageVpns'],
    queryFn: fetchHomepageVpns,
    staleTime: 5 * 60 * 1000, // 5 minutes
  });

  const filteredAndSortedVpns = useMemo(() => {
    if (!vpns) return [];

    // Sort by star rating first
    const sorted = [...vpns].sort((a, b) => (b.star_rating ?? 0) - (a.star_rating ?? 0));

    // Then, filter based on the active category
    if (activeCategory === 'all') {
      return sorted;
    }

    return sorted.filter(vpn => 
      vpn.categories?.includes(activeCategory)
    );
  }, [vpns, activeCategory]);

  return (
    <section id="vpn-deals" className="py-16 px-4">
      <div className="container mx-auto">
        {/* Category Filters */}
        <div className="mb-12">
          <h2 className="text-3xl md:text-4xl font-bold text-center mb-10 flex items-center justify-center gap-3 font-mono">
            <Sparkles className="h-6 w-6 text-purple-400" />
            <span className="bg-gradient-to-r from-purple-500 via-pink-500 to-red-500 bg-clip-text text-transparent">
              VPNs Categories
            </span>
            <Sparkles className="h-6 w-6 text-red-400" />
          </h2>
          <div className="flex flex-wrap justify-center gap-3 md:gap-4">
            {categories.map(cat => (
              <button
                key={cat.category}
                onClick={() => setActiveCategory(cat.category)}
                className={`group flex items-center justify-center px-6 py-3 border rounded-full text-base font-semibold transition-colors duration-300 ease-in-out ${                  activeCategory === cat.category
                    ? 'bg-primary text-primary-foreground border-primary'
                    : 'border-gray-300 dark:border-gray-700 text-foreground hover:bg-primary hover:text-primary-foreground hover:border-primary'
                }`}
              >
                <cat.icon
                  className={`mr-2 h-4 w-4 transition-colors ${                    activeCategory === cat.category ? 'text-primary-foreground' : 'text-primary group-hover:text-primary-foreground'
                  }`}
                  aria-hidden="true"
                />
                {cat.name}
              </button>
            ))}
          </div>
        </div>

        {/* VPN Grid */}
        <h2 className="text-3xl md:text-4xl font-bold text-center mb-12">Today's Top VPN Deals</h2>
        
        {isLoading && (
          <div className="flex justify-center items-center py-20">
            <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-primary"></div>
          </div>
        )}

        {error && (
          <p className="text-center text-red-500">Failed to load VPNs. Please try again later.</p>
        )}

        {!isLoading && !error && (
          <div className="flex flex-wrap justify-center gap-6">
            {filteredAndSortedVpns.length > 0 ? (
              filteredAndSortedVpns.map((vpn: Vpn, index: number) => (
                <VpnCard key={vpn.id} vpn={vpn} rank={index + 1} />
              ))
            ) : (
              <p className="col-span-full text-center text-muted-foreground">
                No VPNs found for this category.
              </p>
            )}
          </div>
        )}
      </div>
    </section>
  );
}
