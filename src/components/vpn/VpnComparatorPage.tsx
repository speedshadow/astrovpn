import React, { useState } from 'react';
import type { Vpn } from '@/types';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { trackAffiliateClick } from '@/lib/analytics-tracker';
import {
  CheckCircle,
  XCircle,
  Star,
  DollarSign,
  Server,
  Globe,
  Smartphone,
  FileLock,
  ShieldOff,
  ShieldCheck,
  Share2,
  Ban,
} from 'lucide-react';

interface VpnComparatorPageProps {
  vpns: Vpn[];
}

const VpnComparatorPage: React.FC<VpnComparatorPageProps> = ({ vpns }) => {
  const [selectedVpns, setSelectedVpns] = useState<Vpn[]>([]);

  const handleSelectVpn = (vpn: Vpn) => {
    if (selectedVpns.length < 5 && !selectedVpns.find((v) => v.id === vpn.id)) {
      setSelectedVpns([...selectedVpns, vpn]);
    }
  };

  const handleRemoveVpn = (vpnId: number) => {
    setSelectedVpns(selectedVpns.filter((v) => v.id !== vpnId));
  };

  const bestVpn =
    selectedVpns.length > 0
      ? selectedVpns.reduce(
          (best, current) =>
            (current.star_rating ?? 0) > (best.star_rating ?? 0)
              ? current
              : best,
          selectedVpns[0]
        )
      : null;

  const availableVpns = vpns.filter(
    (vpn) => !selectedVpns.find((v) => v.id === vpn.id)
  );

  type VpnFeatureKey =
    | 'star_rating'
    | 'price_monthly_usd'
    | 'server_count'
    | 'country_count'
    | 'simultaneous_connections'
    | 'keeps_logs'
    | 'has_kill_switch'
    | 'has_double_vpn'
    | 'has_p2p'
    | 'has_ad_blocker';

  const features: {
    key: VpnFeatureKey;
    label: string;
    icon: React.ElementType;
  }[] = [
    { key: 'star_rating', label: 'Star Rating', icon: Star },
    { key: 'price_monthly_usd', label: 'Price (USD/month)', icon: DollarSign },
    { key: 'server_count', label: 'Servers', icon: Server },
    { key: 'country_count', label: 'Countries', icon: Globe },
    {
      key: 'simultaneous_connections',
      label: 'Simultaneous Devices',
      icon: Smartphone,
    },
    { key: 'keeps_logs', label: 'No-Logs Policy', icon: FileLock },
    { key: 'has_kill_switch', label: 'Kill Switch', icon: ShieldOff },
    { key: 'has_double_vpn', label: 'Double VPN', icon: ShieldCheck },
    { key: 'has_p2p', label: 'P2P/Torrenting', icon: Share2 },
    { key: 'has_ad_blocker', label: 'Ad Blocker', icon: Ban },
  ];

  const renderFeature = (
    vpn: Vpn,
    featureKey: VpnFeatureKey
  ): React.ReactNode => {
    const value = vpn[featureKey];
    switch (featureKey) {
      case 'star_rating':
        return (
          <div className="flex items-center justify-center gap-1 font-bold">
            <Star className="w-4 h-4 text-yellow-400" /> {value}
          </div>
        );
      case 'price_monthly_usd':
        return typeof value === 'number' ? `$${value.toFixed(2)}` : 'N/A';
      case 'keeps_logs':
        // Note: `keeps_logs: false` is a good thing (no-logs policy), so we invert the logic.
        return !value ? (
          <CheckCircle className="text-green-500 w-6 h-6 mx-auto" />
        ) : (
          <XCircle className="text-red-500 w-6 h-6 mx-auto" />
        );
      case 'has_kill_switch':
      case 'has_double_vpn':
      case 'has_p2p':
      case 'has_ad_blocker':
        return value ? (
          <CheckCircle className="text-green-500 w-6 h-6 mx-auto" />
        ) : (
          <XCircle className="text-red-500 w-6 h-6 mx-auto" />
        );
      default:
        // The default case handles 'server_count', 'country_count', and 'simultaneous_connections'.
        // These are all `number | null`.
        if (typeof value === 'number') {
          return <>{value}</>;
        }
        // This handles the `null` case and acts as a safe fallback.
        return <span className="text-gray-500">-</span>;
    }
  };

  return (
    <div className="space-y-12">
      <Card>
        <CardHeader>
          <CardTitle>Select VPNs to Compare</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
            {availableVpns.map((vpn) => (
              <div
                key={vpn.id}
                className="flex flex-col items-center p-4 border rounded-lg gap-2 text-center"
              >
                <img
                  src={vpn.logo_url ?? ''}
                  alt={`${vpn.name} logo`}
                  className="h-12 w-12 object-contain"
                />
                <span className="font-semibold text-sm h-10 flex items-center justify-center">
                  {vpn.name}
                </span>
                <Button
                  size="sm"
                  onClick={() => handleSelectVpn(vpn)}
                  disabled={selectedVpns.length >= 5}
                >
                  Add to Compare
                </Button>
              </div>
            ))}
          </div>
          {selectedVpns.length >= 5 && (
            <p className="text-center text-amber-600 mt-4">
              You have reached the maximum of 5 VPNs for comparison.
            </p>
          )}
        </CardContent>
      </Card>

      {selectedVpns.length > 0 && (
        <Card>
          <CardHeader>
            <CardTitle>Side-by-Side Comparison</CardTitle>
          </CardHeader>
          <CardContent className="overflow-x-auto">
            <Table className="min-w-full">
              <TableHeader>
                <TableRow>
                  <TableHead className="font-bold min-w-[200px] align-middle">
                    Feature
                  </TableHead>
                  {selectedVpns.map((vpn) => (
                    <TableHead
                      key={vpn.id}
                      className="text-center min-w-[150px] relative px-2 pt-8 pb-2"
                    >
                      {bestVpn && vpn.id === bestVpn.id && (
                        <div className="absolute top-0 left-1/2 -translate-x-1/2">
                          <span className="inline-block bg-green-500 text-white text-xs font-bold px-3 py-1 rounded-full shadow-lg">
                            Best Choice
                          </span>
                        </div>
                      )}
                      <div
                        className="flex flex-col"
                        style={{ minHeight: '160px' }}
                      >
                        <div className="flex-grow flex flex-col items-center justify-center gap-2">
                          <img
                            src={vpn.logo_url ?? ''}
                            alt={`${vpn.name} logo`}
                            className="h-12 w-12 object-contain"
                          />
                          <span className="font-semibold text-center h-10 flex items-center justify-center">
                            {vpn.name}
                          </span>
                        </div>
                        <div className="mt-auto flex flex-col sm:flex-row gap-2 w-full">
                          <Button
                            asChild
                            variant="outline"
                            size="sm"
                            className="flex-1"
                          >
                            <a href={`/vpn/${vpn.slug}`}>Review</a>
                          </Button>
                          <Button
                            variant="destructive"
                            size="sm"
                            onClick={() => handleRemoveVpn(vpn.id)}
                            className="flex-1"
                          >
                            Remove
                          </Button>
                        </div>
                      </div>
                    </TableHead>
                  ))}
                </TableRow>
              </TableHeader>
              <TableBody>
                {features.map((feature) => (
                  <TableRow key={feature.key}>
                    <TableCell className="font-semibold text-muted-foreground">
                      <div className="flex items-center gap-3">
                        <feature.icon className="w-5 h-5 text-muted-foreground" />
                        <span>{feature.label}</span>
                      </div>
                    </TableCell>
                    {selectedVpns.map((vpn) => (
                      <TableCell
                        key={`${vpn.id}-${feature.key}`}
                        className="text-center text-lg font-medium text-foreground"
                      >
                        {renderFeature(vpn, feature.key)}
                      </TableCell>
                    ))}
                  </TableRow>
                ))}
                <TableRow className="bg-muted/20 hover:bg-muted/40">
                  <TableCell className="font-bold text-lg">Get Deal</TableCell>
                  {selectedVpns.map((vpn) => (
                    <TableCell key={`deal-${vpn.id}`} className="text-center">
                      <Button
                        asChild
                        size="lg"
                        className="bg-green-600 hover:bg-green-700 text-white font-bold shadow-md transition-transform transform hover:scale-105"
                      >
                        <a
                          href={vpn.affiliate_link ?? '#'}
                          target="_blank"
                          rel="noopener noreferrer"
                          onClick={() => trackAffiliateClick(vpn.id)}
                        >
                          Visit Site
                        </a>
                      </Button>
                    </TableCell>
                  ))}
                </TableRow>
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      )}
    </div>
  );
};

export default VpnComparatorPage;
