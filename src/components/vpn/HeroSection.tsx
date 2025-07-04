'use client';

import { motion } from 'framer-motion';
import { TypeAnimation } from 'react-type-animation';
import { Button } from '@/components/ui/button';
import { ArrowRight, ShieldCheck } from 'lucide-react';

export function HeroSection() {
  return (
    <section className="w-full pt-24 pb-12 sm:pt-32 sm:pb-16 flex flex-col justify-center items-center text-center px-4">
      <motion.h1
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.8, ease: 'easeInOut' }}
        className="text-5xl md:text-7xl font-bold bg-gradient-to-r from-purple-500 via-pink-500 to-red-500 bg-clip-text text-transparent pb-4"
      >
        Secure Your Digital World
      </motion.h1>
      <TypeAnimation
        sequence={[
          'Stream anything, anywhere.',
          1500,
          'Protect your privacy online.',
          1500,
          'Get the fastest VPN speeds.',
          1500,
        ]}
        wrapper="h2"
        speed={50}
        className="text-xl md:text-2xl text-muted-foreground mt-4"
        repeat={Infinity}
      />
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.8, delay: 0.5, ease: 'easeInOut' }}
        className="mt-8 flex gap-4"
      >
        <Button size="lg" className="group">
          Get Started <ArrowRight className="ml-2 h-5 w-5 group-hover:translate-x-1 transition-transform" />
        </Button>
        <Button size="lg" variant="outline">
          <ShieldCheck className="mr-2 h-5 w-5" /> How It Works
        </Button>
      </motion.div>
    </section>
  );
}
