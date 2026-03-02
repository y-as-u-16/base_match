-- =============================================================
-- Migration: create_rls_policies
-- Description: Row Level Security ポリシー設定
-- =============================================================

-- ---------------------------------------------------------
-- users: 全員参照可、自分のレコードのみ更新/挿入可
-- ---------------------------------------------------------
alter table public.users enable row level security;

create policy "users: 全員参照可"
  on public.users for select
  using (true);

create policy "users: 本人のみ挿入可"
  on public.users for insert
  with check (auth.uid() = id);

create policy "users: 本人のみ更新可"
  on public.users for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- ---------------------------------------------------------
-- teams: チームメンバーのみ参照可
-- ---------------------------------------------------------
alter table public.teams enable row level security;

create policy "teams: メンバーのみ参照可"
  on public.teams for select
  using (
    exists (
      select 1 from public.team_members tm
      where tm.team_id = teams.id
        and tm.user_id = auth.uid()
    )
  );

create policy "teams: 認証ユーザーは作成可"
  on public.teams for insert
  with check (auth.uid() = created_by);

create policy "teams: owner/adminのみ更新可"
  on public.teams for update
  using (
    exists (
      select 1 from public.team_members tm
      where tm.team_id = teams.id
        and tm.user_id = auth.uid()
        and tm.role in ('owner', 'admin')
    )
  );

create policy "teams: ownerのみ削除可"
  on public.teams for delete
  using (
    exists (
      select 1 from public.team_members tm
      where tm.team_id = teams.id
        and tm.user_id = auth.uid()
        and tm.role = 'owner'
    )
  );

-- ---------------------------------------------------------
-- team_members: チームメンバーのみ参照可、owner/adminのみ変更可
-- ---------------------------------------------------------
alter table public.team_members enable row level security;

create policy "team_members: メンバーのみ参照可"
  on public.team_members for select
  using (
    exists (
      select 1 from public.team_members tm
      where tm.team_id = team_members.team_id
        and tm.user_id = auth.uid()
    )
  );

create policy "team_members: owner/adminのみ挿入可"
  on public.team_members for insert
  with check (
    -- 既存の owner/admin が他のメンバーを追加する場合
    exists (
      select 1 from public.team_members tm
      where tm.team_id = team_members.team_id
        and tm.user_id = auth.uid()
        and tm.role in ('owner', 'admin')
    )
    -- チーム作成者が最初のメンバー(owner)を追加する場合
    or (
      team_members.role = 'owner'
      and team_members.user_id = auth.uid()
      and exists (
        select 1 from public.teams t
        where t.id = team_members.team_id
          and t.created_by = auth.uid()
      )
      and not exists (
        select 1 from public.team_members tm
        where tm.team_id = team_members.team_id
      )
    )
  );

create policy "team_members: owner/adminのみ更新可"
  on public.team_members for update
  using (
    exists (
      select 1 from public.team_members tm
      where tm.team_id = team_members.team_id
        and tm.user_id = auth.uid()
        and tm.role in ('owner', 'admin')
    )
  );

create policy "team_members: owner/adminのみ削除可"
  on public.team_members for delete
  using (
    exists (
      select 1 from public.team_members tm
      where tm.team_id = team_members.team_id
        and tm.user_id = auth.uid()
        and tm.role in ('owner', 'admin')
    )
  );

-- ---------------------------------------------------------
-- players: 関連チームメンバーのみ参照可
-- ---------------------------------------------------------
alter table public.players enable row level security;

create policy "players: 関連チームメンバーのみ参照可"
  on public.players for select
  using (
    -- チーム所属の選手: そのチームのメンバーなら参照可
    (
      players.team_id is not null
      and exists (
        select 1 from public.team_members tm
        where tm.team_id = players.team_id
          and tm.user_id = auth.uid()
      )
    )
    -- チーム未所属の選手: 作成者なら参照可
    or players.created_by = auth.uid()
  );

create policy "players: 認証ユーザーは作成可"
  on public.players for insert
  with check (auth.uid() = created_by);

create policy "players: 作成者またはチームadmin/ownerのみ更新可"
  on public.players for update
  using (
    players.created_by = auth.uid()
    or (
      players.team_id is not null
      and exists (
        select 1 from public.team_members tm
        where tm.team_id = players.team_id
          and tm.user_id = auth.uid()
          and tm.role in ('owner', 'admin')
      )
    )
  );

-- ---------------------------------------------------------
-- games: 参加チームメンバーのみ参照可
-- ---------------------------------------------------------
alter table public.games enable row level security;

create policy "games: 参加チームメンバーのみ参照可"
  on public.games for select
  using (
    exists (
      select 1 from public.team_members tm
      where (tm.team_id = games.home_team_id or tm.team_id = games.away_team_id)
        and tm.user_id = auth.uid()
    )
  );

create policy "games: 認証ユーザーは作成可"
  on public.games for insert
  with check (auth.uid() = created_by);

create policy "games: 参加チームadmin/ownerのみ更新可"
  on public.games for update
  using (
    exists (
      select 1 from public.team_members tm
      where (tm.team_id = games.home_team_id or tm.team_id = games.away_team_id)
        and tm.user_id = auth.uid()
        and tm.role in ('owner', 'admin')
    )
  );

-- ---------------------------------------------------------
-- plate_appearances: 参加チームメンバーのみ参照可、admin/ownerのみ変更可
-- ---------------------------------------------------------
alter table public.plate_appearances enable row level security;

create policy "plate_appearances: 参加チームメンバーのみ参照可"
  on public.plate_appearances for select
  using (
    exists (
      select 1
      from public.games g
      join public.team_members tm
        on tm.team_id = g.home_team_id or tm.team_id = g.away_team_id
      where g.id = plate_appearances.game_id
        and tm.user_id = auth.uid()
    )
  );

create policy "plate_appearances: 参加チームadmin/ownerのみ挿入可"
  on public.plate_appearances for insert
  with check (
    exists (
      select 1
      from public.games g
      join public.team_members tm
        on tm.team_id = g.home_team_id or tm.team_id = g.away_team_id
      where g.id = plate_appearances.game_id
        and tm.user_id = auth.uid()
        and tm.role in ('owner', 'admin')
    )
  );

create policy "plate_appearances: 参加チームadmin/ownerのみ更新可"
  on public.plate_appearances for update
  using (
    exists (
      select 1
      from public.games g
      join public.team_members tm
        on tm.team_id = g.home_team_id or tm.team_id = g.away_team_id
      where g.id = plate_appearances.game_id
        and tm.user_id = auth.uid()
        and tm.role in ('owner', 'admin')
    )
  );

create policy "plate_appearances: 参加チームadmin/ownerのみ削除可"
  on public.plate_appearances for delete
  using (
    exists (
      select 1
      from public.games g
      join public.team_members tm
        on tm.team_id = g.home_team_id or tm.team_id = g.away_team_id
      where g.id = plate_appearances.game_id
        and tm.user_id = auth.uid()
        and tm.role in ('owner', 'admin')
    )
  );

-- ---------------------------------------------------------
-- claims: 当事者のみ参照可
-- ---------------------------------------------------------
alter table public.claims enable row level security;

create policy "claims: 当事者のみ参照可"
  on public.claims for select
  using (
    claims.claimed_user_id = auth.uid()
    or exists (
      select 1 from public.players p
      where p.id = claims.player_id
        and p.created_by = auth.uid()
    )
  );

create policy "claims: 認証ユーザーは作成可"
  on public.claims for insert
  with check (auth.uid() = claimed_user_id);

-- ---------------------------------------------------------
-- audit_logs: admin以上のみ参照可
-- ---------------------------------------------------------
alter table public.audit_logs enable row level security;

create policy "audit_logs: admin以上のみ参照可"
  on public.audit_logs for select
  using (
    exists (
      select 1 from public.team_members tm
      where tm.user_id = auth.uid()
        and tm.role in ('owner', 'admin')
    )
  );

create policy "audit_logs: システムのみ挿入可"
  on public.audit_logs for insert
  with check (auth.uid() = actor_user_id);
