// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_log_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$foodSearchHash() => r'54f3d6947f3df0d18119e10bc6cc2b98a5218db4';

/// See also [foodSearch].
@ProviderFor(foodSearch)
final foodSearchProvider = AutoDisposeFutureProvider<List<Food>>.internal(
  foodSearch,
  name: r'foodSearchProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$foodSearchHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FoodSearchRef = AutoDisposeFutureProviderRef<List<Food>>;
String _$glutenFilterNotifierHash() =>
    r'062e3cfd8e13363178369dab434c027c9a5d1412';

/// See also [GlutenFilterNotifier].
@ProviderFor(GlutenFilterNotifier)
final glutenFilterNotifierProvider =
    AutoDisposeNotifierProvider<GlutenFilterNotifier, bool>.internal(
      GlutenFilterNotifier.new,
      name: r'glutenFilterNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$glutenFilterNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GlutenFilterNotifier = AutoDisposeNotifier<bool>;
String _$searchQueryNotifierHash() =>
    r'161a8163997686d502421f62455807d8b1f526f9';

/// See also [SearchQueryNotifier].
@ProviderFor(SearchQueryNotifier)
final searchQueryNotifierProvider =
    AutoDisposeNotifierProvider<SearchQueryNotifier, String>.internal(
      SearchQueryNotifier.new,
      name: r'searchQueryNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$searchQueryNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchQueryNotifier = AutoDisposeNotifier<String>;
String _$mealTypeNotifierHash() => r'4018d29ec569a9ff20ba6ab6c82abd94a35dc5c2';

/// See also [MealTypeNotifier].
@ProviderFor(MealTypeNotifier)
final mealTypeNotifierProvider =
    AutoDisposeNotifierProvider<MealTypeNotifier, String>.internal(
      MealTypeNotifier.new,
      name: r'mealTypeNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mealTypeNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MealTypeNotifier = AutoDisposeNotifier<String>;
String _$foodLogNotifierHash() => r'c1f50251c34a27118369feb5a397e48a754aecf8';

/// See also [FoodLogNotifier].
@ProviderFor(FoodLogNotifier)
final foodLogNotifierProvider =
    AutoDisposeNotifierProvider<FoodLogNotifier, FoodLogState>.internal(
      FoodLogNotifier.new,
      name: r'foodLogNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$foodLogNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FoodLogNotifier = AutoDisposeNotifier<FoodLogState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
