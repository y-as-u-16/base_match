-- =============================================================
-- Migration: create_players_and_games
-- Description: playersテーブル + gamesテーブル作成
-- =============================================================

create table public.players (
  id           uuid        primary key default gen_random_uuid(),
  team_id      uuid        references public.teams(id) on delete set null,
  display_name text        not null,
  user_id      uuid        references public.users(id) on delete set null,
  created_by   uuid        not null references public.users(id),
  created_at   timestamptz not null default now()
);

comment on table public.players is '選手 (user_id が null の場合は仮プレイヤー)';

create index idx_players_team_id on public.players (team_id);
create index idx_players_user_id on public.players (user_id);

create table public.games (
  id            uuid        primary key default gen_random_uuid(),
  date          date        not null,
  location      text,
  home_team_id  uuid        not null references public.teams(id),
  away_team_id  uuid        not null references public.teams(id),
  home_score    int,
  away_score    int,
  status        text        not null default 'draft' check (status in ('draft', 'final')),
  created_by    uuid        not null references public.users(id),
  created_at    timestamptz not null default now()
);

comment on table public.games is '試合';

create index idx_games_home_team_id on public.games (home_team_id);
create index idx_games_away_team_id on public.games (away_team_id);
create index idx_games_date on public.games (date);
