-- =============================================================
-- Migration: create_join_team_rpc
-- Description: 招待コード参加をサーバー側で検証するRPC
-- =============================================================

create or replace function public.join_team_by_invite_code(p_invite_code text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_team_id uuid;
begin
  if auth.uid() is null then
    raise exception 'UNAUTHENTICATED';
  end if;

  select t.id
    into v_team_id
  from public.teams t
  where t.invite_code = upper(trim(p_invite_code))
  limit 1;

  if v_team_id is null then
    raise exception 'TEAM_NOT_FOUND';
  end if;

  if exists (
    select 1
    from public.team_members tm
    where tm.team_id = v_team_id
      and tm.user_id = auth.uid()
  ) then
    raise exception 'ALREADY_MEMBER';
  end if;

  insert into public.team_members (team_id, user_id, role)
  values (v_team_id, auth.uid(), 'member');

  return v_team_id;
end;
$$;

grant execute on function public.join_team_by_invite_code(text) to authenticated;
