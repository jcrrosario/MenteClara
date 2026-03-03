// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RecordsTable extends Records
    with TableInfo<$RecordsTable, ThoughtRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _thoughtMeta = const VerificationMeta(
    'thought',
  );
  @override
  late final GeneratedColumn<String> thought = GeneratedColumn<String>(
    'thought',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thoughtAltMeta = const VerificationMeta(
    'thoughtAlt',
  );
  @override
  late final GeneratedColumn<String> thoughtAlt = GeneratedColumn<String>(
    'thought_alt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emotionMeta = const VerificationMeta(
    'emotion',
  );
  @override
  late final GeneratedColumn<String> emotion = GeneratedColumn<String>(
    'emotion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _behaviorMeta = const VerificationMeta(
    'behavior',
  );
  @override
  late final GeneratedColumn<String> behavior = GeneratedColumn<String>(
    'behavior',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intensityMeta = const VerificationMeta(
    'intensity',
  );
  @override
  late final GeneratedColumn<int> intensity = GeneratedColumn<int>(
    'intensity',
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
    thought,
    thoughtAlt,
    emotion,
    behavior,
    intensity,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ThoughtRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('thought')) {
      context.handle(
        _thoughtMeta,
        thought.isAcceptableOrUnknown(data['thought']!, _thoughtMeta),
      );
    } else if (isInserting) {
      context.missing(_thoughtMeta);
    }
    if (data.containsKey('thought_alt')) {
      context.handle(
        _thoughtAltMeta,
        thoughtAlt.isAcceptableOrUnknown(data['thought_alt']!, _thoughtAltMeta),
      );
    }
    if (data.containsKey('emotion')) {
      context.handle(
        _emotionMeta,
        emotion.isAcceptableOrUnknown(data['emotion']!, _emotionMeta),
      );
    } else if (isInserting) {
      context.missing(_emotionMeta);
    }
    if (data.containsKey('behavior')) {
      context.handle(
        _behaviorMeta,
        behavior.isAcceptableOrUnknown(data['behavior']!, _behaviorMeta),
      );
    }
    if (data.containsKey('intensity')) {
      context.handle(
        _intensityMeta,
        intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta),
      );
    } else if (isInserting) {
      context.missing(_intensityMeta);
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
  ThoughtRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ThoughtRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      thought: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thought'],
      )!,
      thoughtAlt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thought_alt'],
      ),
      emotion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emotion'],
      )!,
      behavior: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}behavior'],
      ),
      intensity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intensity'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RecordsTable createAlias(String alias) {
    return $RecordsTable(attachedDatabase, alias);
  }
}

class ThoughtRecord extends DataClass implements Insertable<ThoughtRecord> {
  final int id;
  final String thought;
  final String? thoughtAlt;
  final String emotion;
  final String? behavior;
  final int intensity;
  final DateTime createdAt;
  const ThoughtRecord({
    required this.id,
    required this.thought,
    this.thoughtAlt,
    required this.emotion,
    this.behavior,
    required this.intensity,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['thought'] = Variable<String>(thought);
    if (!nullToAbsent || thoughtAlt != null) {
      map['thought_alt'] = Variable<String>(thoughtAlt);
    }
    map['emotion'] = Variable<String>(emotion);
    if (!nullToAbsent || behavior != null) {
      map['behavior'] = Variable<String>(behavior);
    }
    map['intensity'] = Variable<int>(intensity);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RecordsCompanion toCompanion(bool nullToAbsent) {
    return RecordsCompanion(
      id: Value(id),
      thought: Value(thought),
      thoughtAlt: thoughtAlt == null && nullToAbsent
          ? const Value.absent()
          : Value(thoughtAlt),
      emotion: Value(emotion),
      behavior: behavior == null && nullToAbsent
          ? const Value.absent()
          : Value(behavior),
      intensity: Value(intensity),
      createdAt: Value(createdAt),
    );
  }

  factory ThoughtRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ThoughtRecord(
      id: serializer.fromJson<int>(json['id']),
      thought: serializer.fromJson<String>(json['thought']),
      thoughtAlt: serializer.fromJson<String?>(json['thoughtAlt']),
      emotion: serializer.fromJson<String>(json['emotion']),
      behavior: serializer.fromJson<String?>(json['behavior']),
      intensity: serializer.fromJson<int>(json['intensity']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'thought': serializer.toJson<String>(thought),
      'thoughtAlt': serializer.toJson<String?>(thoughtAlt),
      'emotion': serializer.toJson<String>(emotion),
      'behavior': serializer.toJson<String?>(behavior),
      'intensity': serializer.toJson<int>(intensity),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ThoughtRecord copyWith({
    int? id,
    String? thought,
    Value<String?> thoughtAlt = const Value.absent(),
    String? emotion,
    Value<String?> behavior = const Value.absent(),
    int? intensity,
    DateTime? createdAt,
  }) => ThoughtRecord(
    id: id ?? this.id,
    thought: thought ?? this.thought,
    thoughtAlt: thoughtAlt.present ? thoughtAlt.value : this.thoughtAlt,
    emotion: emotion ?? this.emotion,
    behavior: behavior.present ? behavior.value : this.behavior,
    intensity: intensity ?? this.intensity,
    createdAt: createdAt ?? this.createdAt,
  );
  ThoughtRecord copyWithCompanion(RecordsCompanion data) {
    return ThoughtRecord(
      id: data.id.present ? data.id.value : this.id,
      thought: data.thought.present ? data.thought.value : this.thought,
      thoughtAlt: data.thoughtAlt.present
          ? data.thoughtAlt.value
          : this.thoughtAlt,
      emotion: data.emotion.present ? data.emotion.value : this.emotion,
      behavior: data.behavior.present ? data.behavior.value : this.behavior,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ThoughtRecord(')
          ..write('id: $id, ')
          ..write('thought: $thought, ')
          ..write('thoughtAlt: $thoughtAlt, ')
          ..write('emotion: $emotion, ')
          ..write('behavior: $behavior, ')
          ..write('intensity: $intensity, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    thought,
    thoughtAlt,
    emotion,
    behavior,
    intensity,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ThoughtRecord &&
          other.id == this.id &&
          other.thought == this.thought &&
          other.thoughtAlt == this.thoughtAlt &&
          other.emotion == this.emotion &&
          other.behavior == this.behavior &&
          other.intensity == this.intensity &&
          other.createdAt == this.createdAt);
}

class RecordsCompanion extends UpdateCompanion<ThoughtRecord> {
  final Value<int> id;
  final Value<String> thought;
  final Value<String?> thoughtAlt;
  final Value<String> emotion;
  final Value<String?> behavior;
  final Value<int> intensity;
  final Value<DateTime> createdAt;
  const RecordsCompanion({
    this.id = const Value.absent(),
    this.thought = const Value.absent(),
    this.thoughtAlt = const Value.absent(),
    this.emotion = const Value.absent(),
    this.behavior = const Value.absent(),
    this.intensity = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RecordsCompanion.insert({
    this.id = const Value.absent(),
    required String thought,
    this.thoughtAlt = const Value.absent(),
    required String emotion,
    this.behavior = const Value.absent(),
    required int intensity,
    required DateTime createdAt,
  }) : thought = Value(thought),
       emotion = Value(emotion),
       intensity = Value(intensity),
       createdAt = Value(createdAt);
  static Insertable<ThoughtRecord> custom({
    Expression<int>? id,
    Expression<String>? thought,
    Expression<String>? thoughtAlt,
    Expression<String>? emotion,
    Expression<String>? behavior,
    Expression<int>? intensity,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (thought != null) 'thought': thought,
      if (thoughtAlt != null) 'thought_alt': thoughtAlt,
      if (emotion != null) 'emotion': emotion,
      if (behavior != null) 'behavior': behavior,
      if (intensity != null) 'intensity': intensity,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? thought,
    Value<String?>? thoughtAlt,
    Value<String>? emotion,
    Value<String?>? behavior,
    Value<int>? intensity,
    Value<DateTime>? createdAt,
  }) {
    return RecordsCompanion(
      id: id ?? this.id,
      thought: thought ?? this.thought,
      thoughtAlt: thoughtAlt ?? this.thoughtAlt,
      emotion: emotion ?? this.emotion,
      behavior: behavior ?? this.behavior,
      intensity: intensity ?? this.intensity,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (thought.present) {
      map['thought'] = Variable<String>(thought.value);
    }
    if (thoughtAlt.present) {
      map['thought_alt'] = Variable<String>(thoughtAlt.value);
    }
    if (emotion.present) {
      map['emotion'] = Variable<String>(emotion.value);
    }
    if (behavior.present) {
      map['behavior'] = Variable<String>(behavior.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<int>(intensity.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordsCompanion(')
          ..write('id: $id, ')
          ..write('thought: $thought, ')
          ..write('thoughtAlt: $thoughtAlt, ')
          ..write('emotion: $emotion, ')
          ..write('behavior: $behavior, ')
          ..write('intensity: $intensity, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CheckInsTable extends CheckIns
    with TableInfo<$CheckInsTable, CheckInRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckInsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<String> mood = GeneratedColumn<String>(
    'mood',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intensityMeta = const VerificationMeta(
    'intensity',
  );
  @override
  late final GeneratedColumn<int> intensity = GeneratedColumn<int>(
    'intensity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
  List<GeneratedColumn> get $columns => [id, mood, intensity, note, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'check_ins';
  @override
  VerificationContext validateIntegrity(
    Insertable<CheckInRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    } else if (isInserting) {
      context.missing(_moodMeta);
    }
    if (data.containsKey('intensity')) {
      context.handle(
        _intensityMeta,
        intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta),
      );
    } else if (isInserting) {
      context.missing(_intensityMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
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
  CheckInRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CheckInRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood'],
      )!,
      intensity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intensity'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CheckInsTable createAlias(String alias) {
    return $CheckInsTable(attachedDatabase, alias);
  }
}

class CheckInRecord extends DataClass implements Insertable<CheckInRecord> {
  final int id;
  final String mood;
  final int intensity;
  final String? note;
  final DateTime createdAt;
  const CheckInRecord({
    required this.id,
    required this.mood,
    required this.intensity,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mood'] = Variable<String>(mood);
    map['intensity'] = Variable<int>(intensity);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CheckInsCompanion toCompanion(bool nullToAbsent) {
    return CheckInsCompanion(
      id: Value(id),
      mood: Value(mood),
      intensity: Value(intensity),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory CheckInRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CheckInRecord(
      id: serializer.fromJson<int>(json['id']),
      mood: serializer.fromJson<String>(json['mood']),
      intensity: serializer.fromJson<int>(json['intensity']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mood': serializer.toJson<String>(mood),
      'intensity': serializer.toJson<int>(intensity),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CheckInRecord copyWith({
    int? id,
    String? mood,
    int? intensity,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => CheckInRecord(
    id: id ?? this.id,
    mood: mood ?? this.mood,
    intensity: intensity ?? this.intensity,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  CheckInRecord copyWithCompanion(CheckInsCompanion data) {
    return CheckInRecord(
      id: data.id.present ? data.id.value : this.id,
      mood: data.mood.present ? data.mood.value : this.mood,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CheckInRecord(')
          ..write('id: $id, ')
          ..write('mood: $mood, ')
          ..write('intensity: $intensity, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mood, intensity, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CheckInRecord &&
          other.id == this.id &&
          other.mood == this.mood &&
          other.intensity == this.intensity &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class CheckInsCompanion extends UpdateCompanion<CheckInRecord> {
  final Value<int> id;
  final Value<String> mood;
  final Value<int> intensity;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const CheckInsCompanion({
    this.id = const Value.absent(),
    this.mood = const Value.absent(),
    this.intensity = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CheckInsCompanion.insert({
    this.id = const Value.absent(),
    required String mood,
    required int intensity,
    this.note = const Value.absent(),
    required DateTime createdAt,
  }) : mood = Value(mood),
       intensity = Value(intensity),
       createdAt = Value(createdAt);
  static Insertable<CheckInRecord> custom({
    Expression<int>? id,
    Expression<String>? mood,
    Expression<int>? intensity,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mood != null) 'mood': mood,
      if (intensity != null) 'intensity': intensity,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CheckInsCompanion copyWith({
    Value<int>? id,
    Value<String>? mood,
    Value<int>? intensity,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return CheckInsCompanion(
      id: id ?? this.id,
      mood: mood ?? this.mood,
      intensity: intensity ?? this.intensity,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mood.present) {
      map['mood'] = Variable<String>(mood.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<int>(intensity.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CheckInsCompanion(')
          ..write('id: $id, ')
          ..write('mood: $mood, ')
          ..write('intensity: $intensity, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RecordsTable records = $RecordsTable(this);
  late final $CheckInsTable checkIns = $CheckInsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [records, checkIns];
}

typedef $$RecordsTableCreateCompanionBuilder =
    RecordsCompanion Function({
      Value<int> id,
      required String thought,
      Value<String?> thoughtAlt,
      required String emotion,
      Value<String?> behavior,
      required int intensity,
      required DateTime createdAt,
    });
typedef $$RecordsTableUpdateCompanionBuilder =
    RecordsCompanion Function({
      Value<int> id,
      Value<String> thought,
      Value<String?> thoughtAlt,
      Value<String> emotion,
      Value<String?> behavior,
      Value<int> intensity,
      Value<DateTime> createdAt,
    });

class $$RecordsTableFilterComposer
    extends Composer<_$AppDatabase, $RecordsTable> {
  $$RecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thought => $composableBuilder(
    column: $table.thought,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thoughtAlt => $composableBuilder(
    column: $table.thoughtAlt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emotion => $composableBuilder(
    column: $table.emotion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get behavior => $composableBuilder(
    column: $table.behavior,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecordsTable> {
  $$RecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thought => $composableBuilder(
    column: $table.thought,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thoughtAlt => $composableBuilder(
    column: $table.thoughtAlt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emotion => $composableBuilder(
    column: $table.emotion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get behavior => $composableBuilder(
    column: $table.behavior,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecordsTable> {
  $$RecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get thought =>
      $composableBuilder(column: $table.thought, builder: (column) => column);

  GeneratedColumn<String> get thoughtAlt => $composableBuilder(
    column: $table.thoughtAlt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emotion =>
      $composableBuilder(column: $table.emotion, builder: (column) => column);

  GeneratedColumn<String> get behavior =>
      $composableBuilder(column: $table.behavior, builder: (column) => column);

  GeneratedColumn<int> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecordsTable,
          ThoughtRecord,
          $$RecordsTableFilterComposer,
          $$RecordsTableOrderingComposer,
          $$RecordsTableAnnotationComposer,
          $$RecordsTableCreateCompanionBuilder,
          $$RecordsTableUpdateCompanionBuilder,
          (
            ThoughtRecord,
            BaseReferences<_$AppDatabase, $RecordsTable, ThoughtRecord>,
          ),
          ThoughtRecord,
          PrefetchHooks Function()
        > {
  $$RecordsTableTableManager(_$AppDatabase db, $RecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> thought = const Value.absent(),
                Value<String?> thoughtAlt = const Value.absent(),
                Value<String> emotion = const Value.absent(),
                Value<String?> behavior = const Value.absent(),
                Value<int> intensity = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RecordsCompanion(
                id: id,
                thought: thought,
                thoughtAlt: thoughtAlt,
                emotion: emotion,
                behavior: behavior,
                intensity: intensity,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String thought,
                Value<String?> thoughtAlt = const Value.absent(),
                required String emotion,
                Value<String?> behavior = const Value.absent(),
                required int intensity,
                required DateTime createdAt,
              }) => RecordsCompanion.insert(
                id: id,
                thought: thought,
                thoughtAlt: thoughtAlt,
                emotion: emotion,
                behavior: behavior,
                intensity: intensity,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecordsTable,
      ThoughtRecord,
      $$RecordsTableFilterComposer,
      $$RecordsTableOrderingComposer,
      $$RecordsTableAnnotationComposer,
      $$RecordsTableCreateCompanionBuilder,
      $$RecordsTableUpdateCompanionBuilder,
      (
        ThoughtRecord,
        BaseReferences<_$AppDatabase, $RecordsTable, ThoughtRecord>,
      ),
      ThoughtRecord,
      PrefetchHooks Function()
    >;
typedef $$CheckInsTableCreateCompanionBuilder =
    CheckInsCompanion Function({
      Value<int> id,
      required String mood,
      required int intensity,
      Value<String?> note,
      required DateTime createdAt,
    });
typedef $$CheckInsTableUpdateCompanionBuilder =
    CheckInsCompanion Function({
      Value<int> id,
      Value<String> mood,
      Value<int> intensity,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

class $$CheckInsTableFilterComposer
    extends Composer<_$AppDatabase, $CheckInsTable> {
  $$CheckInsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CheckInsTableOrderingComposer
    extends Composer<_$AppDatabase, $CheckInsTable> {
  $$CheckInsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CheckInsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CheckInsTable> {
  $$CheckInsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<int> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CheckInsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CheckInsTable,
          CheckInRecord,
          $$CheckInsTableFilterComposer,
          $$CheckInsTableOrderingComposer,
          $$CheckInsTableAnnotationComposer,
          $$CheckInsTableCreateCompanionBuilder,
          $$CheckInsTableUpdateCompanionBuilder,
          (
            CheckInRecord,
            BaseReferences<_$AppDatabase, $CheckInsTable, CheckInRecord>,
          ),
          CheckInRecord,
          PrefetchHooks Function()
        > {
  $$CheckInsTableTableManager(_$AppDatabase db, $CheckInsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CheckInsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CheckInsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CheckInsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> mood = const Value.absent(),
                Value<int> intensity = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CheckInsCompanion(
                id: id,
                mood: mood,
                intensity: intensity,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String mood,
                required int intensity,
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
              }) => CheckInsCompanion.insert(
                id: id,
                mood: mood,
                intensity: intensity,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CheckInsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CheckInsTable,
      CheckInRecord,
      $$CheckInsTableFilterComposer,
      $$CheckInsTableOrderingComposer,
      $$CheckInsTableAnnotationComposer,
      $$CheckInsTableCreateCompanionBuilder,
      $$CheckInsTableUpdateCompanionBuilder,
      (
        CheckInRecord,
        BaseReferences<_$AppDatabase, $CheckInsTable, CheckInRecord>,
      ),
      CheckInRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RecordsTableTableManager get records =>
      $$RecordsTableTableManager(_db, _db.records);
  $$CheckInsTableTableManager get checkIns =>
      $$CheckInsTableTableManager(_db, _db.checkIns);
}
