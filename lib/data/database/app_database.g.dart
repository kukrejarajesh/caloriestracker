// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FoodsTable extends Foods with TableInfo<$FoodsTable, Food> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesPer100gMeta = const VerificationMeta(
    'caloriesPer100g',
  );
  @override
  late final GeneratedColumn<double> caloriesPer100g = GeneratedColumn<double>(
    'calories_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinPer100gMeta = const VerificationMeta(
    'proteinPer100g',
  );
  @override
  late final GeneratedColumn<double> proteinPer100g = GeneratedColumn<double>(
    'protein_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _carbsPer100gMeta = const VerificationMeta(
    'carbsPer100g',
  );
  @override
  late final GeneratedColumn<double> carbsPer100g = GeneratedColumn<double>(
    'carbs_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fatPer100gMeta = const VerificationMeta(
    'fatPer100g',
  );
  @override
  late final GeneratedColumn<double> fatPer100g = GeneratedColumn<double>(
    'fat_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fiberPer100gMeta = const VerificationMeta(
    'fiberPer100g',
  );
  @override
  late final GeneratedColumn<double> fiberPer100g = GeneratedColumn<double>(
    'fiber_per100g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sugarPer100gMeta = const VerificationMeta(
    'sugarPer100g',
  );
  @override
  late final GeneratedColumn<double> sugarPer100g = GeneratedColumn<double>(
    'sugar_per100g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sodiumPer100mgMeta = const VerificationMeta(
    'sodiumPer100mg',
  );
  @override
  late final GeneratedColumn<double> sodiumPer100mg = GeneratedColumn<double>(
    'sodium_per100mg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultServingGMeta = const VerificationMeta(
    'defaultServingG',
  );
  @override
  late final GeneratedColumn<double> defaultServingG = GeneratedColumn<double>(
    'default_serving_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  static const VerificationMeta _servingDescriptionMeta =
      const VerificationMeta('servingDescription');
  @override
  late final GeneratedColumn<String> servingDescription =
      GeneratedColumn<String>(
        'serving_description',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isGlutenFreeMeta = const VerificationMeta(
    'isGlutenFree',
  );
  @override
  late final GeneratedColumn<int> isGlutenFree = GeneratedColumn<int>(
    'is_gluten_free',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _glutenStatusMeta = const VerificationMeta(
    'glutenStatus',
  );
  @override
  late final GeneratedColumn<String> glutenStatus = GeneratedColumn<String>(
    'gluten_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL DEFAULT \'unknown\' CHECK(gluten_status IN (\'gluten_free\',\'contains_gluten\',\'may_contain\',\'unknown\'))',
    defaultValue: const CustomExpression('\'unknown\''),
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<int> isCustom = GeneratedColumn<int>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _seedKeyMeta = const VerificationMeta(
    'seedKey',
  );
  @override
  late final GeneratedColumn<String> seedKey = GeneratedColumn<String>(
    'seed_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    brand,
    category,
    caloriesPer100g,
    proteinPer100g,
    carbsPer100g,
    fatPer100g,
    fiberPer100g,
    sugarPer100g,
    sodiumPer100mg,
    defaultServingG,
    servingDescription,
    isGlutenFree,
    glutenStatus,
    isCustom,
    seedKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'foods';
  @override
  VerificationContext validateIntegrity(
    Insertable<Food> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('calories_per100g')) {
      context.handle(
        _caloriesPer100gMeta,
        caloriesPer100g.isAcceptableOrUnknown(
          data['calories_per100g']!,
          _caloriesPer100gMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_caloriesPer100gMeta);
    }
    if (data.containsKey('protein_per100g')) {
      context.handle(
        _proteinPer100gMeta,
        proteinPer100g.isAcceptableOrUnknown(
          data['protein_per100g']!,
          _proteinPer100gMeta,
        ),
      );
    }
    if (data.containsKey('carbs_per100g')) {
      context.handle(
        _carbsPer100gMeta,
        carbsPer100g.isAcceptableOrUnknown(
          data['carbs_per100g']!,
          _carbsPer100gMeta,
        ),
      );
    }
    if (data.containsKey('fat_per100g')) {
      context.handle(
        _fatPer100gMeta,
        fatPer100g.isAcceptableOrUnknown(data['fat_per100g']!, _fatPer100gMeta),
      );
    }
    if (data.containsKey('fiber_per100g')) {
      context.handle(
        _fiberPer100gMeta,
        fiberPer100g.isAcceptableOrUnknown(
          data['fiber_per100g']!,
          _fiberPer100gMeta,
        ),
      );
    }
    if (data.containsKey('sugar_per100g')) {
      context.handle(
        _sugarPer100gMeta,
        sugarPer100g.isAcceptableOrUnknown(
          data['sugar_per100g']!,
          _sugarPer100gMeta,
        ),
      );
    }
    if (data.containsKey('sodium_per100mg')) {
      context.handle(
        _sodiumPer100mgMeta,
        sodiumPer100mg.isAcceptableOrUnknown(
          data['sodium_per100mg']!,
          _sodiumPer100mgMeta,
        ),
      );
    }
    if (data.containsKey('default_serving_g')) {
      context.handle(
        _defaultServingGMeta,
        defaultServingG.isAcceptableOrUnknown(
          data['default_serving_g']!,
          _defaultServingGMeta,
        ),
      );
    }
    if (data.containsKey('serving_description')) {
      context.handle(
        _servingDescriptionMeta,
        servingDescription.isAcceptableOrUnknown(
          data['serving_description']!,
          _servingDescriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_gluten_free')) {
      context.handle(
        _isGlutenFreeMeta,
        isGlutenFree.isAcceptableOrUnknown(
          data['is_gluten_free']!,
          _isGlutenFreeMeta,
        ),
      );
    }
    if (data.containsKey('gluten_status')) {
      context.handle(
        _glutenStatusMeta,
        glutenStatus.isAcceptableOrUnknown(
          data['gluten_status']!,
          _glutenStatusMeta,
        ),
      );
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    if (data.containsKey('seed_key')) {
      context.handle(
        _seedKeyMeta,
        seedKey.isAcceptableOrUnknown(data['seed_key']!, _seedKeyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Food map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Food(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      caloriesPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories_per100g'],
      )!,
      proteinPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_per100g'],
      )!,
      carbsPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_per100g'],
      )!,
      fatPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_per100g'],
      )!,
      fiberPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber_per100g'],
      ),
      sugarPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sugar_per100g'],
      ),
      sodiumPer100mg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sodium_per100mg'],
      ),
      defaultServingG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}default_serving_g'],
      )!,
      servingDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serving_description'],
      ),
      isGlutenFree: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_gluten_free'],
      )!,
      glutenStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gluten_status'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_custom'],
      )!,
      seedKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seed_key'],
      ),
    );
  }

  @override
  $FoodsTable createAlias(String alias) {
    return $FoodsTable(attachedDatabase, alias);
  }
}

class Food extends DataClass implements Insertable<Food> {
  final int id;
  final String name;
  final String? brand;
  final String category;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final double? fiberPer100g;
  final double? sugarPer100g;
  final double? sodiumPer100mg;
  final double defaultServingG;
  final String? servingDescription;
  final int isGlutenFree;
  final String glutenStatus;
  final int isCustom;

  /// Stable identifier for seeded foods. NULL for custom user-added rows.
  /// Used by the seed-data reconciliation flow (see DbSeeder) to detect which
  /// seeded rows are already on-device vs newly shipped in a later release.
  /// Computed by [makeSeedKey] (core/utils/seed_key.dart). Never change the
  /// algorithm once a release has shipped.
  final String? seedKey;
  const Food({
    required this.id,
    required this.name,
    this.brand,
    required this.category,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    this.fiberPer100g,
    this.sugarPer100g,
    this.sodiumPer100mg,
    required this.defaultServingG,
    this.servingDescription,
    required this.isGlutenFree,
    required this.glutenStatus,
    required this.isCustom,
    this.seedKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    map['category'] = Variable<String>(category);
    map['calories_per100g'] = Variable<double>(caloriesPer100g);
    map['protein_per100g'] = Variable<double>(proteinPer100g);
    map['carbs_per100g'] = Variable<double>(carbsPer100g);
    map['fat_per100g'] = Variable<double>(fatPer100g);
    if (!nullToAbsent || fiberPer100g != null) {
      map['fiber_per100g'] = Variable<double>(fiberPer100g);
    }
    if (!nullToAbsent || sugarPer100g != null) {
      map['sugar_per100g'] = Variable<double>(sugarPer100g);
    }
    if (!nullToAbsent || sodiumPer100mg != null) {
      map['sodium_per100mg'] = Variable<double>(sodiumPer100mg);
    }
    map['default_serving_g'] = Variable<double>(defaultServingG);
    if (!nullToAbsent || servingDescription != null) {
      map['serving_description'] = Variable<String>(servingDescription);
    }
    map['is_gluten_free'] = Variable<int>(isGlutenFree);
    map['gluten_status'] = Variable<String>(glutenStatus);
    map['is_custom'] = Variable<int>(isCustom);
    if (!nullToAbsent || seedKey != null) {
      map['seed_key'] = Variable<String>(seedKey);
    }
    return map;
  }

  FoodsCompanion toCompanion(bool nullToAbsent) {
    return FoodsCompanion(
      id: Value(id),
      name: Value(name),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      category: Value(category),
      caloriesPer100g: Value(caloriesPer100g),
      proteinPer100g: Value(proteinPer100g),
      carbsPer100g: Value(carbsPer100g),
      fatPer100g: Value(fatPer100g),
      fiberPer100g: fiberPer100g == null && nullToAbsent
          ? const Value.absent()
          : Value(fiberPer100g),
      sugarPer100g: sugarPer100g == null && nullToAbsent
          ? const Value.absent()
          : Value(sugarPer100g),
      sodiumPer100mg: sodiumPer100mg == null && nullToAbsent
          ? const Value.absent()
          : Value(sodiumPer100mg),
      defaultServingG: Value(defaultServingG),
      servingDescription: servingDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(servingDescription),
      isGlutenFree: Value(isGlutenFree),
      glutenStatus: Value(glutenStatus),
      isCustom: Value(isCustom),
      seedKey: seedKey == null && nullToAbsent
          ? const Value.absent()
          : Value(seedKey),
    );
  }

  factory Food.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Food(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      category: serializer.fromJson<String>(json['category']),
      caloriesPer100g: serializer.fromJson<double>(json['caloriesPer100g']),
      proteinPer100g: serializer.fromJson<double>(json['proteinPer100g']),
      carbsPer100g: serializer.fromJson<double>(json['carbsPer100g']),
      fatPer100g: serializer.fromJson<double>(json['fatPer100g']),
      fiberPer100g: serializer.fromJson<double?>(json['fiberPer100g']),
      sugarPer100g: serializer.fromJson<double?>(json['sugarPer100g']),
      sodiumPer100mg: serializer.fromJson<double?>(json['sodiumPer100mg']),
      defaultServingG: serializer.fromJson<double>(json['defaultServingG']),
      servingDescription: serializer.fromJson<String?>(
        json['servingDescription'],
      ),
      isGlutenFree: serializer.fromJson<int>(json['isGlutenFree']),
      glutenStatus: serializer.fromJson<String>(json['glutenStatus']),
      isCustom: serializer.fromJson<int>(json['isCustom']),
      seedKey: serializer.fromJson<String?>(json['seedKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'category': serializer.toJson<String>(category),
      'caloriesPer100g': serializer.toJson<double>(caloriesPer100g),
      'proteinPer100g': serializer.toJson<double>(proteinPer100g),
      'carbsPer100g': serializer.toJson<double>(carbsPer100g),
      'fatPer100g': serializer.toJson<double>(fatPer100g),
      'fiberPer100g': serializer.toJson<double?>(fiberPer100g),
      'sugarPer100g': serializer.toJson<double?>(sugarPer100g),
      'sodiumPer100mg': serializer.toJson<double?>(sodiumPer100mg),
      'defaultServingG': serializer.toJson<double>(defaultServingG),
      'servingDescription': serializer.toJson<String?>(servingDescription),
      'isGlutenFree': serializer.toJson<int>(isGlutenFree),
      'glutenStatus': serializer.toJson<String>(glutenStatus),
      'isCustom': serializer.toJson<int>(isCustom),
      'seedKey': serializer.toJson<String?>(seedKey),
    };
  }

  Food copyWith({
    int? id,
    String? name,
    Value<String?> brand = const Value.absent(),
    String? category,
    double? caloriesPer100g,
    double? proteinPer100g,
    double? carbsPer100g,
    double? fatPer100g,
    Value<double?> fiberPer100g = const Value.absent(),
    Value<double?> sugarPer100g = const Value.absent(),
    Value<double?> sodiumPer100mg = const Value.absent(),
    double? defaultServingG,
    Value<String?> servingDescription = const Value.absent(),
    int? isGlutenFree,
    String? glutenStatus,
    int? isCustom,
    Value<String?> seedKey = const Value.absent(),
  }) => Food(
    id: id ?? this.id,
    name: name ?? this.name,
    brand: brand.present ? brand.value : this.brand,
    category: category ?? this.category,
    caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
    proteinPer100g: proteinPer100g ?? this.proteinPer100g,
    carbsPer100g: carbsPer100g ?? this.carbsPer100g,
    fatPer100g: fatPer100g ?? this.fatPer100g,
    fiberPer100g: fiberPer100g.present ? fiberPer100g.value : this.fiberPer100g,
    sugarPer100g: sugarPer100g.present ? sugarPer100g.value : this.sugarPer100g,
    sodiumPer100mg: sodiumPer100mg.present
        ? sodiumPer100mg.value
        : this.sodiumPer100mg,
    defaultServingG: defaultServingG ?? this.defaultServingG,
    servingDescription: servingDescription.present
        ? servingDescription.value
        : this.servingDescription,
    isGlutenFree: isGlutenFree ?? this.isGlutenFree,
    glutenStatus: glutenStatus ?? this.glutenStatus,
    isCustom: isCustom ?? this.isCustom,
    seedKey: seedKey.present ? seedKey.value : this.seedKey,
  );
  Food copyWithCompanion(FoodsCompanion data) {
    return Food(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      category: data.category.present ? data.category.value : this.category,
      caloriesPer100g: data.caloriesPer100g.present
          ? data.caloriesPer100g.value
          : this.caloriesPer100g,
      proteinPer100g: data.proteinPer100g.present
          ? data.proteinPer100g.value
          : this.proteinPer100g,
      carbsPer100g: data.carbsPer100g.present
          ? data.carbsPer100g.value
          : this.carbsPer100g,
      fatPer100g: data.fatPer100g.present
          ? data.fatPer100g.value
          : this.fatPer100g,
      fiberPer100g: data.fiberPer100g.present
          ? data.fiberPer100g.value
          : this.fiberPer100g,
      sugarPer100g: data.sugarPer100g.present
          ? data.sugarPer100g.value
          : this.sugarPer100g,
      sodiumPer100mg: data.sodiumPer100mg.present
          ? data.sodiumPer100mg.value
          : this.sodiumPer100mg,
      defaultServingG: data.defaultServingG.present
          ? data.defaultServingG.value
          : this.defaultServingG,
      servingDescription: data.servingDescription.present
          ? data.servingDescription.value
          : this.servingDescription,
      isGlutenFree: data.isGlutenFree.present
          ? data.isGlutenFree.value
          : this.isGlutenFree,
      glutenStatus: data.glutenStatus.present
          ? data.glutenStatus.value
          : this.glutenStatus,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      seedKey: data.seedKey.present ? data.seedKey.value : this.seedKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Food(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('category: $category, ')
          ..write('caloriesPer100g: $caloriesPer100g, ')
          ..write('proteinPer100g: $proteinPer100g, ')
          ..write('carbsPer100g: $carbsPer100g, ')
          ..write('fatPer100g: $fatPer100g, ')
          ..write('fiberPer100g: $fiberPer100g, ')
          ..write('sugarPer100g: $sugarPer100g, ')
          ..write('sodiumPer100mg: $sodiumPer100mg, ')
          ..write('defaultServingG: $defaultServingG, ')
          ..write('servingDescription: $servingDescription, ')
          ..write('isGlutenFree: $isGlutenFree, ')
          ..write('glutenStatus: $glutenStatus, ')
          ..write('isCustom: $isCustom, ')
          ..write('seedKey: $seedKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    brand,
    category,
    caloriesPer100g,
    proteinPer100g,
    carbsPer100g,
    fatPer100g,
    fiberPer100g,
    sugarPer100g,
    sodiumPer100mg,
    defaultServingG,
    servingDescription,
    isGlutenFree,
    glutenStatus,
    isCustom,
    seedKey,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Food &&
          other.id == this.id &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.category == this.category &&
          other.caloriesPer100g == this.caloriesPer100g &&
          other.proteinPer100g == this.proteinPer100g &&
          other.carbsPer100g == this.carbsPer100g &&
          other.fatPer100g == this.fatPer100g &&
          other.fiberPer100g == this.fiberPer100g &&
          other.sugarPer100g == this.sugarPer100g &&
          other.sodiumPer100mg == this.sodiumPer100mg &&
          other.defaultServingG == this.defaultServingG &&
          other.servingDescription == this.servingDescription &&
          other.isGlutenFree == this.isGlutenFree &&
          other.glutenStatus == this.glutenStatus &&
          other.isCustom == this.isCustom &&
          other.seedKey == this.seedKey);
}

class FoodsCompanion extends UpdateCompanion<Food> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> brand;
  final Value<String> category;
  final Value<double> caloriesPer100g;
  final Value<double> proteinPer100g;
  final Value<double> carbsPer100g;
  final Value<double> fatPer100g;
  final Value<double?> fiberPer100g;
  final Value<double?> sugarPer100g;
  final Value<double?> sodiumPer100mg;
  final Value<double> defaultServingG;
  final Value<String?> servingDescription;
  final Value<int> isGlutenFree;
  final Value<String> glutenStatus;
  final Value<int> isCustom;
  final Value<String?> seedKey;
  const FoodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.category = const Value.absent(),
    this.caloriesPer100g = const Value.absent(),
    this.proteinPer100g = const Value.absent(),
    this.carbsPer100g = const Value.absent(),
    this.fatPer100g = const Value.absent(),
    this.fiberPer100g = const Value.absent(),
    this.sugarPer100g = const Value.absent(),
    this.sodiumPer100mg = const Value.absent(),
    this.defaultServingG = const Value.absent(),
    this.servingDescription = const Value.absent(),
    this.isGlutenFree = const Value.absent(),
    this.glutenStatus = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.seedKey = const Value.absent(),
  });
  FoodsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.brand = const Value.absent(),
    required String category,
    required double caloriesPer100g,
    this.proteinPer100g = const Value.absent(),
    this.carbsPer100g = const Value.absent(),
    this.fatPer100g = const Value.absent(),
    this.fiberPer100g = const Value.absent(),
    this.sugarPer100g = const Value.absent(),
    this.sodiumPer100mg = const Value.absent(),
    this.defaultServingG = const Value.absent(),
    this.servingDescription = const Value.absent(),
    this.isGlutenFree = const Value.absent(),
    this.glutenStatus = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.seedKey = const Value.absent(),
  }) : name = Value(name),
       category = Value(category),
       caloriesPer100g = Value(caloriesPer100g);
  static Insertable<Food> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? category,
    Expression<double>? caloriesPer100g,
    Expression<double>? proteinPer100g,
    Expression<double>? carbsPer100g,
    Expression<double>? fatPer100g,
    Expression<double>? fiberPer100g,
    Expression<double>? sugarPer100g,
    Expression<double>? sodiumPer100mg,
    Expression<double>? defaultServingG,
    Expression<String>? servingDescription,
    Expression<int>? isGlutenFree,
    Expression<String>? glutenStatus,
    Expression<int>? isCustom,
    Expression<String>? seedKey,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (category != null) 'category': category,
      if (caloriesPer100g != null) 'calories_per100g': caloriesPer100g,
      if (proteinPer100g != null) 'protein_per100g': proteinPer100g,
      if (carbsPer100g != null) 'carbs_per100g': carbsPer100g,
      if (fatPer100g != null) 'fat_per100g': fatPer100g,
      if (fiberPer100g != null) 'fiber_per100g': fiberPer100g,
      if (sugarPer100g != null) 'sugar_per100g': sugarPer100g,
      if (sodiumPer100mg != null) 'sodium_per100mg': sodiumPer100mg,
      if (defaultServingG != null) 'default_serving_g': defaultServingG,
      if (servingDescription != null) 'serving_description': servingDescription,
      if (isGlutenFree != null) 'is_gluten_free': isGlutenFree,
      if (glutenStatus != null) 'gluten_status': glutenStatus,
      if (isCustom != null) 'is_custom': isCustom,
      if (seedKey != null) 'seed_key': seedKey,
    });
  }

  FoodsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? brand,
    Value<String>? category,
    Value<double>? caloriesPer100g,
    Value<double>? proteinPer100g,
    Value<double>? carbsPer100g,
    Value<double>? fatPer100g,
    Value<double?>? fiberPer100g,
    Value<double?>? sugarPer100g,
    Value<double?>? sodiumPer100mg,
    Value<double>? defaultServingG,
    Value<String?>? servingDescription,
    Value<int>? isGlutenFree,
    Value<String>? glutenStatus,
    Value<int>? isCustom,
    Value<String?>? seedKey,
  }) {
    return FoodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
      proteinPer100g: proteinPer100g ?? this.proteinPer100g,
      carbsPer100g: carbsPer100g ?? this.carbsPer100g,
      fatPer100g: fatPer100g ?? this.fatPer100g,
      fiberPer100g: fiberPer100g ?? this.fiberPer100g,
      sugarPer100g: sugarPer100g ?? this.sugarPer100g,
      sodiumPer100mg: sodiumPer100mg ?? this.sodiumPer100mg,
      defaultServingG: defaultServingG ?? this.defaultServingG,
      servingDescription: servingDescription ?? this.servingDescription,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      glutenStatus: glutenStatus ?? this.glutenStatus,
      isCustom: isCustom ?? this.isCustom,
      seedKey: seedKey ?? this.seedKey,
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
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (caloriesPer100g.present) {
      map['calories_per100g'] = Variable<double>(caloriesPer100g.value);
    }
    if (proteinPer100g.present) {
      map['protein_per100g'] = Variable<double>(proteinPer100g.value);
    }
    if (carbsPer100g.present) {
      map['carbs_per100g'] = Variable<double>(carbsPer100g.value);
    }
    if (fatPer100g.present) {
      map['fat_per100g'] = Variable<double>(fatPer100g.value);
    }
    if (fiberPer100g.present) {
      map['fiber_per100g'] = Variable<double>(fiberPer100g.value);
    }
    if (sugarPer100g.present) {
      map['sugar_per100g'] = Variable<double>(sugarPer100g.value);
    }
    if (sodiumPer100mg.present) {
      map['sodium_per100mg'] = Variable<double>(sodiumPer100mg.value);
    }
    if (defaultServingG.present) {
      map['default_serving_g'] = Variable<double>(defaultServingG.value);
    }
    if (servingDescription.present) {
      map['serving_description'] = Variable<String>(servingDescription.value);
    }
    if (isGlutenFree.present) {
      map['is_gluten_free'] = Variable<int>(isGlutenFree.value);
    }
    if (glutenStatus.present) {
      map['gluten_status'] = Variable<String>(glutenStatus.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<int>(isCustom.value);
    }
    if (seedKey.present) {
      map['seed_key'] = Variable<String>(seedKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('category: $category, ')
          ..write('caloriesPer100g: $caloriesPer100g, ')
          ..write('proteinPer100g: $proteinPer100g, ')
          ..write('carbsPer100g: $carbsPer100g, ')
          ..write('fatPer100g: $fatPer100g, ')
          ..write('fiberPer100g: $fiberPer100g, ')
          ..write('sugarPer100g: $sugarPer100g, ')
          ..write('sodiumPer100mg: $sodiumPer100mg, ')
          ..write('defaultServingG: $defaultServingG, ')
          ..write('servingDescription: $servingDescription, ')
          ..write('isGlutenFree: $isGlutenFree, ')
          ..write('glutenStatus: $glutenStatus, ')
          ..write('isCustom: $isCustom, ')
          ..write('seedKey: $seedKey')
          ..write(')'))
        .toString();
  }
}

class $FoodLogsTable extends FoodLogs with TableInfo<$FoodLogsTable, FoodLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK(meal_type IN (\'breakfast\',\'lunch\',\'dinner\',\'snacks\'))',
  );
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<int> foodId = GeneratedColumn<int>(
    'food_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES foods (id)',
    ),
  );
  static const VerificationMeta _quantityGMeta = const VerificationMeta(
    'quantityG',
  );
  @override
  late final GeneratedColumn<double> quantityG = GeneratedColumn<double>(
    'quantity_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinMeta = const VerificationMeta(
    'protein',
  );
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
    'protein',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _carbsMeta = const VerificationMeta('carbs');
  @override
  late final GeneratedColumn<double> carbs = GeneratedColumn<double>(
    'carbs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
    'fat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _glutenStatusMeta = const VerificationMeta(
    'glutenStatus',
  );
  @override
  late final GeneratedColumn<String> glutenStatus = GeneratedColumn<String>(
    'gluten_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unknown'),
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<String> loggedAt = GeneratedColumn<String>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    mealType,
    foodId,
    quantityG,
    calories,
    protein,
    carbs,
    fat,
    glutenStatus,
    loggedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    } else if (isInserting) {
      context.missing(_foodIdMeta);
    }
    if (data.containsKey('quantity_g')) {
      context.handle(
        _quantityGMeta,
        quantityG.isAcceptableOrUnknown(data['quantity_g']!, _quantityGMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityGMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('protein')) {
      context.handle(
        _proteinMeta,
        protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta),
      );
    }
    if (data.containsKey('carbs')) {
      context.handle(
        _carbsMeta,
        carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta),
      );
    }
    if (data.containsKey('fat')) {
      context.handle(
        _fatMeta,
        fat.isAcceptableOrUnknown(data['fat']!, _fatMeta),
      );
    }
    if (data.containsKey('gluten_status')) {
      context.handle(
        _glutenStatusMeta,
        glutenStatus.isAcceptableOrUnknown(
          data['gluten_status']!,
          _glutenStatusMeta,
        ),
      );
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}food_id'],
      )!,
      quantityG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity_g'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
      protein: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein'],
      )!,
      carbs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs'],
      )!,
      fat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat'],
      )!,
      glutenStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gluten_status'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logged_at'],
      )!,
    );
  }

  @override
  $FoodLogsTable createAlias(String alias) {
    return $FoodLogsTable(attachedDatabase, alias);
  }
}

class FoodLog extends DataClass implements Insertable<FoodLog> {
  final int id;
  final String date;
  final String mealType;
  final int foodId;
  final double quantityG;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final String glutenStatus;
  final String loggedAt;
  const FoodLog({
    required this.id,
    required this.date,
    required this.mealType,
    required this.foodId,
    required this.quantityG,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.glutenStatus,
    required this.loggedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['meal_type'] = Variable<String>(mealType);
    map['food_id'] = Variable<int>(foodId);
    map['quantity_g'] = Variable<double>(quantityG);
    map['calories'] = Variable<double>(calories);
    map['protein'] = Variable<double>(protein);
    map['carbs'] = Variable<double>(carbs);
    map['fat'] = Variable<double>(fat);
    map['gluten_status'] = Variable<String>(glutenStatus);
    map['logged_at'] = Variable<String>(loggedAt);
    return map;
  }

  FoodLogsCompanion toCompanion(bool nullToAbsent) {
    return FoodLogsCompanion(
      id: Value(id),
      date: Value(date),
      mealType: Value(mealType),
      foodId: Value(foodId),
      quantityG: Value(quantityG),
      calories: Value(calories),
      protein: Value(protein),
      carbs: Value(carbs),
      fat: Value(fat),
      glutenStatus: Value(glutenStatus),
      loggedAt: Value(loggedAt),
    );
  }

  factory FoodLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      mealType: serializer.fromJson<String>(json['mealType']),
      foodId: serializer.fromJson<int>(json['foodId']),
      quantityG: serializer.fromJson<double>(json['quantityG']),
      calories: serializer.fromJson<double>(json['calories']),
      protein: serializer.fromJson<double>(json['protein']),
      carbs: serializer.fromJson<double>(json['carbs']),
      fat: serializer.fromJson<double>(json['fat']),
      glutenStatus: serializer.fromJson<String>(json['glutenStatus']),
      loggedAt: serializer.fromJson<String>(json['loggedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'mealType': serializer.toJson<String>(mealType),
      'foodId': serializer.toJson<int>(foodId),
      'quantityG': serializer.toJson<double>(quantityG),
      'calories': serializer.toJson<double>(calories),
      'protein': serializer.toJson<double>(protein),
      'carbs': serializer.toJson<double>(carbs),
      'fat': serializer.toJson<double>(fat),
      'glutenStatus': serializer.toJson<String>(glutenStatus),
      'loggedAt': serializer.toJson<String>(loggedAt),
    };
  }

  FoodLog copyWith({
    int? id,
    String? date,
    String? mealType,
    int? foodId,
    double? quantityG,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    String? glutenStatus,
    String? loggedAt,
  }) => FoodLog(
    id: id ?? this.id,
    date: date ?? this.date,
    mealType: mealType ?? this.mealType,
    foodId: foodId ?? this.foodId,
    quantityG: quantityG ?? this.quantityG,
    calories: calories ?? this.calories,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
    fat: fat ?? this.fat,
    glutenStatus: glutenStatus ?? this.glutenStatus,
    loggedAt: loggedAt ?? this.loggedAt,
  );
  FoodLog copyWithCompanion(FoodLogsCompanion data) {
    return FoodLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      quantityG: data.quantityG.present ? data.quantityG.value : this.quantityG,
      calories: data.calories.present ? data.calories.value : this.calories,
      protein: data.protein.present ? data.protein.value : this.protein,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      fat: data.fat.present ? data.fat.value : this.fat,
      glutenStatus: data.glutenStatus.present
          ? data.glutenStatus.value
          : this.glutenStatus,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('mealType: $mealType, ')
          ..write('foodId: $foodId, ')
          ..write('quantityG: $quantityG, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('glutenStatus: $glutenStatus, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    mealType,
    foodId,
    quantityG,
    calories,
    protein,
    carbs,
    fat,
    glutenStatus,
    loggedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.mealType == this.mealType &&
          other.foodId == this.foodId &&
          other.quantityG == this.quantityG &&
          other.calories == this.calories &&
          other.protein == this.protein &&
          other.carbs == this.carbs &&
          other.fat == this.fat &&
          other.glutenStatus == this.glutenStatus &&
          other.loggedAt == this.loggedAt);
}

class FoodLogsCompanion extends UpdateCompanion<FoodLog> {
  final Value<int> id;
  final Value<String> date;
  final Value<String> mealType;
  final Value<int> foodId;
  final Value<double> quantityG;
  final Value<double> calories;
  final Value<double> protein;
  final Value<double> carbs;
  final Value<double> fat;
  final Value<String> glutenStatus;
  final Value<String> loggedAt;
  const FoodLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.mealType = const Value.absent(),
    this.foodId = const Value.absent(),
    this.quantityG = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
    this.glutenStatus = const Value.absent(),
    this.loggedAt = const Value.absent(),
  });
  FoodLogsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required String mealType,
    required int foodId,
    required double quantityG,
    required double calories,
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
    this.glutenStatus = const Value.absent(),
    required String loggedAt,
  }) : date = Value(date),
       mealType = Value(mealType),
       foodId = Value(foodId),
       quantityG = Value(quantityG),
       calories = Value(calories),
       loggedAt = Value(loggedAt);
  static Insertable<FoodLog> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<String>? mealType,
    Expression<int>? foodId,
    Expression<double>? quantityG,
    Expression<double>? calories,
    Expression<double>? protein,
    Expression<double>? carbs,
    Expression<double>? fat,
    Expression<String>? glutenStatus,
    Expression<String>? loggedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (mealType != null) 'meal_type': mealType,
      if (foodId != null) 'food_id': foodId,
      if (quantityG != null) 'quantity_g': quantityG,
      if (calories != null) 'calories': calories,
      if (protein != null) 'protein': protein,
      if (carbs != null) 'carbs': carbs,
      if (fat != null) 'fat': fat,
      if (glutenStatus != null) 'gluten_status': glutenStatus,
      if (loggedAt != null) 'logged_at': loggedAt,
    });
  }

  FoodLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<String>? mealType,
    Value<int>? foodId,
    Value<double>? quantityG,
    Value<double>? calories,
    Value<double>? protein,
    Value<double>? carbs,
    Value<double>? fat,
    Value<String>? glutenStatus,
    Value<String>? loggedAt,
  }) {
    return FoodLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      foodId: foodId ?? this.foodId,
      quantityG: quantityG ?? this.quantityG,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      glutenStatus: glutenStatus ?? this.glutenStatus,
      loggedAt: loggedAt ?? this.loggedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<int>(foodId.value);
    }
    if (quantityG.present) {
      map['quantity_g'] = Variable<double>(quantityG.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (carbs.present) {
      map['carbs'] = Variable<double>(carbs.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    if (glutenStatus.present) {
      map['gluten_status'] = Variable<String>(glutenStatus.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<String>(loggedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('mealType: $mealType, ')
          ..write('foodId: $foodId, ')
          ..write('quantityG: $quantityG, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('glutenStatus: $glutenStatus, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metValueMeta = const VerificationMeta(
    'metValue',
  );
  @override
  late final GeneratedColumn<double> metValue = GeneratedColumn<double>(
    'met_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    metValue,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('met_value')) {
      context.handle(
        _metValueMeta,
        metValue.isAcceptableOrUnknown(data['met_value']!, _metValueMeta),
      );
    } else if (isInserting) {
      context.missing(_metValueMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      metValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}met_value'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final int id;
  final String name;
  final String category;
  final double metValue;
  final String? description;
  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.metValue,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['met_value'] = Variable<double>(metValue);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      metValue: Value(metValue),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      metValue: serializer.fromJson<double>(json['metValue']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'metValue': serializer.toJson<double>(metValue),
      'description': serializer.toJson<String?>(description),
    };
  }

  Exercise copyWith({
    int? id,
    String? name,
    String? category,
    double? metValue,
    Value<String?> description = const Value.absent(),
  }) => Exercise(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    metValue: metValue ?? this.metValue,
    description: description.present ? description.value : this.description,
  );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      metValue: data.metValue.present ? data.metValue.value : this.metValue,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('metValue: $metValue, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, category, metValue, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.metValue == this.metValue &&
          other.description == this.description);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> category;
  final Value<double> metValue;
  final Value<String?> description;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.metValue = const Value.absent(),
    this.description = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String category,
    required double metValue,
    this.description = const Value.absent(),
  }) : name = Value(name),
       category = Value(category),
       metValue = Value(metValue);
  static Insertable<Exercise> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<double>? metValue,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (metValue != null) 'met_value': metValue,
      if (description != null) 'description': description,
    });
  }

  ExercisesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? category,
    Value<double>? metValue,
    Value<String?>? description,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      metValue: metValue ?? this.metValue,
      description: description ?? this.description,
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
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (metValue.present) {
      map['met_value'] = Variable<double>(metValue.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('metValue: $metValue, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $ExerciseLogsTable extends ExerciseLogs
    with TableInfo<$ExerciseLogsTable, ExerciseLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesBurnedMeta = const VerificationMeta(
    'caloriesBurned',
  );
  @override
  late final GeneratedColumn<double> caloriesBurned = GeneratedColumn<double>(
    'calories_burned',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<String> loggedAt = GeneratedColumn<String>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    exerciseId,
    durationMinutes,
    caloriesBurned,
    loggedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('calories_burned')) {
      context.handle(
        _caloriesBurnedMeta,
        caloriesBurned.isAcceptableOrUnknown(
          data['calories_burned']!,
          _caloriesBurnedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_caloriesBurnedMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      caloriesBurned: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories_burned'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logged_at'],
      )!,
    );
  }

  @override
  $ExerciseLogsTable createAlias(String alias) {
    return $ExerciseLogsTable(attachedDatabase, alias);
  }
}

class ExerciseLog extends DataClass implements Insertable<ExerciseLog> {
  final int id;
  final String date;
  final int exerciseId;
  final int durationMinutes;
  final double caloriesBurned;
  final String loggedAt;
  const ExerciseLog({
    required this.id,
    required this.date,
    required this.exerciseId,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.loggedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['calories_burned'] = Variable<double>(caloriesBurned);
    map['logged_at'] = Variable<String>(loggedAt);
    return map;
  }

  ExerciseLogsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseLogsCompanion(
      id: Value(id),
      date: Value(date),
      exerciseId: Value(exerciseId),
      durationMinutes: Value(durationMinutes),
      caloriesBurned: Value(caloriesBurned),
      loggedAt: Value(loggedAt),
    );
  }

  factory ExerciseLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      caloriesBurned: serializer.fromJson<double>(json['caloriesBurned']),
      loggedAt: serializer.fromJson<String>(json['loggedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'caloriesBurned': serializer.toJson<double>(caloriesBurned),
      'loggedAt': serializer.toJson<String>(loggedAt),
    };
  }

  ExerciseLog copyWith({
    int? id,
    String? date,
    int? exerciseId,
    int? durationMinutes,
    double? caloriesBurned,
    String? loggedAt,
  }) => ExerciseLog(
    id: id ?? this.id,
    date: date ?? this.date,
    exerciseId: exerciseId ?? this.exerciseId,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    caloriesBurned: caloriesBurned ?? this.caloriesBurned,
    loggedAt: loggedAt ?? this.loggedAt,
  );
  ExerciseLog copyWithCompanion(ExerciseLogsCompanion data) {
    return ExerciseLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      caloriesBurned: data.caloriesBurned.present
          ? data.caloriesBurned.value
          : this.caloriesBurned,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('caloriesBurned: $caloriesBurned, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    exerciseId,
    durationMinutes,
    caloriesBurned,
    loggedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.exerciseId == this.exerciseId &&
          other.durationMinutes == this.durationMinutes &&
          other.caloriesBurned == this.caloriesBurned &&
          other.loggedAt == this.loggedAt);
}

class ExerciseLogsCompanion extends UpdateCompanion<ExerciseLog> {
  final Value<int> id;
  final Value<String> date;
  final Value<int> exerciseId;
  final Value<int> durationMinutes;
  final Value<double> caloriesBurned;
  final Value<String> loggedAt;
  const ExerciseLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.caloriesBurned = const Value.absent(),
    this.loggedAt = const Value.absent(),
  });
  ExerciseLogsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required int exerciseId,
    required int durationMinutes,
    required double caloriesBurned,
    required String loggedAt,
  }) : date = Value(date),
       exerciseId = Value(exerciseId),
       durationMinutes = Value(durationMinutes),
       caloriesBurned = Value(caloriesBurned),
       loggedAt = Value(loggedAt);
  static Insertable<ExerciseLog> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<int>? exerciseId,
    Expression<int>? durationMinutes,
    Expression<double>? caloriesBurned,
    Expression<String>? loggedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (caloriesBurned != null) 'calories_burned': caloriesBurned,
      if (loggedAt != null) 'logged_at': loggedAt,
    });
  }

  ExerciseLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<int>? exerciseId,
    Value<int>? durationMinutes,
    Value<double>? caloriesBurned,
    Value<String>? loggedAt,
  }) {
    return ExerciseLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      exerciseId: exerciseId ?? this.exerciseId,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      loggedAt: loggedAt ?? this.loggedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (caloriesBurned.present) {
      map['calories_burned'] = Variable<double>(caloriesBurned.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<String>(loggedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('caloriesBurned: $caloriesBurned, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }
}

class $WaterLogsTable extends WaterLogs
    with TableInfo<$WaterLogsTable, WaterLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WaterLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMlMeta = const VerificationMeta(
    'amountMl',
  );
  @override
  late final GeneratedColumn<int> amountMl = GeneratedColumn<int>(
    'amount_ml',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<String> loggedAt = GeneratedColumn<String>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, amountMl, loggedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'water_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<WaterLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount_ml')) {
      context.handle(
        _amountMlMeta,
        amountMl.isAcceptableOrUnknown(data['amount_ml']!, _amountMlMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMlMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WaterLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaterLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      amountMl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_ml'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logged_at'],
      )!,
    );
  }

  @override
  $WaterLogsTable createAlias(String alias) {
    return $WaterLogsTable(attachedDatabase, alias);
  }
}

class WaterLog extends DataClass implements Insertable<WaterLog> {
  final int id;
  final String date;
  final int amountMl;
  final String loggedAt;
  const WaterLog({
    required this.id,
    required this.date,
    required this.amountMl,
    required this.loggedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['amount_ml'] = Variable<int>(amountMl);
    map['logged_at'] = Variable<String>(loggedAt);
    return map;
  }

  WaterLogsCompanion toCompanion(bool nullToAbsent) {
    return WaterLogsCompanion(
      id: Value(id),
      date: Value(date),
      amountMl: Value(amountMl),
      loggedAt: Value(loggedAt),
    );
  }

  factory WaterLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      amountMl: serializer.fromJson<int>(json['amountMl']),
      loggedAt: serializer.fromJson<String>(json['loggedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'amountMl': serializer.toJson<int>(amountMl),
      'loggedAt': serializer.toJson<String>(loggedAt),
    };
  }

  WaterLog copyWith({int? id, String? date, int? amountMl, String? loggedAt}) =>
      WaterLog(
        id: id ?? this.id,
        date: date ?? this.date,
        amountMl: amountMl ?? this.amountMl,
        loggedAt: loggedAt ?? this.loggedAt,
      );
  WaterLog copyWithCompanion(WaterLogsCompanion data) {
    return WaterLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      amountMl: data.amountMl.present ? data.amountMl.value : this.amountMl,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WaterLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('amountMl: $amountMl, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, amountMl, loggedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.amountMl == this.amountMl &&
          other.loggedAt == this.loggedAt);
}

class WaterLogsCompanion extends UpdateCompanion<WaterLog> {
  final Value<int> id;
  final Value<String> date;
  final Value<int> amountMl;
  final Value<String> loggedAt;
  const WaterLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.amountMl = const Value.absent(),
    this.loggedAt = const Value.absent(),
  });
  WaterLogsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required int amountMl,
    required String loggedAt,
  }) : date = Value(date),
       amountMl = Value(amountMl),
       loggedAt = Value(loggedAt);
  static Insertable<WaterLog> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<int>? amountMl,
    Expression<String>? loggedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (amountMl != null) 'amount_ml': amountMl,
      if (loggedAt != null) 'logged_at': loggedAt,
    });
  }

  WaterLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<int>? amountMl,
    Value<String>? loggedAt,
  }) {
    return WaterLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      amountMl: amountMl ?? this.amountMl,
      loggedAt: loggedAt ?? this.loggedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (amountMl.present) {
      map['amount_ml'] = Variable<int>(amountMl.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<String>(loggedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('amountMl: $amountMl, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }
}

class $WeightLogsTable extends WeightLogs
    with TableInfo<$WeightLogsTable, WeightLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<String> loggedAt = GeneratedColumn<String>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, weightKg, loggedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeightLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logged_at'],
      )!,
    );
  }

  @override
  $WeightLogsTable createAlias(String alias) {
    return $WeightLogsTable(attachedDatabase, alias);
  }
}

class WeightLog extends DataClass implements Insertable<WeightLog> {
  final int id;
  final String date;
  final double weightKg;
  final String loggedAt;
  const WeightLog({
    required this.id,
    required this.date,
    required this.weightKg,
    required this.loggedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['weight_kg'] = Variable<double>(weightKg);
    map['logged_at'] = Variable<String>(loggedAt);
    return map;
  }

  WeightLogsCompanion toCompanion(bool nullToAbsent) {
    return WeightLogsCompanion(
      id: Value(id),
      date: Value(date),
      weightKg: Value(weightKg),
      loggedAt: Value(loggedAt),
    );
  }

  factory WeightLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      loggedAt: serializer.fromJson<String>(json['loggedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'weightKg': serializer.toJson<double>(weightKg),
      'loggedAt': serializer.toJson<String>(loggedAt),
    };
  }

  WeightLog copyWith({
    int? id,
    String? date,
    double? weightKg,
    String? loggedAt,
  }) => WeightLog(
    id: id ?? this.id,
    date: date ?? this.date,
    weightKg: weightKg ?? this.weightKg,
    loggedAt: loggedAt ?? this.loggedAt,
  );
  WeightLog copyWithCompanion(WeightLogsCompanion data) {
    return WeightLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weightKg: $weightKg, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, weightKg, loggedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.weightKg == this.weightKg &&
          other.loggedAt == this.loggedAt);
}

class WeightLogsCompanion extends UpdateCompanion<WeightLog> {
  final Value<int> id;
  final Value<String> date;
  final Value<double> weightKg;
  final Value<String> loggedAt;
  const WeightLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.loggedAt = const Value.absent(),
  });
  WeightLogsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required double weightKg,
    required String loggedAt,
  }) : date = Value(date),
       weightKg = Value(weightKg),
       loggedAt = Value(loggedAt);
  static Insertable<WeightLog> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<double>? weightKg,
    Expression<String>? loggedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (weightKg != null) 'weight_kg': weightKg,
      if (loggedAt != null) 'logged_at': loggedAt,
    });
  }

  WeightLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<double>? weightKg,
    Value<String>? loggedAt,
  }) {
    return WeightLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      weightKg: weightKg ?? this.weightKg,
      loggedAt: loggedAt ?? this.loggedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<String>(loggedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weightKg: $weightKg, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }
}

class $UserProfileTable extends UserProfile
    with TableInfo<$UserProfileTable, UserProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<String> dateOfBirth = GeneratedColumn<String>(
    'date_of_birth',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK(gender IN (\'male\',\'female\',\'other\'))',
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activityLevelMeta = const VerificationMeta(
    'activityLevel',
  );
  @override
  late final GeneratedColumn<String> activityLevel = GeneratedColumn<String>(
    'activity_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK(activity_level IN (\'sedentary\',\'lightly_active\',\'moderately_active\',\'very_active\'))',
  );
  static const VerificationMeta _goalTypeMeta = const VerificationMeta(
    'goalType',
  );
  @override
  late final GeneratedColumn<String> goalType = GeneratedColumn<String>(
    'goal_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK(goal_type IN (\'lose\',\'maintain\',\'gain\'))',
  );
  static const VerificationMeta _calorieTargetMeta = const VerificationMeta(
    'calorieTarget',
  );
  @override
  late final GeneratedColumn<double> calorieTarget = GeneratedColumn<double>(
    'calorie_target',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proteinTargetGMeta = const VerificationMeta(
    'proteinTargetG',
  );
  @override
  late final GeneratedColumn<double> proteinTargetG = GeneratedColumn<double>(
    'protein_target_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _carbsTargetGMeta = const VerificationMeta(
    'carbsTargetG',
  );
  @override
  late final GeneratedColumn<double> carbsTargetG = GeneratedColumn<double>(
    'carbs_target_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fatTargetGMeta = const VerificationMeta(
    'fatTargetG',
  );
  @override
  late final GeneratedColumn<double> fatTargetG = GeneratedColumn<double>(
    'fat_target_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _waterTargetMlMeta = const VerificationMeta(
    'waterTargetMl',
  );
  @override
  late final GeneratedColumn<int> waterTargetMl = GeneratedColumn<int>(
    'water_target_ml',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2000),
  );
  static const VerificationMeta _isGlutenFreeMeta = const VerificationMeta(
    'isGlutenFree',
  );
  @override
  late final GeneratedColumn<int> isGlutenFree = GeneratedColumn<int>(
    'is_gluten_free',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _dbVersionMeta = const VerificationMeta(
    'dbVersion',
  );
  @override
  late final GeneratedColumn<int> dbVersion = GeneratedColumn<int>(
    'db_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _onboardingCompleteMeta =
      const VerificationMeta('onboardingComplete');
  @override
  late final GeneratedColumn<int> onboardingComplete = GeneratedColumn<int>(
    'onboarding_complete',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    dateOfBirth,
    gender,
    heightCm,
    weightKg,
    activityLevel,
    goalType,
    calorieTarget,
    proteinTargetG,
    carbsTargetG,
    fatTargetG,
    waterTargetMl,
    isGlutenFree,
    dbVersion,
    onboardingComplete,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfileData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('activity_level')) {
      context.handle(
        _activityLevelMeta,
        activityLevel.isAcceptableOrUnknown(
          data['activity_level']!,
          _activityLevelMeta,
        ),
      );
    }
    if (data.containsKey('goal_type')) {
      context.handle(
        _goalTypeMeta,
        goalType.isAcceptableOrUnknown(data['goal_type']!, _goalTypeMeta),
      );
    }
    if (data.containsKey('calorie_target')) {
      context.handle(
        _calorieTargetMeta,
        calorieTarget.isAcceptableOrUnknown(
          data['calorie_target']!,
          _calorieTargetMeta,
        ),
      );
    }
    if (data.containsKey('protein_target_g')) {
      context.handle(
        _proteinTargetGMeta,
        proteinTargetG.isAcceptableOrUnknown(
          data['protein_target_g']!,
          _proteinTargetGMeta,
        ),
      );
    }
    if (data.containsKey('carbs_target_g')) {
      context.handle(
        _carbsTargetGMeta,
        carbsTargetG.isAcceptableOrUnknown(
          data['carbs_target_g']!,
          _carbsTargetGMeta,
        ),
      );
    }
    if (data.containsKey('fat_target_g')) {
      context.handle(
        _fatTargetGMeta,
        fatTargetG.isAcceptableOrUnknown(
          data['fat_target_g']!,
          _fatTargetGMeta,
        ),
      );
    }
    if (data.containsKey('water_target_ml')) {
      context.handle(
        _waterTargetMlMeta,
        waterTargetMl.isAcceptableOrUnknown(
          data['water_target_ml']!,
          _waterTargetMlMeta,
        ),
      );
    }
    if (data.containsKey('is_gluten_free')) {
      context.handle(
        _isGlutenFreeMeta,
        isGlutenFree.isAcceptableOrUnknown(
          data['is_gluten_free']!,
          _isGlutenFreeMeta,
        ),
      );
    }
    if (data.containsKey('db_version')) {
      context.handle(
        _dbVersionMeta,
        dbVersion.isAcceptableOrUnknown(data['db_version']!, _dbVersionMeta),
      );
    }
    if (data.containsKey('onboarding_complete')) {
      context.handle(
        _onboardingCompleteMeta,
        onboardingComplete.isAcceptableOrUnknown(
          data['onboarding_complete']!,
          _onboardingCompleteMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      dateOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_of_birth'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      activityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_level'],
      ),
      goalType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_type'],
      ),
      calorieTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calorie_target'],
      ),
      proteinTargetG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_target_g'],
      ),
      carbsTargetG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_target_g'],
      ),
      fatTargetG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_target_g'],
      ),
      waterTargetMl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}water_target_ml'],
      )!,
      isGlutenFree: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_gluten_free'],
      )!,
      dbVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}db_version'],
      )!,
      onboardingComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}onboarding_complete'],
      )!,
    );
  }

  @override
  $UserProfileTable createAlias(String alias) {
    return $UserProfileTable(attachedDatabase, alias);
  }
}

class UserProfileData extends DataClass implements Insertable<UserProfileData> {
  final int id;
  final String? name;
  final String? dateOfBirth;
  final String? gender;
  final double? heightCm;
  final double? weightKg;
  final String? activityLevel;
  final String? goalType;
  final double? calorieTarget;
  final double? proteinTargetG;
  final double? carbsTargetG;
  final double? fatTargetG;
  final int waterTargetMl;
  final int isGlutenFree;
  final int dbVersion;
  final int onboardingComplete;
  const UserProfileData({
    required this.id,
    this.name,
    this.dateOfBirth,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.activityLevel,
    this.goalType,
    this.calorieTarget,
    this.proteinTargetG,
    this.carbsTargetG,
    this.fatTargetG,
    required this.waterTargetMl,
    required this.isGlutenFree,
    required this.dbVersion,
    required this.onboardingComplete,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || dateOfBirth != null) {
      map['date_of_birth'] = Variable<String>(dateOfBirth);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<double>(heightCm);
    }
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || activityLevel != null) {
      map['activity_level'] = Variable<String>(activityLevel);
    }
    if (!nullToAbsent || goalType != null) {
      map['goal_type'] = Variable<String>(goalType);
    }
    if (!nullToAbsent || calorieTarget != null) {
      map['calorie_target'] = Variable<double>(calorieTarget);
    }
    if (!nullToAbsent || proteinTargetG != null) {
      map['protein_target_g'] = Variable<double>(proteinTargetG);
    }
    if (!nullToAbsent || carbsTargetG != null) {
      map['carbs_target_g'] = Variable<double>(carbsTargetG);
    }
    if (!nullToAbsent || fatTargetG != null) {
      map['fat_target_g'] = Variable<double>(fatTargetG);
    }
    map['water_target_ml'] = Variable<int>(waterTargetMl);
    map['is_gluten_free'] = Variable<int>(isGlutenFree);
    map['db_version'] = Variable<int>(dbVersion);
    map['onboarding_complete'] = Variable<int>(onboardingComplete);
    return map;
  }

  UserProfileCompanion toCompanion(bool nullToAbsent) {
    return UserProfileCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      dateOfBirth: dateOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfBirth),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      activityLevel: activityLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(activityLevel),
      goalType: goalType == null && nullToAbsent
          ? const Value.absent()
          : Value(goalType),
      calorieTarget: calorieTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(calorieTarget),
      proteinTargetG: proteinTargetG == null && nullToAbsent
          ? const Value.absent()
          : Value(proteinTargetG),
      carbsTargetG: carbsTargetG == null && nullToAbsent
          ? const Value.absent()
          : Value(carbsTargetG),
      fatTargetG: fatTargetG == null && nullToAbsent
          ? const Value.absent()
          : Value(fatTargetG),
      waterTargetMl: Value(waterTargetMl),
      isGlutenFree: Value(isGlutenFree),
      dbVersion: Value(dbVersion),
      onboardingComplete: Value(onboardingComplete),
    );
  }

  factory UserProfileData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      dateOfBirth: serializer.fromJson<String?>(json['dateOfBirth']),
      gender: serializer.fromJson<String?>(json['gender']),
      heightCm: serializer.fromJson<double?>(json['heightCm']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      activityLevel: serializer.fromJson<String?>(json['activityLevel']),
      goalType: serializer.fromJson<String?>(json['goalType']),
      calorieTarget: serializer.fromJson<double?>(json['calorieTarget']),
      proteinTargetG: serializer.fromJson<double?>(json['proteinTargetG']),
      carbsTargetG: serializer.fromJson<double?>(json['carbsTargetG']),
      fatTargetG: serializer.fromJson<double?>(json['fatTargetG']),
      waterTargetMl: serializer.fromJson<int>(json['waterTargetMl']),
      isGlutenFree: serializer.fromJson<int>(json['isGlutenFree']),
      dbVersion: serializer.fromJson<int>(json['dbVersion']),
      onboardingComplete: serializer.fromJson<int>(json['onboardingComplete']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'dateOfBirth': serializer.toJson<String?>(dateOfBirth),
      'gender': serializer.toJson<String?>(gender),
      'heightCm': serializer.toJson<double?>(heightCm),
      'weightKg': serializer.toJson<double?>(weightKg),
      'activityLevel': serializer.toJson<String?>(activityLevel),
      'goalType': serializer.toJson<String?>(goalType),
      'calorieTarget': serializer.toJson<double?>(calorieTarget),
      'proteinTargetG': serializer.toJson<double?>(proteinTargetG),
      'carbsTargetG': serializer.toJson<double?>(carbsTargetG),
      'fatTargetG': serializer.toJson<double?>(fatTargetG),
      'waterTargetMl': serializer.toJson<int>(waterTargetMl),
      'isGlutenFree': serializer.toJson<int>(isGlutenFree),
      'dbVersion': serializer.toJson<int>(dbVersion),
      'onboardingComplete': serializer.toJson<int>(onboardingComplete),
    };
  }

  UserProfileData copyWith({
    int? id,
    Value<String?> name = const Value.absent(),
    Value<String?> dateOfBirth = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<double?> heightCm = const Value.absent(),
    Value<double?> weightKg = const Value.absent(),
    Value<String?> activityLevel = const Value.absent(),
    Value<String?> goalType = const Value.absent(),
    Value<double?> calorieTarget = const Value.absent(),
    Value<double?> proteinTargetG = const Value.absent(),
    Value<double?> carbsTargetG = const Value.absent(),
    Value<double?> fatTargetG = const Value.absent(),
    int? waterTargetMl,
    int? isGlutenFree,
    int? dbVersion,
    int? onboardingComplete,
  }) => UserProfileData(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    dateOfBirth: dateOfBirth.present ? dateOfBirth.value : this.dateOfBirth,
    gender: gender.present ? gender.value : this.gender,
    heightCm: heightCm.present ? heightCm.value : this.heightCm,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    activityLevel: activityLevel.present
        ? activityLevel.value
        : this.activityLevel,
    goalType: goalType.present ? goalType.value : this.goalType,
    calorieTarget: calorieTarget.present
        ? calorieTarget.value
        : this.calorieTarget,
    proteinTargetG: proteinTargetG.present
        ? proteinTargetG.value
        : this.proteinTargetG,
    carbsTargetG: carbsTargetG.present ? carbsTargetG.value : this.carbsTargetG,
    fatTargetG: fatTargetG.present ? fatTargetG.value : this.fatTargetG,
    waterTargetMl: waterTargetMl ?? this.waterTargetMl,
    isGlutenFree: isGlutenFree ?? this.isGlutenFree,
    dbVersion: dbVersion ?? this.dbVersion,
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
  );
  UserProfileData copyWithCompanion(UserProfileCompanion data) {
    return UserProfileData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dateOfBirth: data.dateOfBirth.present
          ? data.dateOfBirth.value
          : this.dateOfBirth,
      gender: data.gender.present ? data.gender.value : this.gender,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      activityLevel: data.activityLevel.present
          ? data.activityLevel.value
          : this.activityLevel,
      goalType: data.goalType.present ? data.goalType.value : this.goalType,
      calorieTarget: data.calorieTarget.present
          ? data.calorieTarget.value
          : this.calorieTarget,
      proteinTargetG: data.proteinTargetG.present
          ? data.proteinTargetG.value
          : this.proteinTargetG,
      carbsTargetG: data.carbsTargetG.present
          ? data.carbsTargetG.value
          : this.carbsTargetG,
      fatTargetG: data.fatTargetG.present
          ? data.fatTargetG.value
          : this.fatTargetG,
      waterTargetMl: data.waterTargetMl.present
          ? data.waterTargetMl.value
          : this.waterTargetMl,
      isGlutenFree: data.isGlutenFree.present
          ? data.isGlutenFree.value
          : this.isGlutenFree,
      dbVersion: data.dbVersion.present ? data.dbVersion.value : this.dbVersion,
      onboardingComplete: data.onboardingComplete.present
          ? data.onboardingComplete.value
          : this.onboardingComplete,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('gender: $gender, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('goalType: $goalType, ')
          ..write('calorieTarget: $calorieTarget, ')
          ..write('proteinTargetG: $proteinTargetG, ')
          ..write('carbsTargetG: $carbsTargetG, ')
          ..write('fatTargetG: $fatTargetG, ')
          ..write('waterTargetMl: $waterTargetMl, ')
          ..write('isGlutenFree: $isGlutenFree, ')
          ..write('dbVersion: $dbVersion, ')
          ..write('onboardingComplete: $onboardingComplete')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    dateOfBirth,
    gender,
    heightCm,
    weightKg,
    activityLevel,
    goalType,
    calorieTarget,
    proteinTargetG,
    carbsTargetG,
    fatTargetG,
    waterTargetMl,
    isGlutenFree,
    dbVersion,
    onboardingComplete,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileData &&
          other.id == this.id &&
          other.name == this.name &&
          other.dateOfBirth == this.dateOfBirth &&
          other.gender == this.gender &&
          other.heightCm == this.heightCm &&
          other.weightKg == this.weightKg &&
          other.activityLevel == this.activityLevel &&
          other.goalType == this.goalType &&
          other.calorieTarget == this.calorieTarget &&
          other.proteinTargetG == this.proteinTargetG &&
          other.carbsTargetG == this.carbsTargetG &&
          other.fatTargetG == this.fatTargetG &&
          other.waterTargetMl == this.waterTargetMl &&
          other.isGlutenFree == this.isGlutenFree &&
          other.dbVersion == this.dbVersion &&
          other.onboardingComplete == this.onboardingComplete);
}

class UserProfileCompanion extends UpdateCompanion<UserProfileData> {
  final Value<int> id;
  final Value<String?> name;
  final Value<String?> dateOfBirth;
  final Value<String?> gender;
  final Value<double?> heightCm;
  final Value<double?> weightKg;
  final Value<String?> activityLevel;
  final Value<String?> goalType;
  final Value<double?> calorieTarget;
  final Value<double?> proteinTargetG;
  final Value<double?> carbsTargetG;
  final Value<double?> fatTargetG;
  final Value<int> waterTargetMl;
  final Value<int> isGlutenFree;
  final Value<int> dbVersion;
  final Value<int> onboardingComplete;
  const UserProfileCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.gender = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.goalType = const Value.absent(),
    this.calorieTarget = const Value.absent(),
    this.proteinTargetG = const Value.absent(),
    this.carbsTargetG = const Value.absent(),
    this.fatTargetG = const Value.absent(),
    this.waterTargetMl = const Value.absent(),
    this.isGlutenFree = const Value.absent(),
    this.dbVersion = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
  });
  UserProfileCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.gender = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.goalType = const Value.absent(),
    this.calorieTarget = const Value.absent(),
    this.proteinTargetG = const Value.absent(),
    this.carbsTargetG = const Value.absent(),
    this.fatTargetG = const Value.absent(),
    this.waterTargetMl = const Value.absent(),
    this.isGlutenFree = const Value.absent(),
    this.dbVersion = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
  });
  static Insertable<UserProfileData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? dateOfBirth,
    Expression<String>? gender,
    Expression<double>? heightCm,
    Expression<double>? weightKg,
    Expression<String>? activityLevel,
    Expression<String>? goalType,
    Expression<double>? calorieTarget,
    Expression<double>? proteinTargetG,
    Expression<double>? carbsTargetG,
    Expression<double>? fatTargetG,
    Expression<int>? waterTargetMl,
    Expression<int>? isGlutenFree,
    Expression<int>? dbVersion,
    Expression<int>? onboardingComplete,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (gender != null) 'gender': gender,
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (activityLevel != null) 'activity_level': activityLevel,
      if (goalType != null) 'goal_type': goalType,
      if (calorieTarget != null) 'calorie_target': calorieTarget,
      if (proteinTargetG != null) 'protein_target_g': proteinTargetG,
      if (carbsTargetG != null) 'carbs_target_g': carbsTargetG,
      if (fatTargetG != null) 'fat_target_g': fatTargetG,
      if (waterTargetMl != null) 'water_target_ml': waterTargetMl,
      if (isGlutenFree != null) 'is_gluten_free': isGlutenFree,
      if (dbVersion != null) 'db_version': dbVersion,
      if (onboardingComplete != null) 'onboarding_complete': onboardingComplete,
    });
  }

  UserProfileCompanion copyWith({
    Value<int>? id,
    Value<String?>? name,
    Value<String?>? dateOfBirth,
    Value<String?>? gender,
    Value<double?>? heightCm,
    Value<double?>? weightKg,
    Value<String?>? activityLevel,
    Value<String?>? goalType,
    Value<double?>? calorieTarget,
    Value<double?>? proteinTargetG,
    Value<double?>? carbsTargetG,
    Value<double?>? fatTargetG,
    Value<int>? waterTargetMl,
    Value<int>? isGlutenFree,
    Value<int>? dbVersion,
    Value<int>? onboardingComplete,
  }) {
    return UserProfileCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      goalType: goalType ?? this.goalType,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      proteinTargetG: proteinTargetG ?? this.proteinTargetG,
      carbsTargetG: carbsTargetG ?? this.carbsTargetG,
      fatTargetG: fatTargetG ?? this.fatTargetG,
      waterTargetMl: waterTargetMl ?? this.waterTargetMl,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      dbVersion: dbVersion ?? this.dbVersion,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
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
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<String>(dateOfBirth.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (activityLevel.present) {
      map['activity_level'] = Variable<String>(activityLevel.value);
    }
    if (goalType.present) {
      map['goal_type'] = Variable<String>(goalType.value);
    }
    if (calorieTarget.present) {
      map['calorie_target'] = Variable<double>(calorieTarget.value);
    }
    if (proteinTargetG.present) {
      map['protein_target_g'] = Variable<double>(proteinTargetG.value);
    }
    if (carbsTargetG.present) {
      map['carbs_target_g'] = Variable<double>(carbsTargetG.value);
    }
    if (fatTargetG.present) {
      map['fat_target_g'] = Variable<double>(fatTargetG.value);
    }
    if (waterTargetMl.present) {
      map['water_target_ml'] = Variable<int>(waterTargetMl.value);
    }
    if (isGlutenFree.present) {
      map['is_gluten_free'] = Variable<int>(isGlutenFree.value);
    }
    if (dbVersion.present) {
      map['db_version'] = Variable<int>(dbVersion.value);
    }
    if (onboardingComplete.present) {
      map['onboarding_complete'] = Variable<int>(onboardingComplete.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('gender: $gender, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('goalType: $goalType, ')
          ..write('calorieTarget: $calorieTarget, ')
          ..write('proteinTargetG: $proteinTargetG, ')
          ..write('carbsTargetG: $carbsTargetG, ')
          ..write('fatTargetG: $fatTargetG, ')
          ..write('waterTargetMl: $waterTargetMl, ')
          ..write('isGlutenFree: $isGlutenFree, ')
          ..write('dbVersion: $dbVersion, ')
          ..write('onboardingComplete: $onboardingComplete')
          ..write(')'))
        .toString();
  }
}

class $MetadataTable extends Metadata
    with TableInfo<$MetadataTable, MetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<MetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  MetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetadataData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $MetadataTable createAlias(String alias) {
    return $MetadataTable(attachedDatabase, alias);
  }
}

class MetadataData extends DataClass implements Insertable<MetadataData> {
  final String key;
  final String value;
  const MetadataData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  MetadataCompanion toCompanion(bool nullToAbsent) {
    return MetadataCompanion(key: Value(key), value: Value(value));
  }

  factory MetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetadataData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  MetadataData copyWith({String? key, String? value}) =>
      MetadataData(key: key ?? this.key, value: value ?? this.value);
  MetadataData copyWithCompanion(MetadataCompanion data) {
    return MetadataData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetadataData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetadataData &&
          other.key == this.key &&
          other.value == this.value);
}

class MetadataCompanion extends UpdateCompanion<MetadataData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const MetadataCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetadataCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<MetadataData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MetadataCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return MetadataCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetadataCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FoodsTable foods = $FoodsTable(this);
  late final $FoodLogsTable foodLogs = $FoodLogsTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $ExerciseLogsTable exerciseLogs = $ExerciseLogsTable(this);
  late final $WaterLogsTable waterLogs = $WaterLogsTable(this);
  late final $WeightLogsTable weightLogs = $WeightLogsTable(this);
  late final $UserProfileTable userProfile = $UserProfileTable(this);
  late final $MetadataTable metadata = $MetadataTable(this);
  late final FoodsDao foodsDao = FoodsDao(this as AppDatabase);
  late final FoodLogsDao foodLogsDao = FoodLogsDao(this as AppDatabase);
  late final ExerciseLogsDao exerciseLogsDao = ExerciseLogsDao(
    this as AppDatabase,
  );
  late final WaterLogsDao waterLogsDao = WaterLogsDao(this as AppDatabase);
  late final WeightLogsDao weightLogsDao = WeightLogsDao(this as AppDatabase);
  late final UserProfileDao userProfileDao = UserProfileDao(
    this as AppDatabase,
  );
  late final MetadataDao metadataDao = MetadataDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    foods,
    foodLogs,
    exercises,
    exerciseLogs,
    waterLogs,
    weightLogs,
    userProfile,
    metadata,
  ];
}

typedef $$FoodsTableCreateCompanionBuilder =
    FoodsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> brand,
      required String category,
      required double caloriesPer100g,
      Value<double> proteinPer100g,
      Value<double> carbsPer100g,
      Value<double> fatPer100g,
      Value<double?> fiberPer100g,
      Value<double?> sugarPer100g,
      Value<double?> sodiumPer100mg,
      Value<double> defaultServingG,
      Value<String?> servingDescription,
      Value<int> isGlutenFree,
      Value<String> glutenStatus,
      Value<int> isCustom,
      Value<String?> seedKey,
    });
typedef $$FoodsTableUpdateCompanionBuilder =
    FoodsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> brand,
      Value<String> category,
      Value<double> caloriesPer100g,
      Value<double> proteinPer100g,
      Value<double> carbsPer100g,
      Value<double> fatPer100g,
      Value<double?> fiberPer100g,
      Value<double?> sugarPer100g,
      Value<double?> sodiumPer100mg,
      Value<double> defaultServingG,
      Value<String?> servingDescription,
      Value<int> isGlutenFree,
      Value<String> glutenStatus,
      Value<int> isCustom,
      Value<String?> seedKey,
    });

final class $$FoodsTableReferences
    extends BaseReferences<_$AppDatabase, $FoodsTable, Food> {
  $$FoodsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FoodLogsTable, List<FoodLog>> _foodLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.foodLogs,
    aliasName: $_aliasNameGenerator(db.foods.id, db.foodLogs.foodId),
  );

  $$FoodLogsTableProcessedTableManager get foodLogsRefs {
    final manager = $$FoodLogsTableTableManager(
      $_db,
      $_db.foodLogs,
    ).filter((f) => f.foodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_foodLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FoodsTableFilterComposer extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get caloriesPer100g => $composableBuilder(
    column: $table.caloriesPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinPer100g => $composableBuilder(
    column: $table.proteinPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsPer100g => $composableBuilder(
    column: $table.carbsPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatPer100g => $composableBuilder(
    column: $table.fatPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiberPer100g => $composableBuilder(
    column: $table.fiberPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sugarPer100g => $composableBuilder(
    column: $table.sugarPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sodiumPer100mg => $composableBuilder(
    column: $table.sodiumPer100mg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get defaultServingG => $composableBuilder(
    column: $table.defaultServingG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get servingDescription => $composableBuilder(
    column: $table.servingDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isGlutenFree => $composableBuilder(
    column: $table.isGlutenFree,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get glutenStatus => $composableBuilder(
    column: $table.glutenStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seedKey => $composableBuilder(
    column: $table.seedKey,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> foodLogsRefs(
    Expression<bool> Function($$FoodLogsTableFilterComposer f) f,
  ) {
    final $$FoodLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foodLogs,
      getReferencedColumn: (t) => t.foodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodLogsTableFilterComposer(
            $db: $db,
            $table: $db.foodLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get caloriesPer100g => $composableBuilder(
    column: $table.caloriesPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinPer100g => $composableBuilder(
    column: $table.proteinPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsPer100g => $composableBuilder(
    column: $table.carbsPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatPer100g => $composableBuilder(
    column: $table.fatPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiberPer100g => $composableBuilder(
    column: $table.fiberPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sugarPer100g => $composableBuilder(
    column: $table.sugarPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sodiumPer100mg => $composableBuilder(
    column: $table.sodiumPer100mg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get defaultServingG => $composableBuilder(
    column: $table.defaultServingG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get servingDescription => $composableBuilder(
    column: $table.servingDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isGlutenFree => $composableBuilder(
    column: $table.isGlutenFree,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get glutenStatus => $composableBuilder(
    column: $table.glutenStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seedKey => $composableBuilder(
    column: $table.seedKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableAnnotationComposer({
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

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get caloriesPer100g => $composableBuilder(
    column: $table.caloriesPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinPer100g => $composableBuilder(
    column: $table.proteinPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbsPer100g => $composableBuilder(
    column: $table.carbsPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatPer100g => $composableBuilder(
    column: $table.fatPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fiberPer100g => $composableBuilder(
    column: $table.fiberPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sugarPer100g => $composableBuilder(
    column: $table.sugarPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sodiumPer100mg => $composableBuilder(
    column: $table.sodiumPer100mg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get defaultServingG => $composableBuilder(
    column: $table.defaultServingG,
    builder: (column) => column,
  );

  GeneratedColumn<String> get servingDescription => $composableBuilder(
    column: $table.servingDescription,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isGlutenFree => $composableBuilder(
    column: $table.isGlutenFree,
    builder: (column) => column,
  );

  GeneratedColumn<String> get glutenStatus => $composableBuilder(
    column: $table.glutenStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<String> get seedKey =>
      $composableBuilder(column: $table.seedKey, builder: (column) => column);

  Expression<T> foodLogsRefs<T extends Object>(
    Expression<T> Function($$FoodLogsTableAnnotationComposer a) f,
  ) {
    final $$FoodLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foodLogs,
      getReferencedColumn: (t) => t.foodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.foodLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodsTable,
          Food,
          $$FoodsTableFilterComposer,
          $$FoodsTableOrderingComposer,
          $$FoodsTableAnnotationComposer,
          $$FoodsTableCreateCompanionBuilder,
          $$FoodsTableUpdateCompanionBuilder,
          (Food, $$FoodsTableReferences),
          Food,
          PrefetchHooks Function({bool foodLogsRefs})
        > {
  $$FoodsTableTableManager(_$AppDatabase db, $FoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> caloriesPer100g = const Value.absent(),
                Value<double> proteinPer100g = const Value.absent(),
                Value<double> carbsPer100g = const Value.absent(),
                Value<double> fatPer100g = const Value.absent(),
                Value<double?> fiberPer100g = const Value.absent(),
                Value<double?> sugarPer100g = const Value.absent(),
                Value<double?> sodiumPer100mg = const Value.absent(),
                Value<double> defaultServingG = const Value.absent(),
                Value<String?> servingDescription = const Value.absent(),
                Value<int> isGlutenFree = const Value.absent(),
                Value<String> glutenStatus = const Value.absent(),
                Value<int> isCustom = const Value.absent(),
                Value<String?> seedKey = const Value.absent(),
              }) => FoodsCompanion(
                id: id,
                name: name,
                brand: brand,
                category: category,
                caloriesPer100g: caloriesPer100g,
                proteinPer100g: proteinPer100g,
                carbsPer100g: carbsPer100g,
                fatPer100g: fatPer100g,
                fiberPer100g: fiberPer100g,
                sugarPer100g: sugarPer100g,
                sodiumPer100mg: sodiumPer100mg,
                defaultServingG: defaultServingG,
                servingDescription: servingDescription,
                isGlutenFree: isGlutenFree,
                glutenStatus: glutenStatus,
                isCustom: isCustom,
                seedKey: seedKey,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> brand = const Value.absent(),
                required String category,
                required double caloriesPer100g,
                Value<double> proteinPer100g = const Value.absent(),
                Value<double> carbsPer100g = const Value.absent(),
                Value<double> fatPer100g = const Value.absent(),
                Value<double?> fiberPer100g = const Value.absent(),
                Value<double?> sugarPer100g = const Value.absent(),
                Value<double?> sodiumPer100mg = const Value.absent(),
                Value<double> defaultServingG = const Value.absent(),
                Value<String?> servingDescription = const Value.absent(),
                Value<int> isGlutenFree = const Value.absent(),
                Value<String> glutenStatus = const Value.absent(),
                Value<int> isCustom = const Value.absent(),
                Value<String?> seedKey = const Value.absent(),
              }) => FoodsCompanion.insert(
                id: id,
                name: name,
                brand: brand,
                category: category,
                caloriesPer100g: caloriesPer100g,
                proteinPer100g: proteinPer100g,
                carbsPer100g: carbsPer100g,
                fatPer100g: fatPer100g,
                fiberPer100g: fiberPer100g,
                sugarPer100g: sugarPer100g,
                sodiumPer100mg: sodiumPer100mg,
                defaultServingG: defaultServingG,
                servingDescription: servingDescription,
                isGlutenFree: isGlutenFree,
                glutenStatus: glutenStatus,
                isCustom: isCustom,
                seedKey: seedKey,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$FoodsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({foodLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (foodLogsRefs) db.foodLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (foodLogsRefs)
                    await $_getPrefetchedData<Food, $FoodsTable, FoodLog>(
                      currentTable: table,
                      referencedTable: $$FoodsTableReferences
                          ._foodLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$FoodsTableReferences(db, table, p0).foodLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.foodId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodsTable,
      Food,
      $$FoodsTableFilterComposer,
      $$FoodsTableOrderingComposer,
      $$FoodsTableAnnotationComposer,
      $$FoodsTableCreateCompanionBuilder,
      $$FoodsTableUpdateCompanionBuilder,
      (Food, $$FoodsTableReferences),
      Food,
      PrefetchHooks Function({bool foodLogsRefs})
    >;
typedef $$FoodLogsTableCreateCompanionBuilder =
    FoodLogsCompanion Function({
      Value<int> id,
      required String date,
      required String mealType,
      required int foodId,
      required double quantityG,
      required double calories,
      Value<double> protein,
      Value<double> carbs,
      Value<double> fat,
      Value<String> glutenStatus,
      required String loggedAt,
    });
typedef $$FoodLogsTableUpdateCompanionBuilder =
    FoodLogsCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<String> mealType,
      Value<int> foodId,
      Value<double> quantityG,
      Value<double> calories,
      Value<double> protein,
      Value<double> carbs,
      Value<double> fat,
      Value<String> glutenStatus,
      Value<String> loggedAt,
    });

final class $$FoodLogsTableReferences
    extends BaseReferences<_$AppDatabase, $FoodLogsTable, FoodLog> {
  $$FoodLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FoodsTable _foodIdTable(_$AppDatabase db) => db.foods.createAlias(
    $_aliasNameGenerator(db.foodLogs.foodId, db.foods.id),
  );

  $$FoodsTableProcessedTableManager get foodId {
    final $_column = $_itemColumn<int>('food_id')!;

    final manager = $$FoodsTableTableManager(
      $_db,
      $_db.foods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_foodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FoodLogsTableFilterComposer
    extends Composer<_$AppDatabase, $FoodLogsTable> {
  $$FoodLogsTableFilterComposer({
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

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantityG => $composableBuilder(
    column: $table.quantityG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get glutenStatus => $composableBuilder(
    column: $table.glutenStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$FoodsTableFilterComposer get foodId {
    final $$FoodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableFilterComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodLogsTable> {
  $$FoodLogsTableOrderingComposer({
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

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantityG => $composableBuilder(
    column: $table.quantityG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get glutenStatus => $composableBuilder(
    column: $table.glutenStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$FoodsTableOrderingComposer get foodId {
    final $$FoodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableOrderingComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodLogsTable> {
  $$FoodLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<double> get quantityG =>
      $composableBuilder(column: $table.quantityG, builder: (column) => column);

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<String> get glutenStatus => $composableBuilder(
    column: $table.glutenStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  $$FoodsTableAnnotationComposer get foodId {
    final $$FoodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableAnnotationComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodLogsTable,
          FoodLog,
          $$FoodLogsTableFilterComposer,
          $$FoodLogsTableOrderingComposer,
          $$FoodLogsTableAnnotationComposer,
          $$FoodLogsTableCreateCompanionBuilder,
          $$FoodLogsTableUpdateCompanionBuilder,
          (FoodLog, $$FoodLogsTableReferences),
          FoodLog,
          PrefetchHooks Function({bool foodId})
        > {
  $$FoodLogsTableTableManager(_$AppDatabase db, $FoodLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<int> foodId = const Value.absent(),
                Value<double> quantityG = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> protein = const Value.absent(),
                Value<double> carbs = const Value.absent(),
                Value<double> fat = const Value.absent(),
                Value<String> glutenStatus = const Value.absent(),
                Value<String> loggedAt = const Value.absent(),
              }) => FoodLogsCompanion(
                id: id,
                date: date,
                mealType: mealType,
                foodId: foodId,
                quantityG: quantityG,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
                glutenStatus: glutenStatus,
                loggedAt: loggedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                required String mealType,
                required int foodId,
                required double quantityG,
                required double calories,
                Value<double> protein = const Value.absent(),
                Value<double> carbs = const Value.absent(),
                Value<double> fat = const Value.absent(),
                Value<String> glutenStatus = const Value.absent(),
                required String loggedAt,
              }) => FoodLogsCompanion.insert(
                id: id,
                date: date,
                mealType: mealType,
                foodId: foodId,
                quantityG: quantityG,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
                glutenStatus: glutenStatus,
                loggedAt: loggedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FoodLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({foodId = false}) {
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
                    if (foodId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.foodId,
                                referencedTable: $$FoodLogsTableReferences
                                    ._foodIdTable(db),
                                referencedColumn: $$FoodLogsTableReferences
                                    ._foodIdTable(db)
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

typedef $$FoodLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodLogsTable,
      FoodLog,
      $$FoodLogsTableFilterComposer,
      $$FoodLogsTableOrderingComposer,
      $$FoodLogsTableAnnotationComposer,
      $$FoodLogsTableCreateCompanionBuilder,
      $$FoodLogsTableUpdateCompanionBuilder,
      (FoodLog, $$FoodLogsTableReferences),
      FoodLog,
      PrefetchHooks Function({bool foodId})
    >;
typedef $$ExercisesTableCreateCompanionBuilder =
    ExercisesCompanion Function({
      Value<int> id,
      required String name,
      required String category,
      required double metValue,
      Value<String?> description,
    });
typedef $$ExercisesTableUpdateCompanionBuilder =
    ExercisesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> category,
      Value<double> metValue,
      Value<String?> description,
    });

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExerciseLogsTable, List<ExerciseLog>>
  _exerciseLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.exerciseLogs,
    aliasName: $_aliasNameGenerator(
      db.exercises.id,
      db.exerciseLogs.exerciseId,
    ),
  );

  $$ExerciseLogsTableProcessedTableManager get exerciseLogsRefs {
    final manager = $$ExerciseLogsTableTableManager(
      $_db,
      $_db.exerciseLogs,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_exerciseLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get metValue => $composableBuilder(
    column: $table.metValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> exerciseLogsRefs(
    Expression<bool> Function($$ExerciseLogsTableFilterComposer f) f,
  ) {
    final $$ExerciseLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exerciseLogs,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseLogsTableFilterComposer(
            $db: $db,
            $table: $db.exerciseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get metValue => $composableBuilder(
    column: $table.metValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get metValue =>
      $composableBuilder(column: $table.metValue, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  Expression<T> exerciseLogsRefs<T extends Object>(
    Expression<T> Function($$ExerciseLogsTableAnnotationComposer a) f,
  ) {
    final $$ExerciseLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exerciseLogs,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.exerciseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, $$ExercisesTableReferences),
          Exercise,
          PrefetchHooks Function({bool exerciseLogsRefs})
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> metValue = const Value.absent(),
                Value<String?> description = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                name: name,
                category: category,
                metValue: metValue,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String category,
                required double metValue,
                Value<String?> description = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                name: name,
                category: category,
                metValue: metValue,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({exerciseLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (exerciseLogsRefs) db.exerciseLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (exerciseLogsRefs)
                    await $_getPrefetchedData<
                      Exercise,
                      $ExercisesTable,
                      ExerciseLog
                    >(
                      currentTable: table,
                      referencedTable: $$ExercisesTableReferences
                          ._exerciseLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ExercisesTableReferences(
                            db,
                            table,
                            p0,
                          ).exerciseLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.exerciseId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, $$ExercisesTableReferences),
      Exercise,
      PrefetchHooks Function({bool exerciseLogsRefs})
    >;
typedef $$ExerciseLogsTableCreateCompanionBuilder =
    ExerciseLogsCompanion Function({
      Value<int> id,
      required String date,
      required int exerciseId,
      required int durationMinutes,
      required double caloriesBurned,
      required String loggedAt,
    });
typedef $$ExerciseLogsTableUpdateCompanionBuilder =
    ExerciseLogsCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<int> exerciseId,
      Value<int> durationMinutes,
      Value<double> caloriesBurned,
      Value<String> loggedAt,
    });

final class $$ExerciseLogsTableReferences
    extends BaseReferences<_$AppDatabase, $ExerciseLogsTable, ExerciseLog> {
  $$ExerciseLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias(
        $_aliasNameGenerator(db.exerciseLogs.exerciseId, db.exercises.id),
      );

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExerciseLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseLogsTable> {
  $$ExerciseLogsTableFilterComposer({
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

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get caloriesBurned => $composableBuilder(
    column: $table.caloriesBurned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseLogsTable> {
  $$ExerciseLogsTableOrderingComposer({
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

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get caloriesBurned => $composableBuilder(
    column: $table.caloriesBurned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseLogsTable> {
  $$ExerciseLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get caloriesBurned => $composableBuilder(
    column: $table.caloriesBurned,
    builder: (column) => column,
  );

  GeneratedColumn<String> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseLogsTable,
          ExerciseLog,
          $$ExerciseLogsTableFilterComposer,
          $$ExerciseLogsTableOrderingComposer,
          $$ExerciseLogsTableAnnotationComposer,
          $$ExerciseLogsTableCreateCompanionBuilder,
          $$ExerciseLogsTableUpdateCompanionBuilder,
          (ExerciseLog, $$ExerciseLogsTableReferences),
          ExerciseLog,
          PrefetchHooks Function({bool exerciseId})
        > {
  $$ExerciseLogsTableTableManager(_$AppDatabase db, $ExerciseLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<double> caloriesBurned = const Value.absent(),
                Value<String> loggedAt = const Value.absent(),
              }) => ExerciseLogsCompanion(
                id: id,
                date: date,
                exerciseId: exerciseId,
                durationMinutes: durationMinutes,
                caloriesBurned: caloriesBurned,
                loggedAt: loggedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                required int exerciseId,
                required int durationMinutes,
                required double caloriesBurned,
                required String loggedAt,
              }) => ExerciseLogsCompanion.insert(
                id: id,
                date: date,
                exerciseId: exerciseId,
                durationMinutes: durationMinutes,
                caloriesBurned: caloriesBurned,
                loggedAt: loggedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExerciseLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({exerciseId = false}) {
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
                    if (exerciseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.exerciseId,
                                referencedTable: $$ExerciseLogsTableReferences
                                    ._exerciseIdTable(db),
                                referencedColumn: $$ExerciseLogsTableReferences
                                    ._exerciseIdTable(db)
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

typedef $$ExerciseLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseLogsTable,
      ExerciseLog,
      $$ExerciseLogsTableFilterComposer,
      $$ExerciseLogsTableOrderingComposer,
      $$ExerciseLogsTableAnnotationComposer,
      $$ExerciseLogsTableCreateCompanionBuilder,
      $$ExerciseLogsTableUpdateCompanionBuilder,
      (ExerciseLog, $$ExerciseLogsTableReferences),
      ExerciseLog,
      PrefetchHooks Function({bool exerciseId})
    >;
typedef $$WaterLogsTableCreateCompanionBuilder =
    WaterLogsCompanion Function({
      Value<int> id,
      required String date,
      required int amountMl,
      required String loggedAt,
    });
typedef $$WaterLogsTableUpdateCompanionBuilder =
    WaterLogsCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<int> amountMl,
      Value<String> loggedAt,
    });

class $$WaterLogsTableFilterComposer
    extends Composer<_$AppDatabase, $WaterLogsTable> {
  $$WaterLogsTableFilterComposer({
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

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMl => $composableBuilder(
    column: $table.amountMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WaterLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $WaterLogsTable> {
  $$WaterLogsTableOrderingComposer({
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

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMl => $composableBuilder(
    column: $table.amountMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WaterLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WaterLogsTable> {
  $$WaterLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get amountMl =>
      $composableBuilder(column: $table.amountMl, builder: (column) => column);

  GeneratedColumn<String> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);
}

class $$WaterLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WaterLogsTable,
          WaterLog,
          $$WaterLogsTableFilterComposer,
          $$WaterLogsTableOrderingComposer,
          $$WaterLogsTableAnnotationComposer,
          $$WaterLogsTableCreateCompanionBuilder,
          $$WaterLogsTableUpdateCompanionBuilder,
          (WaterLog, BaseReferences<_$AppDatabase, $WaterLogsTable, WaterLog>),
          WaterLog,
          PrefetchHooks Function()
        > {
  $$WaterLogsTableTableManager(_$AppDatabase db, $WaterLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WaterLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WaterLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WaterLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> amountMl = const Value.absent(),
                Value<String> loggedAt = const Value.absent(),
              }) => WaterLogsCompanion(
                id: id,
                date: date,
                amountMl: amountMl,
                loggedAt: loggedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                required int amountMl,
                required String loggedAt,
              }) => WaterLogsCompanion.insert(
                id: id,
                date: date,
                amountMl: amountMl,
                loggedAt: loggedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WaterLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WaterLogsTable,
      WaterLog,
      $$WaterLogsTableFilterComposer,
      $$WaterLogsTableOrderingComposer,
      $$WaterLogsTableAnnotationComposer,
      $$WaterLogsTableCreateCompanionBuilder,
      $$WaterLogsTableUpdateCompanionBuilder,
      (WaterLog, BaseReferences<_$AppDatabase, $WaterLogsTable, WaterLog>),
      WaterLog,
      PrefetchHooks Function()
    >;
typedef $$WeightLogsTableCreateCompanionBuilder =
    WeightLogsCompanion Function({
      Value<int> id,
      required String date,
      required double weightKg,
      required String loggedAt,
    });
typedef $$WeightLogsTableUpdateCompanionBuilder =
    WeightLogsCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<double> weightKg,
      Value<String> loggedAt,
    });

class $$WeightLogsTableFilterComposer
    extends Composer<_$AppDatabase, $WeightLogsTable> {
  $$WeightLogsTableFilterComposer({
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

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeightLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightLogsTable> {
  $$WeightLogsTableOrderingComposer({
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

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeightLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightLogsTable> {
  $$WeightLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<String> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);
}

class $$WeightLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeightLogsTable,
          WeightLog,
          $$WeightLogsTableFilterComposer,
          $$WeightLogsTableOrderingComposer,
          $$WeightLogsTableAnnotationComposer,
          $$WeightLogsTableCreateCompanionBuilder,
          $$WeightLogsTableUpdateCompanionBuilder,
          (
            WeightLog,
            BaseReferences<_$AppDatabase, $WeightLogsTable, WeightLog>,
          ),
          WeightLog,
          PrefetchHooks Function()
        > {
  $$WeightLogsTableTableManager(_$AppDatabase db, $WeightLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<String> loggedAt = const Value.absent(),
              }) => WeightLogsCompanion(
                id: id,
                date: date,
                weightKg: weightKg,
                loggedAt: loggedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                required double weightKg,
                required String loggedAt,
              }) => WeightLogsCompanion.insert(
                id: id,
                date: date,
                weightKg: weightKg,
                loggedAt: loggedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeightLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeightLogsTable,
      WeightLog,
      $$WeightLogsTableFilterComposer,
      $$WeightLogsTableOrderingComposer,
      $$WeightLogsTableAnnotationComposer,
      $$WeightLogsTableCreateCompanionBuilder,
      $$WeightLogsTableUpdateCompanionBuilder,
      (WeightLog, BaseReferences<_$AppDatabase, $WeightLogsTable, WeightLog>),
      WeightLog,
      PrefetchHooks Function()
    >;
typedef $$UserProfileTableCreateCompanionBuilder =
    UserProfileCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<String?> dateOfBirth,
      Value<String?> gender,
      Value<double?> heightCm,
      Value<double?> weightKg,
      Value<String?> activityLevel,
      Value<String?> goalType,
      Value<double?> calorieTarget,
      Value<double?> proteinTargetG,
      Value<double?> carbsTargetG,
      Value<double?> fatTargetG,
      Value<int> waterTargetMl,
      Value<int> isGlutenFree,
      Value<int> dbVersion,
      Value<int> onboardingComplete,
    });
typedef $$UserProfileTableUpdateCompanionBuilder =
    UserProfileCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<String?> dateOfBirth,
      Value<String?> gender,
      Value<double?> heightCm,
      Value<double?> weightKg,
      Value<String?> activityLevel,
      Value<String?> goalType,
      Value<double?> calorieTarget,
      Value<double?> proteinTargetG,
      Value<double?> carbsTargetG,
      Value<double?> fatTargetG,
      Value<int> waterTargetMl,
      Value<int> isGlutenFree,
      Value<int> dbVersion,
      Value<int> onboardingComplete,
    });

class $$UserProfileTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calorieTarget => $composableBuilder(
    column: $table.calorieTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinTargetG => $composableBuilder(
    column: $table.proteinTargetG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsTargetG => $composableBuilder(
    column: $table.carbsTargetG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatTargetG => $composableBuilder(
    column: $table.fatTargetG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get waterTargetMl => $composableBuilder(
    column: $table.waterTargetMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isGlutenFree => $composableBuilder(
    column: $table.isGlutenFree,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dbVersion => $composableBuilder(
    column: $table.dbVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calorieTarget => $composableBuilder(
    column: $table.calorieTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinTargetG => $composableBuilder(
    column: $table.proteinTargetG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsTargetG => $composableBuilder(
    column: $table.carbsTargetG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatTargetG => $composableBuilder(
    column: $table.fatTargetG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get waterTargetMl => $composableBuilder(
    column: $table.waterTargetMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isGlutenFree => $composableBuilder(
    column: $table.isGlutenFree,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dbVersion => $composableBuilder(
    column: $table.dbVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableAnnotationComposer({
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

  GeneratedColumn<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goalType =>
      $composableBuilder(column: $table.goalType, builder: (column) => column);

  GeneratedColumn<double> get calorieTarget => $composableBuilder(
    column: $table.calorieTarget,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinTargetG => $composableBuilder(
    column: $table.proteinTargetG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbsTargetG => $composableBuilder(
    column: $table.carbsTargetG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatTargetG => $composableBuilder(
    column: $table.fatTargetG,
    builder: (column) => column,
  );

  GeneratedColumn<int> get waterTargetMl => $composableBuilder(
    column: $table.waterTargetMl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isGlutenFree => $composableBuilder(
    column: $table.isGlutenFree,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dbVersion =>
      $composableBuilder(column: $table.dbVersion, builder: (column) => column);

  GeneratedColumn<int> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => column,
  );
}

class $$UserProfileTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfileTable,
          UserProfileData,
          $$UserProfileTableFilterComposer,
          $$UserProfileTableOrderingComposer,
          $$UserProfileTableAnnotationComposer,
          $$UserProfileTableCreateCompanionBuilder,
          $$UserProfileTableUpdateCompanionBuilder,
          (
            UserProfileData,
            BaseReferences<_$AppDatabase, $UserProfileTable, UserProfileData>,
          ),
          UserProfileData,
          PrefetchHooks Function()
        > {
  $$UserProfileTableTableManager(_$AppDatabase db, $UserProfileTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> dateOfBirth = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<String?> activityLevel = const Value.absent(),
                Value<String?> goalType = const Value.absent(),
                Value<double?> calorieTarget = const Value.absent(),
                Value<double?> proteinTargetG = const Value.absent(),
                Value<double?> carbsTargetG = const Value.absent(),
                Value<double?> fatTargetG = const Value.absent(),
                Value<int> waterTargetMl = const Value.absent(),
                Value<int> isGlutenFree = const Value.absent(),
                Value<int> dbVersion = const Value.absent(),
                Value<int> onboardingComplete = const Value.absent(),
              }) => UserProfileCompanion(
                id: id,
                name: name,
                dateOfBirth: dateOfBirth,
                gender: gender,
                heightCm: heightCm,
                weightKg: weightKg,
                activityLevel: activityLevel,
                goalType: goalType,
                calorieTarget: calorieTarget,
                proteinTargetG: proteinTargetG,
                carbsTargetG: carbsTargetG,
                fatTargetG: fatTargetG,
                waterTargetMl: waterTargetMl,
                isGlutenFree: isGlutenFree,
                dbVersion: dbVersion,
                onboardingComplete: onboardingComplete,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> dateOfBirth = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<String?> activityLevel = const Value.absent(),
                Value<String?> goalType = const Value.absent(),
                Value<double?> calorieTarget = const Value.absent(),
                Value<double?> proteinTargetG = const Value.absent(),
                Value<double?> carbsTargetG = const Value.absent(),
                Value<double?> fatTargetG = const Value.absent(),
                Value<int> waterTargetMl = const Value.absent(),
                Value<int> isGlutenFree = const Value.absent(),
                Value<int> dbVersion = const Value.absent(),
                Value<int> onboardingComplete = const Value.absent(),
              }) => UserProfileCompanion.insert(
                id: id,
                name: name,
                dateOfBirth: dateOfBirth,
                gender: gender,
                heightCm: heightCm,
                weightKg: weightKg,
                activityLevel: activityLevel,
                goalType: goalType,
                calorieTarget: calorieTarget,
                proteinTargetG: proteinTargetG,
                carbsTargetG: carbsTargetG,
                fatTargetG: fatTargetG,
                waterTargetMl: waterTargetMl,
                isGlutenFree: isGlutenFree,
                dbVersion: dbVersion,
                onboardingComplete: onboardingComplete,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfileTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfileTable,
      UserProfileData,
      $$UserProfileTableFilterComposer,
      $$UserProfileTableOrderingComposer,
      $$UserProfileTableAnnotationComposer,
      $$UserProfileTableCreateCompanionBuilder,
      $$UserProfileTableUpdateCompanionBuilder,
      (
        UserProfileData,
        BaseReferences<_$AppDatabase, $UserProfileTable, UserProfileData>,
      ),
      UserProfileData,
      PrefetchHooks Function()
    >;
typedef $$MetadataTableCreateCompanionBuilder =
    MetadataCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$MetadataTableUpdateCompanionBuilder =
    MetadataCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$MetadataTableFilterComposer
    extends Composer<_$AppDatabase, $MetadataTable> {
  $$MetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $MetadataTable> {
  $$MetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $MetadataTable> {
  $$MetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$MetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MetadataTable,
          MetadataData,
          $$MetadataTableFilterComposer,
          $$MetadataTableOrderingComposer,
          $$MetadataTableAnnotationComposer,
          $$MetadataTableCreateCompanionBuilder,
          $$MetadataTableUpdateCompanionBuilder,
          (
            MetadataData,
            BaseReferences<_$AppDatabase, $MetadataTable, MetadataData>,
          ),
          MetadataData,
          PrefetchHooks Function()
        > {
  $$MetadataTableTableManager(_$AppDatabase db, $MetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MetadataCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => MetadataCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MetadataTable,
      MetadataData,
      $$MetadataTableFilterComposer,
      $$MetadataTableOrderingComposer,
      $$MetadataTableAnnotationComposer,
      $$MetadataTableCreateCompanionBuilder,
      $$MetadataTableUpdateCompanionBuilder,
      (
        MetadataData,
        BaseReferences<_$AppDatabase, $MetadataTable, MetadataData>,
      ),
      MetadataData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FoodsTableTableManager get foods =>
      $$FoodsTableTableManager(_db, _db.foods);
  $$FoodLogsTableTableManager get foodLogs =>
      $$FoodLogsTableTableManager(_db, _db.foodLogs);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$ExerciseLogsTableTableManager get exerciseLogs =>
      $$ExerciseLogsTableTableManager(_db, _db.exerciseLogs);
  $$WaterLogsTableTableManager get waterLogs =>
      $$WaterLogsTableTableManager(_db, _db.waterLogs);
  $$WeightLogsTableTableManager get weightLogs =>
      $$WeightLogsTableTableManager(_db, _db.weightLogs);
  $$UserProfileTableTableManager get userProfile =>
      $$UserProfileTableTableManager(_db, _db.userProfile);
  $$MetadataTableTableManager get metadata =>
      $$MetadataTableTableManager(_db, _db.metadata);
}
