// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Base Match';

  @override
  String get brandName => 'base_match';

  @override
  String get navHome => 'Home';

  @override
  String get navRecord => 'Record';

  @override
  String get navStats => 'Stats';

  @override
  String get homeHeadline => 'Record your games';

  @override
  String get homeDescription =>
      'Keep matchups, plate appearances, and pitching stats in one place.';

  @override
  String get seasonSummaryTitle => 'Season Summary';

  @override
  String seasonSummarySubtitle(int year) {
    return '$year records';
  }

  @override
  String get seasonGamesMetricLabel => 'Games';

  @override
  String get seasonRecordMetricLabel => 'Record';

  @override
  String get seasonRunsMetricLabel => 'Runs';

  @override
  String get seasonAverageMetricLabel => 'AVG';

  @override
  String get seasonEraMetricLabel => 'ERA';

  @override
  String seasonGamesCount(int count) {
    return '$count games';
  }

  @override
  String seasonRecordLabel(int wins, int losses, int draws) {
    return '${wins}W ${losses}L ${draws}D';
  }

  @override
  String seasonRunsLabel(int runs) {
    return '$runs runs';
  }

  @override
  String get recordGameButton => 'Record a game';

  @override
  String get viewStatsButton => 'View stats';

  @override
  String get recentGamesTitle => 'Recent Games';

  @override
  String get homeEmptyGames => 'No games yet. Record your first game.';

  @override
  String get recordTitle => 'Record';

  @override
  String get addGameButton => 'Add game';

  @override
  String get emptyGamesTitle => 'No games yet';

  @override
  String get emptyGamesSubtitle =>
      'Create a game to record plate appearances and pitching stats.';

  @override
  String get createGameButton => 'Create game';

  @override
  String get createGameTitle => 'Create Game';

  @override
  String get gameDateLabel => 'Game date';

  @override
  String get homeTeamNameLabel => 'My team name';

  @override
  String get homeTeamNameRequired => 'Enter a team name';

  @override
  String get awayTeamNameLabel => 'Opponent team name';

  @override
  String get awayTeamNameRequired => 'Enter an opponent team name';

  @override
  String get homeScoreLabel => 'My team score';

  @override
  String get awayScoreLabel => 'Opponent score';

  @override
  String get scoreRequired => 'Enter a score';

  @override
  String get scoreMustBeNonNegative => 'Enter a score of 0 or higher';

  @override
  String get locationOptionalLabel => 'Ballpark (optional)';

  @override
  String get inningsCountLabel => 'Innings';

  @override
  String inningsShort(int innings) {
    return '$innings inn.';
  }

  @override
  String get createButton => 'Create';

  @override
  String get gameDetailTitle => 'Game Details';

  @override
  String get gameNotFound => 'Game not found';

  @override
  String get addPlateAppearanceButton => 'Plate appearance';

  @override
  String get addPitchingButton => 'Pitching';

  @override
  String get plateAppearanceRecordsTitle => 'Plate Appearance Records';

  @override
  String get emptyPlateAppearances => 'No plate appearances yet';

  @override
  String plateAppearanceListSubtitle(String inning, int rbi) {
    return '$inning inn. / RBI $rbi';
  }

  @override
  String get pitchingRecordsTitle => 'Pitching Records';

  @override
  String get emptyPitchingAppearances => 'No pitching records yet';

  @override
  String pitchingOutsTitle(String innings) {
    return 'Innings pitched $innings';
  }

  @override
  String pitchingListSubtitle(int runs, int earnedRuns, int strikeouts) {
    return 'Runs $runs / ER $earnedRuns / SO $strikeouts';
  }

  @override
  String inningsOnlyLabel(int innings) {
    return '$innings inn.';
  }

  @override
  String inningsWithRestLabel(int innings, int rest) {
    return '$innings.$rest inn.';
  }

  @override
  String get resultHit => 'Hit';

  @override
  String get resultOut => 'Out';

  @override
  String get resultWalk => 'Walk/HBP';

  @override
  String get resultError => 'Error';

  @override
  String get detailSingle => 'Single';

  @override
  String get detailDouble => 'Double';

  @override
  String get detailTriple => 'Triple';

  @override
  String get detailHomeRun => 'Home run';

  @override
  String get detailStrikeout => 'Strikeout';

  @override
  String get detailGround => 'Grounder';

  @override
  String get detailFly => 'Fly ball';

  @override
  String get detailLine => 'Line drive';

  @override
  String get detailDoublePlay => 'Double play';

  @override
  String get detailSacBunt => 'Sac bunt';

  @override
  String get detailSacFly => 'Sac fly';

  @override
  String get detailOther => 'Other';

  @override
  String get detailWalk => 'Walk';

  @override
  String get detailHitByPitch => 'Hit by pitch';

  @override
  String get detailError => 'Error';

  @override
  String get plateAppearanceInputTitle => 'Plate Appearance';

  @override
  String get selectPlateAppearanceResultMessage =>
      'Select a plate appearance result';

  @override
  String get notSelectedLabel => 'Not selected';

  @override
  String get playerNameRequired => 'Enter a player name';

  @override
  String get batterNameLabel => 'Batter name';

  @override
  String plateAppearanceSummary(int inning, String result, int rbi) {
    return '$inning inn. / $result / RBI $rbi';
  }

  @override
  String get inningLabel => 'Inning';

  @override
  String get rbiLabel => 'RBI';

  @override
  String get hitSectionTitle => 'Hits';

  @override
  String get outSectionTitle => 'Outs';

  @override
  String get onBaseSectionTitle => 'On base / other';

  @override
  String get saveButton => 'Save';

  @override
  String decreaseLabelTooltip(String label) {
    return 'Decrease $label';
  }

  @override
  String increaseLabelTooltip(String label) {
    return 'Increase $label';
  }

  @override
  String get pitchingInputTitle => 'Pitching';

  @override
  String get pitcherNameLabel => 'Pitcher name';

  @override
  String pitchingInputSummary(String innings, int runs, int earnedRuns) {
    return 'IP $innings / Runs $runs / ER $earnedRuns';
  }

  @override
  String get runsLabel => 'Runs';

  @override
  String get earnedRunsLabel => 'Earned runs';

  @override
  String get hitsAllowedLabel => 'Hits allowed';

  @override
  String get walksAllowedLabel => 'Walks/HBP';

  @override
  String get strikeoutsLabel => 'Strikeouts';

  @override
  String get homeRunsAllowedLabel => 'Home runs allowed';

  @override
  String get pitchingInningsLabel => 'Innings pitched';

  @override
  String get decreaseOneOutTooltip => 'Decrease by 1 out';

  @override
  String get increaseOneOutTooltip => 'Increase by 1 out';

  @override
  String outsLabel(int outs) {
    return '$outs outs';
  }

  @override
  String get addOneThirdInningButton => '+1/3 inn.';

  @override
  String get addOneInningButton => '+1 inn.';

  @override
  String get resetOneInningButton => 'Reset to 1 inn.';

  @override
  String get statsTitle => 'Stats';

  @override
  String get battingStatsTitle => 'Batting Stats';

  @override
  String get pitchingStatsTitle => 'Pitching Stats';

  @override
  String get personalBattingTitle => 'My Batting';

  @override
  String get noBattingStatsLabel => 'No batting records';

  @override
  String battingStatsSummary(int pa, int ab, int hits, int hr, int so) {
    return 'PA $pa / AB $ab / H $hits / HR $hr / SO $so';
  }

  @override
  String get personalPitchingTitle => 'My Pitching';

  @override
  String get noPitchingStatsLabel => 'No pitching records';

  @override
  String pitchingStatsSummary(
    int games,
    String innings,
    int earnedRuns,
    int strikeouts,
  ) {
    return 'G $games / IP $innings / ER $earnedRuns / SO $strikeouts';
  }

  @override
  String get reloadButton => 'Reload';

  @override
  String get myTeamsTitle => 'My Teams';

  @override
  String get manageMyTeamsTooltip => 'Manage my teams';

  @override
  String get addMyTeamButton => 'Add team';

  @override
  String get emptyMyTeamsTitle => 'No teams yet';

  @override
  String get emptyMyTeamsSubtitle =>
      'Add your first team to use it when recording games.';

  @override
  String get addMyTeamTitle => 'Add My Team';

  @override
  String get myTeamNameLabel => 'Team name';

  @override
  String get myTeamNameRequired => 'Enter a team name';

  @override
  String get defaultMyTeamBadge => 'Default';

  @override
  String get myTeamCreatedMessage => 'Team added';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get addButton => 'Add';
}
