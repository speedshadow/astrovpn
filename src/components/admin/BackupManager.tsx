import React, { useState, useRef, useEffect } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
  CardDescription,
} from '@/components/ui/card';
import { toast } from 'sonner';
import { supabase } from '@/lib/supabase';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';

const BackupManager: React.FC = () => {
  const [isCreating, setIsCreating] = useState(false);
  const [isRestoring, setIsRestoring] = useState(false);
  const [isDownloading, setIsDownloading] = useState<string | null>(null); // Track which file is downloading
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const [backups, setBackups] = useState<string[]>([]);
  const [isLoadingList, setIsLoadingList] = useState(true);

  const fetchBackups = async () => {
    setIsLoadingList(true);
    try {
      const {
        data: { session },
      } = await supabase.auth.getSession();
      if (!session) throw new Error('Not authenticated to list backups');

      const response = await fetch('/api/db/list-backups', {
        headers: {
          Authorization: `Bearer ${session.access_token}`,
        },
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.details || 'Failed to fetch backups');
      }

      const data = await response.json();
      setBackups(data.backups || []);
    } catch (error) {
      toast.error((error as Error).message);
      setBackups([]); // Clear backups on error
    } finally {
      setIsLoadingList(false);
    }
  };

  useEffect(() => {
    fetchBackups();
  }, []);

  const handleCreateBackup = async () => {
    setIsCreating(true);
    toast.info('Creating secure backup... This may take a moment.');
    try {
      const {
        data: { session },
      } = await supabase.auth.getSession();
      if (!session) throw new Error('Not authenticated');

      const response = await fetch('/api/db/backup', {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${session.access_token}`,
        },
      });

      const result = await response.json();
      if (!response.ok) {
        throw new Error(
          result.details || result.error || 'Failed to create backup'
        );
      }

      toast.success(`Backup created successfully: ${result.fileName}`);
      fetchBackups();
    } catch (error) {
      toast.error(`Backup failed: ${(error as Error).message}`);
    } finally {
      setIsCreating(false);
    }
  };

  const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    if (event.target.files && event.target.files[0]) {
      const file = event.target.files[0];
      if (file.name.endsWith('.dump')) {
        setSelectedFile(file);
      } else {
        toast.error('Invalid file type. Please select a .dump file.');
        if (fileInputRef.current) fileInputRef.current.value = '';
        setSelectedFile(null);
      }
    }
  };

  const handleRestore = async () => {
    if (!selectedFile) {
      toast.error('Please select a .dump file to restore.');
      return;
    }
    if (
      !confirm(
        `Are you sure you want to restore from "${selectedFile.name}"? This action is irreversible.`
      )
    )
      return;

    setIsRestoring(true);
    toast.info('Restoring database... This may take several minutes.');

    const {
      data: { session },
    } = await supabase.auth.getSession();
    if (!session) {
      toast.error('Authentication error.');
      setIsRestoring(false);
      return;
    }

    const formData = new FormData();
    formData.append('backupFile', selectedFile);

    try {
      const response = await fetch('/api/db/restore', {
        method: 'POST',
        headers: { Authorization: `Bearer ${session.access_token}` },
        body: formData,
      });
      const result = await response.json();
      if (!response.ok)
        throw new Error(result.details || 'Failed to restore backup.');
      toast.success(result.message || 'Database restored successfully!');
    } catch (error) {
      toast.error(`Restore failed: ${(error as Error).message}`);
    } finally {
      setIsRestoring(false);
      setSelectedFile(null);
      if (fileInputRef.current) fileInputRef.current.value = '';
    }
  };

  const handleDownload = async (filename: string) => {
    setIsDownloading(filename);
    toast.info(`Downloading ${filename}...`);
    try {
      const {
        data: { session },
      } = await supabase.auth.getSession();
      if (!session) throw new Error('Not authenticated');

      const response = await fetch(
        `/api/db/download-backup?filename=${filename}`,
        {
          headers: {
            Authorization: `Bearer ${session.access_token}`,
          },
        }
      );

      if (!response.ok) {
        // Try to parse error JSON, otherwise use status text
        let errorDetails = `Error ${response.status}: ${response.statusText}`;
        try {
          const errorJson = await response.json();
          errorDetails = errorJson.details || errorDetails;
        } catch (e) {
          /* Ignore parsing error */
        }
        throw new Error(errorDetails);
      }

      // Trigger browser download
      const blob = await response.blob();
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = filename;
      document.body.appendChild(a);
      a.click();
      a.remove();
      window.URL.revokeObjectURL(url);

      toast.success(`${filename} downloaded successfully.`);
    } catch (error) {
      toast.error(`Download failed: ${(error as Error).message}`);
    } finally {
      setIsDownloading(null);
    }
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle>Database Backup & Restore</CardTitle>
        <CardDescription>
          Use the tools below to create secure backups or restore your database
          from a <code>.dump</code> file.
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-8">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          <div className="space-y-2">
            <h4 className="font-medium">Create Backup</h4>
            <p className="text-sm text-muted-foreground">
              Creates a secure backup of your database.
            </p>
            <Button
              onClick={handleCreateBackup}
              disabled={isCreating || isRestoring || !!isDownloading}
            >
              {isCreating ? 'Creating...' : 'Create Secure Backup'}
            </Button>
          </div>
          <div className="space-y-2">
            <h4 className="font-medium">Restore from Backup</h4>
            <p className="text-sm text-muted-foreground">
              Restore from a <code>.dump</code> file. This overwrites all data.
            </p>
            <div className="flex items-center space-x-2">
              <Input
                ref={fileInputRef}
                type="file"
                onChange={handleFileChange}
                accept=".dump"
                disabled={isRestoring || isCreating || !!isDownloading}
              />
              <Button
                onClick={handleRestore}
                disabled={
                  isRestoring || isCreating || !selectedFile || !!isDownloading
                }
              >
                {isRestoring ? 'Restoring...' : 'Restore'}
              </Button>
            </div>
          </div>
        </div>

        <div>
          <h4 className="font-medium">Available Backups</h4>
          <div className="mt-2 rounded-md border">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Filename</TableHead>
                  <TableHead className="text-right">Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {isLoadingList ? (
                  <TableRow>
                    <TableCell colSpan={2} className="text-center">
                      Loading...
                    </TableCell>
                  </TableRow>
                ) : backups.length > 0 ? (
                  backups.map((backup) => (
                    <TableRow key={backup}>
                      <TableCell className="font-mono">{backup}</TableCell>
                      <TableCell className="text-right">
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => handleDownload(backup)}
                          disabled={!!isDownloading}
                        >
                          {isDownloading === backup
                            ? 'Downloading...'
                            : 'Download'}
                        </Button>
                      </TableCell>
                    </TableRow>
                  ))
                ) : (
                  <TableRow>
                    <TableCell colSpan={2} className="text-center">
                      No backups found.
                    </TableCell>
                  </TableRow>
                )}
              </TableBody>
            </Table>
          </div>
        </div>
      </CardContent>
    </Card>
  );
};

export default BackupManager;
