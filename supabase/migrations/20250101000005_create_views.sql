-- =============================================================
-- Migration: create_views
-- Description: 集計ビュー作成
-- =============================================================

-- ---------------------------------------------------------
-- v_matchup_batter_pitcher
-- バッター x ピッチャーの対戦成績集計
-- ---------------------------------------------------------
create or replace view public.v_matchup_batter_pitcher as
select
  pa.batter_player_id,
  pa.pitcher_player_id,
  bp.display_name as batter_name,
  pp.display_name as pitcher_name,
  -- 打数 (打席のうちヒット/アウト/エラー)
  count(*) filter (where pa.result_type in ('hit', 'out', 'error'))  as ab,
  -- 安打数
  count(*) filter (where pa.result_type = 'hit')                     as hits,
  -- 本塁打
  count(*) filter (where pa.result_detail = 'hr')                    as hr,
  -- 四死球
  count(*) filter (where pa.result_type = 'walk')                    as bb_hbp,
  -- 三振
  count(*) filter (where pa.result_detail = 'k')                     as so,
  -- 打率 (打数 > 0 のみ)
  case
    when count(*) filter (where pa.result_type in ('hit', 'out', 'error')) > 0
    then round(
      count(*) filter (where pa.result_type = 'hit')::numeric
      / count(*) filter (where pa.result_type in ('hit', 'out', 'error')),
      3
    )
    else null
  end as avg
from public.plate_appearances pa
join public.players bp on bp.id = pa.batter_player_id
join public.players pp on pp.id = pa.pitcher_player_id
group by pa.batter_player_id, pa.pitcher_player_id, bp.display_name, pp.display_name;

comment on view public.v_matchup_batter_pitcher is 'バッター x ピッチャー対戦成績集計';

-- ---------------------------------------------------------
-- v_matchup_team_team
-- チーム x チームの対戦成績集計 (対称性のため least/greatest で正規化)
-- ---------------------------------------------------------
create or replace view public.v_matchup_team_team as
select
  least(g.home_team_id, g.away_team_id)    as team_a_id,
  greatest(g.home_team_id, g.away_team_id) as team_b_id,
  ta.name as team_a_name,
  tb.name as team_b_name,
  -- 試合数 (final のみ)
  count(*)                                  as games,
  -- team_a の勝利数
  count(*) filter (where
    (least(g.home_team_id, g.away_team_id) = g.home_team_id and g.home_score > g.away_score)
    or
    (least(g.home_team_id, g.away_team_id) = g.away_team_id and g.away_score > g.home_score)
  ) as wins_a,
  -- team_b の勝利数
  count(*) filter (where
    (greatest(g.home_team_id, g.away_team_id) = g.home_team_id and g.home_score > g.away_score)
    or
    (greatest(g.home_team_id, g.away_team_id) = g.away_team_id and g.away_score > g.home_score)
  ) as wins_b,
  -- 引き分け
  count(*) filter (where g.home_score = g.away_score) as draws,
  -- team_a の得点合計
  sum(case
    when least(g.home_team_id, g.away_team_id) = g.home_team_id then g.home_score
    else g.away_score
  end) as runs_a,
  -- team_b の得点合計
  sum(case
    when greatest(g.home_team_id, g.away_team_id) = g.home_team_id then g.home_score
    else g.away_score
  end) as runs_b
from public.games g
join public.teams ta on ta.id = least(g.home_team_id, g.away_team_id)
join public.teams tb on tb.id = greatest(g.home_team_id, g.away_team_id)
where g.status = 'final'
  and g.home_score is not null
  and g.away_score is not null
group by least(g.home_team_id, g.away_team_id),
         greatest(g.home_team_id, g.away_team_id),
         ta.name,
         tb.name;

comment on view public.v_matchup_team_team is 'チーム x チーム対戦成績集計 (least/greatest で正規化)';
