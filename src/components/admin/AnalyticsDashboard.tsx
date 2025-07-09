'use client';

import { useEffect, useState } from 'react';
import { supabase } from '@/lib/supabase';
import { StatCard } from './StatCard';
import { Users, MousePointerClick, Eye, BarChart } from 'lucide-react';

interface AnalyticsData {
  online: number;
  today: number;
  month: number;
  year: number;
  clicks: number;
  blogViews: number;
}

export function AnalyticsDashboard() {
  const [data, setData] = useState<AnalyticsData | null>(null);
  const [loading, setLoading] = useState(true);

  const fetchStats = async () => {
    const rpcCalls = [
      supabase.rpc('get_online_visitors_count'),
      supabase.rpc('get_today_visitors_count'),
      supabase.rpc('get_monthly_visitors_count'),
      supabase.rpc('get_yearly_visitors_count'),
      supabase.rpc('get_total_affiliate_clicks'),
      supabase.rpc('get_total_blog_post_views'),
    ];

    const [online, today, month, year, clicks, blogViews] =
      await Promise.all(rpcCalls);

    setData({
      online: online.data ?? 0,
      today: today.data ?? 0,
      month: month.data ?? 0,
      year: year.data ?? 0,
      clicks: clicks.data ?? 0,
      blogViews: blogViews.data ?? 0,
    });
    setLoading(false);
  };

  const fetchOnlineCount = async () => {
    const { data: onlineCount } = await supabase.rpc(
      'get_online_visitors_count'
    );
    if (onlineCount !== null) {
      setData((prevData) =>
        prevData ? { ...prevData, online: onlineCount } : null
      );
    }
  };

  useEffect(() => {
    fetchStats();
    // Atualiza os visitantes online a cada 30 segundos
    const interval = setInterval(fetchOnlineCount, 30000);
    return () => clearInterval(interval);
  }, []);

  if (loading) {
    return <p>Loading statistics...</p>;
  }

  if (!data) {
    return <p>Could not load analytics data.</p>;
  }

  return (
    <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6">
      <StatCard
        title="Online Now"
        value={data.online}
        icon={<Users className="h-4 w-4 text-muted-foreground" />}
        description="Visitors in the last 5 minutes"
      />
      <StatCard
        title="Visitors Today"
        value={data.today}
        icon={<Eye className="h-4 w-4 text-muted-foreground" />}
      />
      <StatCard
        title="Visitors (Month)"
        value={data.month}
        icon={<BarChart className="h-4 w-4 text-muted-foreground" />}
      />
      <StatCard
        title="Visitors (Year)"
        value={data.year}
        icon={<BarChart className="h-4 w-4 text-muted-foreground" />}
      />
      <StatCard
        title="Affiliate Clicks"
        value={data.clicks}
        icon={<MousePointerClick className="h-4 w-4 text-muted-foreground" />}
        description="Total clicks on affiliate links"
      />
      <StatCard
        title="Blog Post Views"
        value={data.blogViews}
        icon={<Eye className="h-4 w-4 text-muted-foreground" />}
        description="Total views on individual posts"
      />
    </div>
  );
}
