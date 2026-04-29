-- =============================================================
-- Migration: create_user_trigger
-- Description: auth.users作成時にpublic.usersへ自動挿入するトリガー
-- =============================================================

-- サインアップ時にpublic.usersレコードを自動作成する関数
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.users (id, display_name)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'display_name', '名無し')
  );
  return new;
end;
$$;

-- auth.usersへのINSERT後にトリガー実行
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();