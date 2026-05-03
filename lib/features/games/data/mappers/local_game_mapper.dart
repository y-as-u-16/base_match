import 'package:drift/drift.dart';

import '../../../../core/local_db/local_database.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/pitching_appearance.dart';
import '../../domain/entities/plate_appearance.dart';

extension LocalGameMapper on LocalGame {
  Game toEntity() {
    return Game(
      id: id,
      date: date,
      location: location,
      myTeamId: myTeamId,
      awayTeamName: awayTeamName,
      homeScore: homeScore,
      awayScore: awayScore,
      status: status,
      createdAt: createdAt,
      innings: innings,
    );
  }
}

extension GameMapper on Game {
  LocalGamesCompanion toCompanion() {
    return LocalGamesCompanion.insert(
      id: id,
      date: date,
      location: Value(location),
      myTeamId: myTeamId,
      awayTeamName: awayTeamName,
      homeScore: Value(homeScore),
      awayScore: Value(awayScore),
      status: status,
      createdAt: createdAt,
      innings: Value(innings),
    );
  }
}

extension LocalPlateAppearanceMapper on LocalPlateAppearance {
  PlateAppearance toEntity() {
    return PlateAppearance(
      id: id,
      gameId: gameId,
      batterName: batterName,
      inning: inning,
      resultType: resultType,
      resultDetail: resultDetail,
      rbi: rbi,
      createdAt: createdAt,
    );
  }
}

extension PlateAppearanceMapper on PlateAppearance {
  LocalPlateAppearancesCompanion toCompanion() {
    return LocalPlateAppearancesCompanion.insert(
      id: id,
      gameId: gameId,
      batterName: Value(batterName),
      inning: Value(inning),
      resultType: resultType,
      resultDetail: resultDetail,
      rbi: Value(rbi),
      createdAt: createdAt,
    );
  }
}

extension LocalPitchingAppearanceMapper on LocalPitchingAppearance {
  PitchingAppearance toEntity() {
    return PitchingAppearance(
      id: id,
      gameId: gameId,
      pitcherName: pitcherName,
      outsPitched: outsPitched,
      runs: runs,
      earnedRuns: earnedRuns,
      hitsAllowed: hitsAllowed,
      walks: walks,
      strikeouts: strikeouts,
      homeRunsAllowed: homeRunsAllowed,
      createdAt: createdAt,
    );
  }
}

extension PitchingAppearanceMapper on PitchingAppearance {
  LocalPitchingAppearancesCompanion toCompanion() {
    return LocalPitchingAppearancesCompanion.insert(
      id: id,
      gameId: gameId,
      pitcherName: Value(pitcherName),
      outsPitched: outsPitched,
      runs: runs,
      earnedRuns: earnedRuns,
      hitsAllowed: hitsAllowed,
      walks: walks,
      strikeouts: strikeouts,
      homeRunsAllowed: homeRunsAllowed,
      createdAt: createdAt,
    );
  }
}
