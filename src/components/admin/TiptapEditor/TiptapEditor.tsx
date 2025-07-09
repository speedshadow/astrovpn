import * as React from 'react';
import { useEditor, EditorContent } from '@tiptap/react';
import type { Editor } from '@tiptap/core';
import StarterKit from '@tiptap/starter-kit';
import Image from '@tiptap/extension-image';
import Table from '@tiptap/extension-table';
import TableRow from '@tiptap/extension-table-row';
import TableCell from '@tiptap/extension-table-cell';
import TableHeader from '@tiptap/extension-table-header';
import TextAlign from '@tiptap/extension-text-align';
import Toolbar from './Toolbar';
import { supabase } from '@/lib/supabase';
import './TiptapEditor.css';

interface TiptapEditorProps {
  value: string;
  onChange: (value: string) => void;
}

const TiptapEditor: React.FC<TiptapEditorProps> = ({ value, onChange }) => {
  const editor = useEditor({
    extensions: [
      StarterKit.configure({
        heading: {
          levels: [1, 2, 3, 4],
        },
        bulletList: {
          HTMLAttributes: {
            class: 'list-disc pl-5',
          },
        },
        orderedList: {
          HTMLAttributes: {
            class: 'list-decimal pl-5',
          },
        },
      }),
      Image.configure({
        inline: false,
        HTMLAttributes: {
          class: 'max-w-full h-auto rounded-lg mx-auto',
        },
      }),
      Table.configure({
        resizable: true,
        HTMLAttributes: {
          class:
            'w-full border-collapse border border-gray-300 dark:border-gray-600',
        },
      }),
      TableRow,
      TableHeader.configure({
        HTMLAttributes: {
          class:
            'bg-gray-100 dark:bg-gray-700 font-bold p-2 border border-gray-300 dark:border-gray-600',
        },
      }),
      TextAlign.configure({
        types: ['heading', 'paragraph'],
      }),
      TableCell.configure({
        HTMLAttributes: {
          class: 'p-2 border border-gray-300 dark:border-gray-600',
        },
      }),
    ],
    content: value,
    onUpdate: ({ editor }: { editor: Editor }) => {
      onChange(editor.getHTML());
    },
    editorProps: {
      attributes: {
        class: 'focus:outline-none',
      },
    },
  });

  const handleImageUpload = async (file: File) => {
    if (!editor) return;

    try {
      const fileName = `${Date.now()}_${file.name}`;
      const { error: uploadError } = await supabase.storage
        .from('editor-uploads')
        .upload(fileName, file);

      if (uploadError) {
        throw uploadError;
      }

      const {
        data: { publicUrl },
      } = supabase.storage.from('editor-uploads').getPublicUrl(fileName);

      if (!publicUrl) {
        throw new Error('Could not get public URL for uploaded image.');
      }

      editor.chain().focus().setImage({ src: publicUrl }).run();
    } catch (error) {
      console.error('Error uploading image:', error);
      alert('Failed to upload image. Please check the console for details.');
    }
  };

  return (
    <div>
      <Toolbar editor={editor} onImageUpload={handleImageUpload} />
      <div className="tiptap-editor prose dark:prose-invert max-w-none">
        <EditorContent editor={editor} />
      </div>
      {/* Debug: Show current HTML output of the editor */}
      <pre
        style={{
          marginTop: 16,
          background: '#f3f4f6',
          color: '#111',
          padding: 12,
          borderRadius: 8,
          fontSize: 13,
          overflowX: 'auto',
        }}
      >
        {editor ? editor.getHTML() : ''}
      </pre>
    </div>
  );
};

export default TiptapEditor;
