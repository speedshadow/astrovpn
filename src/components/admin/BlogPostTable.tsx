'use client';

import { useState } from 'react';
import { supabase } from '@/lib/supabase';

import {
  Table,
  TableHeader,
  TableRow,
  TableHead,
  TableBody,
  TableCell,
} from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from '@/components/ui/alert-dialog';

// This type definition should match the data structure fetched from Supabase,
// including the joined 'blog_categories' data.
export interface BlogPostForTable {
  id: number;
  title: string;
  published_at: string | null;
  blog_categories: {
    name: string;
  } | null;
}

interface BlogPostTableProps {
  posts: BlogPostForTable[];
}

export const BlogPostTable = ({ posts: initialPosts }: BlogPostTableProps) => {
  const [posts, setPosts] = useState(initialPosts);

  const handleDelete = async (postId: number) => {
    const { error } = await supabase
      .from('blog_posts')
      .delete()
      .eq('id', postId);

    if (error) {
      alert(`Error deleting post: ${error.message}`);
    } else {
      setPosts(posts.filter((p) => p.id !== postId));
      alert('Post deleted successfully.');
    }
  };
  return (
    <div className="border rounded-lg">
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Title</TableHead>
            <TableHead>Category</TableHead>
            <TableHead>Status</TableHead>
            <TableHead>Published Date</TableHead>
            <TableHead className="text-right">Actions</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {posts.length === 0 ? (
            <TableRow>
              <TableCell
                colSpan={5}
                className="text-center text-muted-foreground py-10"
              >
                No blog posts found.{' '}
                <a
                  href="/admin/blog/new"
                  className="text-primary hover:underline"
                >
                  Create one now
                </a>
                .
              </TableCell>
            </TableRow>
          ) : (
            posts.map((post) => (
              <TableRow key={post.id}>
                <TableCell className="font-medium">{post.title}</TableCell>
                <TableCell>
                  {post.blog_categories?.name || 'Uncategorized'}
                </TableCell>
                <TableCell>
                  <Badge variant={post.published_at ? 'default' : 'secondary'}>
                    {post.published_at ? 'Published' : 'Draft'}
                  </Badge>
                </TableCell>
                <TableCell>
                  {post.published_at
                    ? new Date(post.published_at).toLocaleDateString()
                    : 'N/A'}
                </TableCell>
                <TableCell className="text-right">
                  {/* The edit page will be created in a future step */}
                  <Button asChild variant="outline" size="sm" className="mr-2">
                    <a href={`/admin/blog/edit/${post.id}`}>Edit</a>
                  </Button>
                  <AlertDialog>
                    <AlertDialogTrigger asChild>
                      <Button variant="destructive" size="sm">
                        Delete
                      </Button>
                    </AlertDialogTrigger>
                    <AlertDialogContent>
                      <AlertDialogHeader>
                        <AlertDialogTitle>
                          Are you absolutely sure?
                        </AlertDialogTitle>
                        <AlertDialogDescription>
                          This action cannot be undone. This will permanently
                          delete the blog post "{post.title}".
                        </AlertDialogDescription>
                      </AlertDialogHeader>
                      <AlertDialogFooter>
                        <AlertDialogCancel>Cancel</AlertDialogCancel>
                        <AlertDialogAction
                          onClick={() => handleDelete(post.id)}
                        >
                          Continue
                        </AlertDialogAction>
                      </AlertDialogFooter>
                    </AlertDialogContent>
                  </AlertDialog>
                </TableCell>
              </TableRow>
            ))
          )}
        </TableBody>
      </Table>
    </div>
  );
};
