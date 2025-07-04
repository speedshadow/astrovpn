'use client';

import React from 'react';
import {
  Share2,
  ShieldOff,
  Ban,
  Server,
  GitFork,
  Gavel,
  type LucideProps,
} from 'lucide-react';

const icons = {
  Share2,
  ShieldOff,
  Ban,
  Server,
  GitFork,
  Gavel,
};

export type FeatureIconName = keyof typeof icons;

interface FeatureIconProps extends LucideProps {
  name: FeatureIconName;
}

export const FeatureIcon = ({ name, ...props }: FeatureIconProps) => {
  const IconComponent = icons[name];

  if (!IconComponent) {
    return null; // Or a default fallback icon
  }

  return <IconComponent {...props} />;
};
