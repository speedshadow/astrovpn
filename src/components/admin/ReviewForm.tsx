'use client';

import React, { useState } from 'react';
import { supabase } from '@/lib/supabase';

import type { Vpn, ReviewPage } from '@/types';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Reorder } from 'framer-motion';
import { GripVertical } from 'lucide-react';

// A smaller type for the VPNs used in the selection lists
type SelectableVpn = Pick<Vpn, 'id' | 'name' | 'logo_url' | 'star_rating'>;

interface ReviewFormProps {
  allVpns: SelectableVpn[];
  reviewPageToEdit?: ReviewPage;
}

// Helper to generate a URL-friendly slug from a string
const generateSlug = (title: string) => {
  return title
    .toLowerCase()
    .replace(/[^\w\s-]/g, '') // remove non-word chars
    .replace(/[\s_-]+/g, '-') // swap spaces for hyphens
    .replace(/^-+|-+$/g, ''); // remove leading/trailing hyphens
};

export const ReviewForm = ({ allVpns, reviewPageToEdit }: ReviewFormProps) => {
  const [formData, setFormData] = useState<
    Omit<ReviewPage, 'id' | 'created_at'>
  >({
    title: reviewPageToEdit?.title ?? '',
    slug: reviewPageToEdit?.slug ?? '',
    description: reviewPageToEdit?.description ?? '',
    introduction: reviewPageToEdit?.introduction ?? '',
    conclusion: reviewPageToEdit?.conclusion ?? '',
    vpn_ids: reviewPageToEdit?.vpn_ids ?? [],
  });

  // Initialize the selected VPNs list based on props
  // Initialize the selected VPNs list based on props and sort it by rating
  const initialSelected = (reviewPageToEdit?.vpn_ids ?? [])
    .map((id) => (allVpns ?? []).find((vpn) => vpn.id === id))
    .filter((vpn): vpn is SelectableVpn => vpn !== undefined)
    .sort((a, b) => (b.star_rating ?? 0) - (a.star_rating ?? 0));

  const [selectedVpns, setSelectedVpns] =
    useState<SelectableVpn[]>(initialSelected);
  const [isLoading, setIsLoading] = useState(false);

  // Derive available VPNs from the selected list. This is more robust.
  const availableVpns = (allVpns ?? [])
    .filter((vpn) => !selectedVpns.some((s) => s.id === vpn.id))
    .sort((a, b) => a.name.localeCompare(b.name));

  const handleInputChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));

    // Auto-generate slug from title, but only if the slug field is empty or follows the title
    if (name === 'title') {
      const currentSlug = generateSlug(formData.title);
      if (formData.slug === '' || formData.slug === currentSlug) {
        setFormData((prev) => ({ ...prev, slug: generateSlug(value) }));
      }
    }
  };

  const handleSelectVpn = (vpn: SelectableVpn) => {
    setSelectedVpns((prev) =>
      [...prev, vpn].sort((a, b) => (b.star_rating ?? 0) - (a.star_rating ?? 0))
    );
  };

  const handleDeselectVpn = (vpn: SelectableVpn) => {
    setSelectedVpns((prev) => prev.filter((v) => v.id !== vpn.id));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);

    const submissionData = {
      ...formData,
      vpn_ids: selectedVpns.map((vpn) => vpn.id),
    };

    let error;
    if (reviewPageToEdit) {
      // Update existing page
      const { error: updateError } = await supabase
        .from('review_pages')
        .update(submissionData)
        .eq('id', reviewPageToEdit.id);
      error = updateError;
    } else {
      // Create new page
      const { error: insertError } = await supabase
        .from('review_pages')
        .insert(submissionData);
      error = insertError;
    }

    setIsLoading(false);

    if (error) {
      alert(`Error saving page: ${error.message}`);
    } else {
      alert(`Page successfully ${reviewPageToEdit ? 'updated' : 'created'}!`);
      window.location.href = '/admin/reviews';
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-8">
      <div className="bg-card p-6 rounded-lg shadow-md border space-y-4">
        <h2 className="text-xl font-bold">Page Content</h2>
        <div>
          <label htmlFor="title" className="block text-sm font-medium mb-1">
            Title
          </label>
          <Input
            id="title"
            name="title"
            value={formData.title}
            onChange={handleInputChange}
            required
          />
        </div>
        <div>
          <label htmlFor="slug" className="block text-sm font-medium mb-1">
            Slug
          </label>
          <Input
            id="slug"
            name="slug"
            value={formData.slug}
            onChange={handleInputChange}
            required
          />
          <p className="text-xs text-muted-foreground mt-1">
            URL-friendly identifier. E.g., /reviews/{formData.slug}
          </p>
        </div>
        <div>
          <label
            htmlFor="description"
            className="block text-sm font-medium mb-1"
          >
            Description (for SEO)
          </label>
          <Textarea
            id="description"
            name="description"
            value={formData.description ?? ''}
            onChange={handleInputChange}
            rows={2}
          />
        </div>
        <div>
          <label
            htmlFor="introduction"
            className="block text-sm font-medium mb-1"
          >
            Introduction
          </label>
          <Textarea
            id="introduction"
            name="introduction"
            value={formData.introduction ?? ''}
            onChange={handleInputChange}
            rows={5}
          />
        </div>
        <div>
          <label
            htmlFor="conclusion"
            className="block text-sm font-medium mb-1"
          >
            Conclusion
          </label>
          <Textarea
            id="conclusion"
            name="conclusion"
            value={formData.conclusion ?? ''}
            onChange={handleInputChange}
            rows={5}
          />
        </div>
      </div>

      <div className="bg-card p-6 rounded-lg shadow-md border">
        <h2 className="text-xl font-bold mb-4">Select & Order VPNs</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {/* Available VPNs */}
          <div>
            <h3 className="font-semibold mb-2">Available VPNs</h3>
            <div className="border rounded-md h-96 overflow-y-auto">
              {availableVpns.map((vpn) => (
                <button
                  type="button"
                  key={vpn.id}
                  onClick={() => handleSelectVpn(vpn)}
                  className="flex items-center w-full text-left p-2 border-b cursor-pointer hover:bg-muted"
                >
                  <img
                    src={vpn.logo_url ?? ''}
                    alt={`${vpn.name} logo`}
                    className="w-8 h-8 mr-3 object-contain"
                  />
                  <span>{vpn.name}</span>
                </button>
              ))}
            </div>
          </div>

          {/* Selected VPNs */}
          <div>
            <h3 className="font-semibold mb-2">
              Selected VPNs (Drag to Reorder)
            </h3>
            <div className="border rounded-md h-96 overflow-y-auto">
              <Reorder.Group
                axis="y"
                values={selectedVpns}
                onReorder={setSelectedVpns}
              >
                {selectedVpns.map((vpn) => (
                  <Reorder.Item
                    key={vpn.id}
                    value={vpn}
                    className="p-2 border-b bg-card"
                  >
                    <div className="flex items-center justify-between">
                      <div className="flex items-center">
                        <GripVertical className="mr-2 h-5 w-5 text-muted-foreground cursor-grab active:cursor-grabbing" />
                        <img
                          src={vpn.logo_url ?? ''}
                          alt={`${vpn.name} logo`}
                          className="w-8 h-8 mr-3 object-contain"
                        />
                        <span>{vpn.name}</span>
                      </div>
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        onClick={() => handleDeselectVpn(vpn)}
                      >
                        Remove
                      </Button>
                    </div>
                  </Reorder.Item>
                ))}
              </Reorder.Group>
            </div>
          </div>
        </div>
      </div>

      <div className="flex justify-end">
        <Button type="submit" disabled={isLoading}>
          {isLoading
            ? 'Saving...'
            : reviewPageToEdit
              ? 'Update Page'
              : 'Create Page'}
        </Button>
      </div>
    </form>
  );
};
