// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$weightLogsHash() => r'aaedb3eb20150bd2cdecf904ff6a0ccee78b37c8';

/// See also [weightLogs].
@ProviderFor(weightLogs)
final weightLogsProvider = AutoDisposeStreamProvider<List<WeightLog>>.internal(
  weightLogs,
  name: r'weightLogsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weightLogsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeightLogsRef = AutoDisposeStreamProviderRef<List<WeightLog>>;
String _$weightNotifierHash() => r'8fc29f211acda3c29a9b8f46954c0b7fd6325fe6';

/// See also [WeightNotifier].
@ProviderFor(WeightNotifier)
final weightNotifierProvider =
    AutoDisposeNotifierProvider<WeightNotifier, bool>.internal(
      WeightNotifier.new,
      name: r'weightNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$weightNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WeightNotifier = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
