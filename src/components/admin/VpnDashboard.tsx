'use client';

import { useState } from 'react';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { Button } from '@/components/ui/button';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { MoreHorizontal } from 'lucide-react';
import type { Vpn } from '@/types';

interface VpnDashboardProps {
  initialVpns: Vpn[];
}

export const VpnDashboard = ({ initialVpns }: VpnDashboardProps) => {
  const [vpns] = useState(initialVpns);

  const handleEdit = (id: number) => {
    window.location.href = `/admin/vpn/${id}/edit`;
  };

  const handleDelete = async (id: number) => {
    // Future: This will call Supabase to delete the item and update the UI
    alert(`Placeholder for deleting VPN with ID: ${id}`);
  };

  return (
    <div className="bg-card p-6 rounded-lg shadow-md border">
      <div className="flex justify-between items-center mb-4">
        <h2 className="text-xl font-bold">VPN List</h2>
        <Button asChild>
          <a href="/admin/vpn/new">Add New VPN</a>
        </Button>
      </div>
      <div className="rounded-md border">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Name</TableHead>
              <TableHead>Star Rating</TableHead>
              <TableHead>Country</TableHead>
              <TableHead>On Homepage</TableHead>
              <TableHead>Categories</TableHead>
              <TableHead className="text-right">Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {vpns.length > 0 ? (
              vpns.map((vpn) => (
                <TableRow key={vpn.id}>
                  <TableCell className="font-medium flex items-center gap-3">
                    {vpn.logo_url ? (
                      <img
                        src={vpn.logo_url}
                        alt={`${vpn.name} logo`}
                        className="h-8 w-8 object-contain rounded-full"
                      />
                    ) : (
                      <div className="h-8 w-8 bg-muted rounded-full" />
                    )}
                    <span>{vpn.name}</span>
                  </TableCell>
                  <TableCell>{vpn.star_rating ?? 'N/A'}</TableCell>
                  <TableCell>
                    {vpn.based_in_country_flag}{' '}
                    {vpn.based_in_country_name ?? 'N/A'}
                  </TableCell>
                  <TableCell>{vpn.show_on_homepage ? 'Yes' : 'No'}</TableCell>
                  <TableCell>
                    <div className="flex flex-wrap gap-1 max-w-xs">
                      {vpn.categories && vpn.categories.length > 0 ? (
                        vpn.categories.map((category) => (
                          <span
                            key={category}
                            className="px-2 py-0.5 text-xs font-medium bg-secondary text-secondary-foreground rounded-full"
                          >
                            {category}
                          </span>
                        ))
                      ) : (
                        <span className="text-muted-foreground text-xs">
                          N/A
                        </span>
                      )}
                    </div>
                  </TableCell>
                  <TableCell className="text-right">
                    <DropdownMenu>
                      <DropdownMenuTrigger asChild>
                        <Button variant="ghost" className="h-8 w-8 p-0">
                          <span className="sr-only">Open menu</span>
                          <MoreHorizontal className="h-4 w-4" />
                        </Button>
                      </DropdownMenuTrigger>
                      <DropdownMenuContent align="end">
                        <DropdownMenuItem onClick={() => handleEdit(vpn.id)}>
                          Edit
                        </DropdownMenuItem>
                        <DropdownMenuItem
                          onClick={() => handleDelete(vpn.id)}
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
                <TableCell colSpan={6} className="h-24 text-center">
                  No VPNs found.
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </div>
    </div>
  );
};
