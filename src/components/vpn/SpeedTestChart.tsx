import React, { useState, useEffect } from 'react';
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Label,
  Cell,
} from 'recharts';

interface SpeedTestData {
  country: string;
  speed: number | null;
}

interface SpeedTestChartProps {
  data: SpeedTestData[];
}

const CustomTooltip = ({ active, payload, label }: any) => {
  if (active && payload && payload.length) {
    return (
      <div className="p-3 bg-card/90 backdrop-blur-sm border border-border/50 rounded-lg shadow-xl">
        <p className="font-bold text-card-foreground">{label}</p>
        <p className="text-sm text-primary font-semibold">{`Speed: ${payload[0].value} Mbps`}</p>
      </div>
    );
  }
  return null;
};

export const SpeedTestChart: React.FC<SpeedTestChartProps> = ({ data }) => {
  const [isDark, setIsDark] = useState(false);

  useEffect(() => {
    const checkTheme = () => {
      setIsDark(document.documentElement.classList.contains('dark'));
    };
    checkTheme();
    const observer = new MutationObserver(checkTheme);
    observer.observe(document.documentElement, {
      attributes: true,
      attributeFilter: ['class'],
    });
    return () => observer.disconnect();
  }, []);

  const chartData = data.filter((d) => d.speed !== null && d.country);

  if (chartData.length === 0) {
    return (
      <div className="flex items-center justify-center h-[300px] text-muted-foreground bg-muted/50 rounded-lg">
        No speed test data available.
      </div>
    );
  }

  const colors = {
    light: { grid: '#e5e7eb', text: '#6b7281', bar: '#2563eb' },
    dark: { grid: '#374151', text: '#9ca3af', bar: '#3b82f6' },
  };

  const themeColors = isDark ? colors.dark : colors.light;

  return (
    <div style={{ width: '100%', height: 350 }}>
      <ResponsiveContainer>
        <BarChart
          data={chartData}
          margin={{ top: 20, right: 20, left: 20, bottom: 5 }}
        >
          <CartesianGrid
            strokeDasharray="3 3"
            stroke={themeColors.grid}
            vertical={false}
          />
          <XAxis
            dataKey="country"
            tickLine={false}
            axisLine={false}
            tick={{ fill: themeColors.text, fontSize: 12 }}
          />
          <YAxis
            stroke={themeColors.text}
            axisLine={false}
            tickLine={false}
            tick={{ fill: themeColors.text, fontSize: 12 }}
            tickFormatter={(value) => `${value} Mbps`}
          />
          <Tooltip
            content={<CustomTooltip />}
            cursor={{
              fill: isDark ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.1)',
            }}
          />
          <Bar dataKey="speed" radius={[4, 4, 0, 0]} maxBarSize={80}>
            {chartData.map((entry, index) => (
              <Cell key={`cell-${index}`} fill={themeColors.bar} />
            ))}
          </Bar>
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
};
