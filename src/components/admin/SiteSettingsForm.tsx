import React, { useEffect, useState } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Label } from '@/components/ui/label';
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
  CardDescription,
} from '@/components/ui/card';
import { toast } from 'sonner';
import { Loader2 } from 'lucide-react';

export type SiteSettingsFormProps = {
  initialData?: SettingsFormValues;
};

const settingsSchema = z.object({
  id: z.number().optional(),
  site_title: z.string().min(1, 'Site title is required'),
  site_tagline: z.string().optional(),
  favicon_url: z
    .string()
    .url('Must be a valid URL')
    .optional()
    .or(z.literal('')),
  meta_description: z.string().optional(),
  meta_keywords: z.string().optional(),
  meta_author: z.string().optional(),
  social_preview_image_url: z
    .string()
    .url('Must be a valid URL')
    .optional()
    .or(z.literal('')),
  google_analytics_id: z.string().nullable(),
  site_url: z.string().url('Must be a valid URL').nullable().or(z.literal('')),
  twitter_handle: z.string().nullable(),
  updated_at: z.string().optional(),
  _timestamp: z.number().optional(),
});

type SettingsFormValues = z.infer<typeof settingsSchema>;

export const SiteSettingsForm = ({ initialData }: SiteSettingsFormProps) => {
  const [isSaving, setIsSaving] = useState(false);
  const [isLoading, setIsLoading] = useState(true);

  const {
    register,
    handleSubmit,
    reset,
    watch,
    formState: { errors, isSubmitting },
  } = useForm<SettingsFormValues>({
    resolver: zodResolver(settingsSchema),
    defaultValues: {
      site_title: '',
      site_tagline: '',
      favicon_url: '',
      meta_description: '',
      meta_keywords: '',
      meta_author: '',
      social_preview_image_url: '',
      google_analytics_id: '',
      site_url: '',
      twitter_handle: '',
      ...initialData,
    },
  });

  useEffect(() => {
    if (initialData) {
      reset(initialData);
      setIsLoading(false);
      return;
    }

    const fetchSettings = async () => {
      setIsLoading(true);
      try {
        const response = await fetch('/api/settings', {
          credentials: 'include',
          headers: {
            'Cache-Control': 'no-cache',
            Pragma: 'no-cache',
          },
        });

        if (response.status === 401) {
          window.location.href = '/admin/login';
          return;
        }

        if (!response.ok) {
          const error = await response.json();
          throw new Error(error.message || 'Failed to fetch settings');
        }

        const { data } = await response.json();

        reset(data);
      } catch (error: any) {
        console.error('Error loading settings:', error);
        toast.error(error?.message || 'Failed to load settings');
      } finally {
        setIsLoading(false);
      }
    };
    fetchSettings();
  }, [reset]);

  const onSubmit = async (data: SettingsFormValues) => {
    try {
      setIsSaving(true);
      toast.info('Saving settings...');

      // Remove unnecessary fields and prepare data for submission
      const submissionData = {
        site_title: data.site_title,
        site_tagline: data.site_tagline || '',
        favicon_url: data.favicon_url || '',
        meta_description: data.meta_description || '',
        meta_keywords: data.meta_keywords || '',
        meta_author: data.meta_author || '',
        social_preview_image_url: data.social_preview_image_url || '',
        google_analytics_id: data.google_analytics_id || '',
        site_url: data.site_url || '',
        twitter_handle: data.twitter_handle || '',
      };

      const response = await fetch('/api/settings', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Cache-Control': 'no-cache',
          Pragma: 'no-cache',
        },
        credentials: 'include',
        body: JSON.stringify(submissionData),
      });

      if (response.status === 401) {
        window.location.href = '/admin/login';
        return;
      }

      const result = await response.json();

      if (!response.ok) {
        throw new Error(result.message || 'Failed to save settings');
      }

      toast.success('Settings saved successfully!');

      // Add nocache parameter to force a fresh load
      const url = new URL(window.location.href);
      url.searchParams.set('nocache', Date.now().toString());

      // Add a small delay before reloading
      await new Promise((resolve) => setTimeout(resolve, 1000));
      window.location.href = url.toString();
    } catch (error: any) {
      console.error('Error saving settings:', error);
      if (error.message.includes('Unauthorized')) {
        window.location.href = '/admin/login';
      } else {
        toast.error(error.message || 'Failed to save settings');
      }
    } finally {
      setIsSaving(false);
    }
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle>Site Settings</CardTitle>
        <CardDescription>
          Configure your site's identity and SEO settings.
        </CardDescription>
      </CardHeader>
      <CardContent>
        {isLoading ? (
          <div className="flex items-center justify-center py-8">
            <Loader2 className="h-8 w-8 animate-spin" />
          </div>
        ) : (
          <form
            onSubmit={handleSubmit(async (data) => {
              await onSubmit(data);
            })}
            className="space-y-4"
          >
            <div className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="site_title">Site Title *</Label>
                <Input
                  id="site_title"
                  {...register('site_title')}
                  className={errors.site_title ? 'border-red-500' : ''}
                />
                {errors.site_title && (
                  <p className="text-sm text-red-500">
                    {errors.site_title.message}
                  </p>
                )}
              </div>
              <div className="space-y-2">
                <Label htmlFor="site_tagline">Site Tagline</Label>
                <Input id="site_tagline" {...register('site_tagline')} />
              </div>
              <div className="space-y-2">
                <Label htmlFor="site_url">Site URL</Label>
                <Input
                  id="site_url"
                  type="url"
                  {...register('site_url')}
                  placeholder="https://example.com"
                  className={errors.site_url ? 'border-red-500' : ''}
                  defaultValue=""
                />
                {errors.site_url && (
                  <p className="text-sm text-red-500">
                    {errors.site_url.message}
                  </p>
                )}
              </div>
              <div className="space-y-2">
                <Label htmlFor="meta_description">Meta Description</Label>
                <Textarea
                  id="meta_description"
                  {...register('meta_description')}
                  placeholder="A brief summary of your site for search engines."
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="meta_keywords">Meta Keywords</Label>
                <Input
                  id="meta_keywords"
                  {...register('meta_keywords')}
                  placeholder="vpn, security, privacy, reviews"
                />
                <p className="text-sm text-muted-foreground">
                  Comma-separated keywords.
                </p>
              </div>
              <div className="space-y-2">
                <Label htmlFor="favicon_url">Favicon URL</Label>
                <Input
                  id="favicon_url"
                  type="url"
                  {...register('favicon_url')}
                  placeholder="https://example.com/favicon.ico"
                  className={errors.favicon_url ? 'border-red-500' : ''}
                />
                {errors.favicon_url && (
                  <p className="text-sm text-red-500">
                    {errors.favicon_url.message}
                  </p>
                )}
                <p className="text-sm text-muted-foreground">
                  Recommended: SVG or PNG, 32x32 pixels
                </p>
              </div>
              <div className="space-y-2">
                <Label htmlFor="social_preview_image_url">
                  Social Preview Image URL
                </Label>
                <Input
                  id="social_preview_image_url"
                  type="url"
                  {...register('social_preview_image_url')}
                  placeholder="https://example.com/social-image.png"
                  className={
                    errors.social_preview_image_url ? 'border-red-500' : ''
                  }
                />
                {errors.social_preview_image_url && (
                  <p className="text-sm text-red-500">
                    {errors.social_preview_image_url.message}
                  </p>
                )}
                <p className="text-sm text-muted-foreground">
                  Recommended: 1200x630 pixels for optimal social media display
                </p>
              </div>
              <div className="space-y-2">
                <Label htmlFor="meta_author">Default Author</Label>
                <Input
                  id="meta_author"
                  {...register('meta_author')}
                  defaultValue=""
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="google_analytics_id">Google Analytics ID</Label>
                <Input
                  id="google_analytics_id"
                  {...register('google_analytics_id')}
                  placeholder="G-XXXXXXXXXX"
                  defaultValue=""
                />
                <p className="text-sm text-muted-foreground">
                  Ex: G-XXXXXXXXXX or UA-XXXXXXXX-X
                </p>
              </div>
              <Button
                type="submit"
                disabled={isSaving || isSubmitting}
                className="w-full"
              >
                {isSaving || isSubmitting ? (
                  <>
                    <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                    Saving...
                  </>
                ) : (
                  'Save Settings'
                )}
              </Button>
              {errors.site_title && (
                <p className="text-sm text-red-500">
                  {errors.site_title.message}
                </p>
              )}
            </div>
          </form>
        )}
      </CardContent>
    </Card>
  );
};
