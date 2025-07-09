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
import { trackAffiliateClick } from '@/lib/analytics-tracker';

// A helper to render boolean values as icons
const BooleanFeature = ({ value }: { value: boolean }) => (
  <span className={`text-2xl ${value ? 'text-green-500' : 'text-red-500'}`}>
    {value ? '✓' : '✗'}
  </span>
);

interface VpnComparatorProps {
  vpns: Vpn[];
}

export const VpnComparator: React.FC<VpnComparatorProps> = ({ vpns }) => {
  const [selectedIds, setSelectedIds] = useState<number[]>([]);

  // Effect to pre-select VPNs once data is loaded
  React.useEffect(() => {
    if (vpns && vpns.length > 0) {
      setSelectedIds(vpns.slice(0, 3).map((vpn: Vpn) => vpn.id));
    }
  }, [vpns]);

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
    if (!vpns) return [];
    return selectedIds
      .map((id) => vpns.find((vpn: Vpn) => vpn.id === id))
      .filter(Boolean) as Vpn[];
  }, [selectedIds, vpns]);

  const features = [
    { key: 'star_rating', label: 'Star Rating' },
    { key: 'price_monthly_usd', label: 'Price (USD/month)' },
    { key: 'server_count', label: 'Servers' },
    { key: 'country_count', label: 'Countries' },
    { key: 'simultaneous_connections', label: 'Simultaneous Devices' },
    { key: 'keeps_logs', label: 'No-Logs Policy' },
    { key: 'has_kill_switch', label: 'Kill Switch' },
    { key: 'has_double_vpn', label: 'Double VPN' },
    { key: 'has_p2p', label: 'P2P/Torrenting' },
    { key: 'has_ad_blocker', label: 'Ad Blocker' },
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
          {vpns?.map((vpn: Vpn) => (
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
                  {selectedVpns.map((vpn: Vpn) => (
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
                    {selectedVpns.map((vpn: Vpn) => (
                      <TableCell key={vpn.id} className="text-center text-base">
                        {(() => {
                          const value = vpn[feature.key as keyof Vpn];

                          if (typeof value === 'boolean') {
                            const displayValue =
                              feature.key === 'keeps_logs' ? !value : value;
                            return <BooleanFeature value={displayValue} />;
                          }

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
                            feature.key === 'price_monthly_usd' &&
                            typeof value === 'number'
                          ) {
                            return `$${value.toFixed(2)}`;
                          }

                          if (
                            typeof value === 'string' ||
                            typeof value === 'number'
                          ) {
                            return value;
                          }

                          return 'N/A';
                        })()}
                      </TableCell>
                    ))}
                  </TableRow>
                ))}
                <TableRow>
                  <TableCell></TableCell>
                  {selectedVpns.map((vpn: Vpn) => (
                    <TableCell key={vpn.id} className="text-center">
                      <div className="flex flex-col items-center gap-2">
                        <Button
                          asChild
                          variant="outline"
                          size="sm"
                          className="w-full"
                        >
                          <a href={`/vpn/${vpn.slug}`}>Review</a>
                        </Button>
                        {vpn.affiliate_link && (
                          <Button
                            asChild
                            size="lg"
                            className="bg-green-500 text-white hover:bg-green-600 font-bold w-full"
                          >
                            <a
                              href={vpn.affiliate_link}
                              target="_blank"
                              rel="noopener noreferrer nofollow"
                              onClick={() => trackAffiliateClick(vpn.id)}
                            >
                              Open Deals
                            </a>
                          </Button>
                        )}
                      </div>
                    </TableCell>
                  ))}
                </TableRow>
              </TableBody>
            </Table>
          </div>
        ) : (
          <div className="text-center py-8">
            <p className="text-muted-foreground">
              Select a VPN to see a comparison.
            </p>
          </div>
        )}
      </CardContent>
    </Card>
  );
};
