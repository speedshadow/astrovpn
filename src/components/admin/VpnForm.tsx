import React, { useState } from 'react';
import { supabase } from '@/lib/supabase'; // Import client-side Supabase
import type { Vpn } from '@/types';
import { CountrySelector } from './CountrySelector';
import type { Country } from '@/lib/countries';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import { Textarea } from '@/components/ui/textarea';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

import { Trash2, PlusCircle } from 'lucide-react';

interface VpnFormProps {
  vpnToEdit?: Vpn;
}

// Define types for better safety
type DetailedRatings = NonNullable<Vpn['detailed_ratings']>;
type SupportedDevices = NonNullable<Vpn['supported_devices']>;
type SpeedTestResult = { country: string; speed: number | null };
type BooleanVpnProps =
  | 'keeps_logs'
  | 'has_court_proof'
  | 'has_double_vpn'
  | 'has_coupon'
  | 'show_on_homepage'
  | 'has_p2p'
  | 'has_kill_switch'
  | 'has_ad_blocker'
  | 'has_split_tunneling';

// Default state for a new VPN entry, matching the detailed schema
const defaultVpnState: Omit<Vpn, 'id'> = {
  name: '',
  slug: '',
  logo_url: '',
  description: '',
  categories: [],
  star_rating: 0,
  affiliate_link: '',
  price_monthly_usd: null,
  price_yearly_usd: null,
  price_monthly_eur: null,
  price_yearly_eur: null,
  detailed_ratings: {
    speed: 0,
    streaming: 0,
    privacy: 0,
    torrenting: 0,
    features: 0,
    user_experience: 0,
  },
  supported_devices: {
    windows: false,
    macos: false,
    linux: false,
    android: false,
    ios: false,
    router: false,
    tv: false,
  },
  pros: [],
  cons: [],
  keeps_logs: false,
  has_court_proof: false,
  has_double_vpn: false,
  has_coupon: false,
  show_on_homepage: true,
  court_proof_content: '',
  based_in_country_name: '',
  based_in_country_flag: '',
  coupon_code: '',
  coupon_validity: null,
  full_review: '',
  has_p2p: false,
  has_kill_switch: false,
  server_count: 0,
  country_count: 0,
  has_ad_blocker: false,
  has_split_tunneling: false,
  simultaneous_connections: null,
  speed_test_results: [],
};

export const VpnForm = ({ vpnToEdit }: VpnFormProps) => {
  const [vpn, setVpn] = useState(() => {
    if (!vpnToEdit) {
      return defaultVpnState;
    }
    const deviceObject = { ...defaultVpnState.supported_devices };
    if (Array.isArray(vpnToEdit.supported_devices)) {
      for (const device of vpnToEdit.supported_devices) {
        if (device in deviceObject) {
          deviceObject[device as keyof typeof deviceObject] = true;
        }
      }
    }
    return {
      ...vpnToEdit,
      supported_devices: deviceObject,
      speed_test_results: vpnToEdit.speed_test_results || [],
    };
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [logoFile, setLogoFile] = useState<File | null>(null);
  const [proInput, setProInput] = useState('');
  const [conInput, setConInput] = useState('');
  const [categoryInput, setCategoryInput] = useState(
    vpnToEdit?.categories?.join(', ') || ''
  );

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);

    let logoUrlToSubmit = vpn.logo_url;

    if (logoFile) {
      const fileExt = logoFile.name.split('.').pop();
      const fileName = `${Date.now()}.${fileExt}`;
      const filePath = `logos/${fileName}`;

      const { error: uploadError } = await supabase.storage
        .from('vpn-assets')
        .upload(filePath, logoFile);

      if (uploadError) {
        alert(`Error uploading logo: ${uploadError.message}`);
        setIsSubmitting(false);
        return;
      }

      const { data: urlData } = supabase.storage
        .from('vpn-assets')
        .getPublicUrl(filePath);

      logoUrlToSubmit = urlData.publicUrl;
    }

    const supportedDevicesArray = Object.entries(vpn.supported_devices || {})
      .filter(([, value]) => value)
      .map(([key]) => key);

    let responseError = null;

    if ('id' in vpn && vpn.id) {
      // UPDATE LOGIC
      const { id, ...restOfVpn } = vpn;
      const updateData = {
        ...restOfVpn,
        logo_url: logoUrlToSubmit,
        pros: vpn.pros?.filter((p) => p.trim()) ?? [],
        cons: vpn.cons?.filter((c) => c.trim()) ?? [],
        categories: categoryInput
          .split(',')
          .map((c) => c.trim())
          .filter(Boolean),
        supported_devices: supportedDevicesArray,
        speed_test_results:
          vpn.speed_test_results?.filter(
            (st: SpeedTestResult) => st.country && st.speed != null
          ) ?? [],
      };
      const { error } = await supabase
        .from('vpns')
        .update(updateData)
        .eq('id', id);
      responseError = error;
    } else {
      // INSERT LOGIC
      const insertData = {
        ...vpn,
        logo_url: logoUrlToSubmit,
        pros: vpn.pros?.filter((p) => p.trim()) ?? [],
        cons: vpn.cons?.filter((c) => c.trim()) ?? [],
        categories: categoryInput
          .split(',')
          .map((c) => c.trim())
          .filter(Boolean),
        supported_devices: supportedDevicesArray,
        speed_test_results:
          vpn.speed_test_results?.filter(
            (st: SpeedTestResult) => st.country && st.speed != null
          ) ?? [],
      };
      const { error } = await supabase.from('vpns').insert([insertData]);
      responseError = error;
    }

    setIsSubmitting(false);
    if (!responseError) {
      alert(
        'id' in vpn ? 'VPN updated successfully!' : 'VPN created successfully!'
      );
      window.location.href = '/admin/vpn';
    } else {
      alert(`Error: ${responseError.message}`);
    }
  };

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      setLogoFile(e.target.files[0]);
    }
  };

  const handleCountrySelect = (country: Country) => {
    setVpn((prev) => ({
      ...prev,
      based_in_country_name: country.name,
      based_in_country_flag: country.flag,
    }));
  };

  const slugify = (text: string) =>
    text
      .toString()
      .toLowerCase()
      .trim()
      .replace(/\s+/g, '-') // Replace spaces with -
      .replace(/[^\w-]+/g, '') // Remove all non-word chars
      .replace(/--+/g, '-'); // Replace multiple - with single -

  const handleInputChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) => {
    const { name, value, type } = e.target;
    const isNumber = type === 'number';

    if (name === 'name') {
      const newSlug = slugify(value);
      setVpn((prev) => ({
        ...prev,
        name: value,
        slug: newSlug,
      }));
    } else {
      setVpn((prev) => ({
        ...prev,
        [name]: isNumber ? (value === '' ? null : parseFloat(value)) : value,
      }));
    }
  };

  const handleNestedRatingChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setVpn((prev) => ({
      ...prev,
      detailed_ratings: {
        ...(prev.detailed_ratings ?? {}),
        [name]: parseFloat(value),
      },
    }));
  };

  const handleSwitchChange = (checked: boolean, name: string) => {
    const booleanKeys: BooleanVpnProps[] = [
      'keeps_logs',
      'has_court_proof',
      'has_double_vpn',
      'has_coupon',
      'show_on_homepage',
      'has_p2p',
      'has_kill_switch',
      'has_ad_blocker',
      'has_split_tunneling',
    ];

    if (vpn.supported_devices && name in vpn.supported_devices) {
      setVpn((prev) => ({
        ...prev,
        supported_devices: {
          ...prev.supported_devices!,
          [name as keyof SupportedDevices]: checked,
        },
      }));
    } else if (booleanKeys.includes(name as BooleanVpnProps)) {
      setVpn((prev) => ({ ...prev, [name as BooleanVpnProps]: checked }));
    }
  };

  const handleSpeedTestChange = (
    index: number,
    field: 'country' | 'speed',
    value: string
  ) => {
    const newSpeedTests = [...(vpn.speed_test_results || [])];
    const currentTest = { ...newSpeedTests[index] };

    if (field === 'country') {
      currentTest.country = value;
    } else if (field === 'speed') {
      currentTest.speed = value === '' ? null : parseFloat(value);
    }

    newSpeedTests[index] = currentTest;
    setVpn((prev) => ({ ...prev, speed_test_results: newSpeedTests }));
  };

  const addSpeedTest = () => {
    setVpn((prev) => ({
      ...prev,
      speed_test_results: [
        ...(prev.speed_test_results || []),
        { country: '', speed: null },
      ],
    }));
  };

  const removeSpeedTest = (index: number) => {
    setVpn((prev) => ({
      ...prev,
      speed_test_results: (prev.speed_test_results || []).filter(
        (_: SpeedTestResult, i: number) => i !== index
      ),
    }));
  };

  const handleListChange = (
    listName: 'pros' | 'cons',
    action: 'add' | 'remove',
    value?: string | number
  ) => {
    if (action === 'add') {
      const newItem = listName === 'pros' ? proInput : conInput;
      if (newItem.trim() === '') return;
      setVpn((prev) => ({
        ...prev,
        [listName]: [...(prev[listName] || []), newItem],
      }));
      if (listName === 'pros') setProInput('');
      else setConInput('');
    } else if (action === 'remove') {
      setVpn((prev) => ({
        ...prev,
        [listName]: (prev[listName] || []).filter((_, i) => i !== value),
      }));
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle>Basic Information</CardTitle>
        </CardHeader>
        <CardContent className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="space-y-1.5">
            <Label htmlFor="name">VPN Name</Label>
            <Input
              id="name"
              name="name"
              value={vpn.name}
              onChange={handleInputChange}
              placeholder="CyberGuard VPN"
              required
            />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="slug">Slug (auto-generated)</Label>
            <Input
              id="slug"
              name="slug"
              value={vpn.slug}
              placeholder="cyberguard-vpn"
              required
              readOnly
              className="bg-muted/50"
            />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="logo_file">Logo Upload</Label>
            <Input
              id="logo_file"
              type="file"
              onChange={handleFileChange}
              accept="image/png, image/jpeg, image/svg+xml"
            />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="affiliate_link">Affiliate Link</Label>
            <Input
              id="affiliate_link"
              name="affiliate_link"
              value={vpn.affiliate_link || ''}
              onChange={handleInputChange}
              placeholder="https://cyberguard.com/offer"
            />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="star_rating">Star Rating (0-10)</Label>
            <Input
              id="star_rating"
              name="star_rating"
              type="number"
              step="0.1"
              min="0"
              max="10"
              value={vpn.star_rating ?? ''}
              onChange={handleInputChange}
            />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="server_count">Server Count</Label>
            <Input
              id="server_count"
              name="server_count"
              type="number"
              value={vpn.server_count ?? ''}
              onChange={handleInputChange}
            />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="country_count">Country Count</Label>
            <Input
              id="country_count"
              name="country_count"
              type="number"
              value={vpn.country_count ?? ''}
              onChange={handleInputChange}
            />
          </div>
          <div className="md:col-span-2 space-y-1.5">
            <Label htmlFor="description">Description</Label>
            <Textarea
              id="description"
              name="description"
              value={vpn.description ?? ''}
              onChange={handleInputChange}
              placeholder="A brief summary of the VPN."
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="categories">Categories</Label>
            <Input
              id="categories"
              name="categories"
              placeholder="e.g., streaming, privacy, gaming"
              value={categoryInput}
              onChange={(e) => setCategoryInput(e.target.value)}
            />
            <p className="text-sm text-muted-foreground">
              Enter categories separated by commas.
            </p>
          </div>

          <div className="md:col-span-2 space-y-1.5">
            <Label>Based In Country</Label>
            <CountrySelector
              selectedCountryName={vpn.based_in_country_name}
              onSelect={handleCountrySelect}
            />
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Pricing</CardTitle>
        </CardHeader>
        <CardContent className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <div className="space-y-1.5">
            <Label htmlFor="price_monthly_usd">Monthly (USD)</Label>
            <Input
              id="price_monthly_usd"
              name="price_monthly_usd"
              type="number"
              step="0.01"
              value={vpn.price_monthly_usd ?? ''}
              onChange={handleInputChange}
            />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="price_yearly_usd">Yearly (USD)</Label>
            <Input
              id="price_yearly_usd"
              name="price_yearly_usd"
              type="number"
              step="0.01"
              value={vpn.price_yearly_usd ?? ''}
              onChange={handleInputChange}
            />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="price_monthly_eur">Monthly (EUR)</Label>
            <Input
              id="price_monthly_eur"
              name="price_monthly_eur"
              type="number"
              step="0.01"
              value={vpn.price_monthly_eur ?? ''}
              onChange={handleInputChange}
            />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="price_yearly_eur">Yearly (EUR)</Label>
            <Input
              id="price_yearly_eur"
              name="price_yearly_eur"
              type="number"
              step="0.01"
              value={vpn.price_yearly_eur ?? ''}
              onChange={handleInputChange}
            />
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Speed Tests</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          {(vpn.speed_test_results || []).map((test, index) => (
            <div
              key={index}
              className="flex items-end gap-4 p-2 border rounded-md"
            >
              <div className="flex-grow space-y-1.5">
                <Label htmlFor={`speed_country_${index}`}>Country</Label>
                <Input
                  id={`speed_country_${index}`}
                  value={test.country}
                  onChange={(e) =>
                    handleSpeedTestChange(index, 'country', e.target.value)
                  }
                  placeholder="e.g., USA"
                />
              </div>
              <div className="flex-grow space-y-1.5">
                <Label htmlFor={`speed_value_${index}`}>Speed (Mbps)</Label>
                <Input
                  id={`speed_value_${index}`}
                  type="number"
                  value={test.speed ?? ''}
                  onChange={(e) =>
                    handleSpeedTestChange(index, 'speed', e.target.value)
                  }
                  placeholder="e.g., 95.5"
                />
              </div>
              <Button
                type="button"
                variant="destructive"
                size="icon"
                onClick={() => removeSpeedTest(index)}
              >
                <Trash2 className="h-4 w-4" />
              </Button>
            </div>
          ))}
          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={addSpeedTest}
          >
            <PlusCircle className="mr-2 h-4 w-4" />
            Add Speed Test
          </Button>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Detailed Ratings (0-10)</CardTitle>
        </CardHeader>
        <CardContent className="grid grid-cols-2 md:grid-cols-3 gap-4">
          {vpn.detailed_ratings &&
            Object.keys(vpn.detailed_ratings).map((key) => (
              <div className="space-y-1.5" key={key}>
                <Label htmlFor={`rating_${key}`} className="capitalize">
                  {key.replace('_', ' ')}
                </Label>
                <Input
                  id={`rating_${key}`}
                  name={key}
                  type="number"
                  step="0.1"
                  min="0"
                  max="10"
                  value={
                    vpn.detailed_ratings![key as keyof DetailedRatings] ?? ''
                  }
                  onChange={handleNestedRatingChange}
                />
              </div>
            ))}
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Features & Policies</CardTitle>
        </CardHeader>
        <CardContent className="grid grid-cols-2 md:grid-cols-3 gap-4">
          <div className="flex items-center space-x-2">
            <Switch
              id="show_on_homepage"
              checked={vpn.show_on_homepage}
              onCheckedChange={(c) => handleSwitchChange(c, 'show_on_homepage')}
            />
            <Label htmlFor="show_on_homepage">Show on Homepage</Label>
          </div>
          <div className="flex items-center space-x-2">
            <Switch
              id="keeps_logs"
              checked={vpn.keeps_logs}
              onCheckedChange={(c) => handleSwitchChange(c, 'keeps_logs')}
            />
            <Label htmlFor="keeps_logs">Keeps Logs</Label>
          </div>
          <div className="flex items-center space-x-2">
            <Switch
              id="has_court_proof"
              checked={vpn.has_court_proof}
              onCheckedChange={(c) => handleSwitchChange(c, 'has_court_proof')}
            />
            <Label htmlFor="has_court_proof">Court Proof</Label>
          </div>
          <div className="flex items-center space-x-2">
            <Switch
              id="has_double_vpn"
              checked={vpn.has_double_vpn}
              onCheckedChange={(c) => handleSwitchChange(c, 'has_double_vpn')}
            />
            <Label htmlFor="has_double_vpn">Double VPN</Label>
          </div>
          <div className="flex items-center space-x-2">
            <Switch
              id="has_coupon"
              checked={vpn.has_coupon}
              onCheckedChange={(c) => handleSwitchChange(c, 'has_coupon')}
            />
            <Label htmlFor="has_coupon">Has Coupon</Label>
          </div>
          <div className="flex items-center space-x-2">
            <Switch
              id="has_p2p"
              checked={vpn.has_p2p}
              onCheckedChange={(c) => handleSwitchChange(c, 'has_p2p')}
            />
            <Label htmlFor="has_p2p">P2P Support</Label>
          </div>
          <div className="flex items-center space-x-2">
            <Switch
              id="has_kill_switch"
              checked={vpn.has_kill_switch}
              onCheckedChange={(c) => handleSwitchChange(c, 'has_kill_switch')}
            />
            <Label htmlFor="has_kill_switch">Kill Switch</Label>
          </div>
          <div className="flex items-center space-x-2">
            <Switch
              id="has_ad_blocker"
              checked={vpn.has_ad_blocker}
              onCheckedChange={(c) => handleSwitchChange(c, 'has_ad_blocker')}
            />
            <Label htmlFor="has_ad_blocker">Ad Blocker</Label>
          </div>
          <div className="flex items-center space-x-2">
            <Switch
              id="has_split_tunneling"
              checked={vpn.has_split_tunneling}
              onCheckedChange={(c) =>
                handleSwitchChange(c, 'has_split_tunneling')
              }
            />
            <Label htmlFor="has_split_tunneling">Split Tunneling</Label>
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="simultaneous_connections">
              Simultaneous Connections
            </Label>
            <Input
              id="simultaneous_connections"
              name="simultaneous_connections"
              type="number"
              value={vpn.simultaneous_connections ?? ''}
              onChange={handleInputChange}
            />
          </div>
        </CardContent>
      </Card>

      {vpn.has_court_proof && (
        <Card>
          <CardHeader>
            <CardTitle>Court Proof Details</CardTitle>
          </CardHeader>
          <CardContent>
            <Textarea
              name="court_proof_content"
              value={vpn.court_proof_content || ''}
              onChange={handleInputChange}
              placeholder="Details about the court case or audit..."
            />
          </CardContent>
        </Card>
      )}

      {vpn.has_coupon && (
        <Card>
          <CardHeader>
            <CardTitle>Coupon Details</CardTitle>
          </CardHeader>
          <CardContent className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="space-y-1.5">
              <Label htmlFor="coupon_code">Coupon Code</Label>
              <Input
                id="coupon_code"
                name="coupon_code"
                value={vpn.coupon_code || ''}
                onChange={handleInputChange}
                placeholder="SAVE20NOW"
              />
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="coupon_validity">Validity Date</Label>
              <Input
                id="coupon_validity"
                name="coupon_validity"
                type="date"
                value={vpn.coupon_validity || ''}
                onChange={handleInputChange}
              />
            </div>
          </CardContent>
        </Card>
      )}

      <Card>
        <CardHeader>
          <CardTitle>Supported Devices</CardTitle>
        </CardHeader>
        <CardContent className="grid grid-cols-2 md:grid-cols-4 gap-4">
          {vpn.supported_devices &&
            Object.keys(vpn.supported_devices).map((key) => (
              <div className="flex items-center space-x-2" key={key}>
                <Switch
                  id={`device_${key}`}
                  checked={
                    vpn.supported_devices![key as keyof SupportedDevices]
                  }
                  onCheckedChange={(c) => handleSwitchChange(c, key)}
                />
                <Label htmlFor={`device_${key}`} className="capitalize">
                  {key}
                </Label>
              </div>
            ))}
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Full Review</CardTitle>
        </CardHeader>
        <CardContent>
          <Textarea
            name="full_review"
            value={vpn.full_review || ''}
            onChange={handleInputChange}
            placeholder="Write the full review here..."
            className="min-h-[200px]"
          />
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Pros & Cons</CardTitle>
        </CardHeader>
        <CardContent className="grid grid-cols-1 md:grid-cols-2 gap-8">
          <div className="space-y-2">
            <Label>Pros</Label>
            <div className="flex gap-2">
              <Input
                value={proInput}
                onChange={(e) => setProInput(e.target.value)}
                placeholder="Add a pro..."
                onKeyDown={(e) =>
                  e.key === 'Enter' &&
                  (e.preventDefault(), handleListChange('pros', 'add'))
                }
              />
              <Button
                type="button"
                size="icon"
                onClick={() => handleListChange('pros', 'add')}
              >
                <PlusCircle className="h-4 w-4" />
              </Button>
            </div>
            <ul className="space-y-2 pt-2">
              {vpn.pros?.map((pro, index) => (
                <li
                  key={index}
                  className="flex items-center justify-between bg-secondary p-2 rounded-md"
                >
                  <span className="text-sm">{pro}</span>
                  <Button
                    type="button"
                    size="icon"
                    variant="ghost"
                    onClick={() => handleListChange('pros', 'remove', index)}
                  >
                    <Trash2 className="h-4 w-4 text-red-500" />
                  </Button>
                </li>
              ))}
            </ul>
          </div>

          <div className="space-y-2">
            <Label>Cons</Label>
            <div className="flex gap-2">
              <Input
                value={conInput}
                onChange={(e) => setConInput(e.target.value)}
                placeholder="Add a con..."
                onKeyDown={(e) =>
                  e.key === 'Enter' &&
                  (e.preventDefault(), handleListChange('cons', 'add'))
                }
              />
              <Button
                type="button"
                size="icon"
                onClick={() => handleListChange('cons', 'add')}
              >
                <PlusCircle className="h-4 w-4" />
              </Button>
            </div>
            <ul className="space-y-2 pt-2">
              {vpn.cons?.map((con, index) => (
                <li
                  key={index}
                  className="flex items-center justify-between bg-secondary p-2 rounded-md"
                >
                  <span className="text-sm">{con}</span>
                  <Button
                    type="button"
                    size="icon"
                    variant="ghost"
                    onClick={() => handleListChange('cons', 'remove', index)}
                  >
                    <Trash2 className="h-4 w-4 text-red-500" />
                  </Button>
                </li>
              ))}
            </ul>
          </div>
        </CardContent>
      </Card>

      <div className="flex justify-end">
        <Button type="submit" size="lg" disabled={isSubmitting}>
          {isSubmitting
            ? vpnToEdit
              ? 'Updating...'
              : 'Creating...'
            : vpnToEdit
              ? 'Update VPN'
              : 'Create VPN'}
        </Button>
      </div>
    </form>
  );
};
