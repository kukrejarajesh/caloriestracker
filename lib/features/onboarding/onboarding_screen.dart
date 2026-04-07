import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/gluten_badge.dart';
import 'onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  static const int _totalPages = 4;

  // Page 1 controllers
  final _nameController = TextEditingController();
  final _page1Key = GlobalKey<FormState>();

  // Page 2 controllers
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _page2Key = GlobalKey<FormState>();

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage == 0 && !(_page1Key.currentState?.validate() ?? false)) {
      return;
    }
    if (_currentPage == 1 && !(_page2Key.currentState?.validate() ?? false)) {
      return;
    }
    if (_currentPage == 2) {
      final state = ref.read(onboardingNotifierProvider);
      if (state.activityLevel == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an activity level.')),
        );
        return;
      }
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _back() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish() async {
    final state = ref.read(onboardingNotifierProvider);
    if (state.goalType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a goal.')),
      );
      return;
    }
    final ok =
        await ref.read(onboardingNotifierProvider.notifier).saveProfile();
    if (ok && mounted) {
      // Navigate to dashboard — replace entire stack
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(onboardingNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _ProgressHeader(
                currentPage: _currentPage, totalPages: _totalPages),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (p) => setState(() => _currentPage = p),
                children: [
                  _Page1Personal(
                    formKey: _page1Key,
                    nameController: _nameController,
                  ),
                  _Page2Body(
                    formKey: _page2Key,
                    heightController: _heightController,
                    weightController: _weightController,
                  ),
                  const _Page3Activity(),
                  const _Page4Goal(),
                ],
              ),
            ),
            if (formState.error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  formState.error!,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 13),
                ),
              ),
            _BottomNav(
              currentPage: _currentPage,
              totalPages: _totalPages,
              isSaving: formState.isSaving,
              onBack: _back,
              onNext: _next,
              onFinish: _finish,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Progress header ───────────────────────────────────────────────────────────

class _ProgressHeader extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const _ProgressHeader(
      {required this.currentPage, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(totalPages, (i) {
              final active = i <= currentPage;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 4,
                  margin: EdgeInsets.only(right: i < totalPages - 1 ? 6 : 0),
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            'Step ${currentPage + 1} of $totalPages',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

// ── Bottom nav ────────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool isSaving;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  const _BottomNav({
    required this.currentPage,
    required this.totalPages,
    required this.isSaving,
    required this.onBack,
    required this.onNext,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = currentPage == totalPages - 1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Row(
        children: [
          if (currentPage > 0)
            OutlinedButton(
              onPressed: onBack,
              child: const Text('Back'),
            ),
          const Spacer(),
          ElevatedButton(
            onPressed: isSaving ? null : (isLast ? onFinish : onNext),
            child: isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : Text(isLast ? 'Get Started' : 'Next'),
          ),
        ],
      ),
    );
  }
}

// ── Page 1 — Personal Info ────────────────────────────────────────────────────

class _Page1Personal extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;

  const _Page1Personal(
      {required this.formKey, required this.nameController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(onboardingNotifierProvider.notifier);
    final state = ref.watch(onboardingNotifierProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Personal Info',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text('Tell us a bit about yourself.',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 28),

            // Name
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
              textCapitalization: TextCapitalization.words,
              onChanged: notifier.setName,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 20),

            // Date of birth
            _DatePickerField(
              label: 'Date of Birth',
              selected: state.dateOfBirth,
              onSelected: notifier.setDateOfBirth,
            ),
            const SizedBox(height: 20),

            // Gender
            Text('Gender', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            _ChipSelector<String>(
              options: const ['male', 'female', 'other'],
              labels: const ['Male', 'Female', 'Other'],
              selected: state.gender,
              onSelected: notifier.setGender,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Page 2 — Body Metrics ─────────────────────────────────────────────────────

class _Page2Body extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController heightController;
  final TextEditingController weightController;

  const _Page2Body({
    required this.formKey,
    required this.heightController,
    required this.weightController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(onboardingNotifierProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Body Metrics',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text('Used to calculate your daily calorie goal.',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 28),

            TextFormField(
              controller: heightController,
              decoration: const InputDecoration(
                  labelText: 'Height', suffixText: 'cm'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (v) {
                final d = double.tryParse(v);
                if (d != null) notifier.setHeightCm(d);
              },
              validator: (v) {
                final d = double.tryParse(v ?? '');
                if (d == null || d < 50 || d > 300) {
                  return 'Enter a valid height (50–300 cm)';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: weightController,
              decoration: const InputDecoration(
                  labelText: 'Weight', suffixText: 'kg'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (v) {
                final d = double.tryParse(v);
                if (d != null) notifier.setWeightKg(d);
              },
              validator: (v) {
                final d = double.tryParse(v ?? '');
                if (d == null || d < 20 || d > 500) {
                  return 'Enter a valid weight (20–500 kg)';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Page 3 — Activity Level ───────────────────────────────────────────────────

class _Page3Activity extends ConsumerWidget {
  const _Page3Activity();

  static const _options = [
    ('sedentary', 'Sedentary', 'Little or no exercise'),
    ('lightly_active', 'Lightly Active', 'Light exercise 1–3 days/week'),
    ('moderately_active', 'Moderately Active', 'Moderate exercise 3–5 days/week'),
    ('very_active', 'Very Active', 'Hard exercise 6–7 days/week'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(onboardingNotifierProvider.notifier);
    final selected =
        ref.watch(onboardingNotifierProvider).activityLevel;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Activity Level',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text('How active are you on a typical week?',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          ..._options.map((o) {
            final (value, title, subtitle) = o;
            final isSelected = selected == value;
            return GestureDetector(
              onTap: () => notifier.setActivityLevel(value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: isSelected
                          ? AppColors.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: isSelected
                                        ? AppColors.primary
                                        : null,
                                  )),
                          Text(subtitle,
                              style:
                                  Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Page 4 — Goal + Gluten ────────────────────────────────────────────────────

class _Page4Goal extends ConsumerWidget {
  const _Page4Goal();

  static const _goals = [
    ('lose', 'Lose Weight', Icons.trending_down),
    ('maintain', 'Maintain Weight', Icons.trending_flat),
    ('gain', 'Gain Weight', Icons.trending_up),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(onboardingNotifierProvider.notifier);
    final state = ref.watch(onboardingNotifierProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Goal', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text('We\'ll set your daily calorie target accordingly.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),

          // Goal selector
          ..._goals.map((g) {
            final (value, label, icon) = g;
            final isSelected = state.goalType == value;
            return GestureDetector(
              onTap: () => notifier.setGoalType(value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(icon,
                        color: isSelected
                            ? AppColors.primary
                            : Theme.of(context).colorScheme.onSurface),
                    const SizedBox(width: 12),
                    Text(
                      label,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            color:
                                isSelected ? AppColors.primary : null,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // Gluten-free toggle
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gluten-Free Diet',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    GlutenBadge(
                      glutenStatus: state.isGlutenFree
                          ? 'gluten_free'
                          : 'unknown',
                    ),
                  ],
                ),
              ),
              Switch(
                value: state.isGlutenFree,
                activeThumbColor: AppColors.glutenSafeLight,
                onChanged: notifier.setIsGlutenFree,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'When ON, food search will only show gluten-free items by default.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

class _DatePickerField extends StatelessWidget {
  final String label;
  final String? selected;
  final ValueChanged<String> onSelected;

  const _DatePickerField({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime(1990),
          firstDate: DateTime(1920),
          lastDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
        );
        if (picked != null) {
          onSelected(
              '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}');
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
        ),
        child: Text(
          selected ?? 'Select date',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: selected == null
                    ? Theme.of(context).hintColor
                    : null,
              ),
        ),
      ),
    );
  }
}

class _ChipSelector<T> extends StatelessWidget {
  final List<T> options;
  final List<String> labels;
  final T? selected;
  final ValueChanged<T> onSelected;

  const _ChipSelector({
    required this.options,
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: List.generate(options.length, (i) {
        final isSelected = selected == options[i];
        return ChoiceChip(
          label: Text(labels[i]),
          selected: isSelected,
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : null,
            fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          onSelected: (_) => onSelected(options[i]),
        );
      }),
    );
  }
}
