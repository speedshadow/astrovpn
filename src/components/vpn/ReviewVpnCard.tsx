'use client';

import { memo } from 'react';
import type { Vpn } from '@/types';
import { Button } from '@/components/ui/button';
import {
  Star,
  CheckCircle,
  XCircle,
  ChevronRight,
  Globe,
  Users,
  ShieldQuestion,
  Gavel,
  ShieldOff,
  Laptop,
  Apple,
  Smartphone,
  Bot, // Using for Linux as a generic tech icon
  Server,
  MapPin,
} from 'lucide-react';

interface ReviewVpnCardProps {
  vpn: Vpn;
  rank: number;
}

// Helper component for displaying a feature
const FeatureItem = ({
  icon,
  label,
  children,
}: {
  icon: React.ReactNode;
  label: string;
  children: React.ReactNode;
}) => (
  <div className="flex items-center space-x-2 text-sm">
    <div className="text-muted-foreground flex-shrink-0">{icon}</div>
    <div className="flex-grow">
      <div className="font-semibold text-foreground">{label}</div>
      <div className="text-muted-foreground">{children}</div>
    </div>
  </div>
);

// Helper for boolean features
const BooleanFeature = ({ value }: { value: boolean | undefined }) => (
  <span
    className={
      value ? 'text-green-600 font-semibold' : 'text-red-600 font-semibold'
    }
  >
    {value ? 'Yes' : 'No'}
  </span>
);

// Helper for device icons
const DeviceIcons = ({ devices }: { devices: Vpn['supported_devices'] }) => {
  let parsedDevices = devices;

  // Defensively parse if it's a string from the database
  if (typeof parsedDevices === 'string') {
    try {
      parsedDevices = JSON.parse(parsedDevices);
    } catch (_e) {
      console.error('Failed to parse supported_devices:', parsedDevices);
      return <span>N/A</span>; // Fail gracefully
    }
  }

  // Ensure it's a non-null object before proceeding
  if (!parsedDevices || typeof parsedDevices !== 'object') {
    return <span>N/A</span>;
  }

  const deviceMap: { [key: string]: React.ReactNode } = {
    windows: (
      <span title="Windows">
        <Laptop size={18} />
      </span>
    ),
    macos: (
      <span title="macOS">
        <Apple size={18} />
      </span>
    ),
    linux: (
      <span title="Linux">
        <Bot size={18} />
      </span>
    ),
    android: (
      <span title="Android">
        <Smartphone size={18} />
      </span>
    ),
    ios: (
      <span title="iOS">
        <Smartphone size={18} />
      </span>
    ),
  };

  const supportedDevices = Object.entries(parsedDevices)
    .filter(([, isSupported]) => isSupported)
    .map(([key]) => deviceMap[key])
    .filter(Boolean);

  if (supportedDevices.length === 0) return <span>N/A</span>;

  return (
    <div className="flex items-center space-x-2">
      {supportedDevices.map((icon, i) => (
        <div key={i}>{icon}</div>
      ))}
    </div>
  );
};

// Main component implementation
const ReviewVpnCardComponent = ({ vpn, rank }: ReviewVpnCardProps) => {
  return (
    <div className="not-prose relative overflow-hidden rounded-xl border bg-card text-card-foreground shadow-lg transition-shadow hover:shadow-xl">
      <div className="p-6">
        <div className="grid grid-cols-1 md:grid-cols-12 gap-6 items-center">
          {/* Rank & Logo */}
          <div className="md:col-span-3 flex flex-col items-center text-center">
            <div className="flex items-center justify-center w-16 h-16 rounded-full bg-primary/10 border-2 border-primary mb-4">
              <span className="text-3xl font-bold text-primary">{rank}</span>
            </div>
            <img
              src={vpn.logo_url ?? ''}
              alt={`${vpn.name} logo`}
              className="h-12 max-w-full object-contain mb-2"
            />
            <h3 className="text-lg font-bold">{vpn.name}</h3>
          </div>

          {/* Pros & Cons */}
          <div className="md:col-span-6">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <h4 className="font-semibold mb-2 text-green-600">Pros</h4>
                <ul className="space-y-1 text-sm list-none p-0">
                  {vpn.pros?.slice(0, 3).map((pro, i) => (
                    <li key={i} className="flex items-start m-0 p-0">
                      <CheckCircle className="h-4 w-4 mr-2 mt-0.5 text-green-500 flex-shrink-0" />
                      <span>{pro}</span>
                    </li>
                  ))}
                </ul>
              </div>
              <div>
                <h4 className="font-semibold mb-2 text-red-600">Cons</h4>
                <ul className="space-y-1 text-sm list-none p-0">
                  {vpn.cons?.slice(0, 2).map((con, i) => (
                    <li key={i} className="flex items-start m-0 p-0">
                      <XCircle className="h-4 w-4 mr-2 mt-0.5 text-red-500 flex-shrink-0" />
                      <span>{con}</span>
                    </li>
                  ))}
                </ul>
              </div>
            </div>
          </div>

          {/* Rating & CTA */}
          <div className="md:col-span-3 flex flex-col items-center text-center space-y-4">
            {vpn.star_rating && (
              <div className="flex items-center space-x-1">
                <span className="text-2xl font-bold">
                  {vpn.star_rating.toFixed(1)}
                </span>
                <div className="flex text-yellow-400">
                  {[...Array(5)].map((_, i) => (
                    <Star
                      key={i}
                      className={`h-5 w-5 ${i < Math.round(vpn.star_rating!) ? 'fill-current' : 'text-gray-300'}`}
                    />
                  ))}
                </div>
              </div>
            )}
            <Button
              asChild
              size="lg"
              className="w-full bg-green-600 hover:bg-green-700"
            >
              <a
                href={vpn.affiliate_link ?? '#'}
                target="_blank"
                rel="noopener noreferrer nofollow"
              >
                Visit Site <ChevronRight className="h-4 w-4 ml-2" />
              </a>
            </Button>
            <Button variant="outline" size="sm" asChild>
              <a href={`/vpn/${vpn.slug}`}>
                Read full review
                <ChevronRight className="w-4 h-4 ml-1" />
              </a>
            </Button>
          </div>
        </div>
      </div>

      {/* Key Features Section */}
      <div className="px-6 py-4 border-t bg-muted/30">
        <div className="grid grid-cols-2 md:grid-cols-3 gap-x-4 gap-y-5">
          <FeatureItem icon={<Globe size={24} />} label="Based In">
            {vpn.based_in_country_name || 'N/A'}
          </FeatureItem>
          <FeatureItem icon={<Users className="w-5 h-5" />} label="Connections">
            {vpn.simultaneous_connections || 'N/A'}
          </FeatureItem>

          {vpn.server_count && vpn.server_count > 0 && (
            <FeatureItem icon={<Server className="w-5 h-5" />} label="Servers">
              {vpn.server_count.toLocaleString()}
            </FeatureItem>
          )}

          {vpn.country_count && vpn.country_count > 0 && (
            <FeatureItem
              icon={<MapPin className="w-5 h-5" />}
              label="Countries"
            >
              {vpn.country_count}
            </FeatureItem>
          )}
          <FeatureItem icon={<ShieldQuestion size={24} />} label="Keeps Logs?">
            <BooleanFeature value={vpn.keeps_logs === false} />
          </FeatureItem>
          <FeatureItem icon={<Gavel size={24} />} label="Court Proof">
            <BooleanFeature value={vpn.has_court_proof} />
          </FeatureItem>
          <FeatureItem icon={<ShieldOff size={24} />} label="Ad Blocker">
            <BooleanFeature value={vpn.has_ad_blocker} />
          </FeatureItem>
          <FeatureItem icon={<Laptop size={24} />} label="Devices">
            <DeviceIcons devices={vpn.supported_devices} />
          </FeatureItem>
        </div>
      </div>
      {vpn.description && (
        <div className="px-6 py-4 bg-muted/50 border-t">
          <p className="text-sm text-muted-foreground italic">
            {vpn.description}
          </p>
        </div>
      )}
    </div>
  );
};

export const ReviewVpnCard = memo(ReviewVpnCardComponent);
