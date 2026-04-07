// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$waterLogsHash() => r'c022252073d981015482dfbf2aec2c513898c434';

/// See also [waterLogs].
@ProviderFor(waterLogs)
final waterLogsProvider = AutoDisposeStreamProvider<List<WaterLog>>.internal(
  waterLogs,
  name: r'waterLogsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$waterLogsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WaterLogsRef = AutoDisposeStreamProviderRef<List<WaterLog>>;
String _$waterNotifierHash() => r'ba2f8b318ef5823c95ff8e795b18a87930940586';

/// See also [WaterNotifier].
@ProviderFor(WaterNotifier)
final waterNotifierProvider =
    AutoDisposeNotifierProvider<WaterNotifier, bool>.internal(
      WaterNotifier.new,
      name: r'waterNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$waterNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WaterNotifier = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
