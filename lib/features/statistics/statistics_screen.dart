import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'statistics_provider.dart';

// ── Colour constants (spec-specified, Statistics-only) ────────────────────────

const _kGreen = Color(0xFF388E3C);
const _kAmber = Color(0xFFFF9800);
const _kRed = Color(0xFFE53935);
const _kBlue = Color(0xFF90CAF9);
const _kGrey = Color(0xFFE0E0E0);
const _kPrimaryDark = Color(0xFF1B5E20);

const _kProteinColor = Color(0xFF1565C0);
const _kCarbsColor = Color(0xFFFF8F00);
const _kFatColor = Color(0xFFE53935);

// ── Root screen ───────────────────────────────────────────────────────────────

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _StatisticsHeader(),
          Expanded(child: _StatisticsBody()),
        ],
      ),
    );
  }
}

// ── Header (green, fixed) ─────────────────────────────────────────────────────

class _StatisticsHeader extends ConsumerWidget {
  const _StatisticsHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(statisticsPeriodProvider);

    return Container(
      color: _kPrimaryDark,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Statistics',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 10),
              _PeriodToggle(current: period),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Period toggle ─────────────────────────────────────────────────────────────

class _PeriodToggle extends ConsumerWidget {
  const _PeriodToggle({required this.current});
  final StatPeriod current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(38), // 15% opacity
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: StatPeriod.values.map((p) {
          final isActive = p == current;
          return GestureDetector(
            onTap: () => ref.read(statisticsPeriodProvider.notifier).set(p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                p.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? _kPrimaryDark
                      : Colors.white.withAlpha(178), // 70% opacity
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Scrollable body ───────────────────────────────────────────────────────────

class _StatisticsBody extends ConsumerWidget {
  const _StatisticsBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statisticsDataProvider);

    return statsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (state) => ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        children: [
          // Card row: Streak + Days on Target
          Row(
            children: [
              Expanded(child: _StreakCard(state: state)),
              const SizedBox(width: 10),
              Expanded(child: _DaysOnTargetCard(state: state)),
            ],
          ),
          const SizedBox(height: 10),
          _CalorieChartCard(state: state),
          const SizedBox(height: 10),
          _MacroDonutCard(state: state),
        ],
      ),
    );
  }
}

// ── Mini card shell ───────────────────────────────────────────────────────────

class _MiniCard extends StatelessWidget {
  const _MiniCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: child,
    );
  }
}

// ── Full card shell ───────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.grey[600],
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

// ── Streak card ───────────────────────────────────────────────────────────────

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.state});
  final StatisticsState state;

  @override
  Widget build(BuildContext context) {
    final streak = state.currentStreak;
    final best = state.personalBest;
    final isNew = streak == 0 && best == 0;

    return _MiniCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 22)),
          const SizedBox(height: 2),
          Text(
            '$streak',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: _kPrimaryDark,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Day streak',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            isNew
                ? 'Start logging today!'
                : 'Personal best: $best days',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: isNew ? Colors.grey[500] : _kGreen,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Days on Target card ───────────────────────────────────────────────────────

class _DaysOnTargetCard extends StatelessWidget {
  const _DaysOnTargetCard({required this.state});
  final StatisticsState state;

  @override
  Widget build(BuildContext context) {
    final dots = state.dotStatuses;
    final y = state.loggedDays.length;
    final x = state.daysOnTarget;
    final is7d = state.period == StatPeriod.d7;

    return _MiniCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎯', style: TextStyle(fontSize: 22)),
          const SizedBox(height: 2),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$x',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: _kPrimaryDark,
                  ),
                ),
                TextSpan(
                  text: '/$y',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Days on target',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          if (is7d)
            _DotRow(dots: dots)
          else
            _ProgressBar(pct: state.onTargetPct),
        ],
      ),
    );
  }
}

class _DotRow extends StatelessWidget {
  const _DotRow({required this.dots});
  final List<DotStatus> dots;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 3,
      alignment: WrapAlignment.center,
      children: dots.map((s) {
        final Color fill;
        final Color border;
        switch (s) {
          case DotStatus.hit:
            fill = _kGreen;
            border = _kGreen;
          case DotStatus.miss:
            fill = const Color(0xFFEF9A9A);
            border = _kRed;
          case DotStatus.noLog:
            fill = const Color(0xFFE8F5E9);
            border = const Color(0xFFA5D6A7);
        }
        return Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: fill,
            shape: BoxShape.circle,
            border: Border.all(color: border, width: 1.5),
          ),
        );
      }).toList(),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.pct});
  final double pct;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: SizedBox(
            height: 6,
            child: LinearProgressIndicator(
              value: pct / 100,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(_kGreen),
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '${pct.round()}% on target',
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: _kGreen,
          ),
        ),
      ],
    );
  }
}

// ── Calorie bar chart card ────────────────────────────────────────────────────

class _CalorieChartCard extends StatelessWidget {
  const _CalorieChartCard({required this.state});
  final StatisticsState state;

  static const _kDayLabels = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  Color _barColor(double cal, double target) {
    if (target == 0) return _kGreen;
    final ratio = cal / target;
    if (ratio < 0.85) return _kBlue;
    if (ratio <= 1.02) return _kGreen;
    if (ratio <= 1.10) return _kAmber;
    return _kRed;
  }

  String _dayLabel(String date) {
    final d = DateTime.tryParse(date);
    if (d == null) return '';
    return _kDayLabels[d.weekday - 1];
  }

  String _valLabel(double cal) {
    if (cal >= 1000) return '${(cal / 1000).toStringAsFixed(1)}k';
    return cal.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    final days = state.dayStats;
    final target = state.calorieTarget;
    final is30d = state.period == StatPeriod.d30;
    final is14d = state.period == StatPeriod.d14;
    final loggedDays = state.loggedDays;
    final avg = state.avgCalories;

    // Compute max Y for scaling (at least 110% of target).
    double maxY = target * 1.15;
    for (final d in days) {
      if (d.isLogged && d.calories > maxY) maxY = d.calories * 1.05;
    }
    if (maxY == 0) maxY = 2500;

    final barGroups = <BarChartGroupData>[];
    for (int i = 0; i < days.length; i++) {
      final d = days[i];
      final color = d.isLogged ? _barColor(d.calories, target) : _kGrey;
      // Not-logged bars: tiny stub (40 kcal height so it's visible).
      final toY = d.isLogged ? d.calories : 40.0;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: toY,
              color: color,
              width: is30d ? 6 : 12,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
              rodStackItems: const [],
            ),
          ],
        ),
      );
    }

    // Bottom axis labels (day abbreviations).
    Widget getBottomTitle(double value, TitleMeta meta) {
      final i = value.toInt();
      if (i < 0 || i >= days.length) return const SizedBox.shrink();
      if (is30d) return const SizedBox.shrink();
      if (is14d && i % 2 != 0) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          _dayLabel(days[i].date),
          style: TextStyle(
              fontSize: 9,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600),
        ),
      );
    }

    // Top axis labels (value above each bar — hidden for 30D and unlogged).
    Widget getTopTitle(double value, TitleMeta meta) {
      final i = value.toInt();
      if (i < 0 || i >= days.length) return const SizedBox.shrink();
      if (is30d) return const SizedBox.shrink();
      final d = days[i];
      if (!d.isLogged) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          _valLabel(d.calories),
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w700,
            color: Color(0xFF616161),
          ),
        ),
      );
    }

    final chart = SizedBox(
      height: 130,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          minY: 0,
          barGroups: barGroups,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 16,
                getTitlesWidget: getTopTitle,
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: getBottomTitle,
              ),
            ),
          ),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: target,
                color: _kRed,
                strokeWidth: 1.5,
                dashArray: [4, 4],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.centerRight,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: _kRed,
                  ),
                  labelResolver: (line) => '${target.toInt()}',
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Legend
    const legend = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendChip(color: _kGreen, label: 'On target'),
        SizedBox(width: 10),
        _LegendChip(color: _kAmber, label: 'Slightly over'),
        SizedBox(width: 10),
        _LegendChip(color: _kRed, label: 'Over goal'),
        SizedBox(width: 10),
        _LegendChip(color: _kBlue, label: 'Under'),
      ],
    );

    // Average pill
    final avgText = loggedDays.isEmpty
        ? 'No data yet'
        : '⌀ Avg: ${_formatKcal(avg)} kcal/day';
    final avgPill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        avgText,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: _kPrimaryDark,
        ),
      ),
    );

    return _Card(
      title: 'DAILY CALORIES',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          chart,
          const SizedBox(height: 8),
          legend,
          const SizedBox(height: 6),
          Center(child: avgPill),
        ],
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

// ── Macro donut card ──────────────────────────────────────────────────────────

class _MacroDonutCard extends StatelessWidget {
  const _MacroDonutCard({required this.state});
  final StatisticsState state;

  @override
  Widget build(BuildContext context) {
    final period = state.period;
    final periodLabel =
        period == StatPeriod.d7 ? '7 Days' : period == StatPeriod.d14 ? '14 Days' : '30 Days';

    final loggedCount = state.loggedDays.length;

    return _Card(
      title: 'AVERAGE MACRO SPLIT · $periodLabel',
      child: loggedCount < 2
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'Log at least 2 days to see your macro split.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            )
          : _MacroDonutContent(state: state),
    );
  }
}

class _MacroDonutContent extends StatelessWidget {
  const _MacroDonutContent({required this.state});
  final StatisticsState state;

  @override
  Widget build(BuildContext context) {
    final avgCal = state.avgCalories;
    final avgP = state.avgProtein;
    final avgC = state.avgCarbs;
    final avgF = state.avgFat;

    // Derive percentages from macros (4/4/9 kcal-per-gram).
    final totalMacroKcal = avgP * 4 + avgC * 4 + avgF * 9;
    final pPct = totalMacroKcal > 0 ? (avgP * 4 / totalMacroKcal * 100) : 0.0;
    final cPct = totalMacroKcal > 0 ? (avgC * 4 / totalMacroKcal * 100) : 0.0;
    final fPct = totalMacroKcal > 0 ? (avgF * 9 / totalMacroKcal * 100) : 0.0;

    // Target split from profile grams.
    final profile = state.profile;
    final calTarget = state.calorieTarget;
    final pTarget = profile?.proteinTargetG;
    final cTarget = profile?.carbsTargetG;
    final fTarget = profile?.fatTargetG;

    String targetSplit;
    if (pTarget != null && cTarget != null && fTarget != null && calTarget > 0) {
      final tP = (pTarget * 4 / calTarget * 100).round();
      final tC = (cTarget * 4 / calTarget * 100).round();
      final tF = (fTarget * 9 / calTarget * 100).round();
      targetSplit = 'P $tP% · C $tC% · F $tF%';
    } else {
      targetSplit = 'P --% · C --% · F --%';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Donut
        SizedBox(
          width: 90,
          height: 90,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: pPct > 0 ? pPct : 0.001,
                      color: _kProteinColor,
                      radius: 18,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      value: cPct > 0 ? cPct : 0.001,
                      color: _kCarbsColor,
                      radius: 18,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      value: fPct > 0 ? fPct : 0.001,
                      color: _kFatColor,
                      radius: 18,
                      showTitle: false,
                    ),
                  ],
                  centerSpaceRadius: 27,
                  startDegreeOffset: -90,
                  sectionsSpace: 1.5,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatKcal(avgCal),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF212121),
                      height: 1.1,
                    ),
                  ),
                  Text(
                    'avg kcal',
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        // Legend
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MacroLegendRow(
                color: _kProteinColor,
                name: 'Protein',
                grams: avgP,
                pct: pPct,
              ),
              const SizedBox(height: 7),
              _MacroLegendRow(
                color: _kCarbsColor,
                name: 'Carbs',
                grams: avgC,
                pct: cPct,
              ),
              const SizedBox(height: 7),
              _MacroLegendRow(
                color: _kFatColor,
                name: 'Fat',
                grams: avgF,
                pct: fPct,
              ),
              const SizedBox(height: 6),
              Divider(height: 1, color: Colors.grey[200]),
              const SizedBox(height: 6),
              Text(
                'TARGET SPLIT',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                targetSplit,
                style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFF424242),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MacroLegendRow extends StatelessWidget {
  const _MacroLegendRow({
    required this.color,
    required this.name,
    required this.grams,
    required this.pct,
  });
  final Color color;
  final String name;
  final double grams;
  final double pct;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF424242),
                ),
              ),
            ),
            Text(
              '${grams.round()}g',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              width: 28,
              child: Text(
                '${pct.round()}%',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: SizedBox(
            height: 3,
            child: LinearProgressIndicator(
              value: pct / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Formatting helpers ────────────────────────────────────────────────────────

String _formatKcal(double kcal) {
  final rounded = kcal.round();
  if (rounded >= 1000) {
    final thousands = rounded ~/ 1000;
    final remainder = rounded % 1000;
    return '$thousands,${remainder.toString().padLeft(3, '0')}';
  }
  return rounded.toString();
}
