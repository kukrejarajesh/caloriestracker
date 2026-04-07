// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$historyDataHash() => r'cce417a7ce8b4b74eb1022ed6e62af03505551de';

/// See also [historyData].
@ProviderFor(historyData)
final historyDataProvider = AutoDisposeStreamProvider<DashboardData>.internal(
  historyData,
  name: r'historyDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$historyDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HistoryDataRef = AutoDisposeStreamProviderRef<DashboardData>;
String _$historyWaterMlHash() => r'b27362ea52822707512ed18d5533b483ae708896';

/// See also [historyWaterMl].
@ProviderFor(historyWaterMl)
final historyWaterMlProvider = AutoDisposeStreamProvider<int>.internal(
  historyWaterMl,
  name: r'historyWaterMlProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$historyWaterMlHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HistoryWaterMlRef = AutoDisposeStreamProviderRef<int>;
String _$historyDateHash() => r'e0d39c8aad5cb0fea0219f8bc95d8dc9a607ebd0';

/// See also [HistoryDate].
@ProviderFor(HistoryDate)
final historyDateProvider =
    AutoDisposeNotifierProvider<HistoryDate, String>.internal(
      HistoryDate.new,
      name: r'historyDateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$historyDateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$HistoryDate = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
