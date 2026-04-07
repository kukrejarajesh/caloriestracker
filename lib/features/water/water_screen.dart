import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/database/app_database.dart';
import '../dashboard/dashboard_provider.dart';
import 'water_provider.dart';

class WaterScreen extends ConsumerWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(waterLogsProvider);
    final profileAsync = ref.watch(dashboardProvider);

    final targetMl = profileAsync.valueOrNull?.waterTarget ?? 2000;

    return Scaffold(
      appBar: AppBar(title: const Text('Water Intake')),
      body: logsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (logs) {
          final totalMl = logs.fold(0, (sum, l) => sum + l.amountMl);
          final progress =
              targetMl > 0 ? (totalMl / targetMl).clamp(0.0, 1.0) : 0.0;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ── Summary card ─────────────────────────────────────────
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(Icons.water_drop,
                          size: 48, color: AppColors.water),
                      const SizedBox(height: 12),
                      Text(
                        _formatMl(totalMl),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: AppColors.water,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text('of ${_formatMl(targetMl)} goal',
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor:
                              AppColors.water.withValues(alpha: 0.15),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.water),
                          minHeight: 12,
                        ),
                      ),
                      if (totalMl >= targetMl)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Daily goal reached!',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: AppColors.glutenSafeLight),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Quick add ────────────────────────────────────────────
              Text('Quick Add',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [150, 200, 250, 350, 500, 750].map((ml) {
                  return ActionChip(
                    label: Text('+${_formatMl(ml)}'),
                    avatar: const Icon(Icons.add,
                        size: 14, color: AppColors.water),
                    side:
                        const BorderSide(color: AppColors.water),
                    labelStyle: const TextStyle(
                        color: AppColors.water, fontSize: 12),
                    onPressed: () => ref
                        .read(waterNotifierProvider.notifier)
                        .addWater(ml),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // ── Custom amount ────────────────────────────────────────
              _CustomWaterInput(),
              const SizedBox(height: 20),

              // ── Log history ──────────────────────────────────────────
              if (logs.isNotEmpty) ...[
                Text('Today\'s Log',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...logs.reversed.map(
                  (log) => _WaterLogTile(
                    log: log,
                    onDelete: () => ref
                        .read(waterNotifierProvider.notifier)
                        .deleteLog(log.id),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  String _formatMl(int ml) =>
      ml >= 1000 ? '${(ml / 1000).toStringAsFixed(1)}L' : '${ml}ml';
}

class _CustomWaterInput extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CustomWaterInput> createState() =>
      _CustomWaterInputState();
}

class _CustomWaterInputState extends ConsumerState<_CustomWaterInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Custom amount',
              suffixText: 'ml',
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            final ml = int.tryParse(_controller.text);
            if (ml != null && ml > 0) {
              ref.read(waterNotifierProvider.notifier).addWater(ml);
              _controller.clear();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class _WaterLogTile extends StatelessWidget {
  final WaterLog log;
  final VoidCallback onDelete;

  const _WaterLogTile({required this.log, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final time = DateTime.tryParse(log.loggedAt);
    final timeStr = time != null
        ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
        : '';

    return ListTile(
      dense: true,
      leading:
          const Icon(Icons.water_drop_outlined, color: AppColors.water),
      title: Text(
        log.amountMl >= 1000
            ? '${(log.amountMl / 1000).toStringAsFixed(1)}L'
            : '${log.amountMl}ml',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(timeStr,
          style: Theme.of(context).textTheme.bodyMedium),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, size: 18),
        onPressed: onDelete,
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
