// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $LocalGamesTable extends LocalGames
    with TableInfo<$LocalGamesTable, LocalGame> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalGamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _homeTeamNameMeta = const VerificationMeta(
    'homeTeamName',
  );
  @override
  late final GeneratedColumn<String> homeTeamName = GeneratedColumn<String>(
    'home_team_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _awayTeamNameMeta = const VerificationMeta(
    'awayTeamName',
  );
  @override
  late final GeneratedColumn<String> awayTeamName = GeneratedColumn<String>(
    'away_team_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _homeScoreMeta = const VerificationMeta(
    'homeScore',
  );
  @override
  late final GeneratedColumn<int> homeScore = GeneratedColumn<int>(
    'home_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _awayScoreMeta = const VerificationMeta(
    'awayScore',
  );
  @override
  late final GeneratedColumn<int> awayScore = GeneratedColumn<int>(
    'away_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inningsMeta = const VerificationMeta(
    'innings',
  );
  @override
  late final GeneratedColumn<int> innings = GeneratedColumn<int>(
    'innings',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gameNumberMeta = const VerificationMeta(
    'gameNumber',
  );
  @override
  late final GeneratedColumn<int> gameNumber = GeneratedColumn<int>(
    'game_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    location,
    homeTeamName,
    awayTeamName,
    homeScore,
    awayScore,
    status,
    createdAt,
    innings,
    gameNumber,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_games';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalGame> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('home_team_name')) {
      context.handle(
        _homeTeamNameMeta,
        homeTeamName.isAcceptableOrUnknown(
          data['home_team_name']!,
          _homeTeamNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_homeTeamNameMeta);
    }
    if (data.containsKey('away_team_name')) {
      context.handle(
        _awayTeamNameMeta,
        awayTeamName.isAcceptableOrUnknown(
          data['away_team_name']!,
          _awayTeamNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_awayTeamNameMeta);
    }
    if (data.containsKey('home_score')) {
      context.handle(
        _homeScoreMeta,
        homeScore.isAcceptableOrUnknown(data['home_score']!, _homeScoreMeta),
      );
    }
    if (data.containsKey('away_score')) {
      context.handle(
        _awayScoreMeta,
        awayScore.isAcceptableOrUnknown(data['away_score']!, _awayScoreMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('innings')) {
      context.handle(
        _inningsMeta,
        innings.isAcceptableOrUnknown(data['innings']!, _inningsMeta),
      );
    }
    if (data.containsKey('game_number')) {
      context.handle(
        _gameNumberMeta,
        gameNumber.isAcceptableOrUnknown(data['game_number']!, _gameNumberMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalGame map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalGame(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      homeTeamName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}home_team_name'],
      )!,
      awayTeamName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}away_team_name'],
      )!,
      homeScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}home_score'],
      ),
      awayScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}away_score'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      innings: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}innings'],
      ),
      gameNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}game_number'],
      ),
    );
  }

  @override
  $LocalGamesTable createAlias(String alias) {
    return $LocalGamesTable(attachedDatabase, alias);
  }
}

class LocalGame extends DataClass implements Insertable<LocalGame> {
  final String id;
  final DateTime date;
  final String? location;
  final String homeTeamName;
  final String awayTeamName;
  final int? homeScore;
  final int? awayScore;
  final String status;
  final DateTime createdAt;
  final int? innings;
  final int? gameNumber;
  const LocalGame({
    required this.id,
    required this.date,
    this.location,
    required this.homeTeamName,
    required this.awayTeamName,
    this.homeScore,
    this.awayScore,
    required this.status,
    required this.createdAt,
    this.innings,
    this.gameNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['home_team_name'] = Variable<String>(homeTeamName);
    map['away_team_name'] = Variable<String>(awayTeamName);
    if (!nullToAbsent || homeScore != null) {
      map['home_score'] = Variable<int>(homeScore);
    }
    if (!nullToAbsent || awayScore != null) {
      map['away_score'] = Variable<int>(awayScore);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || innings != null) {
      map['innings'] = Variable<int>(innings);
    }
    if (!nullToAbsent || gameNumber != null) {
      map['game_number'] = Variable<int>(gameNumber);
    }
    return map;
  }

  LocalGamesCompanion toCompanion(bool nullToAbsent) {
    return LocalGamesCompanion(
      id: Value(id),
      date: Value(date),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      homeTeamName: Value(homeTeamName),
      awayTeamName: Value(awayTeamName),
      homeScore: homeScore == null && nullToAbsent
          ? const Value.absent()
          : Value(homeScore),
      awayScore: awayScore == null && nullToAbsent
          ? const Value.absent()
          : Value(awayScore),
      status: Value(status),
      createdAt: Value(createdAt),
      innings: innings == null && nullToAbsent
          ? const Value.absent()
          : Value(innings),
      gameNumber: gameNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(gameNumber),
    );
  }

  factory LocalGame.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalGame(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      location: serializer.fromJson<String?>(json['location']),
      homeTeamName: serializer.fromJson<String>(json['homeTeamName']),
      awayTeamName: serializer.fromJson<String>(json['awayTeamName']),
      homeScore: serializer.fromJson<int?>(json['homeScore']),
      awayScore: serializer.fromJson<int?>(json['awayScore']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      innings: serializer.fromJson<int?>(json['innings']),
      gameNumber: serializer.fromJson<int?>(json['gameNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'location': serializer.toJson<String?>(location),
      'homeTeamName': serializer.toJson<String>(homeTeamName),
      'awayTeamName': serializer.toJson<String>(awayTeamName),
      'homeScore': serializer.toJson<int?>(homeScore),
      'awayScore': serializer.toJson<int?>(awayScore),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'innings': serializer.toJson<int?>(innings),
      'gameNumber': serializer.toJson<int?>(gameNumber),
    };
  }

  LocalGame copyWith({
    String? id,
    DateTime? date,
    Value<String?> location = const Value.absent(),
    String? homeTeamName,
    String? awayTeamName,
    Value<int?> homeScore = const Value.absent(),
    Value<int?> awayScore = const Value.absent(),
    String? status,
    DateTime? createdAt,
    Value<int?> innings = const Value.absent(),
    Value<int?> gameNumber = const Value.absent(),
  }) => LocalGame(
    id: id ?? this.id,
    date: date ?? this.date,
    location: location.present ? location.value : this.location,
    homeTeamName: homeTeamName ?? this.homeTeamName,
    awayTeamName: awayTeamName ?? this.awayTeamName,
    homeScore: homeScore.present ? homeScore.value : this.homeScore,
    awayScore: awayScore.present ? awayScore.value : this.awayScore,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    innings: innings.present ? innings.value : this.innings,
    gameNumber: gameNumber.present ? gameNumber.value : this.gameNumber,
  );
  LocalGame copyWithCompanion(LocalGamesCompanion data) {
    return LocalGame(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      location: data.location.present ? data.location.value : this.location,
      homeTeamName: data.homeTeamName.present
          ? data.homeTeamName.value
          : this.homeTeamName,
      awayTeamName: data.awayTeamName.present
          ? data.awayTeamName.value
          : this.awayTeamName,
      homeScore: data.homeScore.present ? data.homeScore.value : this.homeScore,
      awayScore: data.awayScore.present ? data.awayScore.value : this.awayScore,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      innings: data.innings.present ? data.innings.value : this.innings,
      gameNumber: data.gameNumber.present
          ? data.gameNumber.value
          : this.gameNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalGame(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('location: $location, ')
          ..write('homeTeamName: $homeTeamName, ')
          ..write('awayTeamName: $awayTeamName, ')
          ..write('homeScore: $homeScore, ')
          ..write('awayScore: $awayScore, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('innings: $innings, ')
          ..write('gameNumber: $gameNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    location,
    homeTeamName,
    awayTeamName,
    homeScore,
    awayScore,
    status,
    createdAt,
    innings,
    gameNumber,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalGame &&
          other.id == this.id &&
          other.date == this.date &&
          other.location == this.location &&
          other.homeTeamName == this.homeTeamName &&
          other.awayTeamName == this.awayTeamName &&
          other.homeScore == this.homeScore &&
          other.awayScore == this.awayScore &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.innings == this.innings &&
          other.gameNumber == this.gameNumber);
}

class LocalGamesCompanion extends UpdateCompanion<LocalGame> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<String?> location;
  final Value<String> homeTeamName;
  final Value<String> awayTeamName;
  final Value<int?> homeScore;
  final Value<int?> awayScore;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int?> innings;
  final Value<int?> gameNumber;
  final Value<int> rowid;
  const LocalGamesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.location = const Value.absent(),
    this.homeTeamName = const Value.absent(),
    this.awayTeamName = const Value.absent(),
    this.homeScore = const Value.absent(),
    this.awayScore = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.innings = const Value.absent(),
    this.gameNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalGamesCompanion.insert({
    required String id,
    required DateTime date,
    this.location = const Value.absent(),
    required String homeTeamName,
    required String awayTeamName,
    this.homeScore = const Value.absent(),
    this.awayScore = const Value.absent(),
    required String status,
    required DateTime createdAt,
    this.innings = const Value.absent(),
    this.gameNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       homeTeamName = Value(homeTeamName),
       awayTeamName = Value(awayTeamName),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<LocalGame> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<String>? location,
    Expression<String>? homeTeamName,
    Expression<String>? awayTeamName,
    Expression<int>? homeScore,
    Expression<int>? awayScore,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? innings,
    Expression<int>? gameNumber,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (location != null) 'location': location,
      if (homeTeamName != null) 'home_team_name': homeTeamName,
      if (awayTeamName != null) 'away_team_name': awayTeamName,
      if (homeScore != null) 'home_score': homeScore,
      if (awayScore != null) 'away_score': awayScore,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (innings != null) 'innings': innings,
      if (gameNumber != null) 'game_number': gameNumber,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalGamesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? date,
    Value<String?>? location,
    Value<String>? homeTeamName,
    Value<String>? awayTeamName,
    Value<int?>? homeScore,
    Value<int?>? awayScore,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<int?>? innings,
    Value<int?>? gameNumber,
    Value<int>? rowid,
  }) {
    return LocalGamesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      location: location ?? this.location,
      homeTeamName: homeTeamName ?? this.homeTeamName,
      awayTeamName: awayTeamName ?? this.awayTeamName,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      innings: innings ?? this.innings,
      gameNumber: gameNumber ?? this.gameNumber,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (homeTeamName.present) {
      map['home_team_name'] = Variable<String>(homeTeamName.value);
    }
    if (awayTeamName.present) {
      map['away_team_name'] = Variable<String>(awayTeamName.value);
    }
    if (homeScore.present) {
      map['home_score'] = Variable<int>(homeScore.value);
    }
    if (awayScore.present) {
      map['away_score'] = Variable<int>(awayScore.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (innings.present) {
      map['innings'] = Variable<int>(innings.value);
    }
    if (gameNumber.present) {
      map['game_number'] = Variable<int>(gameNumber.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalGamesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('location: $location, ')
          ..write('homeTeamName: $homeTeamName, ')
          ..write('awayTeamName: $awayTeamName, ')
          ..write('homeScore: $homeScore, ')
          ..write('awayScore: $awayScore, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('innings: $innings, ')
          ..write('gameNumber: $gameNumber, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPlateAppearancesTable extends LocalPlateAppearances
    with TableInfo<$LocalPlateAppearancesTable, LocalPlateAppearance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPlateAppearancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES local_games (id)',
    ),
  );
  static const VerificationMeta _inningMeta = const VerificationMeta('inning');
  @override
  late final GeneratedColumn<int> inning = GeneratedColumn<int>(
    'inning',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resultTypeMeta = const VerificationMeta(
    'resultType',
  );
  @override
  late final GeneratedColumn<String> resultType = GeneratedColumn<String>(
    'result_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resultDetailMeta = const VerificationMeta(
    'resultDetail',
  );
  @override
  late final GeneratedColumn<String> resultDetail = GeneratedColumn<String>(
    'result_detail',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rbiMeta = const VerificationMeta('rbi');
  @override
  late final GeneratedColumn<int> rbi = GeneratedColumn<int>(
    'rbi',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    inning,
    resultType,
    resultDetail,
    rbi,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_plate_appearances';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPlateAppearance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('inning')) {
      context.handle(
        _inningMeta,
        inning.isAcceptableOrUnknown(data['inning']!, _inningMeta),
      );
    }
    if (data.containsKey('result_type')) {
      context.handle(
        _resultTypeMeta,
        resultType.isAcceptableOrUnknown(data['result_type']!, _resultTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_resultTypeMeta);
    }
    if (data.containsKey('result_detail')) {
      context.handle(
        _resultDetailMeta,
        resultDetail.isAcceptableOrUnknown(
          data['result_detail']!,
          _resultDetailMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_resultDetailMeta);
    }
    if (data.containsKey('rbi')) {
      context.handle(
        _rbiMeta,
        rbi.isAcceptableOrUnknown(data['rbi']!, _rbiMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPlateAppearance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPlateAppearance(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      inning: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}inning'],
      ),
      resultType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result_type'],
      )!,
      resultDetail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result_detail'],
      )!,
      rbi: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rbi'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LocalPlateAppearancesTable createAlias(String alias) {
    return $LocalPlateAppearancesTable(attachedDatabase, alias);
  }
}

class LocalPlateAppearance extends DataClass
    implements Insertable<LocalPlateAppearance> {
  final String id;
  final String gameId;
  final int? inning;
  final String resultType;
  final String resultDetail;
  final int? rbi;
  final DateTime createdAt;
  const LocalPlateAppearance({
    required this.id,
    required this.gameId,
    this.inning,
    required this.resultType,
    required this.resultDetail,
    this.rbi,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['game_id'] = Variable<String>(gameId);
    if (!nullToAbsent || inning != null) {
      map['inning'] = Variable<int>(inning);
    }
    map['result_type'] = Variable<String>(resultType);
    map['result_detail'] = Variable<String>(resultDetail);
    if (!nullToAbsent || rbi != null) {
      map['rbi'] = Variable<int>(rbi);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalPlateAppearancesCompanion toCompanion(bool nullToAbsent) {
    return LocalPlateAppearancesCompanion(
      id: Value(id),
      gameId: Value(gameId),
      inning: inning == null && nullToAbsent
          ? const Value.absent()
          : Value(inning),
      resultType: Value(resultType),
      resultDetail: Value(resultDetail),
      rbi: rbi == null && nullToAbsent ? const Value.absent() : Value(rbi),
      createdAt: Value(createdAt),
    );
  }

  factory LocalPlateAppearance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPlateAppearance(
      id: serializer.fromJson<String>(json['id']),
      gameId: serializer.fromJson<String>(json['gameId']),
      inning: serializer.fromJson<int?>(json['inning']),
      resultType: serializer.fromJson<String>(json['resultType']),
      resultDetail: serializer.fromJson<String>(json['resultDetail']),
      rbi: serializer.fromJson<int?>(json['rbi']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gameId': serializer.toJson<String>(gameId),
      'inning': serializer.toJson<int?>(inning),
      'resultType': serializer.toJson<String>(resultType),
      'resultDetail': serializer.toJson<String>(resultDetail),
      'rbi': serializer.toJson<int?>(rbi),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalPlateAppearance copyWith({
    String? id,
    String? gameId,
    Value<int?> inning = const Value.absent(),
    String? resultType,
    String? resultDetail,
    Value<int?> rbi = const Value.absent(),
    DateTime? createdAt,
  }) => LocalPlateAppearance(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    inning: inning.present ? inning.value : this.inning,
    resultType: resultType ?? this.resultType,
    resultDetail: resultDetail ?? this.resultDetail,
    rbi: rbi.present ? rbi.value : this.rbi,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalPlateAppearance copyWithCompanion(LocalPlateAppearancesCompanion data) {
    return LocalPlateAppearance(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      inning: data.inning.present ? data.inning.value : this.inning,
      resultType: data.resultType.present
          ? data.resultType.value
          : this.resultType,
      resultDetail: data.resultDetail.present
          ? data.resultDetail.value
          : this.resultDetail,
      rbi: data.rbi.present ? data.rbi.value : this.rbi,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPlateAppearance(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('inning: $inning, ')
          ..write('resultType: $resultType, ')
          ..write('resultDetail: $resultDetail, ')
          ..write('rbi: $rbi, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, gameId, inning, resultType, resultDetail, rbi, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPlateAppearance &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.inning == this.inning &&
          other.resultType == this.resultType &&
          other.resultDetail == this.resultDetail &&
          other.rbi == this.rbi &&
          other.createdAt == this.createdAt);
}

class LocalPlateAppearancesCompanion
    extends UpdateCompanion<LocalPlateAppearance> {
  final Value<String> id;
  final Value<String> gameId;
  final Value<int?> inning;
  final Value<String> resultType;
  final Value<String> resultDetail;
  final Value<int?> rbi;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocalPlateAppearancesCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.inning = const Value.absent(),
    this.resultType = const Value.absent(),
    this.resultDetail = const Value.absent(),
    this.rbi = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPlateAppearancesCompanion.insert({
    required String id,
    required String gameId,
    this.inning = const Value.absent(),
    required String resultType,
    required String resultDetail,
    this.rbi = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       gameId = Value(gameId),
       resultType = Value(resultType),
       resultDetail = Value(resultDetail),
       createdAt = Value(createdAt);
  static Insertable<LocalPlateAppearance> custom({
    Expression<String>? id,
    Expression<String>? gameId,
    Expression<int>? inning,
    Expression<String>? resultType,
    Expression<String>? resultDetail,
    Expression<int>? rbi,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (inning != null) 'inning': inning,
      if (resultType != null) 'result_type': resultType,
      if (resultDetail != null) 'result_detail': resultDetail,
      if (rbi != null) 'rbi': rbi,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPlateAppearancesCompanion copyWith({
    Value<String>? id,
    Value<String>? gameId,
    Value<int?>? inning,
    Value<String>? resultType,
    Value<String>? resultDetail,
    Value<int?>? rbi,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalPlateAppearancesCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      inning: inning ?? this.inning,
      resultType: resultType ?? this.resultType,
      resultDetail: resultDetail ?? this.resultDetail,
      rbi: rbi ?? this.rbi,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (inning.present) {
      map['inning'] = Variable<int>(inning.value);
    }
    if (resultType.present) {
      map['result_type'] = Variable<String>(resultType.value);
    }
    if (resultDetail.present) {
      map['result_detail'] = Variable<String>(resultDetail.value);
    }
    if (rbi.present) {
      map['rbi'] = Variable<int>(rbi.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPlateAppearancesCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('inning: $inning, ')
          ..write('resultType: $resultType, ')
          ..write('resultDetail: $resultDetail, ')
          ..write('rbi: $rbi, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPitchingAppearancesTable extends LocalPitchingAppearances
    with TableInfo<$LocalPitchingAppearancesTable, LocalPitchingAppearance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPitchingAppearancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES local_games (id)',
    ),
  );
  static const VerificationMeta _outsPitchedMeta = const VerificationMeta(
    'outsPitched',
  );
  @override
  late final GeneratedColumn<int> outsPitched = GeneratedColumn<int>(
    'outs_pitched',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _runsMeta = const VerificationMeta('runs');
  @override
  late final GeneratedColumn<int> runs = GeneratedColumn<int>(
    'runs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _earnedRunsMeta = const VerificationMeta(
    'earnedRuns',
  );
  @override
  late final GeneratedColumn<int> earnedRuns = GeneratedColumn<int>(
    'earned_runs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hitsAllowedMeta = const VerificationMeta(
    'hitsAllowed',
  );
  @override
  late final GeneratedColumn<int> hitsAllowed = GeneratedColumn<int>(
    'hits_allowed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _walksMeta = const VerificationMeta('walks');
  @override
  late final GeneratedColumn<int> walks = GeneratedColumn<int>(
    'walks',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _strikeoutsMeta = const VerificationMeta(
    'strikeouts',
  );
  @override
  late final GeneratedColumn<int> strikeouts = GeneratedColumn<int>(
    'strikeouts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _homeRunsAllowedMeta = const VerificationMeta(
    'homeRunsAllowed',
  );
  @override
  late final GeneratedColumn<int> homeRunsAllowed = GeneratedColumn<int>(
    'home_runs_allowed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    outsPitched,
    runs,
    earnedRuns,
    hitsAllowed,
    walks,
    strikeouts,
    homeRunsAllowed,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_pitching_appearances';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPitchingAppearance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('outs_pitched')) {
      context.handle(
        _outsPitchedMeta,
        outsPitched.isAcceptableOrUnknown(
          data['outs_pitched']!,
          _outsPitchedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_outsPitchedMeta);
    }
    if (data.containsKey('runs')) {
      context.handle(
        _runsMeta,
        runs.isAcceptableOrUnknown(data['runs']!, _runsMeta),
      );
    } else if (isInserting) {
      context.missing(_runsMeta);
    }
    if (data.containsKey('earned_runs')) {
      context.handle(
        _earnedRunsMeta,
        earnedRuns.isAcceptableOrUnknown(data['earned_runs']!, _earnedRunsMeta),
      );
    } else if (isInserting) {
      context.missing(_earnedRunsMeta);
    }
    if (data.containsKey('hits_allowed')) {
      context.handle(
        _hitsAllowedMeta,
        hitsAllowed.isAcceptableOrUnknown(
          data['hits_allowed']!,
          _hitsAllowedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hitsAllowedMeta);
    }
    if (data.containsKey('walks')) {
      context.handle(
        _walksMeta,
        walks.isAcceptableOrUnknown(data['walks']!, _walksMeta),
      );
    } else if (isInserting) {
      context.missing(_walksMeta);
    }
    if (data.containsKey('strikeouts')) {
      context.handle(
        _strikeoutsMeta,
        strikeouts.isAcceptableOrUnknown(data['strikeouts']!, _strikeoutsMeta),
      );
    } else if (isInserting) {
      context.missing(_strikeoutsMeta);
    }
    if (data.containsKey('home_runs_allowed')) {
      context.handle(
        _homeRunsAllowedMeta,
        homeRunsAllowed.isAcceptableOrUnknown(
          data['home_runs_allowed']!,
          _homeRunsAllowedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_homeRunsAllowedMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPitchingAppearance map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPitchingAppearance(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      outsPitched: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}outs_pitched'],
      )!,
      runs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}runs'],
      )!,
      earnedRuns: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}earned_runs'],
      )!,
      hitsAllowed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hits_allowed'],
      )!,
      walks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}walks'],
      )!,
      strikeouts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}strikeouts'],
      )!,
      homeRunsAllowed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}home_runs_allowed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LocalPitchingAppearancesTable createAlias(String alias) {
    return $LocalPitchingAppearancesTable(attachedDatabase, alias);
  }
}

class LocalPitchingAppearance extends DataClass
    implements Insertable<LocalPitchingAppearance> {
  final String id;
  final String gameId;
  final int outsPitched;
  final int runs;
  final int earnedRuns;
  final int hitsAllowed;
  final int walks;
  final int strikeouts;
  final int homeRunsAllowed;
  final DateTime createdAt;
  const LocalPitchingAppearance({
    required this.id,
    required this.gameId,
    required this.outsPitched,
    required this.runs,
    required this.earnedRuns,
    required this.hitsAllowed,
    required this.walks,
    required this.strikeouts,
    required this.homeRunsAllowed,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['game_id'] = Variable<String>(gameId);
    map['outs_pitched'] = Variable<int>(outsPitched);
    map['runs'] = Variable<int>(runs);
    map['earned_runs'] = Variable<int>(earnedRuns);
    map['hits_allowed'] = Variable<int>(hitsAllowed);
    map['walks'] = Variable<int>(walks);
    map['strikeouts'] = Variable<int>(strikeouts);
    map['home_runs_allowed'] = Variable<int>(homeRunsAllowed);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalPitchingAppearancesCompanion toCompanion(bool nullToAbsent) {
    return LocalPitchingAppearancesCompanion(
      id: Value(id),
      gameId: Value(gameId),
      outsPitched: Value(outsPitched),
      runs: Value(runs),
      earnedRuns: Value(earnedRuns),
      hitsAllowed: Value(hitsAllowed),
      walks: Value(walks),
      strikeouts: Value(strikeouts),
      homeRunsAllowed: Value(homeRunsAllowed),
      createdAt: Value(createdAt),
    );
  }

  factory LocalPitchingAppearance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPitchingAppearance(
      id: serializer.fromJson<String>(json['id']),
      gameId: serializer.fromJson<String>(json['gameId']),
      outsPitched: serializer.fromJson<int>(json['outsPitched']),
      runs: serializer.fromJson<int>(json['runs']),
      earnedRuns: serializer.fromJson<int>(json['earnedRuns']),
      hitsAllowed: serializer.fromJson<int>(json['hitsAllowed']),
      walks: serializer.fromJson<int>(json['walks']),
      strikeouts: serializer.fromJson<int>(json['strikeouts']),
      homeRunsAllowed: serializer.fromJson<int>(json['homeRunsAllowed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gameId': serializer.toJson<String>(gameId),
      'outsPitched': serializer.toJson<int>(outsPitched),
      'runs': serializer.toJson<int>(runs),
      'earnedRuns': serializer.toJson<int>(earnedRuns),
      'hitsAllowed': serializer.toJson<int>(hitsAllowed),
      'walks': serializer.toJson<int>(walks),
      'strikeouts': serializer.toJson<int>(strikeouts),
      'homeRunsAllowed': serializer.toJson<int>(homeRunsAllowed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalPitchingAppearance copyWith({
    String? id,
    String? gameId,
    int? outsPitched,
    int? runs,
    int? earnedRuns,
    int? hitsAllowed,
    int? walks,
    int? strikeouts,
    int? homeRunsAllowed,
    DateTime? createdAt,
  }) => LocalPitchingAppearance(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    outsPitched: outsPitched ?? this.outsPitched,
    runs: runs ?? this.runs,
    earnedRuns: earnedRuns ?? this.earnedRuns,
    hitsAllowed: hitsAllowed ?? this.hitsAllowed,
    walks: walks ?? this.walks,
    strikeouts: strikeouts ?? this.strikeouts,
    homeRunsAllowed: homeRunsAllowed ?? this.homeRunsAllowed,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalPitchingAppearance copyWithCompanion(
    LocalPitchingAppearancesCompanion data,
  ) {
    return LocalPitchingAppearance(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      outsPitched: data.outsPitched.present
          ? data.outsPitched.value
          : this.outsPitched,
      runs: data.runs.present ? data.runs.value : this.runs,
      earnedRuns: data.earnedRuns.present
          ? data.earnedRuns.value
          : this.earnedRuns,
      hitsAllowed: data.hitsAllowed.present
          ? data.hitsAllowed.value
          : this.hitsAllowed,
      walks: data.walks.present ? data.walks.value : this.walks,
      strikeouts: data.strikeouts.present
          ? data.strikeouts.value
          : this.strikeouts,
      homeRunsAllowed: data.homeRunsAllowed.present
          ? data.homeRunsAllowed.value
          : this.homeRunsAllowed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPitchingAppearance(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('outsPitched: $outsPitched, ')
          ..write('runs: $runs, ')
          ..write('earnedRuns: $earnedRuns, ')
          ..write('hitsAllowed: $hitsAllowed, ')
          ..write('walks: $walks, ')
          ..write('strikeouts: $strikeouts, ')
          ..write('homeRunsAllowed: $homeRunsAllowed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gameId,
    outsPitched,
    runs,
    earnedRuns,
    hitsAllowed,
    walks,
    strikeouts,
    homeRunsAllowed,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPitchingAppearance &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.outsPitched == this.outsPitched &&
          other.runs == this.runs &&
          other.earnedRuns == this.earnedRuns &&
          other.hitsAllowed == this.hitsAllowed &&
          other.walks == this.walks &&
          other.strikeouts == this.strikeouts &&
          other.homeRunsAllowed == this.homeRunsAllowed &&
          other.createdAt == this.createdAt);
}

class LocalPitchingAppearancesCompanion
    extends UpdateCompanion<LocalPitchingAppearance> {
  final Value<String> id;
  final Value<String> gameId;
  final Value<int> outsPitched;
  final Value<int> runs;
  final Value<int> earnedRuns;
  final Value<int> hitsAllowed;
  final Value<int> walks;
  final Value<int> strikeouts;
  final Value<int> homeRunsAllowed;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocalPitchingAppearancesCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.outsPitched = const Value.absent(),
    this.runs = const Value.absent(),
    this.earnedRuns = const Value.absent(),
    this.hitsAllowed = const Value.absent(),
    this.walks = const Value.absent(),
    this.strikeouts = const Value.absent(),
    this.homeRunsAllowed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPitchingAppearancesCompanion.insert({
    required String id,
    required String gameId,
    required int outsPitched,
    required int runs,
    required int earnedRuns,
    required int hitsAllowed,
    required int walks,
    required int strikeouts,
    required int homeRunsAllowed,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       gameId = Value(gameId),
       outsPitched = Value(outsPitched),
       runs = Value(runs),
       earnedRuns = Value(earnedRuns),
       hitsAllowed = Value(hitsAllowed),
       walks = Value(walks),
       strikeouts = Value(strikeouts),
       homeRunsAllowed = Value(homeRunsAllowed),
       createdAt = Value(createdAt);
  static Insertable<LocalPitchingAppearance> custom({
    Expression<String>? id,
    Expression<String>? gameId,
    Expression<int>? outsPitched,
    Expression<int>? runs,
    Expression<int>? earnedRuns,
    Expression<int>? hitsAllowed,
    Expression<int>? walks,
    Expression<int>? strikeouts,
    Expression<int>? homeRunsAllowed,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (outsPitched != null) 'outs_pitched': outsPitched,
      if (runs != null) 'runs': runs,
      if (earnedRuns != null) 'earned_runs': earnedRuns,
      if (hitsAllowed != null) 'hits_allowed': hitsAllowed,
      if (walks != null) 'walks': walks,
      if (strikeouts != null) 'strikeouts': strikeouts,
      if (homeRunsAllowed != null) 'home_runs_allowed': homeRunsAllowed,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPitchingAppearancesCompanion copyWith({
    Value<String>? id,
    Value<String>? gameId,
    Value<int>? outsPitched,
    Value<int>? runs,
    Value<int>? earnedRuns,
    Value<int>? hitsAllowed,
    Value<int>? walks,
    Value<int>? strikeouts,
    Value<int>? homeRunsAllowed,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalPitchingAppearancesCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      outsPitched: outsPitched ?? this.outsPitched,
      runs: runs ?? this.runs,
      earnedRuns: earnedRuns ?? this.earnedRuns,
      hitsAllowed: hitsAllowed ?? this.hitsAllowed,
      walks: walks ?? this.walks,
      strikeouts: strikeouts ?? this.strikeouts,
      homeRunsAllowed: homeRunsAllowed ?? this.homeRunsAllowed,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (outsPitched.present) {
      map['outs_pitched'] = Variable<int>(outsPitched.value);
    }
    if (runs.present) {
      map['runs'] = Variable<int>(runs.value);
    }
    if (earnedRuns.present) {
      map['earned_runs'] = Variable<int>(earnedRuns.value);
    }
    if (hitsAllowed.present) {
      map['hits_allowed'] = Variable<int>(hitsAllowed.value);
    }
    if (walks.present) {
      map['walks'] = Variable<int>(walks.value);
    }
    if (strikeouts.present) {
      map['strikeouts'] = Variable<int>(strikeouts.value);
    }
    if (homeRunsAllowed.present) {
      map['home_runs_allowed'] = Variable<int>(homeRunsAllowed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPitchingAppearancesCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('outsPitched: $outsPitched, ')
          ..write('runs: $runs, ')
          ..write('earnedRuns: $earnedRuns, ')
          ..write('hitsAllowed: $hitsAllowed, ')
          ..write('walks: $walks, ')
          ..write('strikeouts: $strikeouts, ')
          ..write('homeRunsAllowed: $homeRunsAllowed, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $LocalGamesTable localGames = $LocalGamesTable(this);
  late final $LocalPlateAppearancesTable localPlateAppearances =
      $LocalPlateAppearancesTable(this);
  late final $LocalPitchingAppearancesTable localPitchingAppearances =
      $LocalPitchingAppearancesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localGames,
    localPlateAppearances,
    localPitchingAppearances,
  ];
}

typedef $$LocalGamesTableCreateCompanionBuilder =
    LocalGamesCompanion Function({
      required String id,
      required DateTime date,
      Value<String?> location,
      required String homeTeamName,
      required String awayTeamName,
      Value<int?> homeScore,
      Value<int?> awayScore,
      required String status,
      required DateTime createdAt,
      Value<int?> innings,
      Value<int?> gameNumber,
      Value<int> rowid,
    });
typedef $$LocalGamesTableUpdateCompanionBuilder =
    LocalGamesCompanion Function({
      Value<String> id,
      Value<DateTime> date,
      Value<String?> location,
      Value<String> homeTeamName,
      Value<String> awayTeamName,
      Value<int?> homeScore,
      Value<int?> awayScore,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<int?> innings,
      Value<int?> gameNumber,
      Value<int> rowid,
    });

final class $$LocalGamesTableReferences
    extends BaseReferences<_$LocalDatabase, $LocalGamesTable, LocalGame> {
  $$LocalGamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $LocalPlateAppearancesTable,
    List<LocalPlateAppearance>
  >
  _localPlateAppearancesRefsTable(_$LocalDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.localPlateAppearances,
        aliasName: $_aliasNameGenerator(
          db.localGames.id,
          db.localPlateAppearances.gameId,
        ),
      );

  $$LocalPlateAppearancesTableProcessedTableManager
  get localPlateAppearancesRefs {
    final manager = $$LocalPlateAppearancesTableTableManager(
      $_db,
      $_db.localPlateAppearances,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _localPlateAppearancesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $LocalPitchingAppearancesTable,
    List<LocalPitchingAppearance>
  >
  _localPitchingAppearancesRefsTable(_$LocalDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.localPitchingAppearances,
        aliasName: $_aliasNameGenerator(
          db.localGames.id,
          db.localPitchingAppearances.gameId,
        ),
      );

  $$LocalPitchingAppearancesTableProcessedTableManager
  get localPitchingAppearancesRefs {
    final manager = $$LocalPitchingAppearancesTableTableManager(
      $_db,
      $_db.localPitchingAppearances,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _localPitchingAppearancesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LocalGamesTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalGamesTable> {
  $$LocalGamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get homeTeamName => $composableBuilder(
    column: $table.homeTeamName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get awayTeamName => $composableBuilder(
    column: $table.awayTeamName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get homeScore => $composableBuilder(
    column: $table.homeScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get awayScore => $composableBuilder(
    column: $table.awayScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get innings => $composableBuilder(
    column: $table.innings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gameNumber => $composableBuilder(
    column: $table.gameNumber,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> localPlateAppearancesRefs(
    Expression<bool> Function($$LocalPlateAppearancesTableFilterComposer f) f,
  ) {
    final $$LocalPlateAppearancesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.localPlateAppearances,
          getReferencedColumn: (t) => t.gameId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LocalPlateAppearancesTableFilterComposer(
                $db: $db,
                $table: $db.localPlateAppearances,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> localPitchingAppearancesRefs(
    Expression<bool> Function($$LocalPitchingAppearancesTableFilterComposer f)
    f,
  ) {
    final $$LocalPitchingAppearancesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.localPitchingAppearances,
          getReferencedColumn: (t) => t.gameId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LocalPitchingAppearancesTableFilterComposer(
                $db: $db,
                $table: $db.localPitchingAppearances,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LocalGamesTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalGamesTable> {
  $$LocalGamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get homeTeamName => $composableBuilder(
    column: $table.homeTeamName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get awayTeamName => $composableBuilder(
    column: $table.awayTeamName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get homeScore => $composableBuilder(
    column: $table.homeScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get awayScore => $composableBuilder(
    column: $table.awayScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get innings => $composableBuilder(
    column: $table.innings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gameNumber => $composableBuilder(
    column: $table.gameNumber,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalGamesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalGamesTable> {
  $$LocalGamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get homeTeamName => $composableBuilder(
    column: $table.homeTeamName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get awayTeamName => $composableBuilder(
    column: $table.awayTeamName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get homeScore =>
      $composableBuilder(column: $table.homeScore, builder: (column) => column);

  GeneratedColumn<int> get awayScore =>
      $composableBuilder(column: $table.awayScore, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get innings =>
      $composableBuilder(column: $table.innings, builder: (column) => column);

  GeneratedColumn<int> get gameNumber => $composableBuilder(
    column: $table.gameNumber,
    builder: (column) => column,
  );

  Expression<T> localPlateAppearancesRefs<T extends Object>(
    Expression<T> Function($$LocalPlateAppearancesTableAnnotationComposer a) f,
  ) {
    final $$LocalPlateAppearancesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.localPlateAppearances,
          getReferencedColumn: (t) => t.gameId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LocalPlateAppearancesTableAnnotationComposer(
                $db: $db,
                $table: $db.localPlateAppearances,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> localPitchingAppearancesRefs<T extends Object>(
    Expression<T> Function($$LocalPitchingAppearancesTableAnnotationComposer a)
    f,
  ) {
    final $$LocalPitchingAppearancesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.localPitchingAppearances,
          getReferencedColumn: (t) => t.gameId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LocalPitchingAppearancesTableAnnotationComposer(
                $db: $db,
                $table: $db.localPitchingAppearances,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LocalGamesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalGamesTable,
          LocalGame,
          $$LocalGamesTableFilterComposer,
          $$LocalGamesTableOrderingComposer,
          $$LocalGamesTableAnnotationComposer,
          $$LocalGamesTableCreateCompanionBuilder,
          $$LocalGamesTableUpdateCompanionBuilder,
          (LocalGame, $$LocalGamesTableReferences),
          LocalGame,
          PrefetchHooks Function({
            bool localPlateAppearancesRefs,
            bool localPitchingAppearancesRefs,
          })
        > {
  $$LocalGamesTableTableManager(_$LocalDatabase db, $LocalGamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalGamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalGamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalGamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String> homeTeamName = const Value.absent(),
                Value<String> awayTeamName = const Value.absent(),
                Value<int?> homeScore = const Value.absent(),
                Value<int?> awayScore = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> innings = const Value.absent(),
                Value<int?> gameNumber = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalGamesCompanion(
                id: id,
                date: date,
                location: location,
                homeTeamName: homeTeamName,
                awayTeamName: awayTeamName,
                homeScore: homeScore,
                awayScore: awayScore,
                status: status,
                createdAt: createdAt,
                innings: innings,
                gameNumber: gameNumber,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime date,
                Value<String?> location = const Value.absent(),
                required String homeTeamName,
                required String awayTeamName,
                Value<int?> homeScore = const Value.absent(),
                Value<int?> awayScore = const Value.absent(),
                required String status,
                required DateTime createdAt,
                Value<int?> innings = const Value.absent(),
                Value<int?> gameNumber = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalGamesCompanion.insert(
                id: id,
                date: date,
                location: location,
                homeTeamName: homeTeamName,
                awayTeamName: awayTeamName,
                homeScore: homeScore,
                awayScore: awayScore,
                status: status,
                createdAt: createdAt,
                innings: innings,
                gameNumber: gameNumber,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LocalGamesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                localPlateAppearancesRefs = false,
                localPitchingAppearancesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (localPlateAppearancesRefs) db.localPlateAppearances,
                    if (localPitchingAppearancesRefs)
                      db.localPitchingAppearances,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (localPlateAppearancesRefs)
                        await $_getPrefetchedData<
                          LocalGame,
                          $LocalGamesTable,
                          LocalPlateAppearance
                        >(
                          currentTable: table,
                          referencedTable: $$LocalGamesTableReferences
                              ._localPlateAppearancesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocalGamesTableReferences(
                                db,
                                table,
                                p0,
                              ).localPlateAppearancesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (localPitchingAppearancesRefs)
                        await $_getPrefetchedData<
                          LocalGame,
                          $LocalGamesTable,
                          LocalPitchingAppearance
                        >(
                          currentTable: table,
                          referencedTable: $$LocalGamesTableReferences
                              ._localPitchingAppearancesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocalGamesTableReferences(
                                db,
                                table,
                                p0,
                              ).localPitchingAppearancesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LocalGamesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalGamesTable,
      LocalGame,
      $$LocalGamesTableFilterComposer,
      $$LocalGamesTableOrderingComposer,
      $$LocalGamesTableAnnotationComposer,
      $$LocalGamesTableCreateCompanionBuilder,
      $$LocalGamesTableUpdateCompanionBuilder,
      (LocalGame, $$LocalGamesTableReferences),
      LocalGame,
      PrefetchHooks Function({
        bool localPlateAppearancesRefs,
        bool localPitchingAppearancesRefs,
      })
    >;
typedef $$LocalPlateAppearancesTableCreateCompanionBuilder =
    LocalPlateAppearancesCompanion Function({
      required String id,
      required String gameId,
      Value<int?> inning,
      required String resultType,
      required String resultDetail,
      Value<int?> rbi,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$LocalPlateAppearancesTableUpdateCompanionBuilder =
    LocalPlateAppearancesCompanion Function({
      Value<String> id,
      Value<String> gameId,
      Value<int?> inning,
      Value<String> resultType,
      Value<String> resultDetail,
      Value<int?> rbi,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$LocalPlateAppearancesTableReferences
    extends
        BaseReferences<
          _$LocalDatabase,
          $LocalPlateAppearancesTable,
          LocalPlateAppearance
        > {
  $$LocalPlateAppearancesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LocalGamesTable _gameIdTable(_$LocalDatabase db) =>
      db.localGames.createAlias(
        $_aliasNameGenerator(db.localPlateAppearances.gameId, db.localGames.id),
      );

  $$LocalGamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<String>('game_id')!;

    final manager = $$LocalGamesTableTableManager(
      $_db,
      $_db.localGames,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LocalPlateAppearancesTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalPlateAppearancesTable> {
  $$LocalPlateAppearancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get inning => $composableBuilder(
    column: $table.inning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultType => $composableBuilder(
    column: $table.resultType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultDetail => $composableBuilder(
    column: $table.resultDetail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rbi => $composableBuilder(
    column: $table.rbi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LocalGamesTableFilterComposer get gameId {
    final $$LocalGamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.localGames,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalGamesTableFilterComposer(
            $db: $db,
            $table: $db.localGames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalPlateAppearancesTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalPlateAppearancesTable> {
  $$LocalPlateAppearancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get inning => $composableBuilder(
    column: $table.inning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultType => $composableBuilder(
    column: $table.resultType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultDetail => $composableBuilder(
    column: $table.resultDetail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rbi => $composableBuilder(
    column: $table.rbi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocalGamesTableOrderingComposer get gameId {
    final $$LocalGamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.localGames,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalGamesTableOrderingComposer(
            $db: $db,
            $table: $db.localGames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalPlateAppearancesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalPlateAppearancesTable> {
  $$LocalPlateAppearancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get inning =>
      $composableBuilder(column: $table.inning, builder: (column) => column);

  GeneratedColumn<String> get resultType => $composableBuilder(
    column: $table.resultType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resultDetail => $composableBuilder(
    column: $table.resultDetail,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rbi =>
      $composableBuilder(column: $table.rbi, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$LocalGamesTableAnnotationComposer get gameId {
    final $$LocalGamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.localGames,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalGamesTableAnnotationComposer(
            $db: $db,
            $table: $db.localGames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalPlateAppearancesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalPlateAppearancesTable,
          LocalPlateAppearance,
          $$LocalPlateAppearancesTableFilterComposer,
          $$LocalPlateAppearancesTableOrderingComposer,
          $$LocalPlateAppearancesTableAnnotationComposer,
          $$LocalPlateAppearancesTableCreateCompanionBuilder,
          $$LocalPlateAppearancesTableUpdateCompanionBuilder,
          (LocalPlateAppearance, $$LocalPlateAppearancesTableReferences),
          LocalPlateAppearance,
          PrefetchHooks Function({bool gameId})
        > {
  $$LocalPlateAppearancesTableTableManager(
    _$LocalDatabase db,
    $LocalPlateAppearancesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPlateAppearancesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalPlateAppearancesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalPlateAppearancesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> gameId = const Value.absent(),
                Value<int?> inning = const Value.absent(),
                Value<String> resultType = const Value.absent(),
                Value<String> resultDetail = const Value.absent(),
                Value<int?> rbi = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPlateAppearancesCompanion(
                id: id,
                gameId: gameId,
                inning: inning,
                resultType: resultType,
                resultDetail: resultDetail,
                rbi: rbi,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String gameId,
                Value<int?> inning = const Value.absent(),
                required String resultType,
                required String resultDetail,
                Value<int?> rbi = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalPlateAppearancesCompanion.insert(
                id: id,
                gameId: gameId,
                inning: inning,
                resultType: resultType,
                resultDetail: resultDetail,
                rbi: rbi,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LocalPlateAppearancesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gameId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable:
                                    $$LocalPlateAppearancesTableReferences
                                        ._gameIdTable(db),
                                referencedColumn:
                                    $$LocalPlateAppearancesTableReferences
                                        ._gameIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LocalPlateAppearancesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalPlateAppearancesTable,
      LocalPlateAppearance,
      $$LocalPlateAppearancesTableFilterComposer,
      $$LocalPlateAppearancesTableOrderingComposer,
      $$LocalPlateAppearancesTableAnnotationComposer,
      $$LocalPlateAppearancesTableCreateCompanionBuilder,
      $$LocalPlateAppearancesTableUpdateCompanionBuilder,
      (LocalPlateAppearance, $$LocalPlateAppearancesTableReferences),
      LocalPlateAppearance,
      PrefetchHooks Function({bool gameId})
    >;
typedef $$LocalPitchingAppearancesTableCreateCompanionBuilder =
    LocalPitchingAppearancesCompanion Function({
      required String id,
      required String gameId,
      required int outsPitched,
      required int runs,
      required int earnedRuns,
      required int hitsAllowed,
      required int walks,
      required int strikeouts,
      required int homeRunsAllowed,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$LocalPitchingAppearancesTableUpdateCompanionBuilder =
    LocalPitchingAppearancesCompanion Function({
      Value<String> id,
      Value<String> gameId,
      Value<int> outsPitched,
      Value<int> runs,
      Value<int> earnedRuns,
      Value<int> hitsAllowed,
      Value<int> walks,
      Value<int> strikeouts,
      Value<int> homeRunsAllowed,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$LocalPitchingAppearancesTableReferences
    extends
        BaseReferences<
          _$LocalDatabase,
          $LocalPitchingAppearancesTable,
          LocalPitchingAppearance
        > {
  $$LocalPitchingAppearancesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LocalGamesTable _gameIdTable(_$LocalDatabase db) =>
      db.localGames.createAlias(
        $_aliasNameGenerator(
          db.localPitchingAppearances.gameId,
          db.localGames.id,
        ),
      );

  $$LocalGamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<String>('game_id')!;

    final manager = $$LocalGamesTableTableManager(
      $_db,
      $_db.localGames,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LocalPitchingAppearancesTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalPitchingAppearancesTable> {
  $$LocalPitchingAppearancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get outsPitched => $composableBuilder(
    column: $table.outsPitched,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get runs => $composableBuilder(
    column: $table.runs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get earnedRuns => $composableBuilder(
    column: $table.earnedRuns,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hitsAllowed => $composableBuilder(
    column: $table.hitsAllowed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walks => $composableBuilder(
    column: $table.walks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get strikeouts => $composableBuilder(
    column: $table.strikeouts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get homeRunsAllowed => $composableBuilder(
    column: $table.homeRunsAllowed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LocalGamesTableFilterComposer get gameId {
    final $$LocalGamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.localGames,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalGamesTableFilterComposer(
            $db: $db,
            $table: $db.localGames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalPitchingAppearancesTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalPitchingAppearancesTable> {
  $$LocalPitchingAppearancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get outsPitched => $composableBuilder(
    column: $table.outsPitched,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get runs => $composableBuilder(
    column: $table.runs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get earnedRuns => $composableBuilder(
    column: $table.earnedRuns,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hitsAllowed => $composableBuilder(
    column: $table.hitsAllowed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walks => $composableBuilder(
    column: $table.walks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get strikeouts => $composableBuilder(
    column: $table.strikeouts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get homeRunsAllowed => $composableBuilder(
    column: $table.homeRunsAllowed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocalGamesTableOrderingComposer get gameId {
    final $$LocalGamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.localGames,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalGamesTableOrderingComposer(
            $db: $db,
            $table: $db.localGames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalPitchingAppearancesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalPitchingAppearancesTable> {
  $$LocalPitchingAppearancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get outsPitched => $composableBuilder(
    column: $table.outsPitched,
    builder: (column) => column,
  );

  GeneratedColumn<int> get runs =>
      $composableBuilder(column: $table.runs, builder: (column) => column);

  GeneratedColumn<int> get earnedRuns => $composableBuilder(
    column: $table.earnedRuns,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hitsAllowed => $composableBuilder(
    column: $table.hitsAllowed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get walks =>
      $composableBuilder(column: $table.walks, builder: (column) => column);

  GeneratedColumn<int> get strikeouts => $composableBuilder(
    column: $table.strikeouts,
    builder: (column) => column,
  );

  GeneratedColumn<int> get homeRunsAllowed => $composableBuilder(
    column: $table.homeRunsAllowed,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$LocalGamesTableAnnotationComposer get gameId {
    final $$LocalGamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.localGames,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocalGamesTableAnnotationComposer(
            $db: $db,
            $table: $db.localGames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocalPitchingAppearancesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $LocalPitchingAppearancesTable,
          LocalPitchingAppearance,
          $$LocalPitchingAppearancesTableFilterComposer,
          $$LocalPitchingAppearancesTableOrderingComposer,
          $$LocalPitchingAppearancesTableAnnotationComposer,
          $$LocalPitchingAppearancesTableCreateCompanionBuilder,
          $$LocalPitchingAppearancesTableUpdateCompanionBuilder,
          (LocalPitchingAppearance, $$LocalPitchingAppearancesTableReferences),
          LocalPitchingAppearance,
          PrefetchHooks Function({bool gameId})
        > {
  $$LocalPitchingAppearancesTableTableManager(
    _$LocalDatabase db,
    $LocalPitchingAppearancesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPitchingAppearancesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalPitchingAppearancesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalPitchingAppearancesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> gameId = const Value.absent(),
                Value<int> outsPitched = const Value.absent(),
                Value<int> runs = const Value.absent(),
                Value<int> earnedRuns = const Value.absent(),
                Value<int> hitsAllowed = const Value.absent(),
                Value<int> walks = const Value.absent(),
                Value<int> strikeouts = const Value.absent(),
                Value<int> homeRunsAllowed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPitchingAppearancesCompanion(
                id: id,
                gameId: gameId,
                outsPitched: outsPitched,
                runs: runs,
                earnedRuns: earnedRuns,
                hitsAllowed: hitsAllowed,
                walks: walks,
                strikeouts: strikeouts,
                homeRunsAllowed: homeRunsAllowed,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String gameId,
                required int outsPitched,
                required int runs,
                required int earnedRuns,
                required int hitsAllowed,
                required int walks,
                required int strikeouts,
                required int homeRunsAllowed,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalPitchingAppearancesCompanion.insert(
                id: id,
                gameId: gameId,
                outsPitched: outsPitched,
                runs: runs,
                earnedRuns: earnedRuns,
                hitsAllowed: hitsAllowed,
                walks: walks,
                strikeouts: strikeouts,
                homeRunsAllowed: homeRunsAllowed,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LocalPitchingAppearancesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gameId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable:
                                    $$LocalPitchingAppearancesTableReferences
                                        ._gameIdTable(db),
                                referencedColumn:
                                    $$LocalPitchingAppearancesTableReferences
                                        ._gameIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LocalPitchingAppearancesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $LocalPitchingAppearancesTable,
      LocalPitchingAppearance,
      $$LocalPitchingAppearancesTableFilterComposer,
      $$LocalPitchingAppearancesTableOrderingComposer,
      $$LocalPitchingAppearancesTableAnnotationComposer,
      $$LocalPitchingAppearancesTableCreateCompanionBuilder,
      $$LocalPitchingAppearancesTableUpdateCompanionBuilder,
      (LocalPitchingAppearance, $$LocalPitchingAppearancesTableReferences),
      LocalPitchingAppearance,
      PrefetchHooks Function({bool gameId})
    >;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$LocalGamesTableTableManager get localGames =>
      $$LocalGamesTableTableManager(_db, _db.localGames);
  $$LocalPlateAppearancesTableTableManager get localPlateAppearances =>
      $$LocalPlateAppearancesTableTableManager(_db, _db.localPlateAppearances);
  $$LocalPitchingAppearancesTableTableManager get localPitchingAppearances =>
      $$LocalPitchingAppearancesTableTableManager(
        _db,
        _db.localPitchingAppearances,
      );
}
