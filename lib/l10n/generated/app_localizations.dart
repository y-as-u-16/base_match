import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ja, this message translates to:
  /// **'草野球マッチ'**
  String get appTitle;

  /// No description provided for @brandName.
  ///
  /// In ja, this message translates to:
  /// **'base_match'**
  String get brandName;

  /// No description provided for @navHome.
  ///
  /// In ja, this message translates to:
  /// **'ホーム'**
  String get navHome;

  /// No description provided for @navRecord.
  ///
  /// In ja, this message translates to:
  /// **'記録'**
  String get navRecord;

  /// No description provided for @navStats.
  ///
  /// In ja, this message translates to:
  /// **'成績'**
  String get navStats;

  /// No description provided for @homeHeadline.
  ///
  /// In ja, this message translates to:
  /// **'試合を記録しよう'**
  String get homeHeadline;

  /// No description provided for @homeDescription.
  ///
  /// In ja, this message translates to:
  /// **'対戦カード、打席、ピッチング成績をまとめて残せます。'**
  String get homeDescription;

  /// No description provided for @seasonSummaryTitle.
  ///
  /// In ja, this message translates to:
  /// **'今季サマリー'**
  String get seasonSummaryTitle;

  /// No description provided for @seasonSummarySubtitle.
  ///
  /// In ja, this message translates to:
  /// **'{year}年の記録'**
  String seasonSummarySubtitle(int year);

  /// No description provided for @seasonGamesMetricLabel.
  ///
  /// In ja, this message translates to:
  /// **'試合'**
  String get seasonGamesMetricLabel;

  /// No description provided for @seasonRecordMetricLabel.
  ///
  /// In ja, this message translates to:
  /// **'勝敗'**
  String get seasonRecordMetricLabel;

  /// No description provided for @seasonRunsMetricLabel.
  ///
  /// In ja, this message translates to:
  /// **'得点'**
  String get seasonRunsMetricLabel;

  /// No description provided for @seasonAverageMetricLabel.
  ///
  /// In ja, this message translates to:
  /// **'打率'**
  String get seasonAverageMetricLabel;

  /// No description provided for @seasonEraMetricLabel.
  ///
  /// In ja, this message translates to:
  /// **'防御率'**
  String get seasonEraMetricLabel;

  /// No description provided for @seasonGamesCount.
  ///
  /// In ja, this message translates to:
  /// **'{count}試合'**
  String seasonGamesCount(int count);

  /// No description provided for @seasonRecordLabel.
  ///
  /// In ja, this message translates to:
  /// **'{wins}勝 {losses}敗 {draws}分'**
  String seasonRecordLabel(int wins, int losses, int draws);

  /// No description provided for @seasonRunsLabel.
  ///
  /// In ja, this message translates to:
  /// **'{runs}点'**
  String seasonRunsLabel(int runs);

  /// No description provided for @recordGameButton.
  ///
  /// In ja, this message translates to:
  /// **'試合を記録する'**
  String get recordGameButton;

  /// No description provided for @viewStatsButton.
  ///
  /// In ja, this message translates to:
  /// **'成績を見る'**
  String get viewStatsButton;

  /// No description provided for @recentGamesTitle.
  ///
  /// In ja, this message translates to:
  /// **'直近の試合'**
  String get recentGamesTitle;

  /// No description provided for @homeEmptyGames.
  ///
  /// In ja, this message translates to:
  /// **'まだ試合がありません。最初の試合を記録してください。'**
  String get homeEmptyGames;

  /// No description provided for @recordTitle.
  ///
  /// In ja, this message translates to:
  /// **'記録'**
  String get recordTitle;

  /// No description provided for @addGameButton.
  ///
  /// In ja, this message translates to:
  /// **'試合を追加'**
  String get addGameButton;

  /// No description provided for @emptyGamesTitle.
  ///
  /// In ja, this message translates to:
  /// **'まだ試合がありません'**
  String get emptyGamesTitle;

  /// No description provided for @emptyGamesSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'試合を作成して、打席やピッチング成績を記録します。'**
  String get emptyGamesSubtitle;

  /// No description provided for @createGameButton.
  ///
  /// In ja, this message translates to:
  /// **'試合を作成する'**
  String get createGameButton;

  /// No description provided for @createGameTitle.
  ///
  /// In ja, this message translates to:
  /// **'試合を作成'**
  String get createGameTitle;

  /// No description provided for @gameDateLabel.
  ///
  /// In ja, this message translates to:
  /// **'試合日'**
  String get gameDateLabel;

  /// No description provided for @homeTeamNameLabel.
  ///
  /// In ja, this message translates to:
  /// **'自チーム名'**
  String get homeTeamNameLabel;

  /// No description provided for @homeTeamNameRequired.
  ///
  /// In ja, this message translates to:
  /// **'チーム名を入力してください'**
  String get homeTeamNameRequired;

  /// No description provided for @awayTeamNameLabel.
  ///
  /// In ja, this message translates to:
  /// **'相手チーム名'**
  String get awayTeamNameLabel;

  /// No description provided for @awayTeamNameRequired.
  ///
  /// In ja, this message translates to:
  /// **'相手チーム名を入力してください'**
  String get awayTeamNameRequired;

  /// No description provided for @homeScoreLabel.
  ///
  /// In ja, this message translates to:
  /// **'自チーム得点'**
  String get homeScoreLabel;

  /// No description provided for @awayScoreLabel.
  ///
  /// In ja, this message translates to:
  /// **'相手チーム得点'**
  String get awayScoreLabel;

  /// No description provided for @scoreRequired.
  ///
  /// In ja, this message translates to:
  /// **'点数を入力してください'**
  String get scoreRequired;

  /// No description provided for @scoreMustBeNonNegative.
  ///
  /// In ja, this message translates to:
  /// **'0以上の点数を入力してください'**
  String get scoreMustBeNonNegative;

  /// No description provided for @locationOptionalLabel.
  ///
  /// In ja, this message translates to:
  /// **'球場（任意）'**
  String get locationOptionalLabel;

  /// No description provided for @inningsCountLabel.
  ///
  /// In ja, this message translates to:
  /// **'イニング数'**
  String get inningsCountLabel;

  /// No description provided for @inningsShort.
  ///
  /// In ja, this message translates to:
  /// **'{innings}回'**
  String inningsShort(int innings);

  /// No description provided for @createButton.
  ///
  /// In ja, this message translates to:
  /// **'作成する'**
  String get createButton;

  /// No description provided for @gameDetailTitle.
  ///
  /// In ja, this message translates to:
  /// **'試合詳細'**
  String get gameDetailTitle;

  /// No description provided for @gameNotFound.
  ///
  /// In ja, this message translates to:
  /// **'試合が見つかりません'**
  String get gameNotFound;

  /// No description provided for @addPlateAppearanceButton.
  ///
  /// In ja, this message translates to:
  /// **'打席'**
  String get addPlateAppearanceButton;

  /// No description provided for @addPitchingButton.
  ///
  /// In ja, this message translates to:
  /// **'投手'**
  String get addPitchingButton;

  /// No description provided for @plateAppearanceRecordsTitle.
  ///
  /// In ja, this message translates to:
  /// **'打席記録'**
  String get plateAppearanceRecordsTitle;

  /// No description provided for @emptyPlateAppearances.
  ///
  /// In ja, this message translates to:
  /// **'まだ打席記録がありません'**
  String get emptyPlateAppearances;

  /// No description provided for @plateAppearanceListSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'{inning}回 / 打点 {rbi}'**
  String plateAppearanceListSubtitle(String inning, int rbi);

  /// No description provided for @pitchingRecordsTitle.
  ///
  /// In ja, this message translates to:
  /// **'ピッチング記録'**
  String get pitchingRecordsTitle;

  /// No description provided for @emptyPitchingAppearances.
  ///
  /// In ja, this message translates to:
  /// **'まだピッチング記録がありません'**
  String get emptyPitchingAppearances;

  /// No description provided for @pitchingOutsTitle.
  ///
  /// In ja, this message translates to:
  /// **'投球回 {innings}'**
  String pitchingOutsTitle(String innings);

  /// No description provided for @pitchingListSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'失点 {runs} / 自責 {earnedRuns} / 奪三振 {strikeouts}'**
  String pitchingListSubtitle(int runs, int earnedRuns, int strikeouts);

  /// No description provided for @inningsOnlyLabel.
  ///
  /// In ja, this message translates to:
  /// **'{innings}回'**
  String inningsOnlyLabel(int innings);

  /// No description provided for @inningsWithRestLabel.
  ///
  /// In ja, this message translates to:
  /// **'{innings}回{rest}/3'**
  String inningsWithRestLabel(int innings, int rest);

  /// No description provided for @resultHit.
  ///
  /// In ja, this message translates to:
  /// **'ヒット'**
  String get resultHit;

  /// No description provided for @resultOut.
  ///
  /// In ja, this message translates to:
  /// **'アウト'**
  String get resultOut;

  /// No description provided for @resultWalk.
  ///
  /// In ja, this message translates to:
  /// **'四死球'**
  String get resultWalk;

  /// No description provided for @resultError.
  ///
  /// In ja, this message translates to:
  /// **'エラー'**
  String get resultError;

  /// No description provided for @detailSingle.
  ///
  /// In ja, this message translates to:
  /// **'単打'**
  String get detailSingle;

  /// No description provided for @detailDouble.
  ///
  /// In ja, this message translates to:
  /// **'二塁打'**
  String get detailDouble;

  /// No description provided for @detailTriple.
  ///
  /// In ja, this message translates to:
  /// **'三塁打'**
  String get detailTriple;

  /// No description provided for @detailHomeRun.
  ///
  /// In ja, this message translates to:
  /// **'本塁打'**
  String get detailHomeRun;

  /// No description provided for @detailStrikeout.
  ///
  /// In ja, this message translates to:
  /// **'三振'**
  String get detailStrikeout;

  /// No description provided for @detailGround.
  ///
  /// In ja, this message translates to:
  /// **'ゴロ'**
  String get detailGround;

  /// No description provided for @detailFly.
  ///
  /// In ja, this message translates to:
  /// **'フライ'**
  String get detailFly;

  /// No description provided for @detailLine.
  ///
  /// In ja, this message translates to:
  /// **'ライナー'**
  String get detailLine;

  /// No description provided for @detailDoublePlay.
  ///
  /// In ja, this message translates to:
  /// **'併殺'**
  String get detailDoublePlay;

  /// No description provided for @detailSacBunt.
  ///
  /// In ja, this message translates to:
  /// **'犠打'**
  String get detailSacBunt;

  /// No description provided for @detailSacFly.
  ///
  /// In ja, this message translates to:
  /// **'犠飛'**
  String get detailSacFly;

  /// No description provided for @detailOther.
  ///
  /// In ja, this message translates to:
  /// **'その他'**
  String get detailOther;

  /// No description provided for @detailWalk.
  ///
  /// In ja, this message translates to:
  /// **'四球'**
  String get detailWalk;

  /// No description provided for @detailHitByPitch.
  ///
  /// In ja, this message translates to:
  /// **'死球'**
  String get detailHitByPitch;

  /// No description provided for @detailError.
  ///
  /// In ja, this message translates to:
  /// **'エラー'**
  String get detailError;

  /// No description provided for @plateAppearanceInputTitle.
  ///
  /// In ja, this message translates to:
  /// **'打席入力'**
  String get plateAppearanceInputTitle;

  /// No description provided for @selectPlateAppearanceResultMessage.
  ///
  /// In ja, this message translates to:
  /// **'打席結果を選択してください'**
  String get selectPlateAppearanceResultMessage;

  /// No description provided for @notSelectedLabel.
  ///
  /// In ja, this message translates to:
  /// **'未選択'**
  String get notSelectedLabel;

  /// No description provided for @playerNameRequired.
  ///
  /// In ja, this message translates to:
  /// **'選手名を入力してください'**
  String get playerNameRequired;

  /// No description provided for @batterNameLabel.
  ///
  /// In ja, this message translates to:
  /// **'打者名'**
  String get batterNameLabel;

  /// No description provided for @plateAppearanceSummary.
  ///
  /// In ja, this message translates to:
  /// **'{inning}回 / {result} / 打点 {rbi}'**
  String plateAppearanceSummary(int inning, String result, int rbi);

  /// No description provided for @inningLabel.
  ///
  /// In ja, this message translates to:
  /// **'イニング'**
  String get inningLabel;

  /// No description provided for @rbiLabel.
  ///
  /// In ja, this message translates to:
  /// **'打点'**
  String get rbiLabel;

  /// No description provided for @hitSectionTitle.
  ///
  /// In ja, this message translates to:
  /// **'ヒット'**
  String get hitSectionTitle;

  /// No description provided for @outSectionTitle.
  ///
  /// In ja, this message translates to:
  /// **'アウト'**
  String get outSectionTitle;

  /// No description provided for @onBaseSectionTitle.
  ///
  /// In ja, this message translates to:
  /// **'出塁・その他'**
  String get onBaseSectionTitle;

  /// No description provided for @saveButton.
  ///
  /// In ja, this message translates to:
  /// **'登録する'**
  String get saveButton;

  /// No description provided for @decreaseLabelTooltip.
  ///
  /// In ja, this message translates to:
  /// **'{label}を減らす'**
  String decreaseLabelTooltip(String label);

  /// No description provided for @increaseLabelTooltip.
  ///
  /// In ja, this message translates to:
  /// **'{label}を増やす'**
  String increaseLabelTooltip(String label);

  /// No description provided for @pitchingInputTitle.
  ///
  /// In ja, this message translates to:
  /// **'ピッチング入力'**
  String get pitchingInputTitle;

  /// No description provided for @pitcherNameLabel.
  ///
  /// In ja, this message translates to:
  /// **'投手名'**
  String get pitcherNameLabel;

  /// No description provided for @pitchingInputSummary.
  ///
  /// In ja, this message translates to:
  /// **'投球回 {innings} / 失点 {runs} / 自責 {earnedRuns}'**
  String pitchingInputSummary(String innings, int runs, int earnedRuns);

  /// No description provided for @runsLabel.
  ///
  /// In ja, this message translates to:
  /// **'失点'**
  String get runsLabel;

  /// No description provided for @earnedRunsLabel.
  ///
  /// In ja, this message translates to:
  /// **'自責点'**
  String get earnedRunsLabel;

  /// No description provided for @hitsAllowedLabel.
  ///
  /// In ja, this message translates to:
  /// **'被安打'**
  String get hitsAllowedLabel;

  /// No description provided for @walksAllowedLabel.
  ///
  /// In ja, this message translates to:
  /// **'与四死球'**
  String get walksAllowedLabel;

  /// No description provided for @strikeoutsLabel.
  ///
  /// In ja, this message translates to:
  /// **'奪三振'**
  String get strikeoutsLabel;

  /// No description provided for @homeRunsAllowedLabel.
  ///
  /// In ja, this message translates to:
  /// **'被本塁打'**
  String get homeRunsAllowedLabel;

  /// No description provided for @pitchingInningsLabel.
  ///
  /// In ja, this message translates to:
  /// **'投球回'**
  String get pitchingInningsLabel;

  /// No description provided for @decreaseOneOutTooltip.
  ///
  /// In ja, this message translates to:
  /// **'1アウト減らす'**
  String get decreaseOneOutTooltip;

  /// No description provided for @increaseOneOutTooltip.
  ///
  /// In ja, this message translates to:
  /// **'1アウト増やす'**
  String get increaseOneOutTooltip;

  /// No description provided for @outsLabel.
  ///
  /// In ja, this message translates to:
  /// **'{outs} アウト'**
  String outsLabel(int outs);

  /// No description provided for @addOneThirdInningButton.
  ///
  /// In ja, this message translates to:
  /// **'+1/3回'**
  String get addOneThirdInningButton;

  /// No description provided for @addOneInningButton.
  ///
  /// In ja, this message translates to:
  /// **'+1回'**
  String get addOneInningButton;

  /// No description provided for @resetOneInningButton.
  ///
  /// In ja, this message translates to:
  /// **'1回に戻す'**
  String get resetOneInningButton;

  /// No description provided for @statsTitle.
  ///
  /// In ja, this message translates to:
  /// **'成績'**
  String get statsTitle;

  /// No description provided for @battingStatsTitle.
  ///
  /// In ja, this message translates to:
  /// **'打撃成績'**
  String get battingStatsTitle;

  /// No description provided for @pitchingStatsTitle.
  ///
  /// In ja, this message translates to:
  /// **'ピッチング成績'**
  String get pitchingStatsTitle;

  /// No description provided for @personalBattingTitle.
  ///
  /// In ja, this message translates to:
  /// **'自分の打撃'**
  String get personalBattingTitle;

  /// No description provided for @noBattingStatsLabel.
  ///
  /// In ja, this message translates to:
  /// **'打撃記録なし'**
  String get noBattingStatsLabel;

  /// No description provided for @battingStatsSummary.
  ///
  /// In ja, this message translates to:
  /// **'打席 {pa} / 打数 {ab} / 安打 {hits} / 本塁打 {hr} / 三振 {so}'**
  String battingStatsSummary(int pa, int ab, int hits, int hr, int so);

  /// No description provided for @personalPitchingTitle.
  ///
  /// In ja, this message translates to:
  /// **'自分の投球'**
  String get personalPitchingTitle;

  /// No description provided for @noPitchingStatsLabel.
  ///
  /// In ja, this message translates to:
  /// **'投球記録なし'**
  String get noPitchingStatsLabel;

  /// No description provided for @pitchingStatsSummary.
  ///
  /// In ja, this message translates to:
  /// **'登板 {games} / 投球回 {innings} / 自責 {earnedRuns} / 奪三振 {strikeouts}'**
  String pitchingStatsSummary(
    int games,
    String innings,
    int earnedRuns,
    int strikeouts,
  );

  /// No description provided for @reloadButton.
  ///
  /// In ja, this message translates to:
  /// **'再読み込み'**
  String get reloadButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
