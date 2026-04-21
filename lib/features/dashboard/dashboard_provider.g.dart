// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayHash() => r'2a8c40ad2be1076c8f277be525213857251795c0';

/// See also [today].
@ProviderFor(today)
final todayProvider = AutoDisposeProvider<String>.internal(
  today,
  name: r'todayProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayRef = AutoDisposeProviderRef<String>;
String _$dashboardHash() => r'6be2760e9d8ab8af22b282bb6f1de5e1a76fb5a0';

/// See also [dashboard].
@ProviderFor(dashboard)
final dashboardProvider = AutoDisposeStreamProvider<DashboardData>.internal(
  dashboard,
  name: r'dashboardProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardRef = AutoDisposeStreamProviderRef<DashboardData>;
String _$todayWaterMlHash() => r'8590a68f3b91e75a2c7f1fdc311af87cd0ca7421';

/// See also [todayWaterMl].
@ProviderFor(todayWaterMl)
final todayWaterMlProvider = AutoDisposeStreamProvider<int>.internal(
  todayWaterMl,
  name: r'todayWaterMlProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayWaterMlHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayWaterMlRef = AutoDisposeStreamProviderRef<int>;
String _$dashboardDateNotifierHash() =>
    r'aadcdcd17e7e0b144bfe0b34463c6d1919b3e501';

/// See also [DashboardDateNotifier].
@ProviderFor(DashboardDateNotifier)
final dashboardDateNotifierProvider =
    AutoDisposeNotifierProvider<DashboardDateNotifier, String>.internal(
      DashboardDateNotifier.new,
      name: r'dashboardDateNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dashboardDateNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DashboardDateNotifier = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
