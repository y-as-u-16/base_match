-- =============================================================
-- seed.sql: テスト用シードデータ
-- ローカル開発環境 (supabase start) でのみ使用
-- =============================================================

-- テスト用ユーザー (auth.users に直接挿入 - ローカル環境用)
insert into auth.users (id, instance_id, email, encrypted_password, email_confirmed_at, aud, role, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, email_change, email_change_token_new, email_change_token_current, recovery_token, reauthentication_token, phone_change, phone_change_token)
values
  (
    '11111111-1111-1111-1111-111111111111',
    '00000000-0000-0000-0000-000000000000',
    'taro@example.com',
    crypt('password123', gen_salt('bf')),
    now(),
    'authenticated',
    'authenticated',
    '{"provider":"email","providers":["email"]}',
    '{"display_name":"山田太郎"}',
    now(),
    now(),
    '', '', '', '', '', '', '', ''
  ),
  (
    '22222222-2222-2222-2222-222222222222',
    '00000000-0000-0000-0000-000000000000',
    'hanako@example.com',
    crypt('password123', gen_salt('bf')),
    now(),
    'authenticated',
    'authenticated',
    '{"provider":"email","providers":["email"]}',
    '{"display_name":"鈴木花子"}',
    now(),
    now(),
    '', '', '', '', '', '', '', ''
  );

-- identities (Supabase Auth が必要とする)
insert into auth.identities (id, provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
values
  (
    '11111111-1111-1111-1111-111111111111',
    '11111111-1111-1111-1111-111111111111',
    '11111111-1111-1111-1111-111111111111',
    jsonb_build_object('sub', '11111111-1111-1111-1111-111111111111', 'email', 'taro@example.com'),
    'email',
    now(),
    now(),
    now()
  ),
  (
    '22222222-2222-2222-2222-222222222222',
    '22222222-2222-2222-2222-222222222222',
    '22222222-2222-2222-2222-222222222222',
    jsonb_build_object('sub', '22222222-2222-2222-2222-222222222222', 'email', 'hanako@example.com'),
    'email',
    now(),
    now(),
    now()
  );

-- public.users プロフィール (トリガーで自動作成されるため、ON CONFLICTで上書き)
insert into public.users (id, display_name, photo_url)
values
  ('11111111-1111-1111-1111-111111111111', '山田太郎', null),
  ('22222222-2222-2222-2222-222222222222', '鈴木花子', null)
on conflict (id) do update set
  display_name = excluded.display_name,
  photo_url = excluded.photo_url;

-- チーム作成
insert into public.teams (id, name, area, invite_code, created_by)
values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'サンダーボルツ', '東京都', 'THUNDER2025', '11111111-1111-1111-1111-111111111111'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'ライジングスターズ', '神奈川県', 'RISING2025', '22222222-2222-2222-2222-222222222222');

-- チームメンバー
insert into public.team_members (team_id, user_id, role)
values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'owner'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222', 'member'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '22222222-2222-2222-2222-222222222222', 'owner'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '11111111-1111-1111-1111-111111111111', 'member');

-- 選手 (実在ユーザーと仮プレイヤー)
insert into public.players (id, team_id, display_name, user_id, created_by)
values
  -- サンダーボルツの選手
  ('a1111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '山田太郎', '11111111-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111'),
  ('a2222222-2222-2222-2222-222222222222', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '佐藤次郎', null, '11111111-1111-1111-1111-111111111111'),  -- 仮プレイヤー
  -- ライジングスターズの選手
  ('b1111111-1111-1111-1111-111111111111', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '鈴木花子', '22222222-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222'),
  ('b2222222-2222-2222-2222-222222222222', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '高橋三郎', null, '22222222-2222-2222-2222-222222222222');  -- 仮プレイヤー

-- 試合
insert into public.games (id, date, location, home_team_id, away_team_id, home_score, away_score, status, created_by)
values
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', '2025-04-01', '河川敷グラウンドA', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 5, 3, 'final', '11111111-1111-1111-1111-111111111111'),
  ('dddddddd-dddd-dddd-dddd-dddddddddddd', '2025-05-15', '市民球場', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 2, 4, 'final', '22222222-2222-2222-2222-222222222222'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', '2025-06-20', '中央公園', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', null, null, 'draft', '11111111-1111-1111-1111-111111111111');

-- 打席データ (試合1: サンダーボルツ 5-3 ライジングスターズ)
insert into public.plate_appearances (game_id, inning, batter_player_id, pitcher_player_id, result_type, result_detail, rbi, created_by)
values
  -- 1回: 山田太郎 vs 鈴木花子 -> シングルヒット
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 1, 'a1111111-1111-1111-1111-111111111111', 'b1111111-1111-1111-1111-111111111111', 'hit', 'single', 0, '11111111-1111-1111-1111-111111111111'),
  -- 1回: 佐藤次郎 vs 鈴木花子 -> 三振
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 1, 'a2222222-2222-2222-2222-222222222222', 'b1111111-1111-1111-1111-111111111111', 'out', 'k', 0, '11111111-1111-1111-1111-111111111111'),
  -- 3回: 山田太郎 vs 高橋三郎 -> ツーベースヒット
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 3, 'a1111111-1111-1111-1111-111111111111', 'b2222222-2222-2222-2222-222222222222', 'hit', 'double', 2, '11111111-1111-1111-1111-111111111111'),
  -- 5回: 山田太郎 vs 鈴木花子 -> ホームラン
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 5, 'a1111111-1111-1111-1111-111111111111', 'b1111111-1111-1111-1111-111111111111', 'hit', 'hr', 1, '11111111-1111-1111-1111-111111111111'),
  -- 相手側の打席: 鈴木花子 vs 山田太郎 -> フライアウト
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 2, 'b1111111-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'out', 'fly', 0, '22222222-2222-2222-2222-222222222222'),
  -- 相手側: 高橋三郎 vs 山田太郎 -> 四球
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 2, 'b2222222-2222-2222-2222-222222222222', 'a1111111-1111-1111-1111-111111111111', 'walk', 'bb', 0, '22222222-2222-2222-2222-222222222222'),
  -- 相手側: 鈴木花子 vs 佐藤次郎 -> シングルヒット
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 4, 'b1111111-1111-1111-1111-111111111111', 'a2222222-2222-2222-2222-222222222222', 'hit', 'single', 1, '22222222-2222-2222-2222-222222222222');

-- 打席データ (試合2: ライジングスターズ 2-4 サンダーボルツ)
insert into public.plate_appearances (game_id, inning, batter_player_id, pitcher_player_id, result_type, result_detail, rbi, created_by)
values
  -- 山田太郎 vs 鈴木花子 -> ゴロアウト
  ('dddddddd-dddd-dddd-dddd-dddddddddddd', 1, 'a1111111-1111-1111-1111-111111111111', 'b1111111-1111-1111-1111-111111111111', 'out', 'ground', 0, '11111111-1111-1111-1111-111111111111'),
  -- 山田太郎 vs 鈴木花子 -> シングルヒット
  ('dddddddd-dddd-dddd-dddd-dddddddddddd', 4, 'a1111111-1111-1111-1111-111111111111', 'b1111111-1111-1111-1111-111111111111', 'hit', 'single', 1, '11111111-1111-1111-1111-111111111111'),
  -- 鈴木花子 vs 山田太郎 -> 死球
  ('dddddddd-dddd-dddd-dddd-dddddddddddd', 2, 'b1111111-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'walk', 'hbp', 0, '22222222-2222-2222-2222-222222222222'),
  -- 鈴木花子 vs 山田太郎 -> ライナーアウト
  ('dddddddd-dddd-dddd-dddd-dddddddddddd', 5, 'b1111111-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'out', 'line', 0, '22222222-2222-2222-2222-222222222222');
