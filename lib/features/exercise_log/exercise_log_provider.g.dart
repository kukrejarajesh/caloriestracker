// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_log_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exerciseSearchHash() => r'4964f2111a38ea78da0401f158c2e6c2c8acb90b';

/// See also [exerciseSearch].
@ProviderFor(exerciseSearch)
final exerciseSearchProvider =
    AutoDisposeFutureProvider<List<Exercise>>.internal(
      exerciseSearch,
      name: r'exerciseSearchProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$exerciseSearchHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExerciseSearchRef = AutoDisposeFutureProviderRef<List<Exercise>>;
String _$exerciseSearchQueryHash() =>
    r'dd681493baa521fcc5ef774c5e97bb5f6ad9beef';

/// See also [ExerciseSearchQuery].
@ProviderFor(ExerciseSearchQuery)
final exerciseSearchQueryProvider =
    AutoDisposeNotifierProvider<ExerciseSearchQuery, String>.internal(
      ExerciseSearchQuery.new,
      name: r'exerciseSearchQueryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$exerciseSearchQueryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExerciseSearchQuery = AutoDisposeNotifier<String>;
String _$exerciseLogNotifierHash() =>
    r'510c58d3907fbe343748b02f3938ad9de4a893e9';

/// See also [ExerciseLogNotifier].
@ProviderFor(ExerciseLogNotifier)
final exerciseLogNotifierProvider =
    AutoDisposeNotifierProvider<ExerciseLogNotifier, ExerciseLogState>.internal(
      ExerciseLogNotifier.new,
      name: r'exerciseLogNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$exerciseLogNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExerciseLogNotifier = AutoDisposeNotifier<ExerciseLogState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
