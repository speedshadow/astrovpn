'use client';

import { useState } from 'react';
import type { ReviewPage } from '@/types';
import { Button } from '@/components/ui/button';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { MoreHorizontal } from 'lucide-react';
import { supabase } from '@/lib/supabase'; // Client-side supabase

interface ReviewDashboardProps {
  initialReviewPages: ReviewPage[];
}

export const ReviewDashboard = ({
  initialReviewPages,
}: ReviewDashboardProps) => {
  const [reviewPages, setReviewPages] = useState(initialReviewPages);

  const handleEdit = (id: number) => {
    window.location.href = `/admin/reviews/${id}`;
  };

  const handleDelete = async (id: number) => {
    if (!confirm('Are you sure you want to delete this review page?')) {
      return;
    }

    const { error } = await supabase.from('review_pages').delete().eq('id', id);

    if (error) {
      alert(`Error deleting page: ${error.message}`);
    } else {
      setReviewPages((prev) => prev.filter((page) => page.id !== id));
      alert('Page deleted successfully!');
    }
  };

  return (
    <div className="bg-card p-6 rounded-lg shadow-md border">
      <div className="flex justify-between items-center mb-4">
        <h2 className="text-xl font-bold">Review Pages</h2>
        <Button asChild>
          <a href="/admin/reviews/new">Add New Page</a>
        </Button>
      </div>
      <div className="rounded-md border">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Title</TableHead>
              <TableHead>Slug</TableHead>
              <TableHead>VPNs</TableHead>
              <TableHead className="text-right">Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {reviewPages.length > 0 ? (
              reviewPages.map((page) => (
                <TableRow key={page.id}>
                  <TableCell className="font-medium">{page.title}</TableCell>
                  <TableCell>
                    <a
                      href={`/reviews/${page.slug}`}
                      className="hover:underline"
                      target="_blank"
                      rel="noopener noreferrer"
                    >
                      /reviews/{page.slug}
                    </a>
                  </TableCell>
                  <TableCell>{page.vpn_ids?.length ?? 0}</TableCell>
                  <TableCell className="text-right">
                    <DropdownMenu>
                      <DropdownMenuTrigger asChild>
                        <Button variant="ghost" className="h-8 w-8 p-0">
                          <span className="sr-only">Open menu</span>
                          <MoreHorizontal className="h-4 w-4" />
                        </Button>
                      </DropdownMenuTrigger>
                      <DropdownMenuContent align="end">
                        <DropdownMenuItem onClick={() => handleEdit(page.id)}>
                          Edit
                        </DropdownMenuItem>
                        <DropdownMenuItem
                          onClick={() => handleDelete(page.id)}
                          className="text-destructive focus:text-destructive"
                        >
                          Delete
                        </DropdownMenuItem>
                      </DropdownMenuContent>
                    </DropdownMenu>
                  </TableCell>
                </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell colSpan={4} className="h-24 text-center">
                  No review pages found.
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </div>
    </div>
  );
};
