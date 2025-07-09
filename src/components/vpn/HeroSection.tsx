'use client';

import { motion } from 'framer-motion';
import { TypeAnimation } from 'react-type-animation';
import { Button } from '@/components/ui/button';
import { ArrowRight, ShieldCheck } from 'lucide-react';

export function HeroSection() {
  return (
    <section className="w-full pt-24 pb-12 sm:pt-32 sm:pb-16 flex flex-col justify-center items-center text-center px-4">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.8, ease: 'easeInOut' }}
        className="relative"
      >
        <div className="absolute -inset-2 bg-gradient-to-r from-cyan-400 to-indigo-600 rounded-full blur-3xl opacity-20"></div>
        <h1 className="relative text-5xl md:text-7xl font-bold bg-gradient-to-r from-cyan-400 via-blue-500 to-indigo-600 bg-clip-text text-transparent pb-4">
          Navigate the Web Anonymously
        </h1>
      </motion.div>
      <motion.p
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.8, delay: 0.2, ease: 'easeInOut' }}
        className="mt-4 text-lg md:text-xl text-muted-foreground max-w-2xl"
      >
        Unlock unrestricted access to global content and shield your digital footprint. We find the perfect VPN for your needs.
      </motion.p>
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
        className="mt-10 flex flex-col sm:flex-row gap-4"
      >
        <Button size="lg" className="group shadow-lg hover:shadow-xl transition-shadow">
          Find My Perfect VPN{' '}
          <ArrowRight className="ml-2 h-5 w-5 group-hover:translate-x-1 transition-transform" />
        </Button>
        <Button size="lg" variant="ghost" className="text-muted-foreground hover:text-foreground">
          <ShieldCheck className="mr-2 h-5 w-5" /> See Top Rankings
        </Button>
      </motion.div>
    </section>
  );
}
