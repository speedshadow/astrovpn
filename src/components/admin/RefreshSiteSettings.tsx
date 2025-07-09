import React from 'react';
import { toast } from 'sonner';
import { Button } from '@/components/ui/button';
import { RefreshCw } from 'lucide-react';

export function RefreshSiteSettings() {
  const handleRefresh = async () => {
    try {
      toast.info('Atualizando configurações...');

      // Usar o novo endpoint para forçar a atualização das configurações
      window.location.href = '/api/force-update-settings';
    } catch (error) {
      toast.error('Erro ao atualizar configurações');
      console.error(error);
    }
  };

  return (
    <Button
      variant="outline"
      size="sm"
      onClick={handleRefresh}
      className="flex items-center gap-1"
    >
      <RefreshCw className="h-4 w-4" />
      <span>Atualizar Configurações</span>
    </Button>
  );
}
