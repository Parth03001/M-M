// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password =
      GeneratedColumn<String>('password', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 6,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, username, password, email, fullName, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String username;
  final String password;
  final String? email;
  final String? fullName;
  final DateTime createdAt;
  final DateTime updatedAt;
  const User(
      {required this.id,
      required this.username,
      required this.password,
      this.email,
      this.fullName,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['password'] = Variable<String>(password);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || fullName != null) {
      map['full_name'] = Variable<String>(fullName);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      password: Value(password),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      fullName: fullName == null && nullToAbsent
          ? const Value.absent()
          : Value(fullName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      password: serializer.fromJson<String>(json['password']),
      email: serializer.fromJson<String?>(json['email']),
      fullName: serializer.fromJson<String?>(json['fullName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'password': serializer.toJson<String>(password),
      'email': serializer.toJson<String?>(email),
      'fullName': serializer.toJson<String?>(fullName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  User copyWith(
          {int? id,
          String? username,
          String? password,
          Value<String?> email = const Value.absent(),
          Value<String?> fullName = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        password: password ?? this.password,
        email: email.present ? email.value : this.email,
        fullName: fullName.present ? fullName.value : this.fullName,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      email: data.email.present ? data.email.value : this.email,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('email: $email, ')
          ..write('fullName: $fullName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, username, password, email, fullName, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.password == this.password &&
          other.email == this.email &&
          other.fullName == this.fullName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> password;
  final Value<String?> email;
  final Value<String?> fullName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.email = const Value.absent(),
    this.fullName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String password,
    this.email = const Value.absent(),
    this.fullName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : username = Value(username),
        password = Value(password);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? password,
    Expression<String>? email,
    Expression<String>? fullName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (email != null) 'email': email,
      if (fullName != null) 'full_name': fullName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? username,
      Value<String>? password,
      Value<String?>? email,
      Value<String?>? fullName,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('email: $email, ')
          ..write('fullName: $fullName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $LoginSessionsTable extends LoginSessions
    with TableInfo<$LoginSessionsTable, LoginSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoginSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _loginTimeMeta =
      const VerificationMeta('loginTime');
  @override
  late final GeneratedColumn<DateTime> loginTime = GeneratedColumn<DateTime>(
      'login_time', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _logoutTimeMeta =
      const VerificationMeta('logoutTime');
  @override
  late final GeneratedColumn<DateTime> logoutTime = GeneratedColumn<DateTime>(
      'logout_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, loginTime, logoutTime, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'login_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<LoginSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('login_time')) {
      context.handle(_loginTimeMeta,
          loginTime.isAcceptableOrUnknown(data['login_time']!, _loginTimeMeta));
    }
    if (data.containsKey('logout_time')) {
      context.handle(
          _logoutTimeMeta,
          logoutTime.isAcceptableOrUnknown(
              data['logout_time']!, _logoutTimeMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoginSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoginSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      loginTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}login_time'])!,
      logoutTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}logout_time']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $LoginSessionsTable createAlias(String alias) {
    return $LoginSessionsTable(attachedDatabase, alias);
  }
}

class LoginSession extends DataClass implements Insertable<LoginSession> {
  final int id;
  final int userId;
  final DateTime loginTime;
  final DateTime? logoutTime;
  final bool isActive;
  const LoginSession(
      {required this.id,
      required this.userId,
      required this.loginTime,
      this.logoutTime,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['login_time'] = Variable<DateTime>(loginTime);
    if (!nullToAbsent || logoutTime != null) {
      map['logout_time'] = Variable<DateTime>(logoutTime);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  LoginSessionsCompanion toCompanion(bool nullToAbsent) {
    return LoginSessionsCompanion(
      id: Value(id),
      userId: Value(userId),
      loginTime: Value(loginTime),
      logoutTime: logoutTime == null && nullToAbsent
          ? const Value.absent()
          : Value(logoutTime),
      isActive: Value(isActive),
    );
  }

  factory LoginSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoginSession(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      loginTime: serializer.fromJson<DateTime>(json['loginTime']),
      logoutTime: serializer.fromJson<DateTime?>(json['logoutTime']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'loginTime': serializer.toJson<DateTime>(loginTime),
      'logoutTime': serializer.toJson<DateTime?>(logoutTime),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  LoginSession copyWith(
          {int? id,
          int? userId,
          DateTime? loginTime,
          Value<DateTime?> logoutTime = const Value.absent(),
          bool? isActive}) =>
      LoginSession(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        loginTime: loginTime ?? this.loginTime,
        logoutTime: logoutTime.present ? logoutTime.value : this.logoutTime,
        isActive: isActive ?? this.isActive,
      );
  LoginSession copyWithCompanion(LoginSessionsCompanion data) {
    return LoginSession(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      loginTime: data.loginTime.present ? data.loginTime.value : this.loginTime,
      logoutTime:
          data.logoutTime.present ? data.logoutTime.value : this.logoutTime,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoginSession(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('loginTime: $loginTime, ')
          ..write('logoutTime: $logoutTime, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, loginTime, logoutTime, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoginSession &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.loginTime == this.loginTime &&
          other.logoutTime == this.logoutTime &&
          other.isActive == this.isActive);
}

class LoginSessionsCompanion extends UpdateCompanion<LoginSession> {
  final Value<int> id;
  final Value<int> userId;
  final Value<DateTime> loginTime;
  final Value<DateTime?> logoutTime;
  final Value<bool> isActive;
  const LoginSessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.loginTime = const Value.absent(),
    this.logoutTime = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  LoginSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    this.loginTime = const Value.absent(),
    this.logoutTime = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<LoginSession> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<DateTime>? loginTime,
    Expression<DateTime>? logoutTime,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (loginTime != null) 'login_time': loginTime,
      if (logoutTime != null) 'logout_time': logoutTime,
      if (isActive != null) 'is_active': isActive,
    });
  }

  LoginSessionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<DateTime>? loginTime,
      Value<DateTime?>? logoutTime,
      Value<bool>? isActive}) {
    return LoginSessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      loginTime: loginTime ?? this.loginTime,
      logoutTime: logoutTime ?? this.logoutTime,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (loginTime.present) {
      map['login_time'] = Variable<DateTime>(loginTime.value);
    }
    if (logoutTime.present) {
      map['logout_time'] = Variable<DateTime>(logoutTime.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoginSessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('loginTime: $loginTime, ')
          ..write('logoutTime: $logoutTime, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $BarcodeScansTable extends BarcodeScans
    with TableInfo<$BarcodeScansTable, BarcodeScan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BarcodeScansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _barcodeTypeMeta =
      const VerificationMeta('barcodeType');
  @override
  late final GeneratedColumn<String> barcodeType = GeneratedColumn<String>(
      'barcode_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scannedDataMeta =
      const VerificationMeta('scannedData');
  @override
  late final GeneratedColumn<String> scannedData = GeneratedColumn<String>(
      'scanned_data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scannedAtMeta =
      const VerificationMeta('scannedAt');
  @override
  late final GeneratedColumn<DateTime> scannedAt = GeneratedColumn<DateTime>(
      'scanned_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, barcode, barcodeType, scannedData, scannedAt, userId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'barcode_scans';
  @override
  VerificationContext validateIntegrity(Insertable<BarcodeScan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    if (data.containsKey('barcode_type')) {
      context.handle(
          _barcodeTypeMeta,
          barcodeType.isAcceptableOrUnknown(
              data['barcode_type']!, _barcodeTypeMeta));
    }
    if (data.containsKey('scanned_data')) {
      context.handle(
          _scannedDataMeta,
          scannedData.isAcceptableOrUnknown(
              data['scanned_data']!, _scannedDataMeta));
    }
    if (data.containsKey('scanned_at')) {
      context.handle(_scannedAtMeta,
          scannedAt.isAcceptableOrUnknown(data['scanned_at']!, _scannedAtMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BarcodeScan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BarcodeScan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode'])!,
      barcodeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode_type']),
      scannedData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scanned_data']),
      scannedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}scanned_at'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
    );
  }

  @override
  $BarcodeScansTable createAlias(String alias) {
    return $BarcodeScansTable(attachedDatabase, alias);
  }
}

class BarcodeScan extends DataClass implements Insertable<BarcodeScan> {
  final int id;
  final String barcode;
  final String? barcodeType;
  final String? scannedData;
  final DateTime scannedAt;
  final int? userId;
  const BarcodeScan(
      {required this.id,
      required this.barcode,
      this.barcodeType,
      this.scannedData,
      required this.scannedAt,
      this.userId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['barcode'] = Variable<String>(barcode);
    if (!nullToAbsent || barcodeType != null) {
      map['barcode_type'] = Variable<String>(barcodeType);
    }
    if (!nullToAbsent || scannedData != null) {
      map['scanned_data'] = Variable<String>(scannedData);
    }
    map['scanned_at'] = Variable<DateTime>(scannedAt);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    return map;
  }

  BarcodeScansCompanion toCompanion(bool nullToAbsent) {
    return BarcodeScansCompanion(
      id: Value(id),
      barcode: Value(barcode),
      barcodeType: barcodeType == null && nullToAbsent
          ? const Value.absent()
          : Value(barcodeType),
      scannedData: scannedData == null && nullToAbsent
          ? const Value.absent()
          : Value(scannedData),
      scannedAt: Value(scannedAt),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
    );
  }

  factory BarcodeScan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BarcodeScan(
      id: serializer.fromJson<int>(json['id']),
      barcode: serializer.fromJson<String>(json['barcode']),
      barcodeType: serializer.fromJson<String?>(json['barcodeType']),
      scannedData: serializer.fromJson<String?>(json['scannedData']),
      scannedAt: serializer.fromJson<DateTime>(json['scannedAt']),
      userId: serializer.fromJson<int?>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'barcode': serializer.toJson<String>(barcode),
      'barcodeType': serializer.toJson<String?>(barcodeType),
      'scannedData': serializer.toJson<String?>(scannedData),
      'scannedAt': serializer.toJson<DateTime>(scannedAt),
      'userId': serializer.toJson<int?>(userId),
    };
  }

  BarcodeScan copyWith(
          {int? id,
          String? barcode,
          Value<String?> barcodeType = const Value.absent(),
          Value<String?> scannedData = const Value.absent(),
          DateTime? scannedAt,
          Value<int?> userId = const Value.absent()}) =>
      BarcodeScan(
        id: id ?? this.id,
        barcode: barcode ?? this.barcode,
        barcodeType: barcodeType.present ? barcodeType.value : this.barcodeType,
        scannedData: scannedData.present ? scannedData.value : this.scannedData,
        scannedAt: scannedAt ?? this.scannedAt,
        userId: userId.present ? userId.value : this.userId,
      );
  BarcodeScan copyWithCompanion(BarcodeScansCompanion data) {
    return BarcodeScan(
      id: data.id.present ? data.id.value : this.id,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      barcodeType:
          data.barcodeType.present ? data.barcodeType.value : this.barcodeType,
      scannedData:
          data.scannedData.present ? data.scannedData.value : this.scannedData,
      scannedAt: data.scannedAt.present ? data.scannedAt.value : this.scannedAt,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BarcodeScan(')
          ..write('id: $id, ')
          ..write('barcode: $barcode, ')
          ..write('barcodeType: $barcodeType, ')
          ..write('scannedData: $scannedData, ')
          ..write('scannedAt: $scannedAt, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, barcode, barcodeType, scannedData, scannedAt, userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BarcodeScan &&
          other.id == this.id &&
          other.barcode == this.barcode &&
          other.barcodeType == this.barcodeType &&
          other.scannedData == this.scannedData &&
          other.scannedAt == this.scannedAt &&
          other.userId == this.userId);
}

class BarcodeScansCompanion extends UpdateCompanion<BarcodeScan> {
  final Value<int> id;
  final Value<String> barcode;
  final Value<String?> barcodeType;
  final Value<String?> scannedData;
  final Value<DateTime> scannedAt;
  final Value<int?> userId;
  const BarcodeScansCompanion({
    this.id = const Value.absent(),
    this.barcode = const Value.absent(),
    this.barcodeType = const Value.absent(),
    this.scannedData = const Value.absent(),
    this.scannedAt = const Value.absent(),
    this.userId = const Value.absent(),
  });
  BarcodeScansCompanion.insert({
    this.id = const Value.absent(),
    required String barcode,
    this.barcodeType = const Value.absent(),
    this.scannedData = const Value.absent(),
    this.scannedAt = const Value.absent(),
    this.userId = const Value.absent(),
  }) : barcode = Value(barcode);
  static Insertable<BarcodeScan> custom({
    Expression<int>? id,
    Expression<String>? barcode,
    Expression<String>? barcodeType,
    Expression<String>? scannedData,
    Expression<DateTime>? scannedAt,
    Expression<int>? userId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (barcode != null) 'barcode': barcode,
      if (barcodeType != null) 'barcode_type': barcodeType,
      if (scannedData != null) 'scanned_data': scannedData,
      if (scannedAt != null) 'scanned_at': scannedAt,
      if (userId != null) 'user_id': userId,
    });
  }

  BarcodeScansCompanion copyWith(
      {Value<int>? id,
      Value<String>? barcode,
      Value<String?>? barcodeType,
      Value<String?>? scannedData,
      Value<DateTime>? scannedAt,
      Value<int?>? userId}) {
    return BarcodeScansCompanion(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      barcodeType: barcodeType ?? this.barcodeType,
      scannedData: scannedData ?? this.scannedData,
      scannedAt: scannedAt ?? this.scannedAt,
      userId: userId ?? this.userId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (barcodeType.present) {
      map['barcode_type'] = Variable<String>(barcodeType.value);
    }
    if (scannedData.present) {
      map['scanned_data'] = Variable<String>(scannedData.value);
    }
    if (scannedAt.present) {
      map['scanned_at'] = Variable<DateTime>(scannedAt.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BarcodeScansCompanion(')
          ..write('id: $id, ')
          ..write('barcode: $barcode, ')
          ..write('barcodeType: $barcodeType, ')
          ..write('scannedData: $scannedData, ')
          ..write('scannedAt: $scannedAt, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }
}

class $ConnectorsTable extends Connectors
    with TableInfo<$ConnectorsTable, Connector> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConnectorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _barcodeIdMeta =
      const VerificationMeta('barcodeId');
  @override
  late final GeneratedColumn<String> barcodeId = GeneratedColumn<String>(
      'barcode_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _barcodeScanIdMeta =
      const VerificationMeta('barcodeScanId');
  @override
  late final GeneratedColumn<int> barcodeScanId = GeneratedColumn<int>(
      'barcode_scan_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES barcode_scans (id)'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, description, barcodeId, barcodeScanId, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'connectors';
  @override
  VerificationContext validateIntegrity(Insertable<Connector> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('barcode_id')) {
      context.handle(_barcodeIdMeta,
          barcodeId.isAcceptableOrUnknown(data['barcode_id']!, _barcodeIdMeta));
    }
    if (data.containsKey('barcode_scan_id')) {
      context.handle(
          _barcodeScanIdMeta,
          barcodeScanId.isAcceptableOrUnknown(
              data['barcode_scan_id']!, _barcodeScanIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Connector map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Connector(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      barcodeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode_id']),
      barcodeScanId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}barcode_scan_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ConnectorsTable createAlias(String alias) {
    return $ConnectorsTable(attachedDatabase, alias);
  }
}

class Connector extends DataClass implements Insertable<Connector> {
  final int id;
  final String name;
  final String? description;
  final String? barcodeId;
  final int? barcodeScanId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Connector(
      {required this.id,
      required this.name,
      this.description,
      this.barcodeId,
      this.barcodeScanId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || barcodeId != null) {
      map['barcode_id'] = Variable<String>(barcodeId);
    }
    if (!nullToAbsent || barcodeScanId != null) {
      map['barcode_scan_id'] = Variable<int>(barcodeScanId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ConnectorsCompanion toCompanion(bool nullToAbsent) {
    return ConnectorsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      barcodeId: barcodeId == null && nullToAbsent
          ? const Value.absent()
          : Value(barcodeId),
      barcodeScanId: barcodeScanId == null && nullToAbsent
          ? const Value.absent()
          : Value(barcodeScanId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Connector.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Connector(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      barcodeId: serializer.fromJson<String?>(json['barcodeId']),
      barcodeScanId: serializer.fromJson<int?>(json['barcodeScanId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'barcodeId': serializer.toJson<String?>(barcodeId),
      'barcodeScanId': serializer.toJson<int?>(barcodeScanId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Connector copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> barcodeId = const Value.absent(),
          Value<int?> barcodeScanId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Connector(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        barcodeId: barcodeId.present ? barcodeId.value : this.barcodeId,
        barcodeScanId:
            barcodeScanId.present ? barcodeScanId.value : this.barcodeScanId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Connector copyWithCompanion(ConnectorsCompanion data) {
    return Connector(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      barcodeId: data.barcodeId.present ? data.barcodeId.value : this.barcodeId,
      barcodeScanId: data.barcodeScanId.present
          ? data.barcodeScanId.value
          : this.barcodeScanId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Connector(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('barcodeId: $barcodeId, ')
          ..write('barcodeScanId: $barcodeScanId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, description, barcodeId, barcodeScanId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Connector &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.barcodeId == this.barcodeId &&
          other.barcodeScanId == this.barcodeScanId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ConnectorsCompanion extends UpdateCompanion<Connector> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> barcodeId;
  final Value<int?> barcodeScanId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ConnectorsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.barcodeId = const Value.absent(),
    this.barcodeScanId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ConnectorsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.barcodeId = const Value.absent(),
    this.barcodeScanId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Connector> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? barcodeId,
    Expression<int>? barcodeScanId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (barcodeId != null) 'barcode_id': barcodeId,
      if (barcodeScanId != null) 'barcode_scan_id': barcodeScanId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ConnectorsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? barcodeId,
      Value<int?>? barcodeScanId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ConnectorsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      barcodeId: barcodeId ?? this.barcodeId,
      barcodeScanId: barcodeScanId ?? this.barcodeScanId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (barcodeId.present) {
      map['barcode_id'] = Variable<String>(barcodeId.value);
    }
    if (barcodeScanId.present) {
      map['barcode_scan_id'] = Variable<int>(barcodeScanId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConnectorsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('barcodeId: $barcodeId, ')
          ..write('barcodeScanId: $barcodeScanId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DetectionsTable extends Detections
    with TableInfo<$DetectionsTable, Detection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DetectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _connectorIdMeta =
      const VerificationMeta('connectorId');
  @override
  late final GeneratedColumn<int> connectorId = GeneratedColumn<int>(
      'connector_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES connectors (id)'));
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageBytesMeta =
      const VerificationMeta('imageBytes');
  @override
  late final GeneratedColumn<Uint8List> imageBytes = GeneratedColumn<Uint8List>(
      'image_bytes', aliasedName, true,
      type: DriftSqlType.blob, requiredDuringInsert: false);
  static const VerificationMeta _classNameMeta =
      const VerificationMeta('className');
  @override
  late final GeneratedColumn<String> className = GeneratedColumn<String>(
      'class_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
      'confidence', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _boundingBoxX1Meta =
      const VerificationMeta('boundingBoxX1');
  @override
  late final GeneratedColumn<double> boundingBoxX1 = GeneratedColumn<double>(
      'bounding_box_x1', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _boundingBoxY1Meta =
      const VerificationMeta('boundingBoxY1');
  @override
  late final GeneratedColumn<double> boundingBoxY1 = GeneratedColumn<double>(
      'bounding_box_y1', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _boundingBoxX2Meta =
      const VerificationMeta('boundingBoxX2');
  @override
  late final GeneratedColumn<double> boundingBoxX2 = GeneratedColumn<double>(
      'bounding_box_x2', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _boundingBoxY2Meta =
      const VerificationMeta('boundingBoxY2');
  @override
  late final GeneratedColumn<double> boundingBoxY2 = GeneratedColumn<double>(
      'bounding_box_y2', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _classIdMeta =
      const VerificationMeta('classId');
  @override
  late final GeneratedColumn<int> classId = GeneratedColumn<int>(
      'class_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _detectedAtMeta =
      const VerificationMeta('detectedAt');
  @override
  late final GeneratedColumn<DateTime> detectedAt = GeneratedColumn<DateTime>(
      'detected_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        connectorId,
        imagePath,
        imageBytes,
        className,
        confidence,
        boundingBoxX1,
        boundingBoxY1,
        boundingBoxX2,
        boundingBoxY2,
        classId,
        detectedAt,
        userId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'detections';
  @override
  VerificationContext validateIntegrity(Insertable<Detection> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('connector_id')) {
      context.handle(
          _connectorIdMeta,
          connectorId.isAcceptableOrUnknown(
              data['connector_id']!, _connectorIdMeta));
    } else if (isInserting) {
      context.missing(_connectorIdMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('image_bytes')) {
      context.handle(
          _imageBytesMeta,
          imageBytes.isAcceptableOrUnknown(
              data['image_bytes']!, _imageBytesMeta));
    }
    if (data.containsKey('class_name')) {
      context.handle(_classNameMeta,
          className.isAcceptableOrUnknown(data['class_name']!, _classNameMeta));
    } else if (isInserting) {
      context.missing(_classNameMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('bounding_box_x1')) {
      context.handle(
          _boundingBoxX1Meta,
          boundingBoxX1.isAcceptableOrUnknown(
              data['bounding_box_x1']!, _boundingBoxX1Meta));
    } else if (isInserting) {
      context.missing(_boundingBoxX1Meta);
    }
    if (data.containsKey('bounding_box_y1')) {
      context.handle(
          _boundingBoxY1Meta,
          boundingBoxY1.isAcceptableOrUnknown(
              data['bounding_box_y1']!, _boundingBoxY1Meta));
    } else if (isInserting) {
      context.missing(_boundingBoxY1Meta);
    }
    if (data.containsKey('bounding_box_x2')) {
      context.handle(
          _boundingBoxX2Meta,
          boundingBoxX2.isAcceptableOrUnknown(
              data['bounding_box_x2']!, _boundingBoxX2Meta));
    } else if (isInserting) {
      context.missing(_boundingBoxX2Meta);
    }
    if (data.containsKey('bounding_box_y2')) {
      context.handle(
          _boundingBoxY2Meta,
          boundingBoxY2.isAcceptableOrUnknown(
              data['bounding_box_y2']!, _boundingBoxY2Meta));
    } else if (isInserting) {
      context.missing(_boundingBoxY2Meta);
    }
    if (data.containsKey('class_id')) {
      context.handle(_classIdMeta,
          classId.isAcceptableOrUnknown(data['class_id']!, _classIdMeta));
    }
    if (data.containsKey('detected_at')) {
      context.handle(
          _detectedAtMeta,
          detectedAt.isAcceptableOrUnknown(
              data['detected_at']!, _detectedAtMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Detection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Detection(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      connectorId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}connector_id'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path'])!,
      imageBytes: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}image_bytes']),
      className: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}class_name'])!,
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}confidence'])!,
      boundingBoxX1: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}bounding_box_x1'])!,
      boundingBoxY1: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}bounding_box_y1'])!,
      boundingBoxX2: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}bounding_box_x2'])!,
      boundingBoxY2: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}bounding_box_y2'])!,
      classId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}class_id'])!,
      detectedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}detected_at'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
    );
  }

  @override
  $DetectionsTable createAlias(String alias) {
    return $DetectionsTable(attachedDatabase, alias);
  }
}

class Detection extends DataClass implements Insertable<Detection> {
  final int id;
  final int connectorId;
  final String imagePath;
  final Uint8List? imageBytes;
  final String className;
  final double confidence;
  final double boundingBoxX1;
  final double boundingBoxY1;
  final double boundingBoxX2;
  final double boundingBoxY2;
  final int classId;
  final DateTime detectedAt;
  final int? userId;
  const Detection(
      {required this.id,
      required this.connectorId,
      required this.imagePath,
      this.imageBytes,
      required this.className,
      required this.confidence,
      required this.boundingBoxX1,
      required this.boundingBoxY1,
      required this.boundingBoxX2,
      required this.boundingBoxY2,
      required this.classId,
      required this.detectedAt,
      this.userId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['connector_id'] = Variable<int>(connectorId);
    map['image_path'] = Variable<String>(imagePath);
    if (!nullToAbsent || imageBytes != null) {
      map['image_bytes'] = Variable<Uint8List>(imageBytes);
    }
    map['class_name'] = Variable<String>(className);
    map['confidence'] = Variable<double>(confidence);
    map['bounding_box_x1'] = Variable<double>(boundingBoxX1);
    map['bounding_box_y1'] = Variable<double>(boundingBoxY1);
    map['bounding_box_x2'] = Variable<double>(boundingBoxX2);
    map['bounding_box_y2'] = Variable<double>(boundingBoxY2);
    map['class_id'] = Variable<int>(classId);
    map['detected_at'] = Variable<DateTime>(detectedAt);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    return map;
  }

  DetectionsCompanion toCompanion(bool nullToAbsent) {
    return DetectionsCompanion(
      id: Value(id),
      connectorId: Value(connectorId),
      imagePath: Value(imagePath),
      imageBytes: imageBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(imageBytes),
      className: Value(className),
      confidence: Value(confidence),
      boundingBoxX1: Value(boundingBoxX1),
      boundingBoxY1: Value(boundingBoxY1),
      boundingBoxX2: Value(boundingBoxX2),
      boundingBoxY2: Value(boundingBoxY2),
      classId: Value(classId),
      detectedAt: Value(detectedAt),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
    );
  }

  factory Detection.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Detection(
      id: serializer.fromJson<int>(json['id']),
      connectorId: serializer.fromJson<int>(json['connectorId']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      imageBytes: serializer.fromJson<Uint8List?>(json['imageBytes']),
      className: serializer.fromJson<String>(json['className']),
      confidence: serializer.fromJson<double>(json['confidence']),
      boundingBoxX1: serializer.fromJson<double>(json['boundingBoxX1']),
      boundingBoxY1: serializer.fromJson<double>(json['boundingBoxY1']),
      boundingBoxX2: serializer.fromJson<double>(json['boundingBoxX2']),
      boundingBoxY2: serializer.fromJson<double>(json['boundingBoxY2']),
      classId: serializer.fromJson<int>(json['classId']),
      detectedAt: serializer.fromJson<DateTime>(json['detectedAt']),
      userId: serializer.fromJson<int?>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'connectorId': serializer.toJson<int>(connectorId),
      'imagePath': serializer.toJson<String>(imagePath),
      'imageBytes': serializer.toJson<Uint8List?>(imageBytes),
      'className': serializer.toJson<String>(className),
      'confidence': serializer.toJson<double>(confidence),
      'boundingBoxX1': serializer.toJson<double>(boundingBoxX1),
      'boundingBoxY1': serializer.toJson<double>(boundingBoxY1),
      'boundingBoxX2': serializer.toJson<double>(boundingBoxX2),
      'boundingBoxY2': serializer.toJson<double>(boundingBoxY2),
      'classId': serializer.toJson<int>(classId),
      'detectedAt': serializer.toJson<DateTime>(detectedAt),
      'userId': serializer.toJson<int?>(userId),
    };
  }

  Detection copyWith(
          {int? id,
          int? connectorId,
          String? imagePath,
          Value<Uint8List?> imageBytes = const Value.absent(),
          String? className,
          double? confidence,
          double? boundingBoxX1,
          double? boundingBoxY1,
          double? boundingBoxX2,
          double? boundingBoxY2,
          int? classId,
          DateTime? detectedAt,
          Value<int?> userId = const Value.absent()}) =>
      Detection(
        id: id ?? this.id,
        connectorId: connectorId ?? this.connectorId,
        imagePath: imagePath ?? this.imagePath,
        imageBytes: imageBytes.present ? imageBytes.value : this.imageBytes,
        className: className ?? this.className,
        confidence: confidence ?? this.confidence,
        boundingBoxX1: boundingBoxX1 ?? this.boundingBoxX1,
        boundingBoxY1: boundingBoxY1 ?? this.boundingBoxY1,
        boundingBoxX2: boundingBoxX2 ?? this.boundingBoxX2,
        boundingBoxY2: boundingBoxY2 ?? this.boundingBoxY2,
        classId: classId ?? this.classId,
        detectedAt: detectedAt ?? this.detectedAt,
        userId: userId.present ? userId.value : this.userId,
      );
  Detection copyWithCompanion(DetectionsCompanion data) {
    return Detection(
      id: data.id.present ? data.id.value : this.id,
      connectorId:
          data.connectorId.present ? data.connectorId.value : this.connectorId,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      imageBytes:
          data.imageBytes.present ? data.imageBytes.value : this.imageBytes,
      className: data.className.present ? data.className.value : this.className,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      boundingBoxX1: data.boundingBoxX1.present
          ? data.boundingBoxX1.value
          : this.boundingBoxX1,
      boundingBoxY1: data.boundingBoxY1.present
          ? data.boundingBoxY1.value
          : this.boundingBoxY1,
      boundingBoxX2: data.boundingBoxX2.present
          ? data.boundingBoxX2.value
          : this.boundingBoxX2,
      boundingBoxY2: data.boundingBoxY2.present
          ? data.boundingBoxY2.value
          : this.boundingBoxY2,
      classId: data.classId.present ? data.classId.value : this.classId,
      detectedAt:
          data.detectedAt.present ? data.detectedAt.value : this.detectedAt,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Detection(')
          ..write('id: $id, ')
          ..write('connectorId: $connectorId, ')
          ..write('imagePath: $imagePath, ')
          ..write('imageBytes: $imageBytes, ')
          ..write('className: $className, ')
          ..write('confidence: $confidence, ')
          ..write('boundingBoxX1: $boundingBoxX1, ')
          ..write('boundingBoxY1: $boundingBoxY1, ')
          ..write('boundingBoxX2: $boundingBoxX2, ')
          ..write('boundingBoxY2: $boundingBoxY2, ')
          ..write('classId: $classId, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      connectorId,
      imagePath,
      $driftBlobEquality.hash(imageBytes),
      className,
      confidence,
      boundingBoxX1,
      boundingBoxY1,
      boundingBoxX2,
      boundingBoxY2,
      classId,
      detectedAt,
      userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Detection &&
          other.id == this.id &&
          other.connectorId == this.connectorId &&
          other.imagePath == this.imagePath &&
          $driftBlobEquality.equals(other.imageBytes, this.imageBytes) &&
          other.className == this.className &&
          other.confidence == this.confidence &&
          other.boundingBoxX1 == this.boundingBoxX1 &&
          other.boundingBoxY1 == this.boundingBoxY1 &&
          other.boundingBoxX2 == this.boundingBoxX2 &&
          other.boundingBoxY2 == this.boundingBoxY2 &&
          other.classId == this.classId &&
          other.detectedAt == this.detectedAt &&
          other.userId == this.userId);
}

class DetectionsCompanion extends UpdateCompanion<Detection> {
  final Value<int> id;
  final Value<int> connectorId;
  final Value<String> imagePath;
  final Value<Uint8List?> imageBytes;
  final Value<String> className;
  final Value<double> confidence;
  final Value<double> boundingBoxX1;
  final Value<double> boundingBoxY1;
  final Value<double> boundingBoxX2;
  final Value<double> boundingBoxY2;
  final Value<int> classId;
  final Value<DateTime> detectedAt;
  final Value<int?> userId;
  const DetectionsCompanion({
    this.id = const Value.absent(),
    this.connectorId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.imageBytes = const Value.absent(),
    this.className = const Value.absent(),
    this.confidence = const Value.absent(),
    this.boundingBoxX1 = const Value.absent(),
    this.boundingBoxY1 = const Value.absent(),
    this.boundingBoxX2 = const Value.absent(),
    this.boundingBoxY2 = const Value.absent(),
    this.classId = const Value.absent(),
    this.detectedAt = const Value.absent(),
    this.userId = const Value.absent(),
  });
  DetectionsCompanion.insert({
    this.id = const Value.absent(),
    required int connectorId,
    required String imagePath,
    this.imageBytes = const Value.absent(),
    required String className,
    required double confidence,
    required double boundingBoxX1,
    required double boundingBoxY1,
    required double boundingBoxX2,
    required double boundingBoxY2,
    this.classId = const Value.absent(),
    this.detectedAt = const Value.absent(),
    this.userId = const Value.absent(),
  })  : connectorId = Value(connectorId),
        imagePath = Value(imagePath),
        className = Value(className),
        confidence = Value(confidence),
        boundingBoxX1 = Value(boundingBoxX1),
        boundingBoxY1 = Value(boundingBoxY1),
        boundingBoxX2 = Value(boundingBoxX2),
        boundingBoxY2 = Value(boundingBoxY2);
  static Insertable<Detection> custom({
    Expression<int>? id,
    Expression<int>? connectorId,
    Expression<String>? imagePath,
    Expression<Uint8List>? imageBytes,
    Expression<String>? className,
    Expression<double>? confidence,
    Expression<double>? boundingBoxX1,
    Expression<double>? boundingBoxY1,
    Expression<double>? boundingBoxX2,
    Expression<double>? boundingBoxY2,
    Expression<int>? classId,
    Expression<DateTime>? detectedAt,
    Expression<int>? userId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (connectorId != null) 'connector_id': connectorId,
      if (imagePath != null) 'image_path': imagePath,
      if (imageBytes != null) 'image_bytes': imageBytes,
      if (className != null) 'class_name': className,
      if (confidence != null) 'confidence': confidence,
      if (boundingBoxX1 != null) 'bounding_box_x1': boundingBoxX1,
      if (boundingBoxY1 != null) 'bounding_box_y1': boundingBoxY1,
      if (boundingBoxX2 != null) 'bounding_box_x2': boundingBoxX2,
      if (boundingBoxY2 != null) 'bounding_box_y2': boundingBoxY2,
      if (classId != null) 'class_id': classId,
      if (detectedAt != null) 'detected_at': detectedAt,
      if (userId != null) 'user_id': userId,
    });
  }

  DetectionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? connectorId,
      Value<String>? imagePath,
      Value<Uint8List?>? imageBytes,
      Value<String>? className,
      Value<double>? confidence,
      Value<double>? boundingBoxX1,
      Value<double>? boundingBoxY1,
      Value<double>? boundingBoxX2,
      Value<double>? boundingBoxY2,
      Value<int>? classId,
      Value<DateTime>? detectedAt,
      Value<int?>? userId}) {
    return DetectionsCompanion(
      id: id ?? this.id,
      connectorId: connectorId ?? this.connectorId,
      imagePath: imagePath ?? this.imagePath,
      imageBytes: imageBytes ?? this.imageBytes,
      className: className ?? this.className,
      confidence: confidence ?? this.confidence,
      boundingBoxX1: boundingBoxX1 ?? this.boundingBoxX1,
      boundingBoxY1: boundingBoxY1 ?? this.boundingBoxY1,
      boundingBoxX2: boundingBoxX2 ?? this.boundingBoxX2,
      boundingBoxY2: boundingBoxY2 ?? this.boundingBoxY2,
      classId: classId ?? this.classId,
      detectedAt: detectedAt ?? this.detectedAt,
      userId: userId ?? this.userId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (connectorId.present) {
      map['connector_id'] = Variable<int>(connectorId.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (imageBytes.present) {
      map['image_bytes'] = Variable<Uint8List>(imageBytes.value);
    }
    if (className.present) {
      map['class_name'] = Variable<String>(className.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (boundingBoxX1.present) {
      map['bounding_box_x1'] = Variable<double>(boundingBoxX1.value);
    }
    if (boundingBoxY1.present) {
      map['bounding_box_y1'] = Variable<double>(boundingBoxY1.value);
    }
    if (boundingBoxX2.present) {
      map['bounding_box_x2'] = Variable<double>(boundingBoxX2.value);
    }
    if (boundingBoxY2.present) {
      map['bounding_box_y2'] = Variable<double>(boundingBoxY2.value);
    }
    if (classId.present) {
      map['class_id'] = Variable<int>(classId.value);
    }
    if (detectedAt.present) {
      map['detected_at'] = Variable<DateTime>(detectedAt.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DetectionsCompanion(')
          ..write('id: $id, ')
          ..write('connectorId: $connectorId, ')
          ..write('imagePath: $imagePath, ')
          ..write('imageBytes: $imageBytes, ')
          ..write('className: $className, ')
          ..write('confidence: $confidence, ')
          ..write('boundingBoxX1: $boundingBoxX1, ')
          ..write('boundingBoxY1: $boundingBoxY1, ')
          ..write('boundingBoxX2: $boundingBoxX2, ')
          ..write('boundingBoxY2: $boundingBoxY2, ')
          ..write('classId: $classId, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $LoginSessionsTable loginSessions = $LoginSessionsTable(this);
  late final $BarcodeScansTable barcodeScans = $BarcodeScansTable(this);
  late final $ConnectorsTable connectors = $ConnectorsTable(this);
  late final $DetectionsTable detections = $DetectionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [users, loginSessions, barcodeScans, connectors, detections];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String username,
  required String password,
  Value<String?> email,
  Value<String?> fullName,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> username,
  Value<String> password,
  Value<String?> email,
  Value<String?> fullName,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LoginSessionsTable, List<LoginSession>>
      _loginSessionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.loginSessions,
              aliasName:
                  $_aliasNameGenerator(db.users.id, db.loginSessions.userId));

  $$LoginSessionsTableProcessedTableManager get loginSessionsRefs {
    final manager = $$LoginSessionsTableTableManager($_db, $_db.loginSessions)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_loginSessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$BarcodeScansTable, List<BarcodeScan>>
      _barcodeScansRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.barcodeScans,
          aliasName: $_aliasNameGenerator(db.users.id, db.barcodeScans.userId));

  $$BarcodeScansTableProcessedTableManager get barcodeScansRefs {
    final manager = $$BarcodeScansTableTableManager($_db, $_db.barcodeScans)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_barcodeScansRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DetectionsTable, List<Detection>>
      _detectionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.detections,
          aliasName: $_aliasNameGenerator(db.users.id, db.detections.userId));

  $$DetectionsTableProcessedTableManager get detectionsRefs {
    final manager = $$DetectionsTableTableManager($_db, $_db.detections)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_detectionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> loginSessionsRefs(
      Expression<bool> Function($$LoginSessionsTableFilterComposer f) f) {
    final $$LoginSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.loginSessions,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LoginSessionsTableFilterComposer(
              $db: $db,
              $table: $db.loginSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> barcodeScansRefs(
      Expression<bool> Function($$BarcodeScansTableFilterComposer f) f) {
    final $$BarcodeScansTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.barcodeScans,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BarcodeScansTableFilterComposer(
              $db: $db,
              $table: $db.barcodeScans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> detectionsRefs(
      Expression<bool> Function($$DetectionsTableFilterComposer f) f) {
    final $$DetectionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.detections,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DetectionsTableFilterComposer(
              $db: $db,
              $table: $db.detections,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> loginSessionsRefs<T extends Object>(
      Expression<T> Function($$LoginSessionsTableAnnotationComposer a) f) {
    final $$LoginSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.loginSessions,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LoginSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.loginSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> barcodeScansRefs<T extends Object>(
      Expression<T> Function($$BarcodeScansTableAnnotationComposer a) f) {
    final $$BarcodeScansTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.barcodeScans,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BarcodeScansTableAnnotationComposer(
              $db: $db,
              $table: $db.barcodeScans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> detectionsRefs<T extends Object>(
      Expression<T> Function($$DetectionsTableAnnotationComposer a) f) {
    final $$DetectionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.detections,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DetectionsTableAnnotationComposer(
              $db: $db,
              $table: $db.detections,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function(
        {bool loginSessionsRefs, bool barcodeScansRefs, bool detectionsRefs})> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> password = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> fullName = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            username: username,
            password: password,
            email: email,
            fullName: fullName,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String username,
            required String password,
            Value<String?> email = const Value.absent(),
            Value<String?> fullName = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            username: username,
            password: password,
            email: email,
            fullName: fullName,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {loginSessionsRefs = false,
              barcodeScansRefs = false,
              detectionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (loginSessionsRefs) db.loginSessions,
                if (barcodeScansRefs) db.barcodeScans,
                if (detectionsRefs) db.detections
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (loginSessionsRefs)
                    await $_getPrefetchedData<User, $UsersTable, LoginSession>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._loginSessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .loginSessionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (barcodeScansRefs)
                    await $_getPrefetchedData<User, $UsersTable, BarcodeScan>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._barcodeScansRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .barcodeScansRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (detectionsRefs)
                    await $_getPrefetchedData<User, $UsersTable, Detection>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._detectionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .detectionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function(
        {bool loginSessionsRefs, bool barcodeScansRefs, bool detectionsRefs})>;
typedef $$LoginSessionsTableCreateCompanionBuilder = LoginSessionsCompanion
    Function({
  Value<int> id,
  required int userId,
  Value<DateTime> loginTime,
  Value<DateTime?> logoutTime,
  Value<bool> isActive,
});
typedef $$LoginSessionsTableUpdateCompanionBuilder = LoginSessionsCompanion
    Function({
  Value<int> id,
  Value<int> userId,
  Value<DateTime> loginTime,
  Value<DateTime?> logoutTime,
  Value<bool> isActive,
});

final class $$LoginSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $LoginSessionsTable, LoginSession> {
  $$LoginSessionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.loginSessions.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LoginSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $LoginSessionsTable> {
  $$LoginSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get loginTime => $composableBuilder(
      column: $table.loginTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get logoutTime => $composableBuilder(
      column: $table.logoutTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LoginSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LoginSessionsTable> {
  $$LoginSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get loginTime => $composableBuilder(
      column: $table.loginTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get logoutTime => $composableBuilder(
      column: $table.logoutTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LoginSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoginSessionsTable> {
  $$LoginSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get loginTime =>
      $composableBuilder(column: $table.loginTime, builder: (column) => column);

  GeneratedColumn<DateTime> get logoutTime => $composableBuilder(
      column: $table.logoutTime, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LoginSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LoginSessionsTable,
    LoginSession,
    $$LoginSessionsTableFilterComposer,
    $$LoginSessionsTableOrderingComposer,
    $$LoginSessionsTableAnnotationComposer,
    $$LoginSessionsTableCreateCompanionBuilder,
    $$LoginSessionsTableUpdateCompanionBuilder,
    (LoginSession, $$LoginSessionsTableReferences),
    LoginSession,
    PrefetchHooks Function({bool userId})> {
  $$LoginSessionsTableTableManager(_$AppDatabase db, $LoginSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoginSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoginSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoginSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<DateTime> loginTime = const Value.absent(),
            Value<DateTime?> logoutTime = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              LoginSessionsCompanion(
            id: id,
            userId: userId,
            loginTime: loginTime,
            logoutTime: logoutTime,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            Value<DateTime> loginTime = const Value.absent(),
            Value<DateTime?> logoutTime = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              LoginSessionsCompanion.insert(
            id: id,
            userId: userId,
            loginTime: loginTime,
            logoutTime: logoutTime,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LoginSessionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
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
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$LoginSessionsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$LoginSessionsTableReferences._userIdTable(db).id,
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

typedef $$LoginSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LoginSessionsTable,
    LoginSession,
    $$LoginSessionsTableFilterComposer,
    $$LoginSessionsTableOrderingComposer,
    $$LoginSessionsTableAnnotationComposer,
    $$LoginSessionsTableCreateCompanionBuilder,
    $$LoginSessionsTableUpdateCompanionBuilder,
    (LoginSession, $$LoginSessionsTableReferences),
    LoginSession,
    PrefetchHooks Function({bool userId})>;
typedef $$BarcodeScansTableCreateCompanionBuilder = BarcodeScansCompanion
    Function({
  Value<int> id,
  required String barcode,
  Value<String?> barcodeType,
  Value<String?> scannedData,
  Value<DateTime> scannedAt,
  Value<int?> userId,
});
typedef $$BarcodeScansTableUpdateCompanionBuilder = BarcodeScansCompanion
    Function({
  Value<int> id,
  Value<String> barcode,
  Value<String?> barcodeType,
  Value<String?> scannedData,
  Value<DateTime> scannedAt,
  Value<int?> userId,
});

final class $$BarcodeScansTableReferences
    extends BaseReferences<_$AppDatabase, $BarcodeScansTable, BarcodeScan> {
  $$BarcodeScansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.barcodeScans.userId, db.users.id));

  $$UsersTableProcessedTableManager? get userId {
    final $_column = $_itemColumn<int>('user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ConnectorsTable, List<Connector>>
      _connectorsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.connectors,
              aliasName: $_aliasNameGenerator(
                  db.barcodeScans.id, db.connectors.barcodeScanId));

  $$ConnectorsTableProcessedTableManager get connectorsRefs {
    final manager = $$ConnectorsTableTableManager($_db, $_db.connectors)
        .filter((f) => f.barcodeScanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_connectorsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$BarcodeScansTableFilterComposer
    extends Composer<_$AppDatabase, $BarcodeScansTable> {
  $$BarcodeScansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcodeType => $composableBuilder(
      column: $table.barcodeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scannedData => $composableBuilder(
      column: $table.scannedData, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scannedAt => $composableBuilder(
      column: $table.scannedAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> connectorsRefs(
      Expression<bool> Function($$ConnectorsTableFilterComposer f) f) {
    final $$ConnectorsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.connectors,
        getReferencedColumn: (t) => t.barcodeScanId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConnectorsTableFilterComposer(
              $db: $db,
              $table: $db.connectors,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BarcodeScansTableOrderingComposer
    extends Composer<_$AppDatabase, $BarcodeScansTable> {
  $$BarcodeScansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcodeType => $composableBuilder(
      column: $table.barcodeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scannedData => $composableBuilder(
      column: $table.scannedData, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scannedAt => $composableBuilder(
      column: $table.scannedAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BarcodeScansTableAnnotationComposer
    extends Composer<_$AppDatabase, $BarcodeScansTable> {
  $$BarcodeScansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get barcodeType => $composableBuilder(
      column: $table.barcodeType, builder: (column) => column);

  GeneratedColumn<String> get scannedData => $composableBuilder(
      column: $table.scannedData, builder: (column) => column);

  GeneratedColumn<DateTime> get scannedAt =>
      $composableBuilder(column: $table.scannedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> connectorsRefs<T extends Object>(
      Expression<T> Function($$ConnectorsTableAnnotationComposer a) f) {
    final $$ConnectorsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.connectors,
        getReferencedColumn: (t) => t.barcodeScanId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConnectorsTableAnnotationComposer(
              $db: $db,
              $table: $db.connectors,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BarcodeScansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BarcodeScansTable,
    BarcodeScan,
    $$BarcodeScansTableFilterComposer,
    $$BarcodeScansTableOrderingComposer,
    $$BarcodeScansTableAnnotationComposer,
    $$BarcodeScansTableCreateCompanionBuilder,
    $$BarcodeScansTableUpdateCompanionBuilder,
    (BarcodeScan, $$BarcodeScansTableReferences),
    BarcodeScan,
    PrefetchHooks Function({bool userId, bool connectorsRefs})> {
  $$BarcodeScansTableTableManager(_$AppDatabase db, $BarcodeScansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BarcodeScansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BarcodeScansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BarcodeScansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> barcode = const Value.absent(),
            Value<String?> barcodeType = const Value.absent(),
            Value<String?> scannedData = const Value.absent(),
            Value<DateTime> scannedAt = const Value.absent(),
            Value<int?> userId = const Value.absent(),
          }) =>
              BarcodeScansCompanion(
            id: id,
            barcode: barcode,
            barcodeType: barcodeType,
            scannedData: scannedData,
            scannedAt: scannedAt,
            userId: userId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String barcode,
            Value<String?> barcodeType = const Value.absent(),
            Value<String?> scannedData = const Value.absent(),
            Value<DateTime> scannedAt = const Value.absent(),
            Value<int?> userId = const Value.absent(),
          }) =>
              BarcodeScansCompanion.insert(
            id: id,
            barcode: barcode,
            barcodeType: barcodeType,
            scannedData: scannedData,
            scannedAt: scannedAt,
            userId: userId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BarcodeScansTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false, connectorsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (connectorsRefs) db.connectors],
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
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$BarcodeScansTableReferences._userIdTable(db),
                    referencedColumn:
                        $$BarcodeScansTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (connectorsRefs)
                    await $_getPrefetchedData<BarcodeScan, $BarcodeScansTable,
                            Connector>(
                        currentTable: table,
                        referencedTable: $$BarcodeScansTableReferences
                            ._connectorsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BarcodeScansTableReferences(db, table, p0)
                                .connectorsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.barcodeScanId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$BarcodeScansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BarcodeScansTable,
    BarcodeScan,
    $$BarcodeScansTableFilterComposer,
    $$BarcodeScansTableOrderingComposer,
    $$BarcodeScansTableAnnotationComposer,
    $$BarcodeScansTableCreateCompanionBuilder,
    $$BarcodeScansTableUpdateCompanionBuilder,
    (BarcodeScan, $$BarcodeScansTableReferences),
    BarcodeScan,
    PrefetchHooks Function({bool userId, bool connectorsRefs})>;
typedef $$ConnectorsTableCreateCompanionBuilder = ConnectorsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> description,
  Value<String?> barcodeId,
  Value<int?> barcodeScanId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ConnectorsTableUpdateCompanionBuilder = ConnectorsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
  Value<String?> barcodeId,
  Value<int?> barcodeScanId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$ConnectorsTableReferences
    extends BaseReferences<_$AppDatabase, $ConnectorsTable, Connector> {
  $$ConnectorsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BarcodeScansTable _barcodeScanIdTable(_$AppDatabase db) =>
      db.barcodeScans.createAlias($_aliasNameGenerator(
          db.connectors.barcodeScanId, db.barcodeScans.id));

  $$BarcodeScansTableProcessedTableManager? get barcodeScanId {
    final $_column = $_itemColumn<int>('barcode_scan_id');
    if ($_column == null) return null;
    final manager = $$BarcodeScansTableTableManager($_db, $_db.barcodeScans)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_barcodeScanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$DetectionsTable, List<Detection>>
      _detectionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.detections,
              aliasName: $_aliasNameGenerator(
                  db.connectors.id, db.detections.connectorId));

  $$DetectionsTableProcessedTableManager get detectionsRefs {
    final manager = $$DetectionsTableTableManager($_db, $_db.detections)
        .filter((f) => f.connectorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_detectionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ConnectorsTableFilterComposer
    extends Composer<_$AppDatabase, $ConnectorsTable> {
  $$ConnectorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcodeId => $composableBuilder(
      column: $table.barcodeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$BarcodeScansTableFilterComposer get barcodeScanId {
    final $$BarcodeScansTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.barcodeScanId,
        referencedTable: $db.barcodeScans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BarcodeScansTableFilterComposer(
              $db: $db,
              $table: $db.barcodeScans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> detectionsRefs(
      Expression<bool> Function($$DetectionsTableFilterComposer f) f) {
    final $$DetectionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.detections,
        getReferencedColumn: (t) => t.connectorId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DetectionsTableFilterComposer(
              $db: $db,
              $table: $db.detections,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ConnectorsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConnectorsTable> {
  $$ConnectorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcodeId => $composableBuilder(
      column: $table.barcodeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$BarcodeScansTableOrderingComposer get barcodeScanId {
    final $$BarcodeScansTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.barcodeScanId,
        referencedTable: $db.barcodeScans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BarcodeScansTableOrderingComposer(
              $db: $db,
              $table: $db.barcodeScans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ConnectorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConnectorsTable> {
  $$ConnectorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get barcodeId =>
      $composableBuilder(column: $table.barcodeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BarcodeScansTableAnnotationComposer get barcodeScanId {
    final $$BarcodeScansTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.barcodeScanId,
        referencedTable: $db.barcodeScans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BarcodeScansTableAnnotationComposer(
              $db: $db,
              $table: $db.barcodeScans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> detectionsRefs<T extends Object>(
      Expression<T> Function($$DetectionsTableAnnotationComposer a) f) {
    final $$DetectionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.detections,
        getReferencedColumn: (t) => t.connectorId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DetectionsTableAnnotationComposer(
              $db: $db,
              $table: $db.detections,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ConnectorsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ConnectorsTable,
    Connector,
    $$ConnectorsTableFilterComposer,
    $$ConnectorsTableOrderingComposer,
    $$ConnectorsTableAnnotationComposer,
    $$ConnectorsTableCreateCompanionBuilder,
    $$ConnectorsTableUpdateCompanionBuilder,
    (Connector, $$ConnectorsTableReferences),
    Connector,
    PrefetchHooks Function({bool barcodeScanId, bool detectionsRefs})> {
  $$ConnectorsTableTableManager(_$AppDatabase db, $ConnectorsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConnectorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConnectorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConnectorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> barcodeId = const Value.absent(),
            Value<int?> barcodeScanId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ConnectorsCompanion(
            id: id,
            name: name,
            description: description,
            barcodeId: barcodeId,
            barcodeScanId: barcodeScanId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            Value<String?> barcodeId = const Value.absent(),
            Value<int?> barcodeScanId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ConnectorsCompanion.insert(
            id: id,
            name: name,
            description: description,
            barcodeId: barcodeId,
            barcodeScanId: barcodeScanId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ConnectorsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {barcodeScanId = false, detectionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (detectionsRefs) db.detections],
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
                if (barcodeScanId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.barcodeScanId,
                    referencedTable:
                        $$ConnectorsTableReferences._barcodeScanIdTable(db),
                    referencedColumn:
                        $$ConnectorsTableReferences._barcodeScanIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (detectionsRefs)
                    await $_getPrefetchedData<Connector, $ConnectorsTable,
                            Detection>(
                        currentTable: table,
                        referencedTable: $$ConnectorsTableReferences
                            ._detectionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ConnectorsTableReferences(db, table, p0)
                                .detectionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.connectorId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ConnectorsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ConnectorsTable,
    Connector,
    $$ConnectorsTableFilterComposer,
    $$ConnectorsTableOrderingComposer,
    $$ConnectorsTableAnnotationComposer,
    $$ConnectorsTableCreateCompanionBuilder,
    $$ConnectorsTableUpdateCompanionBuilder,
    (Connector, $$ConnectorsTableReferences),
    Connector,
    PrefetchHooks Function({bool barcodeScanId, bool detectionsRefs})>;
typedef $$DetectionsTableCreateCompanionBuilder = DetectionsCompanion Function({
  Value<int> id,
  required int connectorId,
  required String imagePath,
  Value<Uint8List?> imageBytes,
  required String className,
  required double confidence,
  required double boundingBoxX1,
  required double boundingBoxY1,
  required double boundingBoxX2,
  required double boundingBoxY2,
  Value<int> classId,
  Value<DateTime> detectedAt,
  Value<int?> userId,
});
typedef $$DetectionsTableUpdateCompanionBuilder = DetectionsCompanion Function({
  Value<int> id,
  Value<int> connectorId,
  Value<String> imagePath,
  Value<Uint8List?> imageBytes,
  Value<String> className,
  Value<double> confidence,
  Value<double> boundingBoxX1,
  Value<double> boundingBoxY1,
  Value<double> boundingBoxX2,
  Value<double> boundingBoxY2,
  Value<int> classId,
  Value<DateTime> detectedAt,
  Value<int?> userId,
});

final class $$DetectionsTableReferences
    extends BaseReferences<_$AppDatabase, $DetectionsTable, Detection> {
  $$DetectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ConnectorsTable _connectorIdTable(_$AppDatabase db) =>
      db.connectors.createAlias(
          $_aliasNameGenerator(db.detections.connectorId, db.connectors.id));

  $$ConnectorsTableProcessedTableManager get connectorId {
    final $_column = $_itemColumn<int>('connector_id')!;

    final manager = $$ConnectorsTableTableManager($_db, $_db.connectors)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_connectorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.detections.userId, db.users.id));

  $$UsersTableProcessedTableManager? get userId {
    final $_column = $_itemColumn<int>('user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DetectionsTableFilterComposer
    extends Composer<_$AppDatabase, $DetectionsTable> {
  $$DetectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get imageBytes => $composableBuilder(
      column: $table.imageBytes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get className => $composableBuilder(
      column: $table.className, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get boundingBoxX1 => $composableBuilder(
      column: $table.boundingBoxX1, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get boundingBoxY1 => $composableBuilder(
      column: $table.boundingBoxY1, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get boundingBoxX2 => $composableBuilder(
      column: $table.boundingBoxX2, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get boundingBoxY2 => $composableBuilder(
      column: $table.boundingBoxY2, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get classId => $composableBuilder(
      column: $table.classId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get detectedAt => $composableBuilder(
      column: $table.detectedAt, builder: (column) => ColumnFilters(column));

  $$ConnectorsTableFilterComposer get connectorId {
    final $$ConnectorsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.connectorId,
        referencedTable: $db.connectors,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConnectorsTableFilterComposer(
              $db: $db,
              $table: $db.connectors,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DetectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $DetectionsTable> {
  $$DetectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get imageBytes => $composableBuilder(
      column: $table.imageBytes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get className => $composableBuilder(
      column: $table.className, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get boundingBoxX1 => $composableBuilder(
      column: $table.boundingBoxX1,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get boundingBoxY1 => $composableBuilder(
      column: $table.boundingBoxY1,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get boundingBoxX2 => $composableBuilder(
      column: $table.boundingBoxX2,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get boundingBoxY2 => $composableBuilder(
      column: $table.boundingBoxY2,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get classId => $composableBuilder(
      column: $table.classId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get detectedAt => $composableBuilder(
      column: $table.detectedAt, builder: (column) => ColumnOrderings(column));

  $$ConnectorsTableOrderingComposer get connectorId {
    final $$ConnectorsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.connectorId,
        referencedTable: $db.connectors,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConnectorsTableOrderingComposer(
              $db: $db,
              $table: $db.connectors,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DetectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DetectionsTable> {
  $$DetectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<Uint8List> get imageBytes => $composableBuilder(
      column: $table.imageBytes, builder: (column) => column);

  GeneratedColumn<String> get className =>
      $composableBuilder(column: $table.className, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => column);

  GeneratedColumn<double> get boundingBoxX1 => $composableBuilder(
      column: $table.boundingBoxX1, builder: (column) => column);

  GeneratedColumn<double> get boundingBoxY1 => $composableBuilder(
      column: $table.boundingBoxY1, builder: (column) => column);

  GeneratedColumn<double> get boundingBoxX2 => $composableBuilder(
      column: $table.boundingBoxX2, builder: (column) => column);

  GeneratedColumn<double> get boundingBoxY2 => $composableBuilder(
      column: $table.boundingBoxY2, builder: (column) => column);

  GeneratedColumn<int> get classId =>
      $composableBuilder(column: $table.classId, builder: (column) => column);

  GeneratedColumn<DateTime> get detectedAt => $composableBuilder(
      column: $table.detectedAt, builder: (column) => column);

  $$ConnectorsTableAnnotationComposer get connectorId {
    final $$ConnectorsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.connectorId,
        referencedTable: $db.connectors,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConnectorsTableAnnotationComposer(
              $db: $db,
              $table: $db.connectors,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DetectionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DetectionsTable,
    Detection,
    $$DetectionsTableFilterComposer,
    $$DetectionsTableOrderingComposer,
    $$DetectionsTableAnnotationComposer,
    $$DetectionsTableCreateCompanionBuilder,
    $$DetectionsTableUpdateCompanionBuilder,
    (Detection, $$DetectionsTableReferences),
    Detection,
    PrefetchHooks Function({bool connectorId, bool userId})> {
  $$DetectionsTableTableManager(_$AppDatabase db, $DetectionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DetectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DetectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DetectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> connectorId = const Value.absent(),
            Value<String> imagePath = const Value.absent(),
            Value<Uint8List?> imageBytes = const Value.absent(),
            Value<String> className = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<double> boundingBoxX1 = const Value.absent(),
            Value<double> boundingBoxY1 = const Value.absent(),
            Value<double> boundingBoxX2 = const Value.absent(),
            Value<double> boundingBoxY2 = const Value.absent(),
            Value<int> classId = const Value.absent(),
            Value<DateTime> detectedAt = const Value.absent(),
            Value<int?> userId = const Value.absent(),
          }) =>
              DetectionsCompanion(
            id: id,
            connectorId: connectorId,
            imagePath: imagePath,
            imageBytes: imageBytes,
            className: className,
            confidence: confidence,
            boundingBoxX1: boundingBoxX1,
            boundingBoxY1: boundingBoxY1,
            boundingBoxX2: boundingBoxX2,
            boundingBoxY2: boundingBoxY2,
            classId: classId,
            detectedAt: detectedAt,
            userId: userId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int connectorId,
            required String imagePath,
            Value<Uint8List?> imageBytes = const Value.absent(),
            required String className,
            required double confidence,
            required double boundingBoxX1,
            required double boundingBoxY1,
            required double boundingBoxX2,
            required double boundingBoxY2,
            Value<int> classId = const Value.absent(),
            Value<DateTime> detectedAt = const Value.absent(),
            Value<int?> userId = const Value.absent(),
          }) =>
              DetectionsCompanion.insert(
            id: id,
            connectorId: connectorId,
            imagePath: imagePath,
            imageBytes: imageBytes,
            className: className,
            confidence: confidence,
            boundingBoxX1: boundingBoxX1,
            boundingBoxY1: boundingBoxY1,
            boundingBoxX2: boundingBoxX2,
            boundingBoxY2: boundingBoxY2,
            classId: classId,
            detectedAt: detectedAt,
            userId: userId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DetectionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({connectorId = false, userId = false}) {
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
                if (connectorId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.connectorId,
                    referencedTable:
                        $$DetectionsTableReferences._connectorIdTable(db),
                    referencedColumn:
                        $$DetectionsTableReferences._connectorIdTable(db).id,
                  ) as T;
                }
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$DetectionsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$DetectionsTableReferences._userIdTable(db).id,
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

typedef $$DetectionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DetectionsTable,
    Detection,
    $$DetectionsTableFilterComposer,
    $$DetectionsTableOrderingComposer,
    $$DetectionsTableAnnotationComposer,
    $$DetectionsTableCreateCompanionBuilder,
    $$DetectionsTableUpdateCompanionBuilder,
    (Detection, $$DetectionsTableReferences),
    Detection,
    PrefetchHooks Function({bool connectorId, bool userId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$LoginSessionsTableTableManager get loginSessions =>
      $$LoginSessionsTableTableManager(_db, _db.loginSessions);
  $$BarcodeScansTableTableManager get barcodeScans =>
      $$BarcodeScansTableTableManager(_db, _db.barcodeScans);
  $$ConnectorsTableTableManager get connectors =>
      $$ConnectorsTableTableManager(_db, _db.connectors);
  $$DetectionsTableTableManager get detections =>
      $$DetectionsTableTableManager(_db, _db.detections);
}
