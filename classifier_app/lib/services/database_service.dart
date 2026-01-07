import '../database/database.dart';
import 'package:drift/drift.dart';

/// Service class to manage database operations
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  AppDatabase? _database;
  
  AppDatabase get database {
    _database ??= AppDatabase();
    return _database!;
  }

  // User operations
  Future<User?> getUserByUsername(String username) async {
    final users = await (database.select(database.users)
          ..where((u) => u.username.equals(username))
          ..limit(1))
        .get();
    return users.isNotEmpty ? users.first : null;
  }

  Future<User> createUser({
    required String username,
    required String password,
    String? email,
    String? fullName,
  }) async {
    final companion = UsersCompanion.insert(
      username: username,
      password: password, // In production, hash this password
      email: Value(email),
      fullName: Value(fullName),
    );
    return await database.into(database.users).insertReturning(companion);
  }

  Future<bool> validateUser(String username, String password) async {
    final user = await getUserByUsername(username);
    return user != null && user.password == password; // In production, use hashing
  }

  // Login session operations
  Future<LoginSession> createLoginSession(int userId) async {
    // Deactivate all previous sessions
    await (database.update(database.loginSessions)
          ..where((s) => s.userId.equals(userId)))
        .write(LoginSessionsCompanion(isActive: const Value(false)));

    // Create new session
    final companion = LoginSessionsCompanion.insert(
      userId: userId,
      isActive: const Value(true),
    );
    return await database.into(database.loginSessions).insertReturning(companion);
  }

  Future<void> logout(int sessionId) async {
    await (database.update(database.loginSessions)
          ..where((s) => s.id.equals(sessionId)))
        .write(LoginSessionsCompanion(
          isActive: const Value(false),
          logoutTime: Value(DateTime.now()),
        ));
  }

  // Barcode scan operations
  Future<BarcodeScan> createBarcodeScan({
    required String barcode,
    String? barcodeType,
    String? scannedData,
    int? userId,
  }) async {
    final companion = BarcodeScansCompanion.insert(
      barcode: barcode,
      barcodeType: Value(barcodeType),
      scannedData: Value(scannedData),
      userId: Value(userId),
    );
    return await database.into(database.barcodeScans).insertReturning(companion);
  }

  Future<List<BarcodeScan>> getBarcodeScans({int? userId, int? limit}) async {
    var query = database.select(database.barcodeScans)
      ..orderBy([(b) => OrderingTerm.desc(b.scannedAt)]);
    
    if (userId != null) {
      query = query..where((b) => b.userId.equals(userId));
    }
    
    if (limit != null) {
      query = query..limit(limit);
    }
    
    return await query.get();
  }

  // Connector operations
  Future<Connector> createConnector({
    required String name,
    String? description,
    String? barcodeId,
    int? barcodeScanId,
  }) async {
    final companion = ConnectorsCompanion.insert(
      name: name,
      description: Value(description),
      barcodeId: Value(barcodeId),
      barcodeScanId: Value(barcodeScanId),
    );
    return await database.into(database.connectors).insertReturning(companion);
  }

  Future<List<Connector>> getConnectors({int? limit}) async {
    var query = database.select(database.connectors)
      ..orderBy([(c) => OrderingTerm.desc(c.createdAt)]);
    
    if (limit != null) {
      query = query..limit(limit);
    }
    
    return await query.get();
  }

  Future<Connector?> getConnectorById(int id) async {
    final connectors = await (database.select(database.connectors)
          ..where((c) => c.id.equals(id))
          ..limit(1))
        .get();
    return connectors.isNotEmpty ? connectors.first : null;
  }

  Future<Connector?> getConnectorByName(String name) async {
    final connectors = await (database.select(database.connectors)
          ..where((c) => c.name.equals(name))
          ..limit(1))
        .get();
    return connectors.isNotEmpty ? connectors.first : null;
  }

  // Detection operations
  Future<Detection> createDetection({
    required int connectorId,
    required String imagePath,
    Uint8List? imageBytes,
    required String className,
    required double confidence,
    required double x1,
    required double y1,
    required double x2,
    required double y2,
    int classId = 0,
    int? userId,
  }) async {
    final companion = DetectionsCompanion.insert(
      connectorId: connectorId,
      imagePath: imagePath,
      imageBytes: Value(imageBytes),
      className: className,
      confidence: confidence,
      boundingBoxX1: x1,
      boundingBoxY1: y1,
      boundingBoxX2: x2,
      boundingBoxY2: y2,
      classId: Value(classId),
      userId: Value(userId),
    );
    return await database.into(database.detections).insertReturning(companion);
  }

  Future<List<Detection>> getDetections({
    int? connectorId,
    int? userId,
    int? limit,
  }) async {
    var query = database.select(database.detections)
      ..orderBy([(d) => OrderingTerm.desc(d.detectedAt)]);
    
    if (connectorId != null) {
      query = query..where((d) => d.connectorId.equals(connectorId));
    }
    
    if (userId != null) {
      query = query..where((d) => d.userId.equals(userId));
    }
    
    if (limit != null) {
      query = query..limit(limit);
    }
    
    return await query.get();
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}

