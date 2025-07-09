-- Adiciona a coluna full_review à tabela de VPNs para guardar a análise completa em formato de texto (HTML).
ALTER TABLE public.vpns
ADD COLUMN full_review TEXT;
