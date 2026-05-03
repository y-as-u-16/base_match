// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '草野球マッチ';

  @override
  String get brandName => 'base_match';

  @override
  String get navHome => 'ホーム';

  @override
  String get navRecord => '記録';

  @override
  String get navStats => '成績';

  @override
  String get homeHeadline => '試合を記録しよう';

  @override
  String get homeDescription => '対戦カード、打席、ピッチング成績をまとめて残せます。';

  @override
  String get seasonSummaryTitle => '今季サマリー';

  @override
  String seasonSummarySubtitle(int year) {
    return '$year年の記録';
  }

  @override
  String get seasonGamesMetricLabel => '試合';

  @override
  String get seasonRecordMetricLabel => '勝敗';

  @override
  String get seasonRunsMetricLabel => '得点';

  @override
  String get seasonAverageMetricLabel => '打率';

  @override
  String get seasonEraMetricLabel => '防御率';

  @override
  String seasonGamesCount(int count) {
    return '$count試合';
  }

  @override
  String seasonRecordLabel(int wins, int losses, int draws) {
    return '$wins勝 $losses敗 $draws分';
  }

  @override
  String seasonRunsLabel(int runs) {
    return '$runs点';
  }

  @override
  String get recordGameButton => '試合を記録する';

  @override
  String get viewStatsButton => '成績を見る';

  @override
  String get recentGamesTitle => '直近の試合';

  @override
  String get homeEmptyGames => 'まだ試合がありません。最初の試合を記録してください。';

  @override
  String get recordTitle => '記録';

  @override
  String get addGameButton => '試合を追加';

  @override
  String get gamesListViewLabel => 'リスト';

  @override
  String get gamesCalendarViewLabel => 'カレンダー';

  @override
  String get gamesCalendarPlaceholder => 'カレンダー表示は次の手順で追加します';

  @override
  String get emptyGamesTitle => 'まだ試合がありません';

  @override
  String get emptyGamesSubtitle => '試合を作成して、打席やピッチング成績を記録します。';

  @override
  String get createGameButton => '試合を作成する';

  @override
  String get createGameTitle => '試合を作成';

  @override
  String get gameDateLabel => '試合日';

  @override
  String get homeTeamNameLabel => '自チーム名';

  @override
  String get homeTeamNameRequired => 'チーム名を入力してください';

  @override
  String get awayTeamNameLabel => '相手チーム名';

  @override
  String get awayTeamNameRequired => '相手チーム名を入力してください';

  @override
  String get homeScoreLabel => '自チーム得点';

  @override
  String get awayScoreLabel => '相手チーム得点';

  @override
  String get scoreRequired => '点数を入力してください';

  @override
  String get scoreMustBeNonNegative => '0以上の点数を入力してください';

  @override
  String get locationOptionalLabel => '球場（任意）';

  @override
  String get inningsCountLabel => 'イニング数';

  @override
  String inningsShort(int innings) {
    return '$innings回';
  }

  @override
  String get createButton => '作成する';

  @override
  String get gameDetailTitle => '試合詳細';

  @override
  String get gameNotFound => '試合が見つかりません';

  @override
  String get addPlateAppearanceButton => '打席';

  @override
  String get addPitchingButton => '投手';

  @override
  String get plateAppearanceRecordsTitle => '打席記録';

  @override
  String get emptyPlateAppearances => 'まだ打席記録がありません';

  @override
  String plateAppearanceListSubtitle(String inning, int rbi) {
    return '$inning回 / 打点 $rbi';
  }

  @override
  String get pitchingRecordsTitle => 'ピッチング記録';

  @override
  String get emptyPitchingAppearances => 'まだピッチング記録がありません';

  @override
  String pitchingOutsTitle(String innings) {
    return '投球回 $innings';
  }

  @override
  String pitchingListSubtitle(int runs, int earnedRuns, int strikeouts) {
    return '失点 $runs / 自責 $earnedRuns / 奪三振 $strikeouts';
  }

  @override
  String inningsOnlyLabel(int innings) {
    return '$innings回';
  }

  @override
  String inningsWithRestLabel(int innings, int rest) {
    return '$innings回$rest/3';
  }

  @override
  String get resultHit => 'ヒット';

  @override
  String get resultOut => 'アウト';

  @override
  String get resultWalk => '四死球';

  @override
  String get resultError => 'エラー';

  @override
  String get detailSingle => '単打';

  @override
  String get detailDouble => '二塁打';

  @override
  String get detailTriple => '三塁打';

  @override
  String get detailHomeRun => '本塁打';

  @override
  String get detailStrikeout => '三振';

  @override
  String get detailGround => 'ゴロ';

  @override
  String get detailFly => 'フライ';

  @override
  String get detailLine => 'ライナー';

  @override
  String get detailDoublePlay => '併殺';

  @override
  String get detailSacBunt => '犠打';

  @override
  String get detailSacFly => '犠飛';

  @override
  String get detailOther => 'その他';

  @override
  String get detailWalk => '四球';

  @override
  String get detailHitByPitch => '死球';

  @override
  String get detailError => 'エラー';

  @override
  String get plateAppearanceInputTitle => '打席入力';

  @override
  String get selectPlateAppearanceResultMessage => '打席結果を選択してください';

  @override
  String get notSelectedLabel => '未選択';

  @override
  String get playerNameRequired => '選手名を入力してください';

  @override
  String get batterNameLabel => '打者名';

  @override
  String plateAppearanceSummary(int inning, String result, int rbi) {
    return '$inning回 / $result / 打点 $rbi';
  }

  @override
  String get inningLabel => 'イニング';

  @override
  String get rbiLabel => '打点';

  @override
  String get hitSectionTitle => 'ヒット';

  @override
  String get outSectionTitle => 'アウト';

  @override
  String get onBaseSectionTitle => '出塁・その他';

  @override
  String get saveButton => '登録する';

  @override
  String decreaseLabelTooltip(String label) {
    return '$labelを減らす';
  }

  @override
  String increaseLabelTooltip(String label) {
    return '$labelを増やす';
  }

  @override
  String get pitchingInputTitle => 'ピッチング入力';

  @override
  String get pitcherNameLabel => '投手名';

  @override
  String pitchingInputSummary(String innings, int runs, int earnedRuns) {
    return '投球回 $innings / 失点 $runs / 自責 $earnedRuns';
  }

  @override
  String get runsLabel => '失点';

  @override
  String get earnedRunsLabel => '自責点';

  @override
  String get hitsAllowedLabel => '被安打';

  @override
  String get walksAllowedLabel => '与四死球';

  @override
  String get strikeoutsLabel => '奪三振';

  @override
  String get homeRunsAllowedLabel => '被本塁打';

  @override
  String get pitchingInningsLabel => '投球回';

  @override
  String get decreaseOneOutTooltip => '1アウト減らす';

  @override
  String get increaseOneOutTooltip => '1アウト増やす';

  @override
  String outsLabel(int outs) {
    return '$outs アウト';
  }

  @override
  String get addOneThirdInningButton => '+1/3回';

  @override
  String get addOneInningButton => '+1回';

  @override
  String get resetOneInningButton => '1回に戻す';

  @override
  String get statsTitle => '成績';

  @override
  String get battingStatsTitle => '打撃成績';

  @override
  String get pitchingStatsTitle => 'ピッチング成績';

  @override
  String get personalBattingTitle => '自分の打撃';

  @override
  String get noBattingStatsLabel => '打撃記録なし';

  @override
  String battingStatsSummary(int pa, int ab, int hits, int hr, int so) {
    return '打席 $pa / 打数 $ab / 安打 $hits / 本塁打 $hr / 三振 $so';
  }

  @override
  String get personalPitchingTitle => '自分の投球';

  @override
  String get noPitchingStatsLabel => '投球記録なし';

  @override
  String pitchingStatsSummary(
    int games,
    String innings,
    int earnedRuns,
    int strikeouts,
  ) {
    return '登板 $games / 投球回 $innings / 自責 $earnedRuns / 奪三振 $strikeouts';
  }

  @override
  String get reloadButton => '再読み込み';

  @override
  String get addMyTeamButton => 'チームを追加';

  @override
  String get addMyTeamTitle => '自チームを追加';

  @override
  String get myTeamNameLabel => 'チーム名';

  @override
  String get myTeamNameRequired => 'チーム名を入力してください';

  @override
  String get myTeamSelectLabel => '自チーム';

  @override
  String get selectMyTeamRequired => '自チームを選択してください';

  @override
  String get noMyTeamsForGameTitle => '自チームを追加してください';

  @override
  String get noMyTeamsForGameSubtitle => '試合を作成するには、先に自分のチームが必要です。';

  @override
  String get defaultMyTeamBadge => 'デフォルト';

  @override
  String get myTeamCreatedMessage => 'チームを追加しました';

  @override
  String get unknownMyTeamLabel => '不明なチーム';

  @override
  String get cancelButton => 'キャンセル';

  @override
  String get addButton => '追加';
}
