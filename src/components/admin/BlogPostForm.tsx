'use client';

import React, { useState, lazy, Suspense } from 'react';
import { supabase } from '@/lib/supabase';

import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import TiptapEditor from './TiptapEditor/TiptapEditor';
import { Switch } from '@/components/ui/switch';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import type { BlogCategory } from './BlogCategoryManager';

export interface BlogPost {
  id?: number;
  title: string;
  slug: string;
  content: string;
  excerpt: string | null;
  featured_image_url: string | null;
  category_id: number | null;
  allow_comments: boolean;
  show_cta: boolean;
}

const defaultPostState: BlogPost = {
  title: '',
  slug: '',
  content: '',
  excerpt: '',
  featured_image_url: '',
  category_id: null,
  allow_comments: true,
  show_cta: true,
};

const slugify = (text: string) =>
  text
    .toString()
    .toLowerCase()
    .trim()
    .replace(/\s+/g, '-')
    .replace(/[^\w-]+/g, '')
    .replace(/--+/g, '-');

interface BlogPostFormProps {
  categories: BlogCategory[];
  initialPost?: BlogPost;
}

export const BlogPostForm = ({
  categories,
  initialPost,
}: BlogPostFormProps) => {
  const [post, setPost] = useState<BlogPost>(initialPost || defaultPostState);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleInputChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) => {
    const { name, value } = e.target;
    setPost((prev) => ({
      ...prev,
      [name]: value,
      ...(name === 'title' && { slug: slugify(value) }),
    }));
  };

  const handleSwitchChange = (name: keyof BlogPost, checked: boolean) => {
    setPost((prev) => ({ ...prev, [name]: checked }));
  };

  const handleCategoryChange = (value: string) => {
    setPost((prev) => ({ ...prev, category_id: parseInt(value, 10) || null }));
  };

  const handleEditorChange = (data: string) => {
    setPost((prev) => ({ ...prev, content: data }));
  };

  const handleSubmit = async (publish: boolean) => {
    setIsSubmitting(true);

    const { id, ...postData } = post;

    const dataToSubmit = {
      ...postData,
      published_at: publish ? new Date().toISOString() : null,
    };

    // If we are saving a draft of a published post, we should unpublish it
    if (id && !publish) {
      dataToSubmit.published_at = null;
    }

    const promise = id
      ? supabase.from('blog_posts').update(dataToSubmit).eq('id', id)
      : supabase.from('blog_posts').insert([dataToSubmit]);

    const { error } = await promise;

    setIsSubmitting(false);

    if (error) {
      alert(`Error: ${error.message}`);
    } else {
      alert(`Blog post ${id ? 'updated' : 'saved'} successfully!`);
      window.location.href = '/admin/blog';
    }
  };

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        handleSubmit(true);
      }}
    >
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Main content column */}
        <div className="lg:col-span-2 space-y-6">
          <Card>
            <CardContent className="pt-6">
              <div className="space-y-2 mb-4">
                <Label htmlFor="title">Title</Label>
                <Input
                  id="title"
                  name="title"
                  value={post.title}
                  onChange={handleInputChange}
                  placeholder="Your amazing blog post title"
                  required
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="slug">Slug (auto-generated)</Label>
                <Input
                  id="slug"
                  name="slug"
                  value={post.slug}
                  placeholder="your-amazing-blog-post-title"
                  required
                  readOnly
                  className="bg-muted/50"
                />
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardHeader>
              <CardTitle>Content</CardTitle>
            </CardHeader>
            <CardContent>
              <TiptapEditor
                value={post.content}
                onChange={handleEditorChange}
              />
            </CardContent>
          </Card>
        </div>

        {/* Sidebar column */}
        <div className="lg:col-span-1 space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Publish</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="flex flex-col space-y-2">
                <Button
                  type="submit"
                  className="w-full"
                  disabled={isSubmitting}
                >
                  {isSubmitting
                    ? post.id
                      ? 'Updating...'
                      : 'Publishing...'
                    : post.id
                      ? 'Update Post'
                      : 'Publish Post'}
                </Button>
                <Button
                  type="button"
                  variant="outline"
                  className="w-full"
                  onClick={() => handleSubmit(false)}
                  disabled={isSubmitting}
                >
                  Save as Draft
                </Button>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Details</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="category_id">Category</Label>
                <Select
                  onValueChange={handleCategoryChange}
                  defaultValue={post.category_id?.toString()}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Select a category" />
                  </SelectTrigger>
                  <SelectContent>
                    {categories.map((cat) => (
                      <SelectItem key={cat.id} value={cat.id.toString()}>
                        {cat.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label htmlFor="excerpt">Excerpt</Label>
                <Textarea
                  id="excerpt"
                  name="excerpt"
                  value={post.excerpt || ''}
                  onChange={handleInputChange}
                  placeholder="A short summary of the post"
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="featured_image_url">Featured Image URL</Label>
                <Input
                  id="featured_image_url"
                  name="featured_image_url"
                  value={post.featured_image_url || ''}
                  onChange={handleInputChange}
                  placeholder="https://.../image.jpg"
                />
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Settings</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex items-center justify-between">
                <Label htmlFor="allow_comments">Allow Comments</Label>
                <Switch
                  id="allow_comments"
                  checked={post.allow_comments}
                  onCheckedChange={(c) =>
                    handleSwitchChange('allow_comments', c)
                  }
                />
              </div>
              <div className="flex items-center justify-between">
                <Label htmlFor="show_cta">Show Affiliate CTA</Label>
                <Switch
                  id="show_cta"
                  checked={post.show_cta}
                  onCheckedChange={(c) => handleSwitchChange('show_cta', c)}
                />
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </form>
  );
};
