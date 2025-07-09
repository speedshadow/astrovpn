'use client';

import { trackAffiliateClick } from '@/lib/analytics-tracker';
import { motion } from 'framer-motion';
import {
  ShieldCheck,
  MapPin,
  Server,
  ShieldAlert,
  Award,
  Gavel,
  CheckCircle,
  XCircle,
  Smartphone,
} from 'lucide-react';
import { StarRating } from '@/components/StarRating';
import { Button } from '@/components/ui/button';
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from '@/components/ui/tooltip';
import {
  FaWindows,
  FaApple,
  FaLinux,
  FaAndroid,
  FaAppStoreIos,
} from 'react-icons/fa';
import { RiRouterFill } from 'react-icons/ri';
import { PiTelevisionSimpleBold } from 'react-icons/pi';
import type { Vpn } from '@/types';

const deviceIcons: { [key: string]: React.ElementType } = {
  windows: FaWindows,
  macos: FaApple,
  linux: FaLinux,
  android: FaAndroid,
  ios: FaAppStoreIos,
  router: RiRouterFill,
  tv: PiTelevisionSimpleBold,
};

interface VpnCardProps {
  vpn: Vpn;
  rank?: number;
}

// Helper function to robustly get the list of supported devices from multiple possible data formats
const getSupportedDevices = (devices: any): string[] => {
  if (!devices) {
    return [];
  }

  // Case 1: Already an array
  if (Array.isArray(devices)) {
    return devices.map((d) => String(d).toLowerCase());
  }

  // Case 2: An object with boolean flags (as per the type definition)
  if (typeof devices === 'object' && !Array.isArray(devices)) {
    return Object.entries(devices)
      .filter(([, value]) => value === true)
      .map(([key]) => key.toLowerCase());
  }

  // Case 3: A string (could be JSON, could be comma-separated)
  if (typeof devices === 'string') {
    const trimmed = devices.trim();

    // Try parsing as JSON
    if (trimmed.startsWith('[') || trimmed.startsWith('{')) {
      try {
        const parsed = JSON.parse(trimmed);
        // Recurse with the parsed result
        return getSupportedDevices(parsed);
      } catch (e) {
        // Not valid JSON, fall through to comma-separated check
      }
    }

    // Treat as comma-separated
    if (trimmed.length > 0) {
      return trimmed.split(',').map((d) => d.trim().toLowerCase());
    }
  }

  return [];
};

export function VpnCard({ vpn, rank }: VpnCardProps) {
  const supportedDevices = getSupportedDevices(vpn.supported_devices);

  const shouldShowServers =
    typeof vpn.server_count === 'number' && vpn.server_count > 0;
  const shouldShowCountries =
    typeof vpn.country_count === 'number' && vpn.country_count > 0;
  const shouldShowSimultaneousConnections =
    typeof vpn.simultaneous_connections === 'number' &&
    vpn.simultaneous_connections > 0;

  // Robustly parse prices to handle strings or numbers from the database
  const priceUSD = vpn.price_monthly_usd
    ? parseFloat(String(vpn.price_monthly_usd))
    : NaN;
  const priceEUR = vpn.price_monthly_eur
    ? parseFloat(String(vpn.price_monthly_eur))
    : NaN;

  const shouldShowUSD = !isNaN(priceUSD) && priceUSD > 0;
  const shouldShowEUR = !isNaN(priceEUR) && priceEUR > 0;

  const rankClasses: { [key: number]: string } = {
    0: 'border-amber-400 border-2 shadow-amber-400/20',
    1: 'border-slate-400 border-2 shadow-slate-400/20',
    2: 'border-orange-600 border-2 shadow-orange-600/20',
  };

  const rankClass = (rank !== undefined && rankClasses[rank]) || '';

  return (
    <TooltipProvider delayDuration={100}>
      <motion.div
        whileHover={{ y: -8, scale: 1.03 }}
        transition={{ type: 'spring', stiffness: 300 }}
        className={`bg-card border rounded-xl overflow-hidden shadow-lg hover:shadow-2xl transition-shadow duration-300 flex flex-col h-full relative min-w-[340px] ${rankClass}`}
        data-vpn-card
        data-categories={vpn.categories?.join(',') || ''}
      >
        {rank !== undefined && rank < 3 && (
          <div className="absolute top-2 right-2 z-10">
            <Tooltip>
              <TooltipTrigger>
                <Award
                  className={`h-6 w-6 ${rank === 0 ? 'text-amber-400 fill-amber-400/20' : rank === 1 ? 'text-slate-400 fill-slate-400/20' : 'text-orange-600 fill-orange-600/20'}`}
                />
              </TooltipTrigger>
              <TooltipContent>
                <p>
                  {rank === 0
                    ? '#1 Top Pick'
                    : rank === 1
                      ? '#2 Runner-up'
                      : '#3 Great Value'}
                </p>
              </TooltipContent>
            </Tooltip>
          </div>
        )}

        <div className="p-6 bg-card-foreground/5 flex items-center gap-4">
          {vpn.optimizedLogo ? (
            <img
              {...vpn.optimizedLogo.attributes}
              alt={`${vpn.name} logo`}
              className="h-12 w-12 object-contain"
            />
          ) : vpn.logo_url && (
            <img
              src={vpn.logo_url}
              alt={`${vpn.name} logo`}
              className="h-12 w-12 object-contain"
              loading="lazy"
              width="48"
              height="48"
            />
          )}
          <div>
            <h3 className="text-xl font-bold">{vpn.name}</h3>
            {typeof vpn.star_rating === 'number' && (
              <div className="mt-1">
                <StarRating rating={vpn.star_rating / 2} />
              </div>
            )}
            <div className="flex items-center gap-4 text-sm text-muted-foreground mt-2">
              {shouldShowServers && vpn.server_count && (
                <div className="flex items-center gap-1.5">
                  <Server className="size-4" />
                  <span>
                    <span className="font-semibold">
                      {vpn.server_count.toLocaleString()}
                    </span>{' '}
                    Servers
                  </span>
                </div>
              )}
              {shouldShowCountries && vpn.country_count && (
                <div className="flex items-center gap-1.5">
                  <MapPin className="size-4" />
                  <span>
                    <span className="font-semibold">{vpn.country_count}</span>{' '}
                    Countries
                  </span>
                </div>
              )}
            </div>
          </div>
        </div>

        <div className="p-6 flex-grow space-y-4">
          {vpn.categories && vpn.categories.length > 0 && (
            <div className="flex flex-wrap gap-2">
              {vpn.categories.map((category) => (
                <span
                  key={category}
                  className="px-2.5 py-1 text-xs font-semibold bg-primary/10 text-primary rounded-full"
                >
                  {category}
                </span>
              ))}
            </div>
          )}

          <div className="space-y-2 text-sm">
            <div className="flex items-center gap-2">
              {vpn.keeps_logs ? (
                <ShieldAlert className="h-5 w-5 text-red-500" />
              ) : (
                <ShieldCheck className="h-5 w-5 text-green-500" />
              )}
              <span className="text-muted-foreground">
                {vpn.keeps_logs ? 'Keeps Logs' : 'No-Logs Policy'}
              </span>
            </div>
            {vpn.has_court_proof && (
              <div className="flex items-center gap-2">
                <Gavel className="h-5 w-5 text-blue-500" />
                <span className="text-muted-foreground">Proven in Court</span>
              </div>
            )}
            {vpn.based_in_country_name && (
              <div className="flex items-center gap-2">
                <MapPin className="h-5 w-5 text-sky-500" />
                <span className="text-muted-foreground">
                  Based in {vpn.based_in_country_name}
                </span>
              </div>
            )}

            {vpn.has_double_vpn && (
              <div className="flex items-center gap-2">
                <Server className="h-5 w-5 text-purple-500" />
                <span className="text-muted-foreground">Double VPN</span>
              </div>
            )}
          </div>

          {vpn.pros && vpn.pros.length > 0 && (
            <div>
              <h4 className="font-semibold mb-2 text-sm">Pros:</h4>
              <ul className="space-y-1 text-sm">
                {vpn.pros.map((pro, i) => (
                  <li key={`pro-${i}`} className="flex items-start gap-2">
                    <CheckCircle className="h-4 w-4 mt-0.5 text-green-500 flex-shrink-0" />
                    <span className="text-muted-foreground">{pro}</span>
                  </li>
                ))}
              </ul>
            </div>
          )}

          {vpn.cons && vpn.cons.length > 0 && (
            <div>
              <h4 className="font-semibold mb-2 text-sm">Cons:</h4>
              <ul className="space-y-1 text-sm">
                {vpn.cons.map((con, i) => (
                  <li key={`con-${i}`} className="flex items-start gap-2">
                    <XCircle className="h-4 w-4 mt-0.5 text-red-500 flex-shrink-0" />
                    <span className="text-muted-foreground">{con}</span>
                  </li>
                ))}
              </ul>
            </div>
          )}

          {supportedDevices.length > 0 && (
            <div>
              <h4 className="font-semibold mb-2 text-sm">Supported Devices:</h4>
              <div className="flex items-center flex-wrap gap-3 text-muted-foreground">
                {supportedDevices.map((device: string) => {
                  const Icon = deviceIcons[device];
                  return Icon ? (
                    <Tooltip key={device}>
                      <TooltipTrigger asChild>
                        <span>
                          <Icon className="h-5 w-5" />
                        </span>
                      </TooltipTrigger>
                      <TooltipContent>
                        <p>
                          {device.charAt(0).toUpperCase() + device.slice(1)}
                        </p>
                      </TooltipContent>
                    </Tooltip>
                  ) : null;
                })}
              </div>
            </div>
          )}

          {shouldShowSimultaneousConnections &&
            vpn.simultaneous_connections && (
              <div>
                <h4 className="font-semibold mb-2 text-sm">
                  Simultaneous Connections:
                </h4>
                <div className="flex items-center gap-2 text-sm text-muted-foreground">
                  <Smartphone className="h-5 w-5" />
                  <span>
                    {vpn.simultaneous_connections} device
                    {vpn.simultaneous_connections === 1 ? '' : 's'} at once
                  </span>
                </div>
              </div>
            )}
        </div>

        <div className="p-6 mt-auto bg-card-foreground/5 space-y-4">
          <div className="flex justify-center items-end gap-4 text-center min-h-[28px]">
            {shouldShowUSD && (
              <p className="text-lg font-bold">
                ${priceUSD.toFixed(2)}
                <span className="text-sm font-normal text-muted-foreground">
                  /mo
                </span>
              </p>
            )}
            {shouldShowEUR && (
              <p className="text-lg font-bold text-muted-foreground/80">
                €{priceEUR.toFixed(2)}
                <span className="text-sm font-normal text-muted-foreground">
                  /mo
                </span>
              </p>
            )}
          </div>
          <Button
            onClick={async () => {
              await trackAffiliateClick(vpn.id);
              if (vpn.affiliate_link) {
                window.open(
                  vpn.affiliate_link,
                  '_blank',
                  'noopener,noreferrer'
                );
              }
            }}
            className="w-full font-bold"
            disabled={!vpn.affiliate_link}
          >
            View Deal
          </Button>
        </div>
      </motion.div>
    </TooltipProvider>
  );
}
