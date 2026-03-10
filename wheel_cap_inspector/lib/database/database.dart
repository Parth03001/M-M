import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class VinScans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get vin => text().withLength(min: 17, max: 17)();
  DateTimeColumn get scannedAt => dateTime().withDefault(currentDateAndTime)();
}

class Inspections extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vinScanId => integer().references(VinScans, #id)();
  TextColumn get wheelPosition => text()(); // FL, FR, RL, RR
  TextColumn get status => text()(); // OK, Missing, Damaged
  RealColumn get confidence => real()();
  DateTimeColumn get inspectedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get imagePath => text().nullable()();
}

@DriftDatabase(tables: [VinScans, Inspections])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'wheel_cap_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  // Helper methods
  Future<int> insertVinScan(VinScansCompanion entry) => into(vinScans).insert(entry);
  Future<int> insertInspection(InspectionsCompanion entry) => into(inspections).insert(entry);
  
  Future<List<VinScan>> getAllVinScans() => 
    (select(vinScans)..orderBy([(t) => OrderingTerm.desc(t.scannedAt)])).get();

  Future<List<Inspection>> getInspectionsByVin(int vinId) => 
    (select(inspections)..where((t) => t.vinScanId.equals(vinId))).get();

  Future<void> deleteVinScan(int vinId) async {
    await (delete(inspections)..where((t) => t.vinScanId.equals(vinId))).go();
    await (delete(vinScans)..where((t) => t.id.equals(vinId))).go();
  }
}
