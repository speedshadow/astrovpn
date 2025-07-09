'use client';

import * as React from 'react';
import { useState, useMemo } from 'react';
import type { Vpn } from '@/types';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Checkbox } from '@/components/ui/checkbox';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { Star } from 'lucide-react';

interface VpnComparisonProps {
  vpns: Vpn[];
}

// A helper to render boolean values as icons
const BooleanFeature = ({ value }: { value: boolean }) => (
  <span className={`text-2xl ${value ? 'text-green-500' : 'text-red-500'}`}>
    {value ? '✓' : '✗'}
  </span>
);

export const VpnComparison: React.FC<VpnComparisonProps> = ({ vpns }) => {
  const [selectedIds, setSelectedIds] = useState<number[]>(() => {
    // Pre-select up to the first 3 VPNs by default
    return vpns.slice(0, 3).map((vpn) => vpn.id);
  });

  const handleCheckboxChange = (vpnId: number) => {
    setSelectedIds((prevIds) => {
      if (prevIds.includes(vpnId)) {
        return prevIds.filter((id) => id !== vpnId);
      }
      if (prevIds.length < 3) {
        return [...prevIds, vpnId];
      }
      return prevIds;
    });
  };

  const selectedVpns = useMemo(() => {
    return selectedIds
      .map((id) => vpns.find((vpn) => vpn.id === id))
      .filter(Boolean) as Vpn[];
  }, [selectedIds, vpns]);

  const features = [
    { key: 'star_rating', label: 'Star Rating' },
    { key: 'price_monthly', label: 'Price (USD/month)' },
    { key: 'server_count', label: 'Servers' },
    { key: 'country_count', label: 'Countries' },
    { key: 'simultaneous_connections', label: 'Simultaneous Devices' },
    { key: 'keeps_logs', label: 'Keeps Logs' },
    { key: 'kill_switch', label: 'Kill Switch' },
    { key: 'double_vpn', label: 'Double VPN' },
  ];

  return (
    <Card className="w-full max-w-6xl mx-auto my-12">
      <CardHeader className="text-center">
        <CardTitle className="text-3xl md:text-4xl font-extrabold">
          Compare VPNs Side-by-Side
        </CardTitle>
        <p className="text-muted-foreground">
          Select up to 3 VPNs to compare features.
        </p>
      </CardHeader>
      <CardContent>
        <div className="flex flex-wrap justify-center gap-4 mb-8">
          {vpns.map((vpn) => (
            <div key={vpn.id} className="flex items-center space-x-2">
              <Checkbox
                id={`vpn-${vpn.id}`}
                checked={selectedIds.includes(vpn.id)}
                onCheckedChange={() => handleCheckboxChange(vpn.id)}
                disabled={
                  !selectedIds.includes(vpn.id) && selectedIds.length >= 3
                }
              />
              <label
                htmlFor={`vpn-${vpn.id}`}
                className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
              >
                {vpn.name}
              </label>
            </div>
          ))}
        </div>

        {selectedVpns.length > 0 ? (
          <div className="overflow-x-auto">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead className="font-bold text-lg min-w-[150px]">
                    Feature
                  </TableHead>
                  {selectedVpns.map((vpn) => (
                    <TableHead
                      key={vpn.id}
                      className="text-center min-w-[150px]"
                    >
                      <div className="flex flex-col items-center gap-2">
                        {vpn.logo_url && (
                          <img
                            src={vpn.logo_url}
                            alt={`${vpn.name} logo`}
                            className="h-10 object-contain"
                          />
                        )}
                        <span className="font-bold text-lg">{vpn.name}</span>
                      </div>
                    </TableHead>
                  ))}
                </TableRow>
              </TableHeader>
              <TableBody>
                {features.map((feature) => (
                  <TableRow key={feature.key}>
                    <TableCell className="font-semibold">
                      {feature.label}
                    </TableCell>
                    {selectedVpns.map((vpn) => (
                      <TableCell key={vpn.id} className="text-center text-base">
                        {(() => {
                          const value = vpn[feature.key as keyof Vpn];

                          // Handle booleans, inverting logic for 'keeps_logs' where false is better
                          if (typeof value === 'boolean') {
                            const displayValue =
                              feature.key === 'keeps_logs' ? !value : value;
                            return <BooleanFeature value={displayValue} />;
                          }

                          // Handle specific numeric keys with formatting
                          if (
                            feature.key === 'star_rating' &&
                            typeof value === 'number'
                          ) {
                            return (
                              <div className="flex items-center justify-center">
                                {value.toFixed(1)}{' '}
                                <Star className="w-4 h-4 ml-1 text-yellow-500 fill-current" />
                              </div>
                            );
                          }
                          if (
                            feature.key === 'price_monthly' &&
                            typeof value === 'number'
                          ) {
                            return `$${value.toFixed(2)}`;
                          }

                          // Handle generic renderable types
                          if (
                            typeof value === 'string' ||
                            typeof value === 'number'
                          ) {
                            return value;
                          }

                          // Fallback for any other type (objects, arrays, null)
                          return 'N/A';
                        })()}
                      </TableCell>
                    ))}
                  </TableRow>
                ))}
                <TableRow>
                  <TableCell></TableCell>
                  {selectedVpns.map((vpn) => (
                    <TableCell key={vpn.id} className="text-center">
                      {vpn.affiliate_link && (
                        <Button asChild className="w-full">
                          <a
                            href={vpn.affiliate_link}
                            target="_blank"
                            rel="noopener noreferrer nofollow"
                          >
                            Visit Site
                          </a>
                        </Button>
                      )}
                    </TableCell>
                  ))}
                </TableRow>
              </TableBody>
            </Table>
          </div>
        ) : (
          <div className="text-center text-muted-foreground py-10">
            Please select at least one VPN to see the comparison.
          </div>
        )}
      </CardContent>
    </Card>
  );
};
