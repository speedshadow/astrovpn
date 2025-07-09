import React from 'react';
import { Button } from '@/components/ui/button';
import { Sheet, SheetContent, SheetTrigger } from '@/components/ui/sheet';
import { Menu, Rocket, type LucideIcon } from 'lucide-react';

interface NavLink {
  href: string;
  label: string;
  icon: LucideIcon;
}

interface MobileNavProps {
  navLinks: NavLink[];
  pathname: string;
}

const getLinkClass = (path: string, pathname: string) => {
  const baseClass =
    'mx-[-0.65rem] flex items-center gap-4 rounded-xl px-3 py-2 text-muted-foreground hover:text-foreground';
  return pathname.startsWith(path)
    ? `${baseClass} bg-muted text-foreground`
    : baseClass;
};

export function MobileNav({ navLinks, pathname }: MobileNavProps) {
  return (
    <Sheet>
      <SheetTrigger asChild>
        <Button variant="outline" size="icon" className="shrink-0 md:hidden">
          <Menu className="h-5 w-5" />
          <span className="sr-only">Toggle navigation menu</span>
        </Button>
      </SheetTrigger>
      <SheetContent side="left" className="flex flex-col">
        <nav className="grid gap-2 text-lg font-medium">
          <a
            href="/"
            className="flex items-center gap-2 text-lg font-semibold mb-4"
          >
            <Rocket className="h-6 w-6" />
            <span>AstroVPN Admin</span>
          </a>
          {navLinks.map((link) => (
            <a
              key={link.href}
              href={link.href}
              className={getLinkClass(link.href, pathname)}
            >
              <link.icon className="h-5 w-5" />
              {link.label}
            </a>
          ))}
        </nav>
      </SheetContent>
    </Sheet>
  );
}
