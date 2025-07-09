'use client';

import { useState, useEffect } from 'react';
import { supabase } from '@/lib/supabase';
import type { Session } from '@supabase/supabase-js';
import { Button } from '@/components/ui/button';
import { Textarea } from '@/components/ui/textarea';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
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
import { formatDistanceToNow } from 'date-fns';

export interface CommentWithAuthor {
  id: number;
  content: string;
  created_at: string;
  author_id: string | null;
  guest_name: string | null;
  author: {
    full_name: string;
    avatar_url: string;
  } | null;
}

interface CommentSectionProps {
  postId: number;
}

export const CommentSection = ({ postId }: CommentSectionProps) => {
  const [session, setSession] = useState<Session | null>(null);
  const [comments, setComments] = useState<CommentWithAuthor[]>([]);
  const [newComment, setNewComment] = useState('');
  const [guestName, setGuestName] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    const getSession = async () => {
      const { data } = await supabase.auth.getSession();
      setSession(data.session);
    };
    getSession();

    fetchComments();

    const { data: authListener } = supabase.auth.onAuthStateChange(
      (_event, session) => {
        setSession(session);
      }
    );

    return () => {
      authListener.subscription.unsubscribe();
    };
  }, []);

  const fetchComments = async () => {
    const { data, error } = await supabase
      .from('blog_comments')
      .select(
        `
        id, content, created_at, author_id, guest_name,
        author:profiles ( full_name, avatar_url )
      `
      )
      .eq('post_id', postId)
      .order('created_at', { ascending: false });

    if (error) {
      console.error('Error fetching comments:', error);
    } else {
      setComments(data as unknown as CommentWithAuthor[]);
    }
  };

  const handleCommentSubmit = async () => {
    if (!newComment.trim()) return;

    setIsSubmitting(true);

    let commentData;
    if (session) {
      // User is logged in
      commentData = {
        post_id: postId,
        content: newComment,
        author_id: session.user.id,
      };
    } else {
      // Guest is commenting
      if (!guestName.trim()) {
        alert('Please provide your name.');
        setIsSubmitting(false);
        return;
      }
      commentData = {
        post_id: postId,
        content: newComment,
        guest_name: guestName,
      };
    }

    const { error } = await supabase
      .from('blog_comments')
      .insert([commentData]);
    setIsSubmitting(false);

    if (error) {
      // This specific error indicates a stale session for a logged-in user.
      if (
        session &&
        error.code === '23503' &&
        error.message.includes('blog_comments_author_id_fkey')
      ) {
        alert(
          'Your login session is out of date. Please log in again to comment.'
        );
        await supabase.auth.signOut();
        setSession(null); // This will refresh the component to show the guest view.
      } else {
        // Handle other potential errors.
        console.error('Error submitting comment:', error);
        alert('An unexpected error occurred: ' + error.message);
      }
    } else {
      setNewComment('');
      if (!session) setGuestName(''); // Clear guest name only if guest
      await fetchComments(); // Refetch comments to show the new one
    }
  };

  const handleDelete = async (commentId: number) => {
    const { error } = await supabase
      .from('blog_comments')
      .delete()
      .eq('id', commentId);
    if (error) {
      alert('Error deleting comment: ' + error.message);
    } else {
      setComments(comments.filter((c) => c.id !== commentId));
    }
  };

  return (
    <div className="mt-12">
      <h2 className="text-2xl font-bold mb-6">Comments ({comments.length})</h2>

      <div className="mb-8">
        {!session && (
          <input
            type="text"
            value={guestName}
            onChange={(e) => setGuestName(e.target.value)}
            placeholder="Your Name"
            className="w-full p-2 mb-2 border rounded bg-input text-foreground"
          />
        )}
        <Textarea
          value={newComment}
          onChange={(e) => setNewComment(e.target.value)}
          placeholder={
            session
              ? `Commenting as ${session.user.user_metadata.full_name}...`
              : 'Write a comment as a guest...'
          }
          className="mb-2"
        />
        <Button
          onClick={handleCommentSubmit}
          disabled={isSubmitting || !newComment.trim()}
        >
          {isSubmitting ? 'Submitting...' : 'Submit Comment'}
        </Button>
      </div>

      <div className="space-y-6">
        {comments.map((comment) => (
          <div key={comment.id} className="flex items-start gap-4">
            <Avatar>
              <AvatarImage
                src={comment.author?.avatar_url}
                alt={comment.author?.full_name}
              />
              <AvatarFallback>
                {comment.author?.full_name?.charAt(0) || 'U'}
              </AvatarFallback>
            </Avatar>
            <div className="flex-1">
              <div className="flex justify-between items-center">
                <p className="font-semibold">
                  {comment.author?.full_name ||
                    comment.guest_name ||
                    'Anonymous'}
                </p>
                {session?.user.id === comment.author_id && (
                  <AlertDialog>
                    <AlertDialogTrigger asChild>
                      <Button variant="ghost" size="sm">
                        Delete
                      </Button>
                    </AlertDialogTrigger>
                    <AlertDialogContent>
                      <AlertDialogHeader>
                        <AlertDialogTitle>Are you sure?</AlertDialogTitle>
                        <AlertDialogDescription>
                          This will permanently delete your comment.
                        </AlertDialogDescription>
                      </AlertDialogHeader>
                      <AlertDialogFooter>
                        <AlertDialogCancel>Cancel</AlertDialogCancel>
                        <AlertDialogAction
                          onClick={() => handleDelete(comment.id)}
                        >
                          Delete
                        </AlertDialogAction>
                      </AlertDialogFooter>
                    </AlertDialogContent>
                  </AlertDialog>
                )}
              </div>
              <p className="text-sm text-muted-foreground mb-1">
                {formatDistanceToNow(new Date(comment.created_at), {
                  addSuffix: true,
                })}
              </p>
              <p>{comment.content}</p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};
