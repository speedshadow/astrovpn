alter table public.vpns
  add column has_p2p boolean not null default false,
  add column has_kill_switch boolean not null default false,
  add column has_ad_blocker boolean not null default false,
  add column has_split_tunneling boolean not null default false,
  add column simultaneous_connections integer;
