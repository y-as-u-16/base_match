import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/local_db/local_database.dart';
import '../../domain/entities/my_team.dart';
import '../../domain/repositories/my_team_repository.dart';
import '../mappers/local_my_team_mapper.dart';

class LocalMyTeamRepository implements MyTeamRepository {
  LocalMyTeamRepository(this._database, {Uuid? uuid}) : _uuid = uuid ?? Uuid();

  final LocalDatabase _database;
  final Uuid _uuid;

  @override
  Future<List<MyTeam>> getMyTeams() async {
    final query = _database.select(_database.localMyTeams)
      ..where((table) => table.archivedAt.isNull())
      ..orderBy([
        (table) => OrderingTerm.asc(table.displayOrder),
        (table) => OrderingTerm.asc(table.createdAt),
      ]);
    final rows = await query.get();
    return rows.map((row) => row.toEntity()).toList();
  }

  @override
  Future<MyTeam?> getDefaultMyTeam() async {
    final query = _database.select(_database.localMyTeams)
      ..where(
        (table) => table.archivedAt.isNull() & table.isDefault.equals(true),
      )
      ..limit(1);
    final row = await query.getSingleOrNull();
    return row?.toEntity();
  }

  @override
  Future<MyTeam> createMyTeam({
    required String name,
    String? colorKey,
    bool isDefault = false,
  }) async {
    _validateMyTeamInput(name: name);

    final activeTeams = await getMyTeams();
    final shouldBeDefault = isDefault || activeTeams.isEmpty;
    final displayOrder = activeTeams.isEmpty
        ? 0
        : activeTeams
                  .map((team) => team.displayOrder)
                  .reduce((a, b) => a > b ? a : b) +
              1;

    final now = DateTime.now();
    final team = MyTeam(
      id: _id(),
      name: name.trim(),
      colorKey: _normalizeOptionalText(colorKey),
      isDefault: shouldBeDefault,
      displayOrder: displayOrder,
      createdAt: now,
      updatedAt: now,
    );

    await _database.transaction(() async {
      if (shouldBeDefault) {
        await _clearDefaultTeam();
      }
      await _database.into(_database.localMyTeams).insert(team.toCompanion());
    });

    return team;
  }

  Future<void> _clearDefaultTeam() {
    return (_database.update(_database.localMyTeams)
          ..where((table) => table.isDefault.equals(true)))
        .write(const LocalMyTeamsCompanion(isDefault: Value(false)));
  }

  void _validateMyTeamInput({required String name}) {
    if (name.trim().isEmpty) {
      throw ArgumentError.value(name, 'name', 'Required.');
    }
  }

  String? _normalizeOptionalText(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  String _id() => _uuid.v4();
}
