'use client';

import React from 'react';
import {
  FaWindows,
  FaApple,
  FaLinux,
  FaAndroid,
  FaChrome,
  FaFirefox,
  FaEdge,
} from 'react-icons/fa';
import { SiBrave } from 'react-icons/si';
import { FiTv } from 'react-icons/fi';
import { BsRouter } from 'react-icons/bs';
import type { IconType } from 'react-icons';

const iconMap: { [key: string]: IconType } = {
  windows: FaWindows,
  macos: FaApple,
  linux: FaLinux,
  android: FaAndroid,
  ios: FaApple,
  chrome: FaChrome,
  firefox: FaFirefox,
  brave: SiBrave,
  edge: FaEdge,
  tv: FiTv,
  router: BsRouter,
};

interface PlatformIconProps {
  platform: string;
  className?: string;
}

export const PlatformIcon = ({ platform, className }: PlatformIconProps) => {
  const platformKey = platform.toLowerCase().replace(/\s/g, '');
  const IconComponent = iconMap[platformKey];

  if (!IconComponent) {
    return null; // Don't render anything if no icon is found
  }

  return <IconComponent className={className} />;
};
