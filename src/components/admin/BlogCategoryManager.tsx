'use client';

import { useState, useEffect } from 'react';
import { supabase } from '@/lib/supabase';
import { slugify } from '@/lib/utils';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
  DialogClose,
} from '@/components/ui/dialog';
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
import {
  Table,
  TableHeader,
  TableRow,
  TableHead,
  TableBody,
  TableCell,
} from '@/components/ui/table';
import { Textarea } from '@/components/ui/textarea';

export interface BlogCategory {
  id: number;
  name: string;
  slug: string;
  description: string | null;
}

interface BlogCategoryManagerProps {
  initialCategories: BlogCategory[];
}

export const BlogCategoryManager = ({
  initialCategories,
}: BlogCategoryManagerProps) => {
  const [categories, setCategories] = useState(initialCategories);
  const [categoryToEdit, setCategoryToEdit] = useState<BlogCategory | null>(
    null
  );
  const [newCategoryName, setNewCategoryName] = useState('');
  const [newCategoryDescription, setNewCategoryDescription] = useState('');
  const [isSaving, setIsSaving] = useState(false);
  const [isDialogOpen, setIsDialogOpen] = useState(false);

  useEffect(() => {
    if (isDialogOpen) {
      // If a category is being edited, populate the input field
      if (categoryToEdit) {
        setNewCategoryName(categoryToEdit.name);
        setNewCategoryDescription(categoryToEdit.description || '');
      } else {
        // Otherwise, reset it for creating a new one
        setNewCategoryName('');
        setNewCategoryDescription('');
      }
    }
  }, [isDialogOpen, categoryToEdit]);

  const handleSave = async () => {
    if (!newCategoryName.trim()) {
      alert('Category name cannot be empty.');
      return;
    }

    setIsSaving(true);
    const slug = slugify(newCategoryName);

    if (categoryToEdit) {
      // Update existing category
      const { data, error } = await supabase
        .from('blog_categories')
        .update({
          name: newCategoryName,
          description: newCategoryDescription,
          slug,
        })
        .eq('id', categoryToEdit.id)
        .select()
        .single();

      if (error) {
        alert(`Error updating category: ${error.message}`);
      } else if (data) {
        setCategories(categories.map((c) => (c.id === data.id ? data : c)));
        alert('Category updated successfully!');
        closeDialog();
      }
    } else {
      // Create new category
      const { data, error } = await supabase
        .from('blog_categories')
        .insert([
          { name: newCategoryName, description: newCategoryDescription, slug },
        ])
        .select()
        .single();

      if (error) {
        alert(`Error creating category: ${error.message}`);
      } else if (data) {
        setCategories([...categories, data]);
        alert('Category created successfully!');
        closeDialog();
      }
    }

    setIsSaving(false);
  };

  const handleDelete = async (categoryId: number) => {
    const { error } = await supabase
      .from('blog_categories')
      .delete()
      .eq('id', categoryId);

    if (error) {
      alert(`Error deleting category: ${error.message}`);
    } else {
      setCategories(categories.filter((c) => c.id !== categoryId));
      alert('Category deleted successfully.');
    }
  };

  const openDialogForEdit = (category: BlogCategory) => {
    setCategoryToEdit(category);
    setIsDialogOpen(true);
  };

  const openDialogForNew = () => {
    setCategoryToEdit(null);
    setIsDialogOpen(true);
  };

  const closeDialog = () => {
    setIsDialogOpen(false);
    setCategoryToEdit(null);
    setNewCategoryName('');
    setNewCategoryDescription('');
  };

  return (
    <div>
      <div className="flex justify-end mb-4">
        <Button onClick={openDialogForNew}>New Category</Button>
        <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>
                {categoryToEdit ? 'Edit Category' : 'New Category'}
              </DialogTitle>
            </DialogHeader>
            <div className="grid gap-4 py-4">
              <div className="grid grid-cols-4 items-center gap-4">
                <Label htmlFor="name" className="text-right">
                  Name
                </Label>
                <Input
                  id="name"
                  name="name"
                  value={newCategoryName}
                  onChange={(e) => setNewCategoryName(e.target.value)}
                  className="col-span-3"
                />
              </div>
              <div className="grid grid-cols-4 items-center gap-4">
                <Label htmlFor="description" className="text-right">
                  Description
                </Label>
                <Textarea
                  id="description"
                  name="description"
                  value={newCategoryDescription}
                  onChange={(e) => setNewCategoryDescription(e.target.value)}
                  className="col-span-3"
                />
              </div>
            </div>
            <DialogFooter>
              <DialogClose asChild>
                <Button variant="outline" onClick={closeDialog}>
                  Cancel
                </Button>
              </DialogClose>
              <Button onClick={handleSave} disabled={isSaving}>
                {isSaving ? 'Saving...' : 'Save Category'}
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      </div>
      <div className="border rounded-lg">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Name</TableHead>
              <TableHead>Slug</TableHead>
              <TableHead>Description</TableHead>
              <TableHead className="text-right">Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {categories.map((category) => (
              <TableRow key={category.id}>
                <TableCell className="font-medium">{category.name}</TableCell>
                <TableCell>{category.slug}</TableCell>
                <TableCell>{category.description}</TableCell>
                <TableCell className="text-right">
                  <Button
                    variant="outline"
                    size="sm"
                    className="mr-2"
                    onClick={() => openDialogForEdit(category)}
                  >
                    Edit
                  </Button>
                  <AlertDialog>
                    <AlertDialogTrigger asChild>
                      <Button variant="destructive" size="sm">
                        Delete
                      </Button>
                    </AlertDialogTrigger>
                    <AlertDialogContent>
                      <AlertDialogHeader>
                        <AlertDialogTitle>Are you sure?</AlertDialogTitle>
                        <AlertDialogDescription>
                          This will permanently delete the category "
                          {category.name}". Associated posts will not be
                          deleted.
                        </AlertDialogDescription>
                      </AlertDialogHeader>
                      <AlertDialogFooter>
                        <AlertDialogCancel>Cancel</AlertDialogCancel>
                        <AlertDialogAction
                          onClick={() => handleDelete(category.id)}
                        >
                          Delete
                        </AlertDialogAction>
                      </AlertDialogFooter>
                    </AlertDialogContent>
                  </AlertDialog>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </div>
  );
};
