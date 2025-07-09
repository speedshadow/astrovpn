'use client';

'use client';

import type { Vpn } from '@/types';
import { HomepageContent } from './HomepageContent';
import { VpnComparator } from './VpnComparator';

interface HomepageProps {
  vpns: Vpn[];
}

/**
 * This component acts as the main entrypoint for the interactive
 * homepage section. It passes the server-fetched VPN data to its children.
 */
export function Homepage({ vpns }: HomepageProps) {
  return (
    <>
      <HomepageContent vpns={vpns} />
      <VpnComparator vpns={vpns} />
    </>
  );
}
