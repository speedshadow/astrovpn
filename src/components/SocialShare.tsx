'use client';

import { Facebook, Twitter, Mail, Linkedin } from 'lucide-react';
import { FaWhatsapp, FaReddit } from 'react-icons/fa';

interface SocialShareProps {
  url: string;
  title: string;
}

export const SocialShare = ({ url, title }: SocialShareProps) => {
  const encodedUrl = encodeURIComponent(url);
  const encodedTitle = encodeURIComponent(title);
  const textToShare = `Check out this post about ${title}!`;
  const encodedText = encodeURIComponent(textToShare);

  const shareLinks = [
    {
      name: 'Twitter',
      href: `https://twitter.com/intent/tweet?url=${encodedUrl}&text=${encodedText}`,
      icon: Twitter,
    },
    {
      name: 'Facebook',
      href: `https://www.facebook.com/sharer/sharer.php?u=${encodedUrl}`,
      icon: Facebook,
    },
    {
      name: 'WhatsApp',
      href: `https://api.whatsapp.com/send?text=${encodedText}%20${encodedUrl}`,
      icon: FaWhatsapp,
    },
    {
      name: 'LinkedIn',
      href: `https://www.linkedin.com/shareArticle?mini=true&url=${encodedUrl}&title=${encodedTitle}&summary=${encodedText}`,
      icon: Linkedin,
    },
    {
      name: 'Reddit',
      href: `https://www.reddit.com/submit?url=${encodedUrl}&title=${encodedTitle}`,
      icon: FaReddit,
    },
    {
      name: 'Email',
      href: `mailto:?subject=${encodedTitle}&body=${encodedText}%0A%0A${encodedUrl}`,
      icon: Mail,
    },
  ];

  return (
    <div className="fixed left-4 top-1/2 -translate-y-1/2 z-50 hidden lg:flex flex-col items-center gap-2 bg-card/80 backdrop-blur-sm border rounded-full p-2 shadow-lg">
      {shareLinks.map((link) => {
        const Icon = link.icon;
        return (
          <a
            key={link.name}
            href={link.href}
            target="_blank"
            rel="noopener noreferrer"
            title={`Share on ${link.name}`}
            className="text-muted-foreground hover:text-primary transition-colors p-2 rounded-full"
          >
            <Icon className="h-5 w-5" />
            <span className="sr-only">{link.name}</span>
          </a>
        );
      })}
    </div>
  );
};
