// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class Foods extends Table with TableInfo<Foods, FoodsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Foods(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> caloriesPer100g = GeneratedColumn<double>(
    'calories_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> proteinPer100g = GeneratedColumn<double>(
    'protein_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('0.0'),
  );
  late final GeneratedColumn<double> carbsPer100g = GeneratedColumn<double>(
    'carbs_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('0.0'),
  );
  late final GeneratedColumn<double> fatPer100g = GeneratedColumn<double>(
    'fat_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('0.0'),
  );
  late final GeneratedColumn<double> fiberPer100g = GeneratedColumn<double>(
    'fiber_per100g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<double> sugarPer100g = GeneratedColumn<double>(
    'sugar_per100g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<double> sodiumPer100mg = GeneratedColumn<double>(
    'sodium_per100mg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<double> defaultServingG = GeneratedColumn<double>(
    'default_serving_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('100.0'),
  );
  late final GeneratedColumn<String> servingDescription =
      GeneratedColumn<String>(
        'serving_description',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  late final GeneratedColumn<int> isGlutenFree = GeneratedColumn<int>(
    'is_gluten_free',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('0'),
  );
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
  late final GeneratedColumn<int> isCustom = GeneratedColumn<int>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('0'),
  );
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodsData(
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
  Foods createAlias(String alias) {
    return Foods(attachedDatabase, alias);
  }
}

class FoodsData extends DataClass implements Insertable<FoodsData> {
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
  final String? seedKey;
  const FoodsData({
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

  factory FoodsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodsData(
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

  FoodsData copyWith({
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
  }) => FoodsData(
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
  FoodsData copyWithCompanion(FoodsCompanion data) {
    return FoodsData(
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
    return (StringBuffer('FoodsData(')
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
      (other is FoodsData &&
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

class FoodsCompanion extends UpdateCompanion<FoodsData> {
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
  static Insertable<FoodsData> custom({
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

class FoodLogs extends Table with TableInfo<FoodLogs, FoodLogsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  FoodLogs(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK(meal_type IN (\'breakfast\',\'lunch\',\'dinner\',\'snacks\'))',
  );
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
  late final GeneratedColumn<double> quantityG = GeneratedColumn<double>(
    'quantity_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
    'protein',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('0.0'),
  );
  late final GeneratedColumn<double> carbs = GeneratedColumn<double>(
    'carbs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('0.0'),
  );
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
    'fat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('0.0'),
  );
  late final GeneratedColumn<String> glutenStatus = GeneratedColumn<String>(
    'gluten_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('\'unknown\''),
  );
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodLogsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodLogsData(
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
  FoodLogs createAlias(String alias) {
    return FoodLogs(attachedDatabase, alias);
  }
}

class FoodLogsData extends DataClass implements Insertable<FoodLogsData> {
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
  const FoodLogsData({
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

  factory FoodLogsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodLogsData(
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

  FoodLogsData copyWith({
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
  }) => FoodLogsData(
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
  FoodLogsData copyWithCompanion(FoodLogsCompanion data) {
    return FoodLogsData(
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
    return (StringBuffer('FoodLogsData(')
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
      (other is FoodLogsData &&
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

class FoodLogsCompanion extends UpdateCompanion<FoodLogsData> {
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
  static Insertable<FoodLogsData> custom({
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

class Exercises extends Table with TableInfo<Exercises, ExercisesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Exercises(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> metValue = GeneratedColumn<double>(
    'met_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExercisesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExercisesData(
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
  Exercises createAlias(String alias) {
    return Exercises(attachedDatabase, alias);
  }
}

class ExercisesData extends DataClass implements Insertable<ExercisesData> {
  final int id;
  final String name;
  final String category;
  final double metValue;
  final String? description;
  const ExercisesData({
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

  factory ExercisesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExercisesData(
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

  ExercisesData copyWith({
    int? id,
    String? name,
    String? category,
    double? metValue,
    Value<String?> description = const Value.absent(),
  }) => ExercisesData(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    metValue: metValue ?? this.metValue,
    description: description.present ? description.value : this.description,
  );
  ExercisesData copyWithCompanion(ExercisesCompanion data) {
    return ExercisesData(
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
    return (StringBuffer('ExercisesData(')
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
      (other is ExercisesData &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.metValue == this.metValue &&
          other.description == this.description);
}

class ExercisesCompanion extends UpdateCompanion<ExercisesData> {
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
  static Insertable<ExercisesData> custom({
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

class ExerciseLogs extends Table
    with TableInfo<ExerciseLogs, ExerciseLogsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ExerciseLogs(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
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
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> caloriesBurned = GeneratedColumn<double>(
    'calories_burned',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseLogsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseLogsData(
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
  ExerciseLogs createAlias(String alias) {
    return ExerciseLogs(attachedDatabase, alias);
  }
}

class ExerciseLogsData extends DataClass
    implements Insertable<ExerciseLogsData> {
  final int id;
  final String date;
  final int exerciseId;
  final int durationMinutes;
  final double caloriesBurned;
  final String loggedAt;
  const ExerciseLogsData({
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

  factory ExerciseLogsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseLogsData(
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

  ExerciseLogsData copyWith({
    int? id,
    String? date,
    int? exerciseId,
    int? durationMinutes,
    double? caloriesBurned,
    String? loggedAt,
  }) => ExerciseLogsData(
    id: id ?? this.id,
    date: date ?? this.date,
    exerciseId: exerciseId ?? this.exerciseId,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    caloriesBurned: caloriesBurned ?? this.caloriesBurned,
    loggedAt: loggedAt ?? this.loggedAt,
  );
  ExerciseLogsData copyWithCompanion(ExerciseLogsCompanion data) {
    return ExerciseLogsData(
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
    return (StringBuffer('ExerciseLogsData(')
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
      (other is ExerciseLogsData &&
          other.id == this.id &&
          other.date == this.date &&
          other.exerciseId == this.exerciseId &&
          other.durationMinutes == this.durationMinutes &&
          other.caloriesBurned == this.caloriesBurned &&
          other.loggedAt == this.loggedAt);
}

class ExerciseLogsCompanion extends UpdateCompanion<ExerciseLogsData> {
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
  static Insertable<ExerciseLogsData> custom({
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

class WaterLogs extends Table with TableInfo<WaterLogs, WaterLogsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  WaterLogs(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<int> amountMl = GeneratedColumn<int>(
    'amount_ml',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WaterLogsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaterLogsData(
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
  WaterLogs createAlias(String alias) {
    return WaterLogs(attachedDatabase, alias);
  }
}

class WaterLogsData extends DataClass implements Insertable<WaterLogsData> {
  final int id;
  final String date;
  final int amountMl;
  final String loggedAt;
  const WaterLogsData({
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

  factory WaterLogsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterLogsData(
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

  WaterLogsData copyWith({
    int? id,
    String? date,
    int? amountMl,
    String? loggedAt,
  }) => WaterLogsData(
    id: id ?? this.id,
    date: date ?? this.date,
    amountMl: amountMl ?? this.amountMl,
    loggedAt: loggedAt ?? this.loggedAt,
  );
  WaterLogsData copyWithCompanion(WaterLogsCompanion data) {
    return WaterLogsData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      amountMl: data.amountMl.present ? data.amountMl.value : this.amountMl,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WaterLogsData(')
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
      (other is WaterLogsData &&
          other.id == this.id &&
          other.date == this.date &&
          other.amountMl == this.amountMl &&
          other.loggedAt == this.loggedAt);
}

class WaterLogsCompanion extends UpdateCompanion<WaterLogsData> {
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
  static Insertable<WaterLogsData> custom({
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

class WeightLogs extends Table with TableInfo<WeightLogs, WeightLogsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  WeightLogs(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightLogsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightLogsData(
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
  WeightLogs createAlias(String alias) {
    return WeightLogs(attachedDatabase, alias);
  }
}

class WeightLogsData extends DataClass implements Insertable<WeightLogsData> {
  final int id;
  final String date;
  final double weightKg;
  final String loggedAt;
  const WeightLogsData({
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

  factory WeightLogsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightLogsData(
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

  WeightLogsData copyWith({
    int? id,
    String? date,
    double? weightKg,
    String? loggedAt,
  }) => WeightLogsData(
    id: id ?? this.id,
    date: date ?? this.date,
    weightKg: weightKg ?? this.weightKg,
    loggedAt: loggedAt ?? this.loggedAt,
  );
  WeightLogsData copyWithCompanion(WeightLogsCompanion data) {
    return WeightLogsData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightLogsData(')
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
      (other is WeightLogsData &&
          other.id == this.id &&
          other.date == this.date &&
          other.weightKg == this.weightKg &&
          other.loggedAt == this.loggedAt);
}

class WeightLogsCompanion extends UpdateCompanion<WeightLogsData> {
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
  static Insertable<WeightLogsData> custom({
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

class UserProfile extends Table with TableInfo<UserProfile, UserProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  UserProfile(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('1'),
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> dateOfBirth = GeneratedColumn<String>(
    'date_of_birth',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK(gender IN (\'male\',\'female\',\'other\'))',
  );
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> activityLevel = GeneratedColumn<String>(
    'activity_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK(activity_level IN (\'sedentary\',\'lightly_active\',\'moderately_active\',\'very_active\'))',
  );
  late final GeneratedColumn<String> goalType = GeneratedColumn<String>(
    'goal_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK(goal_type IN (\'lose\',\'maintain\',\'gain\'))',
  );
  late final GeneratedColumn<double> calorieTarget = GeneratedColumn<double>(
    'calorie_target',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<double> proteinTargetG = GeneratedColumn<double>(
    'protein_target_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<double> carbsTargetG = GeneratedColumn<double>(
    'carbs_target_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<double> fatTargetG = GeneratedColumn<double>(
    'fat_target_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<int> waterTargetMl = GeneratedColumn<int>(
    'water_target_ml',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('2000'),
  );
  late final GeneratedColumn<int> isGlutenFree = GeneratedColumn<int>(
    'is_gluten_free',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('1'),
  );
  late final GeneratedColumn<int> dbVersion = GeneratedColumn<int>(
    'db_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('1'),
  );
  late final GeneratedColumn<int> onboardingComplete = GeneratedColumn<int>(
    'onboarding_complete',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('0'),
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
  UserProfile createAlias(String alias) {
    return UserProfile(attachedDatabase, alias);
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

class Metadata extends Table with TableInfo<Metadata, MetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Metadata(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
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
  Metadata createAlias(String alias) {
    return Metadata(attachedDatabase, alias);
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

class DatabaseAtV2 extends GeneratedDatabase {
  DatabaseAtV2(QueryExecutor e) : super(e);
  late final Foods foods = Foods(this);
  late final FoodLogs foodLogs = FoodLogs(this);
  late final Exercises exercises = Exercises(this);
  late final ExerciseLogs exerciseLogs = ExerciseLogs(this);
  late final WaterLogs waterLogs = WaterLogs(this);
  late final WeightLogs weightLogs = WeightLogs(this);
  late final UserProfile userProfile = UserProfile(this);
  late final Metadata metadata = Metadata(this);
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
  @override
  int get schemaVersion => 2;
}
