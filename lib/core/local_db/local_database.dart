import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'local_database.g.dart';

class LocalMyTeams extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get colorKey => text().nullable()();
  BoolColumn get isDefault => boolean()();
  IntColumn get displayOrder => integer()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class LocalGames extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get location => text().nullable()();
  TextColumn get myTeamId => text().references(LocalMyTeams, #id)();
  TextColumn get awayTeamName => text()();
  IntColumn get homeScore => integer().nullable()();
  IntColumn get awayScore => integer().nullable()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get innings => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class LocalPlateAppearances extends Table {
  TextColumn get id => text()();
  TextColumn get gameId => text().references(LocalGames, #id)();
  TextColumn get batterName => text().withDefault(const Constant('自分'))();
  IntColumn get inning => integer().nullable()();
  TextColumn get resultType => text()();
  TextColumn get resultDetail => text()();
  IntColumn get rbi => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class LocalPitchingAppearances extends Table {
  TextColumn get id => text()();
  TextColumn get gameId => text().references(LocalGames, #id)();
  TextColumn get pitcherName => text().withDefault(const Constant('自分'))();
  IntColumn get outsPitched => integer()();
  IntColumn get runs => integer()();
  IntColumn get earnedRuns => integer()();
  IntColumn get hitsAllowed => integer()();
  IntColumn get walks => integer()();
  IntColumn get strikeouts => integer()();
  IntColumn get homeRunsAllowed => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    LocalMyTeams,
    LocalGames,
    LocalPlateAppearances,
    LocalPitchingAppearances,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  LocalDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (migrator, from, to) async {
        if (from < 3) {
          await customStatement(
            'DROP TABLE IF EXISTS local_pitching_appearances',
          );
          await customStatement('DROP TABLE IF EXISTS local_plate_appearances');
          await customStatement('DROP TABLE IF EXISTS local_games');
          await customStatement('DROP TABLE IF EXISTS local_my_teams');
          await migrator.createTable(localMyTeams);
          await migrator.createTable(localGames);
          await migrator.createTable(localPlateAppearances);
          await migrator.createTable(localPitchingAppearances);
          return;
        }

        if (from < 2) {
          await migrator.addColumn(
            localPlateAppearances,
            localPlateAppearances.batterName,
          );
          await migrator.addColumn(
            localPitchingAppearances,
            localPitchingAppearances.pitcherName,
          );
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'base_match_local.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
