import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

part 'database.g.dart';

// Users table for signup/login
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().withLength(min: 3, max: 50).unique()();
  TextColumn get password => text().withLength(min: 6)(); // Store hashed password
  TextColumn get email => text().nullable()();
  TextColumn get fullName => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// Login sessions table
class LoginSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  DateTimeColumn get loginTime => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get logoutTime => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// Barcode scans table
class BarcodeScans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get barcode => text()(); // The scanned barcode value
  TextColumn get barcodeType => text().nullable()(); // QR, EAN, UPC, etc.
  TextColumn get scannedData => text().nullable()(); // Additional data from scan
  DateTimeColumn get scannedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get userId => integer().references(Users, #id).nullable()();
}

// Connectors table
class Connectors extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()(); // Connector name
  TextColumn get description => text().nullable()();
  TextColumn get barcodeId => text().nullable()(); // Link to barcode scan if applicable
  IntColumn get barcodeScanId => integer().references(BarcodeScans, #id).nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// Detections table - stores image, bounding box, and result
class Detections extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get connectorId => integer().references(Connectors, #id)();
  TextColumn get imagePath => text()(); // Path to stored image file
  BlobColumn get imageBytes => blob().nullable()(); // Optional: store image bytes
  TextColumn get className => text()(); // 'OK' or 'NOT_OK'
  RealColumn get confidence => real()(); // Confidence score (0.0 to 1.0)
  RealColumn get boundingBoxX1 => real()(); // Bounding box coordinates
  RealColumn get boundingBoxY1 => real()();
  RealColumn get boundingBoxX2 => real()();
  RealColumn get boundingBoxY2 => real()();
  IntColumn get classId => integer().withDefault(const Constant(0))(); // Class index
  DateTimeColumn get detectedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get userId => integer().references(Users, #id).nullable()();
}

@DriftDatabase(tables: [Users, LoginSessions, BarcodeScans, Connectors, Detections])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'classifier_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  // Helper method to check if users table is empty
  Future<bool> isUsersTableEmpty() async {
    final count = await (select(users)..limit(1)).get();
    return count.isEmpty;
  }

  // Helper method to get active user session
  Future<LoginSession?> getActiveSession() async {
    final sessions = await (select(loginSessions)
          ..where((s) => s.isActive.equals(true))
          ..orderBy([(s) => OrderingTerm.desc(s.loginTime)])
          ..limit(1))
        .get();
    return sessions.isNotEmpty ? sessions.first : null;
  }
}

