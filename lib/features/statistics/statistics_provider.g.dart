// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$statisticsDataHash() => r'8671eea626385e771feae6bc154fbfe7c9696370';

/// Main statistics computation. Re-runs whenever the period changes.
///
/// Copied from [statisticsData].
@ProviderFor(statisticsData)
final statisticsDataProvider =
    AutoDisposeFutureProvider<StatisticsState>.internal(
      statisticsData,
      name: r'statisticsDataProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$statisticsDataHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StatisticsDataRef = AutoDisposeFutureProviderRef<StatisticsState>;
String _$statisticsPeriodHash() => r'a487668e8b343f06ff0db3d36fd82688659081fb';

/// Period selector. Resets to [StatPeriod.d7] every time the screen opens
/// (default build() value), as per spec: "not persisted between sessions".
///
/// Copied from [StatisticsPeriod].
@ProviderFor(StatisticsPeriod)
final statisticsPeriodProvider =
    AutoDisposeNotifierProvider<StatisticsPeriod, StatPeriod>.internal(
      StatisticsPeriod.new,
      name: r'statisticsPeriodProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$statisticsPeriodHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$StatisticsPeriod = AutoDisposeNotifier<StatPeriod>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
