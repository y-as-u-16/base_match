import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local_database.dart';

final localDatabaseProvider = Provider<LocalDatabase>((ref) {
  final database = LocalDatabase();
  ref.onDispose(database.close);
  return database;
});
