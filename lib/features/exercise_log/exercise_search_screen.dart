import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/database/app_database.dart';
import 'exercise_log_provider.dart';
import 'exercise_log_screen.dart';

class ExerciseSearchScreen extends ConsumerStatefulWidget {
  final String? logDate;
  const ExerciseSearchScreen({super.key, this.logDate});

  @override
  ConsumerState<ExerciseSearchScreen> createState() =>
      _ExerciseSearchScreenState();
}

class _ExerciseSearchScreenState
    extends ConsumerState<ExerciseSearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(exerciseSearchQueryProvider.notifier).set('');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(exerciseSearchQueryProvider.notifier).set(v.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(exerciseSearchProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Log Exercise')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search exercises…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          ref
                              .read(exerciseSearchQueryProvider.notifier)
                              .set('');
                        },
                      )
                    : null,
              ),
              onChanged: _onChanged,
            ),
          ),
          Expanded(
            child: searchAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (exercises) {
                if (exercises.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.fitness_center,
                              size: 56,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.3)),
                          const SizedBox(height: 16),
                          Text(
                            ref
                                    .watch(exerciseSearchQueryProvider)
                                    .isEmpty
                                ? 'Start typing to search exercises'
                                : 'No exercises found',
                            style:
                                Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: exercises.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, indent: 72),
                  itemBuilder: (context, i) => _ExerciseTile(
                    exercise: exercises[i],
                    logDate: widget.logDate,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  final String? logDate;
  const _ExerciseTile({required this.exercise, this.logDate});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: AppColors.primary,
        child: Icon(Icons.fitness_center, color: Colors.white, size: 18),
      ),
      title: Text(exercise.name,
          style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(
        '${exercise.category} · MET ${exercise.metValue}',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              ExerciseLogScreen(exercise: exercise, logDate: logDate),
        ),
      ),
    );
  }
}
