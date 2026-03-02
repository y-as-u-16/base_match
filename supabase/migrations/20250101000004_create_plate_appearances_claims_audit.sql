-- =============================================================
-- Migration: create_plate_appearances_claims_audit
-- Description: plate_appearances, claims, audit_logs テーブル作成
-- =============================================================

create table public.plate_appearances (
  id                uuid        primary key default gen_random_uuid(),
  game_id           uuid        not null references public.games(id) on delete cascade,
  inning            int,
  batter_player_id  uuid        not null references public.players(id),
  pitcher_player_id uuid        not null references public.players(id),
  result_type       text        not null check (result_type in ('out', 'hit', 'walk', 'error')),
  result_detail     text        not null check (result_detail in (
    'single', 'double', 'triple', 'hr',
    'k', 'ground', 'fly', 'line', 'dp', 'other',
    'bb', 'hbp', 'e'
  )),
  rbi               int,
  created_by        uuid        not null references public.users(id),
  created_at        timestamptz not null default now()
);

comment on table public.plate_appearances is '打席イベント (一次データ)';

create index idx_pa_game_id on public.plate_appearances (game_id);
create index idx_pa_batter on public.plate_appearances (batter_player_id);
create index idx_pa_pitcher on public.plate_appearances (pitcher_player_id);

create table public.claims (
  id              uuid        primary key default gen_random_uuid(),
  player_id       uuid        not null references public.players(id) on delete cascade,
  claimed_user_id uuid        not null references public.users(id),
  status          text        not null default 'approved',
  created_at      timestamptz not null default now()
);

comment on table public.claims is '仮プレイヤーを本人に紐づける申請';

create index idx_claims_player_id on public.claims (player_id);
create index idx_claims_claimed_user_id on public.claims (claimed_user_id);

create table public.audit_logs (
  id             uuid        primary key default gen_random_uuid(),
  actor_user_id  uuid        not null references public.users(id),
  entity_type    text        not null,
  entity_id      uuid        not null,
  action         text        not null check (action in ('create', 'update', 'delete')),
  payload        jsonb       not null,
  created_at     timestamptz not null default now()
);

comment on table public.audit_logs is '操作ログ';

create index idx_audit_logs_entity on public.audit_logs (entity_type, entity_id);
create index idx_audit_logs_actor on public.audit_logs (actor_user_id);
