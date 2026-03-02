-- =============================================================
-- Migration: add_innings_game_number
-- Description: gamesテーブルにイニング数とダブルヘッダー試合番号カラムを追加
-- =============================================================

alter table public.games
  add column innings int default null,
  add column game_number int default null check (game_number in (1, 2));

comment on column public.games.innings is 'イニング数 (3, 5, 7, 9)';
comment on column public.games.game_number is 'ダブルヘッダー時の試合番号 (1=第1試合, 2=第2試合, null=通常)';
