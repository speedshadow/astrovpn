import React, { useState, useEffect } from 'react';
import type { ChangeEvent } from 'react';
import { toast } from 'sonner';
import { Button } from '@/components/ui/button';
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { Loader2, PlusCircle, Trash2, Upload, Download } from 'lucide-react';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';

interface BackupFile {
  name: string;
  size: string;
  createdAt: string;
}

export function DatabaseManager() {
  const [backups, setBackups] = useState<BackupFile[]>([]);
  const [isCreating, setIsCreating] = useState(false);
  const [deletingFile, setDeletingFile] = useState<string | null>(null);
  const [isRestoring, setIsRestoring] = useState(false);
  const [isFetching, setIsFetching] = useState(true);

  const fetchBackups = async () => {
    try {
      const response = await fetch('/api/db/backups');
      if (!response.ok) throw new Error('Failed to fetch backups.');
      const data = await response.json();
      setBackups(data);
    } catch (error) {
      toast.error(
        error instanceof Error ? error.message : 'Failed to fetch backups.'
      );
    } finally {
      setIsFetching(false);
    }
  };

  const handleCreateBackup = async () => {
    setIsCreating(true);
    try {
      const response = await fetch('/api/db/backup', { method: 'POST' });
      const result = await response.json();
      if (!response.ok) throw new Error(result.error || 'Backup failed.');
      toast.success('Backup created successfully!', {
        description: result.file,
      });
      fetchBackups(); // Refresh list
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Backup failed.');
    } finally {
      setIsCreating(false);
    }
  };

  const handleDeleteBackup = async (fileName: string) => {
    if (
      !window.confirm(
        `Are you sure you want to delete the backup file "${fileName}"? This action cannot be undone.`
      )
    ) {
      return;
    }

    setDeletingFile(fileName);
    try {
      const response = await fetch(`/api/db/backup?file=${fileName}`, {
        method: 'DELETE',
      });

      const result = await response.json();

      if (!response.ok) {
        throw new Error(result.error || 'Failed to delete backup.');
      }

      toast.success(result.message || 'Backup deleted successfully!');
      fetchBackups(); // Refresh the list
    } catch (error: unknown) {
      console.error('Delete error:', error);
      toast.error(String(error));
    } finally {
      setDeletingFile(null);
    }
  };

  const handleRestore = async (event: ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file) return;

    setIsRestoring(true);
    const formData = new FormData();
    formData.append('backup', file);

    try {
      const response = await fetch('/api/db/restore', {
        method: 'POST',
        body: formData,
      });
      const result = await response.json();
      if (!response.ok) throw new Error(result.error || 'Restore failed.');
      toast.success('Database restored successfully!', {
        description: `The page will now reload to reflect the changes.`,
      });
      setTimeout(() => window.location.reload(), 3000);
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Restore failed.');
    } finally {
      setIsRestoring(false);
      event.target.value = ''; // Reset file input
    }
  };

  const [backupConfig, setBackupConfig] = useState({
    schedule: 'daily',
    time: '02:00',
    storagePath: '/var/backups/supabase',
  });
  const [isSavingConfig, setIsSavingConfig] = useState(false);

  const fetchConfig = async () => {
    try {
      const response = await fetch('/api/db/config');
      if (response.ok) {
        const data = await response.json();
        setBackupConfig(data);
      }
      // Don't throw error if not found, use defaults
    } catch (error) {
      console.error('Could not fetch backup config:', error);
    }
  };

  useEffect(() => {
    fetchBackups();
    fetchConfig();
  }, []);

  const handleSaveConfig = async () => {
    setIsSavingConfig(true);
    try {
      const response = await fetch('/api/db/config', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(backupConfig),
      });
      if (!response.ok) throw new Error('Failed to save configuration.');
      toast.success('Configuration saved successfully!');
    } catch (error) {
      toast.error(
        error instanceof Error ? error.message : 'Failed to save configuration.'
      );
    } finally {
      setIsSavingConfig(false);
    }
  };

  return (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle>Local Development Backups</CardTitle>
          <CardDescription>
            Manage manual backups for your local database. These files are
            stored in the `supabase/backups` directory.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="flex items-center gap-4 mb-4">
            <Button onClick={handleCreateBackup} disabled={isCreating}>
              {isCreating ? (
                <>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" /> Creating...
                </>
              ) : (
                <>
                  <PlusCircle className="mr-2 h-4 w-4" /> Create Backup Now
                </>
              )}
            </Button>
            <Button asChild variant="outline">
              <Label htmlFor="restore-upload">
                {isRestoring ? (
                  <>
                    <Loader2 className="mr-2 h-4 w-4 animate-spin" />{' '}
                    Restoring...
                  </>
                ) : (
                  <>
                    <Upload className="mr-2 h-4 w-4" /> Restore from File
                  </>
                )}
                <Input
                  id="restore-upload"
                  type="file"
                  className="hidden"
                  onChange={handleRestore}
                  accept=".sql"
                  disabled={isRestoring}
                />
              </Label>
            </Button>
          </div>
          <Card>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Backup File</TableHead>
                  <TableHead>Size</TableHead>
                  <TableHead>Created At</TableHead>
                  <TableHead className="text-right">Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {isFetching ? (
                  <TableRow>
                    <TableCell colSpan={4} className="text-center">
                      Loading backups...
                    </TableCell>
                  </TableRow>
                ) : backups.length > 0 ? (
                  backups.map((backup) => (
                    <TableRow key={backup.name}>
                      <TableCell className="font-medium">
                        {backup.name}
                      </TableCell>
                      <TableCell>{backup.size}</TableCell>
                      <TableCell>{backup.createdAt}</TableCell>
                      <TableCell className="text-right">
                        <Button asChild variant="ghost" size="icon">
                          <a
                            href={`/api/db/download?file=${backup.name}`}
                            download
                          >
                            <Download className="h-4 w-4" />
                          </a>
                        </Button>
                        <Button
                          variant="ghost"
                          size="icon"
                          onClick={() => handleDeleteBackup(backup.name)}
                          disabled={deletingFile === backup.name}
                          aria-label={`Delete backup ${backup.name}`}
                          className="h-8 w-8"
                        >
                          {deletingFile === backup.name ? (
                            <Loader2 className="h-4 w-4 animate-spin" />
                          ) : (
                            <Trash2 className="h-4 w-4 text-destructive" />
                          )}
                        </Button>
                      </TableCell>
                    </TableRow>
                  ))
                ) : (
                  <TableRow>
                    <TableCell colSpan={4} className="text-center">
                      No backups found.
                    </TableCell>
                  </TableRow>
                )}
              </TableBody>
            </Table>
          </Card>
        </CardContent>
        <CardFooter>
          <p className="text-sm text-muted-foreground">
            Restore will overwrite the current database. Use with caution.
          </p>
        </CardFooter>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Production Backup Configuration</CardTitle>
          <CardDescription>
            Configure automated backups for the production environment. This
            only saves the configuration; a separate cron job on the server is
            required to execute the backups.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="schedule">Backup Schedule</Label>
            <Select
              value={backupConfig.schedule}
              onValueChange={(value: string) =>
                setBackupConfig({ ...backupConfig, schedule: value })
              }
            >
              <SelectTrigger id="schedule">
                <SelectValue placeholder="Select a schedule" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="daily">Daily</SelectItem>
                <SelectItem value="weekly">Weekly</SelectItem>
                <SelectItem value="monthly">Monthly</SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-2">
            <Label htmlFor="time">Backup Time (UTC)</Label>
            <Input
              id="time"
              type="time"
              value={backupConfig.time}
              onChange={(e: ChangeEvent<HTMLInputElement>) =>
                setBackupConfig({ ...backupConfig, time: e.target.value })
              }
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="storagePath">Storage Path</Label>
            <Input
              id="storagePath"
              type="text"
              value={backupConfig.storagePath}
              onChange={(e: ChangeEvent<HTMLInputElement>) =>
                setBackupConfig({
                  ...backupConfig,
                  storagePath: e.target.value,
                })
              }
              placeholder="e.g., /path/to/backups or s3://bucket-name/"
            />
          </div>
        </CardContent>
        <CardFooter>
          <Button onClick={handleSaveConfig} disabled={isSavingConfig}>
            {isSavingConfig ? (
              <>
                <Loader2 className="mr-2 h-4 w-4 animate-spin" /> Saving...
              </>
            ) : (
              'Save Configuration'
            )}
          </Button>
        </CardFooter>
      </Card>
    </div>
  );
}
