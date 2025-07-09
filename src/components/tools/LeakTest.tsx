import React, { useState, useEffect, useCallback } from 'react';
import {
  CheckCircle2,
  AlertTriangle,
  XCircle,
  Loader2,
  MapPin,
  Server,
  Globe,
  RefreshCw,
} from 'lucide-react';
import { Button } from '@/components/ui/button';

// Type Definitions
interface IpInfo {
  ipv4: string | null;
  ipv6: string | null;
  city: string | null;
  country_name: string | null;
  org: string | null;
}

interface DnsServer {
  ip: string;
  country_name: string;
  isp: string;
}

type TestStatus = 'loading' | 'safe' | 'leak' | 'error' | 'results';

const statusIcons: Record<TestStatus, React.ReactNode> = {
  loading: <Loader2 className="h-6 w-6 animate-spin text-blue-500" />,
  safe: <CheckCircle2 className="h-6 w-6 text-green-500" />,
  leak: <AlertTriangle className="h-6 w-6 text-yellow-500" />,
  error: <XCircle className="h-6 w-6 text-red-500" />,
  results: <CheckCircle2 className="h-6 w-6 text-blue-500" />,
};

const ResultCard = ({
  title,
  status,
  children,
}: {
  title: string;
  status: TestStatus;
  children: React.ReactNode;
}) => (
  <div className="bg-gray-50 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg shadow-sm overflow-hidden">
    <div className="p-5 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between">
      <h2 className="text-xl font-semibold flex items-center gap-3">{title}</h2>
      {statusIcons[status]}
    </div>
    <div className="p-5">{children}</div>
  </div>
);

const InfoRow = ({
  icon,
  label,
  value,
}: {
  icon: React.ReactNode;
  label: string;
  value: string;
}) => (
  <div className="flex items-center gap-4 py-2">
    <div className="flex-shrink-0 text-gray-500 dark:text-gray-400">{icon}</div>
    <div className="flex-grow">
      <p className="text-sm text-gray-500 dark:text-gray-400">{label}</p>
      <p className="font-semibold text-gray-900 dark:text-gray-100">{value}</p>
    </div>
  </div>
);

const LeakTest = () => {
  const [ipInfo, setIpInfo] = useState<IpInfo>({
    ipv4: null,
    ipv6: null,
    city: null,
    country_name: null,
    org: null,
  });
  const [ipStatus, setIpStatus] = useState<TestStatus>('loading');

  const [dnsServers, setDnsServers] = useState<DnsServer[]>([]);
  const [dnsStatus, setDnsStatus] = useState<TestStatus>('loading');

  const [webrtcIps, setWebrtcIps] = useState<string[]>([]);
  const [webrtcStatus, setWebrtcStatus] = useState<TestStatus>('loading');

  const runIpAndDnsTests = useCallback(() => {
    setIpStatus('loading');
    setDnsStatus('loading');

    const ipleakPromise = fetch('https://api.ipleak.net/json/').then((res) => {
      if (!res.ok) throw new Error(`HTTP error! status: ${res.status}`);
      return res.json();
    });

    const ipv4Promise = fetch('https://api.ipify.org?format=json')
      .then((res) => res.json())
      .catch(() => ({ ip: null })); // Prevent Promise.all from failing if this one call fails

    Promise.all([ipleakPromise, ipv4Promise])
      .then(([ipleakData, ipv4Data]) => {
        const isIPv6 = (ip: string) => ip && ip.includes(':');

        const newIpInfo: IpInfo = {
          ipv4: ipv4Data?.ip || null,
          ipv6: isIPv6(ipleakData.ip) ? ipleakData.ip : null,
          city: ipleakData.city_name,
          country_name: ipleakData.country_name,
          org: ipleakData.isp_name || ipleakData.isp,
        };

        // If ipleak returned an IPv4, use it as the definitive source
        if (!isIPv6(ipleakData.ip)) {
          newIpInfo.ipv4 = ipleakData.ip;
        }

        setIpInfo(newIpInfo);
        setIpStatus('safe');

        // Handle DNS servers from ipleak data
        const servers = ipleakData.dns_servers || [];
        const formattedServers: DnsServer[] = servers.map((s: any) => ({
          ip: s.ip,
          country_name: s.country_name,
          isp: s.hostname,
        }));
        setDnsServers(formattedServers);
        setDnsStatus('results');
      })
      .catch((error) => {
        console.error('Leak test API error:', error);
        setIpStatus('error');
        setDnsStatus('error');
      });
  }, []);

  useEffect(() => {
    runIpAndDnsTests();

    // WebRTC Leak Test (Client-side)
    try {
      // @ts-ignore
      const RTCPeerConnection =
        window.RTCPeerConnection ||
        window.mozRTCPeerConnection ||
        window.webkitRTCPeerConnection;
      if (!RTCPeerConnection) {
        setWebrtcStatus('error');
        return;
      }
      const pc = new RTCPeerConnection({
        iceServers: [{ urls: 'stun:stun.l.google.com:19302' }],
      });
      const ips = new Set<string>();
      pc.createDataChannel('');
      pc.onicecandidate = (ice) => {
        if (!ice || !ice.candidate || !ice.candidate.candidate) return;
        const ipRegex =
          /([0-9]{1,3}(\.[0-9]{1,3}){3}|[a-f0-9]{1,4}(:[a-f0-9]{1,4}){7})/;
        const match = ipRegex.exec(ice.candidate.candidate);
        if (match) ips.add(match[1]);
      };
      pc.createOffer().then((offer) => pc.setLocalDescription(offer));
      setTimeout(() => {
        const foundIps = Array.from(ips);
        setWebrtcIps(foundIps);
        setWebrtcStatus(foundIps.length > 0 ? 'leak' : 'safe');
      }, 2000);
    } catch (e) {
      setWebrtcStatus('error');
    }
  }, [runIpAndDnsTests]);

  return (
    <div className="space-y-8">
      <ResultCard title="Public IP Address" status={ipStatus}>
        {ipStatus === 'loading' && <p>Testing your public IP address...</p>}
        {ipStatus === 'error' && (
          <div className="text-center">
            <p className="text-red-500 mb-4">
              Could not fetch your IP information.
            </p>
            <Button onClick={runIpAndDnsTests} variant="destructive" size="sm">
              <RefreshCw className="h-4 w-4 mr-2" />
              Try Again
            </Button>
          </div>
        )}
        {ipStatus === 'safe' && (
          <div className="divide-y divide-gray-200 dark:divide-gray-700">
            {ipInfo.ipv4 && (
              <InfoRow
                icon={<Globe className="h-5 w-5" />}
                label="IPv4 Address"
                value={ipInfo.ipv4}
              />
            )}
            {ipInfo.ipv6 && (
              <InfoRow
                icon={<Globe className="h-5 w-5" />}
                label="IPv6 Address"
                value={ipInfo.ipv6}
              />
            )}
            {ipInfo.city && ipInfo.country_name && (
              <InfoRow
                icon={<MapPin className="h-5 w-5" />}
                label="Location"
                value={`${ipInfo.city}, ${ipInfo.country_name}`}
              />
            )}
            {ipInfo.org && (
              <InfoRow
                icon={<Server className="h-5 w-5" />}
                label="Provider"
                value={ipInfo.org}
              />
            )}
          </div>
        )}
      </ResultCard>

      <ResultCard title="DNS Leak Test" status={dnsStatus}>
        {dnsStatus === 'loading' && <p>Testing for DNS leaks...</p>}
        {dnsStatus === 'error' && (
          <div className="text-center">
            <p className="text-red-500 mb-2">
              An error occurred while testing for DNS leaks.
            </p>
            <p className="text-sm text-gray-500 dark:text-gray-400 mb-4">
              This might be a network issue or a browser extension. Please check
              your connection and try again.
            </p>
            <Button onClick={runIpAndDnsTests} variant="destructive" size="sm">
              <RefreshCw className="h-4 w-4 mr-2" />
              Try Again
            </Button>
          </div>
        )}
        {dnsStatus === 'results' && (
          <div>
            <p className="mb-4 text-sm text-gray-600 dark:text-gray-400">
              Your DNS requests are handled by the servers below. If you're
              using a VPN, you should only see your VPN's DNS servers. If you
              see your regular ISP, you may have a DNS leak.
            </p>
            {dnsServers.length > 0 ? (
              <ul className="space-y-2">
                {dnsServers.map((server, index) => (
                  <li
                    key={index}
                    className="flex items-center gap-3 p-2 bg-gray-100 dark:bg-gray-900 rounded-md"
                  >
                    <Server className="h-5 w-5 text-blue-500" />
                    <div>
                      <span className="font-mono text-sm">{server.ip}</span>
                      <span className="text-xs text-gray-500 dark:text-gray-400">
                        {' '}
                        ({server.country_name} - {server.isp})
                      </span>
                    </div>
                  </li>
                ))}
              </ul>
            ) : (
              <p>
                No DNS servers detected. This could mean your connection is very
                secure, or there was an issue with the test.
              </p>
            )}
          </div>
        )}
      </ResultCard>

      <ResultCard title="WebRTC Leak Test" status={webrtcStatus}>
        {webrtcStatus === 'loading' && <p>Testing for WebRTC leaks...</p>}
        {webrtcStatus === 'error' && (
          <p className="text-red-500">
            WebRTC is not supported or an error occurred.
          </p>
        )}
        {webrtcStatus === 'safe' && (
          <p>No WebRTC leaks detected. Your real IP address is hidden.</p>
        )}
        {webrtcStatus === 'leak' && (
          <div>
            <p className="mb-4">
              WebRTC leak detected! Your real IP address may be exposed.
            </p>
            <ul className="space-y-2">
              {webrtcIps.map((ip, index) => (
                <li
                  key={index}
                  className="flex items-center gap-3 p-2 bg-gray-100 dark:bg-gray-900 rounded-md"
                >
                  <AlertTriangle className="h-5 w-5 text-red-500" />
                  <span className="font-mono text-sm">{ip}</span>
                </li>
              ))}
            </ul>
          </div>
        )}
      </ResultCard>
    </div>
  );
};

export default LeakTest;
