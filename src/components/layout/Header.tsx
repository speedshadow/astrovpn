import { useState, useEffect } from 'react';
import { Button } from '@/components/ui/button';
import { Sheet, SheetContent, SheetTrigger } from '@/components/ui/sheet';
import {
  Menu,
  Shield,
  Star,
  Trophy,
  BarChart,
  FileText,
  PlayCircle,
  Wrench,
  ChevronDown,
} from 'lucide-react';
import {
  NavigationMenu,
  NavigationMenuContent,
  NavigationMenuItem,
  NavigationMenuLink,
  NavigationMenuList,
  NavigationMenuTrigger,
  navigationMenuTriggerStyle,
} from '@/components/ui/navigation-menu';
import { cn } from '@/lib/utils';
import React from 'react';
import { ThemeToggle } from '@/components/ui/ThemeToggle';

interface NavLink {
  name: string;
  slug: string;
}

interface HeaderProps {
  vpnLinks: NavLink[];
}

const mainNav = [
  { href: '/#vpn-comparator', label: 'Compare', icon: BarChart },
  { href: '/blog', label: 'Blog', icon: FileText },
];

const bestVpnsMenu = {
  label: 'Best VPNs for...',
  icon: Trophy,
  items: [
    {
      title: 'Streaming',
      href: '/reviews/streaming',
      icon: PlayCircle,
      description:
        'Unblock your favorite shows and movies from anywhere in the world.',
    },
    // Add more items here in the future, e.g., for Gaming, Privacy, etc.
  ],
};

const toolsMenu = {
  label: 'Tools',
  icon: Wrench,
  items: [
    {
      title: 'Do I Leak?',
      href: '/tools/do-i-leak',
      icon: Shield,
      description:
        'Check for IP, DNS, and WebRTC leaks to ensure your VPN is working correctly.',
    },
    {
      title: 'VPN Comparator',
      href: '/vpn-comparator',
      icon: BarChart,
      description:
        'Compare VPNs side-by-side to find the best one for your needs.',
    },
  ],
};

const ListItem = React.forwardRef<
  React.ElementRef<'a'>,
  React.ComponentPropsWithoutRef<'a'> & { icon: React.ElementType }
>(({ className, title, children, icon: Icon, ...props }, ref) => {
  return (
    <li>
      <NavigationMenuLink asChild>
        <a
          ref={ref}
          className={cn(
            'block select-none space-y-1 rounded-md p-3 leading-none no-underline outline-none transition-colors hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground',
            className
          )}
          {...props}
        >
          <div className="flex items-center gap-3">
            <Icon className="h-6 w-6 text-primary" />
            <div className="text-sm font-medium leading-none">{title}</div>
          </div>
          <p className="line-clamp-2 text-sm leading-snug text-muted-foreground">
            {children}
          </p>
        </a>
      </NavigationMenuLink>
    </li>
  );
});
ListItem.displayName = 'ListItem';

export function Header({ vpnLinks }: HeaderProps) {
  const [isScrolled, setIsScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 10);
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <header
      className={`sticky top-0 z-50 w-full transition-all duration-300 ${isScrolled ? 'border-b bg-background/95 backdrop-blur-sm' : 'bg-transparent'}`}
    >
      <div className="container flex h-16 items-center justify-between">
        {/* Usar onClick em vez de href direto para evitar problemas de hidratação */}
        <a
          href="/"
          className="flex items-center gap-2 font-bold text-lg"
          onClick={(e) => {
            // Navegação manual para evitar problemas de hidratação
            e.preventDefault();
            window.location.href = '/';
          }}
        >
          <Shield className="h-6 w-6 text-primary" />
          <span>AstroVPN</span>
        </a>

        {/* Desktop Navigation */}
        <div className="hidden md:flex items-center gap-2">
          <NavigationMenu>
            <NavigationMenuList>
              {mainNav.map((link) => (
                <NavigationMenuItem key={link.href}>
                  <NavigationMenuLink href={link.href}>
                    <div
                      className={cn(
                        navigationMenuTriggerStyle(),
                        'flex items-center gap-2'
                      )}
                    >
                      <link.icon className="h-4 w-4" />
                      <span>{link.label}</span>
                    </div>
                  </NavigationMenuLink>
                </NavigationMenuItem>
              ))}

              <NavigationMenuItem>
                <NavigationMenuTrigger>
                  <Star className="h-4 w-4 mr-2" />
                  Reviews
                </NavigationMenuTrigger>
                <NavigationMenuContent>
                  <ul className="grid w-[400px] gap-3 p-4 md:w-[500px] lg:w-[600px] grid-cols-1">
                    {vpnLinks.map((vpn) => (
                      <ListItem
                        key={vpn.slug}
                        title={vpn.name}
                        href={`/vpn/${vpn.slug}`}
                        icon={Shield} // Using a generic icon for all
                      >
                        Read our full review of {vpn.name}.
                      </ListItem>
                    ))}
                  </ul>
                </NavigationMenuContent>
              </NavigationMenuItem>

              <NavigationMenuItem>
                <NavigationMenuTrigger>
                  <bestVpnsMenu.icon className="h-4 w-4 mr-2" />
                  {bestVpnsMenu.label}
                </NavigationMenuTrigger>
                <NavigationMenuContent>
                  <ul className="grid w-[400px] gap-3 p-4 md:w-[500px] lg:w-[600px] grid-cols-1">
                    {bestVpnsMenu.items.map((item) => (
                      <ListItem
                        key={item.title}
                        title={item.title}
                        href={item.href}
                        icon={item.icon}
                      >
                        {item.description}
                      </ListItem>
                    ))}
                  </ul>
                </NavigationMenuContent>
              </NavigationMenuItem>

              <NavigationMenuItem>
                <NavigationMenuTrigger>
                  <toolsMenu.icon className="h-4 w-4 mr-2" />
                  {toolsMenu.label}
                </NavigationMenuTrigger>
                <NavigationMenuContent>
                  <ul className="grid w-[400px] gap-3 p-4 md:w-[500px] lg:w-[600px] grid-cols-1">
                    {toolsMenu.items.map((item) => (
                      <ListItem
                        key={item.title}
                        title={item.title}
                        href={item.href}
                        icon={item.icon}
                      >
                        {item.description}
                      </ListItem>
                    ))}
                  </ul>
                </NavigationMenuContent>
              </NavigationMenuItem>
            </NavigationMenuList>
          </NavigationMenu>
        </div>

        <div className="flex items-center gap-2">
          <ThemeToggle />

          {/* Mobile Navigation */}
          <div className="md:hidden">
            <Sheet>
              <SheetTrigger asChild>
                <Button variant="outline" size="icon">
                  <Menu className="h-5 w-5" />
                  <span className="sr-only">Open menu</span>
                </Button>
              </SheetTrigger>
              <SheetContent side="right">
                <div className="grid gap-6 p-6">
                  <a
                    href="/"
                    className="flex items-center gap-2 font-bold text-lg"
                  >
                    <Shield className="h-6 w-6 text-primary" />
                    <span>AstroVPN</span>
                  </a>
                  <nav className="grid gap-4">
                    {mainNav.map((link) => (
                      <a
                        key={link.href}
                        href={link.href}
                        className="flex items-center gap-3 rounded-md p-2 text-lg font-medium hover:bg-accent"
                      >
                        <link.icon className="h-5 w-5" />
                        {link.label}
                      </a>
                    ))}
                    <div className="pt-2">
                      <h3 className="px-2 text-lg font-semibold flex items-center gap-3">
                        <bestVpnsMenu.icon className="h-5 w-5" />{' '}
                        {bestVpnsMenu.label}
                      </h3>
                      <div className="grid gap-1 mt-2">
                        {bestVpnsMenu.items.map((item) => (
                          <a
                            key={item.href}
                            href={item.href}
                            className="flex items-center gap-3 rounded-md py-2 pl-10 pr-2 text-base font-medium text-muted-foreground hover:bg-accent hover:text-foreground"
                          >
                            <item.icon className="h-5 w-5" />
                            {item.title}
                          </a>
                        ))}
                      </div>
                    </div>

                    <div className="pt-2">
                      <h3 className="px-2 text-lg font-semibold flex items-center gap-3">
                        <toolsMenu.icon className="h-5 w-5" /> {toolsMenu.label}
                      </h3>
                      <div className="grid gap-1 mt-2">
                        {toolsMenu.items.map((item) => (
                          <a
                            key={item.href}
                            href={item.href}
                            className="flex items-center gap-3 rounded-md py-2 pl-10 pr-2 text-base font-medium text-muted-foreground hover:bg-accent hover:text-foreground"
                          >
                            <item.icon className="h-5 w-5" />
                            {item.title}
                          </a>
                        ))}
                      </div>
                    </div>
                  </nav>
                </div>
              </SheetContent>
            </Sheet>
          </div>
        </div>
      </div>
    </header>
  );
}
