import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'local_database.g.dart';

class LocalGames extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get location => text().nullable()();
  TextColumn get homeTeamName => text()();
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
  tables: [LocalGames, LocalPlateAppearances, LocalPitchingAppearances],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  LocalDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'base_match_local.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
