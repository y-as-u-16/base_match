import 'package:drift/drift.dart';

import '../../../../core/local_db/local_database.dart';
import '../../domain/entities/my_team.dart';

extension LocalMyTeamMapper on LocalMyTeam {
  MyTeam toEntity() {
    return MyTeam(
      id: id,
      name: name,
      colorKey: colorKey,
      isDefault: isDefault,
      displayOrder: displayOrder,
      archivedAt: archivedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension MyTeamMapper on MyTeam {
  LocalMyTeamsCompanion toCompanion() {
    return LocalMyTeamsCompanion.insert(
      id: id,
      name: name,
      colorKey: Value(colorKey),
      isDefault: isDefault,
      displayOrder: displayOrder,
      archivedAt: Value(archivedAt),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
