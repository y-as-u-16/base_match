-- =============================================================
-- Migration: create_teams_and_members
-- Description: teamsテーブル + team_membersテーブル作成
-- =============================================================

create table public.teams (
  id          uuid        primary key default gen_random_uuid(),
  name        text        not null,
  area        text,
  photo_url   text,
  invite_code text        unique not null,
  created_by  uuid        not null references public.users(id),
  created_at  timestamptz not null default now()
);

comment on table public.teams is 'チーム';

create table public.team_members (
  id         uuid        primary key default gen_random_uuid(),
  team_id    uuid        not null references public.teams(id) on delete cascade,
  user_id    uuid        not null references public.users(id) on delete cascade,
  role       text        not null check (role in ('owner', 'admin', 'member')),
  created_at timestamptz not null default now(),
  unique (team_id, user_id)
);

comment on table public.team_members is 'チームメンバー (チームとユーザーの中間テーブル)';

-- invite_code の検索用インデックス
create index idx_teams_invite_code on public.teams (invite_code);

-- team_members の検索用インデックス
create index idx_team_members_team_id on public.team_members (team_id);
create index idx_team_members_user_id on public.team_members (user_id);
