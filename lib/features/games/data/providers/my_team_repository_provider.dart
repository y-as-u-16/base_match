import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/local_db/local_database_provider.dart';
import '../../domain/repositories/my_team_repository.dart';
import '../repositories/local_my_team_repository.dart';

final myTeamRepositoryProvider = Provider<MyTeamRepository>((ref) {
  final database = ref.watch(localDatabaseProvider);
  return LocalMyTeamRepository(database);
});
