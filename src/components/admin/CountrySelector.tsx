'use client';

import * as React from 'react';
import { Check, ChevronsUpDown } from 'lucide-react';

import { cn } from '@/lib/utils';
import { Button } from '@/components/ui/button';
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
} from '@/components/ui/command';
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from '@/components/ui/popover';
import { countries, type Country } from '@/lib/countries';

interface CountrySelectorProps {
  selectedCountryName: string | null;
  onSelect: (country: Country) => void;
}

export function CountrySelector({
  selectedCountryName,
  onSelect,
}: CountrySelectorProps) {
  const [open, setOpen] = React.useState(false);

  const selectedCountry =
    countries.find((c) => c.name === selectedCountryName) || null;

  return (
    <Popover open={open} onOpenChange={setOpen}>
      <PopoverTrigger asChild>
        <Button
          variant="outline"
          role="combobox"
          aria-expanded={open}
          className="w-full justify-between"
        >
          {selectedCountry ? (
            <>
              {selectedCountry.flag} {selectedCountry.name}
            </>
          ) : (
            'Select country...'
          )}
          <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
        </Button>
      </PopoverTrigger>
      <PopoverContent className="w-[--radix-popover-trigger-width] p-0">
        <Command>
          <CommandInput placeholder="Search country..." />
          <CommandEmpty>No country found.</CommandEmpty>
          <CommandGroup className="max-h-60 overflow-y-auto">
            {countries.map((country) => (
              <CommandItem
                key={country.name}
                value={country.name}
                onSelect={(currentValue) => {
                  const selected = countries.find(
                    (c) => c.name.toLowerCase() === currentValue.toLowerCase()
                  );
                  if (selected) {
                    onSelect(selected);
                  }
                  setOpen(false);
                }}
              >
                <Check
                  className={cn(
                    'mr-2 h-4 w-4',
                    selectedCountryName === country.name
                      ? 'opacity-100'
                      : 'opacity-0'
                  )}
                />
                {country.flag} {country.name}
              </CommandItem>
            ))}
          </CommandGroup>
        </Command>
      </PopoverContent>
    </Popover>
  );
}
