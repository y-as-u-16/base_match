-- =============================================================
-- Migration: create_users
-- Description: usersテーブル作成 (auth.uid() 連携)
-- =============================================================

create table public.users (
  id         uuid        primary key references auth.users(id) on delete cascade,
  display_name text      not null,
  photo_url  text,
  created_at timestamptz not null default now()
);

comment on table public.users is 'アプリユーザーのプロフィール情報';
