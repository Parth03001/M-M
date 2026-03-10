// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $VinScansTable extends VinScans with TableInfo<$VinScansTable, VinScan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VinScansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _vinMeta = const VerificationMeta('vin');
  @override
  late final GeneratedColumn<String> vin = GeneratedColumn<String>(
      'vin', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 17, maxTextLength: 17),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _scannedAtMeta =
      const VerificationMeta('scannedAt');
  @override
  late final GeneratedColumn<DateTime> scannedAt = GeneratedColumn<DateTime>(
      'scanned_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, vin, scannedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vin_scans';
  @override
  VerificationContext validateIntegrity(Insertable<VinScan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vin')) {
      context.handle(
          _vinMeta, vin.isAcceptableOrUnknown(data['vin']!, _vinMeta));
    } else if (isInserting) {
      context.missing(_vinMeta);
    }
    if (data.containsKey('scanned_at')) {
      context.handle(_scannedAtMeta,
          scannedAt.isAcceptableOrUnknown(data['scanned_at']!, _scannedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VinScan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VinScan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      vin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vin'])!,
      scannedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}scanned_at'])!,
    );
  }

  @override
  $VinScansTable createAlias(String alias) {
    return $VinScansTable(attachedDatabase, alias);
  }
}

class VinScan extends DataClass implements Insertable<VinScan> {
  final int id;
  final String vin;
  final DateTime scannedAt;
  const VinScan({required this.id, required this.vin, required this.scannedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vin'] = Variable<String>(vin);
    map['scanned_at'] = Variable<DateTime>(scannedAt);
    return map;
  }

  VinScansCompanion toCompanion(bool nullToAbsent) {
    return VinScansCompanion(
      id: Value(id),
      vin: Value(vin),
      scannedAt: Value(scannedAt),
    );
  }

  factory VinScan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VinScan(
      id: serializer.fromJson<int>(json['id']),
      vin: serializer.fromJson<String>(json['vin']),
      scannedAt: serializer.fromJson<DateTime>(json['scannedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vin': serializer.toJson<String>(vin),
      'scannedAt': serializer.toJson<DateTime>(scannedAt),
    };
  }

  VinScan copyWith({int? id, String? vin, DateTime? scannedAt}) => VinScan(
        id: id ?? this.id,
        vin: vin ?? this.vin,
        scannedAt: scannedAt ?? this.scannedAt,
      );
  VinScan copyWithCompanion(VinScansCompanion data) {
    return VinScan(
      id: data.id.present ? data.id.value : this.id,
      vin: data.vin.present ? data.vin.value : this.vin,
      scannedAt: data.scannedAt.present ? data.scannedAt.value : this.scannedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VinScan(')
          ..write('id: $id, ')
          ..write('vin: $vin, ')
          ..write('scannedAt: $scannedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, vin, scannedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VinScan &&
          other.id == this.id &&
          other.vin == this.vin &&
          other.scannedAt == this.scannedAt);
}

class VinScansCompanion extends UpdateCompanion<VinScan> {
  final Value<int> id;
  final Value<String> vin;
  final Value<DateTime> scannedAt;
  const VinScansCompanion({
    this.id = const Value.absent(),
    this.vin = const Value.absent(),
    this.scannedAt = const Value.absent(),
  });
  VinScansCompanion.insert({
    this.id = const Value.absent(),
    required String vin,
    this.scannedAt = const Value.absent(),
  }) : vin = Value(vin);
  static Insertable<VinScan> custom({
    Expression<int>? id,
    Expression<String>? vin,
    Expression<DateTime>? scannedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vin != null) 'vin': vin,
      if (scannedAt != null) 'scanned_at': scannedAt,
    });
  }

  VinScansCompanion copyWith(
      {Value<int>? id, Value<String>? vin, Value<DateTime>? scannedAt}) {
    return VinScansCompanion(
      id: id ?? this.id,
      vin: vin ?? this.vin,
      scannedAt: scannedAt ?? this.scannedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vin.present) {
      map['vin'] = Variable<String>(vin.value);
    }
    if (scannedAt.present) {
      map['scanned_at'] = Variable<DateTime>(scannedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VinScansCompanion(')
          ..write('id: $id, ')
          ..write('vin: $vin, ')
          ..write('scannedAt: $scannedAt')
          ..write(')'))
        .toString();
  }
}

class $InspectionsTable extends Inspections
    with TableInfo<$InspectionsTable, Inspection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _vinScanIdMeta =
      const VerificationMeta('vinScanId');
  @override
  late final GeneratedColumn<int> vinScanId = GeneratedColumn<int>(
      'vin_scan_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES vin_scans (id)'));
  static const VerificationMeta _wheelPositionMeta =
      const VerificationMeta('wheelPosition');
  @override
  late final GeneratedColumn<String> wheelPosition = GeneratedColumn<String>(
      'wheel_position', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
      'confidence', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _inspectedAtMeta =
      const VerificationMeta('inspectedAt');
  @override
  late final GeneratedColumn<DateTime> inspectedAt = GeneratedColumn<DateTime>(
      'inspected_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        vinScanId,
        wheelPosition,
        status,
        confidence,
        inspectedAt,
        imagePath
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspections';
  @override
  VerificationContext validateIntegrity(Insertable<Inspection> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vin_scan_id')) {
      context.handle(
          _vinScanIdMeta,
          vinScanId.isAcceptableOrUnknown(
              data['vin_scan_id']!, _vinScanIdMeta));
    } else if (isInserting) {
      context.missing(_vinScanIdMeta);
    }
    if (data.containsKey('wheel_position')) {
      context.handle(
          _wheelPositionMeta,
          wheelPosition.isAcceptableOrUnknown(
              data['wheel_position']!, _wheelPositionMeta));
    } else if (isInserting) {
      context.missing(_wheelPositionMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('inspected_at')) {
      context.handle(
          _inspectedAtMeta,
          inspectedAt.isAcceptableOrUnknown(
              data['inspected_at']!, _inspectedAtMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Inspection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Inspection(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      vinScanId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vin_scan_id'])!,
      wheelPosition: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}wheel_position'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}confidence'])!,
      inspectedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}inspected_at'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
    );
  }

  @override
  $InspectionsTable createAlias(String alias) {
    return $InspectionsTable(attachedDatabase, alias);
  }
}

class Inspection extends DataClass implements Insertable<Inspection> {
  final int id;
  final int vinScanId;
  final String wheelPosition;
  final String status;
  final double confidence;
  final DateTime inspectedAt;
  final String? imagePath;
  const Inspection(
      {required this.id,
      required this.vinScanId,
      required this.wheelPosition,
      required this.status,
      required this.confidence,
      required this.inspectedAt,
      this.imagePath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vin_scan_id'] = Variable<int>(vinScanId);
    map['wheel_position'] = Variable<String>(wheelPosition);
    map['status'] = Variable<String>(status);
    map['confidence'] = Variable<double>(confidence);
    map['inspected_at'] = Variable<DateTime>(inspectedAt);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    return map;
  }

  InspectionsCompanion toCompanion(bool nullToAbsent) {
    return InspectionsCompanion(
      id: Value(id),
      vinScanId: Value(vinScanId),
      wheelPosition: Value(wheelPosition),
      status: Value(status),
      confidence: Value(confidence),
      inspectedAt: Value(inspectedAt),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
    );
  }

  factory Inspection.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Inspection(
      id: serializer.fromJson<int>(json['id']),
      vinScanId: serializer.fromJson<int>(json['vinScanId']),
      wheelPosition: serializer.fromJson<String>(json['wheelPosition']),
      status: serializer.fromJson<String>(json['status']),
      confidence: serializer.fromJson<double>(json['confidence']),
      inspectedAt: serializer.fromJson<DateTime>(json['inspectedAt']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vinScanId': serializer.toJson<int>(vinScanId),
      'wheelPosition': serializer.toJson<String>(wheelPosition),
      'status': serializer.toJson<String>(status),
      'confidence': serializer.toJson<double>(confidence),
      'inspectedAt': serializer.toJson<DateTime>(inspectedAt),
      'imagePath': serializer.toJson<String?>(imagePath),
    };
  }

  Inspection copyWith(
          {int? id,
          int? vinScanId,
          String? wheelPosition,
          String? status,
          double? confidence,
          DateTime? inspectedAt,
          Value<String?> imagePath = const Value.absent()}) =>
      Inspection(
        id: id ?? this.id,
        vinScanId: vinScanId ?? this.vinScanId,
        wheelPosition: wheelPosition ?? this.wheelPosition,
        status: status ?? this.status,
        confidence: confidence ?? this.confidence,
        inspectedAt: inspectedAt ?? this.inspectedAt,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
      );
  Inspection copyWithCompanion(InspectionsCompanion data) {
    return Inspection(
      id: data.id.present ? data.id.value : this.id,
      vinScanId: data.vinScanId.present ? data.vinScanId.value : this.vinScanId,
      wheelPosition: data.wheelPosition.present
          ? data.wheelPosition.value
          : this.wheelPosition,
      status: data.status.present ? data.status.value : this.status,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      inspectedAt:
          data.inspectedAt.present ? data.inspectedAt.value : this.inspectedAt,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Inspection(')
          ..write('id: $id, ')
          ..write('vinScanId: $vinScanId, ')
          ..write('wheelPosition: $wheelPosition, ')
          ..write('status: $status, ')
          ..write('confidence: $confidence, ')
          ..write('inspectedAt: $inspectedAt, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, vinScanId, wheelPosition, status, confidence, inspectedAt, imagePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Inspection &&
          other.id == this.id &&
          other.vinScanId == this.vinScanId &&
          other.wheelPosition == this.wheelPosition &&
          other.status == this.status &&
          other.confidence == this.confidence &&
          other.inspectedAt == this.inspectedAt &&
          other.imagePath == this.imagePath);
}

class InspectionsCompanion extends UpdateCompanion<Inspection> {
  final Value<int> id;
  final Value<int> vinScanId;
  final Value<String> wheelPosition;
  final Value<String> status;
  final Value<double> confidence;
  final Value<DateTime> inspectedAt;
  final Value<String?> imagePath;
  const InspectionsCompanion({
    this.id = const Value.absent(),
    this.vinScanId = const Value.absent(),
    this.wheelPosition = const Value.absent(),
    this.status = const Value.absent(),
    this.confidence = const Value.absent(),
    this.inspectedAt = const Value.absent(),
    this.imagePath = const Value.absent(),
  });
  InspectionsCompanion.insert({
    this.id = const Value.absent(),
    required int vinScanId,
    required String wheelPosition,
    required String status,
    required double confidence,
    this.inspectedAt = const Value.absent(),
    this.imagePath = const Value.absent(),
  })  : vinScanId = Value(vinScanId),
        wheelPosition = Value(wheelPosition),
        status = Value(status),
        confidence = Value(confidence);
  static Insertable<Inspection> custom({
    Expression<int>? id,
    Expression<int>? vinScanId,
    Expression<String>? wheelPosition,
    Expression<String>? status,
    Expression<double>? confidence,
    Expression<DateTime>? inspectedAt,
    Expression<String>? imagePath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vinScanId != null) 'vin_scan_id': vinScanId,
      if (wheelPosition != null) 'wheel_position': wheelPosition,
      if (status != null) 'status': status,
      if (confidence != null) 'confidence': confidence,
      if (inspectedAt != null) 'inspected_at': inspectedAt,
      if (imagePath != null) 'image_path': imagePath,
    });
  }

  InspectionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? vinScanId,
      Value<String>? wheelPosition,
      Value<String>? status,
      Value<double>? confidence,
      Value<DateTime>? inspectedAt,
      Value<String?>? imagePath}) {
    return InspectionsCompanion(
      id: id ?? this.id,
      vinScanId: vinScanId ?? this.vinScanId,
      wheelPosition: wheelPosition ?? this.wheelPosition,
      status: status ?? this.status,
      confidence: confidence ?? this.confidence,
      inspectedAt: inspectedAt ?? this.inspectedAt,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vinScanId.present) {
      map['vin_scan_id'] = Variable<int>(vinScanId.value);
    }
    if (wheelPosition.present) {
      map['wheel_position'] = Variable<String>(wheelPosition.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (inspectedAt.present) {
      map['inspected_at'] = Variable<DateTime>(inspectedAt.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspectionsCompanion(')
          ..write('id: $id, ')
          ..write('vinScanId: $vinScanId, ')
          ..write('wheelPosition: $wheelPosition, ')
          ..write('status: $status, ')
          ..write('confidence: $confidence, ')
          ..write('inspectedAt: $inspectedAt, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VinScansTable vinScans = $VinScansTable(this);
  late final $InspectionsTable inspections = $InspectionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [vinScans, inspections];
}

typedef $$VinScansTableCreateCompanionBuilder = VinScansCompanion Function({
  Value<int> id,
  required String vin,
  Value<DateTime> scannedAt,
});
typedef $$VinScansTableUpdateCompanionBuilder = VinScansCompanion Function({
  Value<int> id,
  Value<String> vin,
  Value<DateTime> scannedAt,
});

final class $$VinScansTableReferences
    extends BaseReferences<_$AppDatabase, $VinScansTable, VinScan> {
  $$VinScansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InspectionsTable, List<Inspection>>
      _inspectionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.inspections,
          aliasName:
              $_aliasNameGenerator(db.vinScans.id, db.inspections.vinScanId));

  $$InspectionsTableProcessedTableManager get inspectionsRefs {
    final manager = $$InspectionsTableTableManager($_db, $_db.inspections)
        .filter((f) => f.vinScanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_inspectionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$VinScansTableFilterComposer
    extends Composer<_$AppDatabase, $VinScansTable> {
  $$VinScansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vin => $composableBuilder(
      column: $table.vin, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scannedAt => $composableBuilder(
      column: $table.scannedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> inspectionsRefs(
      Expression<bool> Function($$InspectionsTableFilterComposer f) f) {
    final $$InspectionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inspections,
        getReferencedColumn: (t) => t.vinScanId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InspectionsTableFilterComposer(
              $db: $db,
              $table: $db.inspections,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$VinScansTableOrderingComposer
    extends Composer<_$AppDatabase, $VinScansTable> {
  $$VinScansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vin => $composableBuilder(
      column: $table.vin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scannedAt => $composableBuilder(
      column: $table.scannedAt, builder: (column) => ColumnOrderings(column));
}

class $$VinScansTableAnnotationComposer
    extends Composer<_$AppDatabase, $VinScansTable> {
  $$VinScansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vin =>
      $composableBuilder(column: $table.vin, builder: (column) => column);

  GeneratedColumn<DateTime> get scannedAt =>
      $composableBuilder(column: $table.scannedAt, builder: (column) => column);

  Expression<T> inspectionsRefs<T extends Object>(
      Expression<T> Function($$InspectionsTableAnnotationComposer a) f) {
    final $$InspectionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inspections,
        getReferencedColumn: (t) => t.vinScanId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InspectionsTableAnnotationComposer(
              $db: $db,
              $table: $db.inspections,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$VinScansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VinScansTable,
    VinScan,
    $$VinScansTableFilterComposer,
    $$VinScansTableOrderingComposer,
    $$VinScansTableAnnotationComposer,
    $$VinScansTableCreateCompanionBuilder,
    $$VinScansTableUpdateCompanionBuilder,
    (VinScan, $$VinScansTableReferences),
    VinScan,
    PrefetchHooks Function({bool inspectionsRefs})> {
  $$VinScansTableTableManager(_$AppDatabase db, $VinScansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VinScansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VinScansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VinScansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> vin = const Value.absent(),
            Value<DateTime> scannedAt = const Value.absent(),
          }) =>
              VinScansCompanion(
            id: id,
            vin: vin,
            scannedAt: scannedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String vin,
            Value<DateTime> scannedAt = const Value.absent(),
          }) =>
              VinScansCompanion.insert(
            id: id,
            vin: vin,
            scannedAt: scannedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$VinScansTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({inspectionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (inspectionsRefs) db.inspections],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (inspectionsRefs)
                    await $_getPrefetchedData<VinScan, $VinScansTable,
                            Inspection>(
                        currentTable: table,
                        referencedTable:
                            $$VinScansTableReferences._inspectionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$VinScansTableReferences(db, table, p0)
                                .inspectionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.vinScanId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$VinScansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VinScansTable,
    VinScan,
    $$VinScansTableFilterComposer,
    $$VinScansTableOrderingComposer,
    $$VinScansTableAnnotationComposer,
    $$VinScansTableCreateCompanionBuilder,
    $$VinScansTableUpdateCompanionBuilder,
    (VinScan, $$VinScansTableReferences),
    VinScan,
    PrefetchHooks Function({bool inspectionsRefs})>;
typedef $$InspectionsTableCreateCompanionBuilder = InspectionsCompanion
    Function({
  Value<int> id,
  required int vinScanId,
  required String wheelPosition,
  required String status,
  required double confidence,
  Value<DateTime> inspectedAt,
  Value<String?> imagePath,
});
typedef $$InspectionsTableUpdateCompanionBuilder = InspectionsCompanion
    Function({
  Value<int> id,
  Value<int> vinScanId,
  Value<String> wheelPosition,
  Value<String> status,
  Value<double> confidence,
  Value<DateTime> inspectedAt,
  Value<String?> imagePath,
});

final class $$InspectionsTableReferences
    extends BaseReferences<_$AppDatabase, $InspectionsTable, Inspection> {
  $$InspectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VinScansTable _vinScanIdTable(_$AppDatabase db) =>
      db.vinScans.createAlias(
          $_aliasNameGenerator(db.inspections.vinScanId, db.vinScans.id));

  $$VinScansTableProcessedTableManager get vinScanId {
    final $_column = $_itemColumn<int>('vin_scan_id')!;

    final manager = $$VinScansTableTableManager($_db, $_db.vinScans)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vinScanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$InspectionsTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get wheelPosition => $composableBuilder(
      column: $table.wheelPosition, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get inspectedAt => $composableBuilder(
      column: $table.inspectedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  $$VinScansTableFilterComposer get vinScanId {
    final $$VinScansTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.vinScanId,
        referencedTable: $db.vinScans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VinScansTableFilterComposer(
              $db: $db,
              $table: $db.vinScans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InspectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get wheelPosition => $composableBuilder(
      column: $table.wheelPosition,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get inspectedAt => $composableBuilder(
      column: $table.inspectedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  $$VinScansTableOrderingComposer get vinScanId {
    final $$VinScansTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.vinScanId,
        referencedTable: $db.vinScans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VinScansTableOrderingComposer(
              $db: $db,
              $table: $db.vinScans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InspectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get wheelPosition => $composableBuilder(
      column: $table.wheelPosition, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => column);

  GeneratedColumn<DateTime> get inspectedAt => $composableBuilder(
      column: $table.inspectedAt, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  $$VinScansTableAnnotationComposer get vinScanId {
    final $$VinScansTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.vinScanId,
        referencedTable: $db.vinScans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VinScansTableAnnotationComposer(
              $db: $db,
              $table: $db.vinScans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InspectionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InspectionsTable,
    Inspection,
    $$InspectionsTableFilterComposer,
    $$InspectionsTableOrderingComposer,
    $$InspectionsTableAnnotationComposer,
    $$InspectionsTableCreateCompanionBuilder,
    $$InspectionsTableUpdateCompanionBuilder,
    (Inspection, $$InspectionsTableReferences),
    Inspection,
    PrefetchHooks Function({bool vinScanId})> {
  $$InspectionsTableTableManager(_$AppDatabase db, $InspectionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> vinScanId = const Value.absent(),
            Value<String> wheelPosition = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<DateTime> inspectedAt = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
          }) =>
              InspectionsCompanion(
            id: id,
            vinScanId: vinScanId,
            wheelPosition: wheelPosition,
            status: status,
            confidence: confidence,
            inspectedAt: inspectedAt,
            imagePath: imagePath,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int vinScanId,
            required String wheelPosition,
            required String status,
            required double confidence,
            Value<DateTime> inspectedAt = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
          }) =>
              InspectionsCompanion.insert(
            id: id,
            vinScanId: vinScanId,
            wheelPosition: wheelPosition,
            status: status,
            confidence: confidence,
            inspectedAt: inspectedAt,
            imagePath: imagePath,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$InspectionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({vinScanId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (vinScanId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.vinScanId,
                    referencedTable:
                        $$InspectionsTableReferences._vinScanIdTable(db),
                    referencedColumn:
                        $$InspectionsTableReferences._vinScanIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$InspectionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InspectionsTable,
    Inspection,
    $$InspectionsTableFilterComposer,
    $$InspectionsTableOrderingComposer,
    $$InspectionsTableAnnotationComposer,
    $$InspectionsTableCreateCompanionBuilder,
    $$InspectionsTableUpdateCompanionBuilder,
    (Inspection, $$InspectionsTableReferences),
    Inspection,
    PrefetchHooks Function({bool vinScanId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VinScansTableTableManager get vinScans =>
      $$VinScansTableTableManager(_db, _db.vinScans);
  $$InspectionsTableTableManager get inspections =>
      $$InspectionsTableTableManager(_db, _db.inspections);
}
