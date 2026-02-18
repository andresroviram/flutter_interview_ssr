import 'package:drift/drift.dart';
import 'tables/users_table.dart';
import 'tables/addresses_table.dart';
import 'connection/shared.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Users, Addresses])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}
