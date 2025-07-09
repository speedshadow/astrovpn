'use client';

import React, { useState, useMemo } from 'react';
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

interface HomepageContentProps {
  vpns: Vpn[];
}

export function HomepageContent({ vpns }: HomepageContentProps) {
  const [activeCategory, setActiveCategory] = useState('all');

  const filteredAndSortedVpns = useMemo(() => {
    if (!vpns) return [];

    // Sort by star rating first
    const sorted = [...vpns].sort(
      (a, b) => (b.star_rating ?? 0) - (a.star_rating ?? 0)
    );

    // Then, filter based on the active category
    if (activeCategory === 'all') {
      return sorted;
    }

    return sorted.filter((vpn) => vpn.categories?.includes(activeCategory));
  }, [vpns, activeCategory]);

  return (
    <section id="vpn-deals" className="py-16 px-4">
      <div className="container mx-auto">
        {/* Category Filters */}
        <div className="relative mb-12 rounded-2xl bg-gradient-to-r from-primary/10 via-blue-500/10 to-green-500/10 p-1 shadow-xl"> 
          <div className="rounded-[11px] bg-card p-8">
          <h2 className="text-3xl font-bold text-center mb-8">
            Explore by Category
          </h2>
          <div className="flex flex-wrap justify-center gap-3 md:gap-4">
            {categories.map((cat) => (
              <button
                key={cat.category}
                onClick={() => setActiveCategory(cat.category)}
                className={`group flex items-center justify-center px-6 py-3 border rounded-full text-base font-semibold transition-colors duration-300 ease-in-out ${
                  activeCategory === cat.category
                    ? 'bg-primary text-primary-foreground border-primary shadow-lg shadow-primary/30'
                    : 'border-border bg-background/50 text-foreground hover:bg-primary hover:text-primary-foreground hover:border-primary'
                }`}
              >
                <cat.icon
                  className={`mr-2 h-4 w-4 transition-colors ${
                    activeCategory === cat.category
                      ? 'text-primary-foreground'
                      : 'text-primary group-hover:text-primary-foreground'
                  }`}
                  aria-hidden="true"
                />
                {cat.name}
              </button>
            ))}
          </div>
        </div>
      </div>

        {/* VPN Grid */}
        <h2 className="text-3xl md:text-4xl font-bold text-center mb-12">
          Today's Top VPN Deals
        </h2>

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
      </div>
    </section>
  );
}
