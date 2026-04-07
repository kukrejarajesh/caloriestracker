import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/gluten_badge.dart';
import 'profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile found.'));
          }
          return _ProfileForm(profile: profile);
        },
      ),
    );
  }
}

class _ProfileForm extends ConsumerStatefulWidget {
  final dynamic profile;
  const _ProfileForm({required this.profile});

  @override
  ConsumerState<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<_ProfileForm> {
  final _nameCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _waterCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(profileEditNotifierProvider.notifier)
          .loadFrom(widget.profile);
      final s = ref.read(profileEditNotifierProvider);
      _nameCtrl.text = s.name;
      _heightCtrl.text = s.heightCm?.toStringAsFixed(1) ?? '';
      _weightCtrl.text = s.weightKg?.toStringAsFixed(1) ?? '';
      _waterCtrl.text = '${s.waterTargetMl}';
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _waterCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final ok =
        await ref.read(profileEditNotifierProvider.notifier).save();
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved. Targets recalculated.'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(profileEditNotifierProvider.notifier);
    final state = ref.watch(profileEditNotifierProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Personal ───────────────────────────────────────────────
            _SectionHeader('Personal Info'),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Full Name'),
              onChanged: notifier.setName,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            _DatePickerRow(
              label: 'Date of Birth',
              value: state.dateOfBirth,
              onSelected: notifier.setDateOfBirth,
            ),
            const SizedBox(height: 12),
            Text('Gender',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 6),
            _ChipRow(
              options: const ['male', 'female', 'other'],
              labels: const ['Male', 'Female', 'Other'],
              selected: state.gender,
              onSelected: notifier.setGender,
            ),
            const SizedBox(height: 20),

            // ── Body ───────────────────────────────────────────────────
            _SectionHeader('Body Metrics'),
            TextFormField(
              controller: _heightCtrl,
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
                return (d == null || d < 50 || d > 300)
                    ? 'Enter 50–300 cm'
                    : null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _weightCtrl,
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
                return (d == null || d < 20 || d > 500)
                    ? 'Enter 20–500 kg'
                    : null;
              },
            ),
            const SizedBox(height: 20),

            // ── Activity ───────────────────────────────────────────────
            _SectionHeader('Activity Level'),
            _ChipRow(
              options: const [
                'sedentary',
                'lightly_active',
                'moderately_active',
                'very_active'
              ],
              labels: const [
                'Sedentary',
                'Light',
                'Moderate',
                'Very Active'
              ],
              selected: state.activityLevel,
              onSelected: notifier.setActivityLevel,
            ),
            const SizedBox(height: 20),

            // ── Goal ───────────────────────────────────────────────────
            _SectionHeader('Goal'),
            _ChipRow(
              options: const ['lose', 'maintain', 'gain'],
              labels: const ['Lose', 'Maintain', 'Gain'],
              selected: state.goalType,
              onSelected: notifier.setGoalType,
            ),
            const SizedBox(height: 20),

            // ── Water target ───────────────────────────────────────────
            _SectionHeader('Daily Water Target'),
            TextFormField(
              controller: _waterCtrl,
              decoration: const InputDecoration(
                  labelText: 'Water Target', suffixText: 'ml'),
              keyboardType: TextInputType.number,
              onChanged: (v) {
                final d = int.tryParse(v);
                if (d != null && d > 0) notifier.setWaterTarget(d);
              },
            ),
            const SizedBox(height: 20),

            // ── Gluten ─────────────────────────────────────────────────
            _SectionHeader('Dietary'),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gluten-Free Diet',
                          style:
                              Theme.of(context).textTheme.titleMedium),
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
            const SizedBox(height: 28),

            if (state.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(state.error!,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error)),
              ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.isSaving ? null : _save,
                child: state.isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Save Profile'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
              )),
    );
  }
}

class _DatePickerRow extends StatelessWidget {
  final String label;
  final String? value;
  final ValueChanged<String> onSelected;

  const _DatePickerRow(
      {required this.label,
      required this.value,
      required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final initial = value != null
            ? (DateTime.tryParse(value!) ?? DateTime(1990))
            : DateTime(1990);
        final picked = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: DateTime(1920),
          lastDate:
              DateTime.now().subtract(const Duration(days: 365 * 10)),
        );
        if (picked != null) {
          onSelected(
              '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}');
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon:
              const Icon(Icons.calendar_today_outlined, size: 18),
        ),
        child: Text(
          value ?? 'Select date',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: value == null ? Theme.of(context).hintColor : null,
              ),
        ),
      ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  final List<String> options;
  final List<String> labels;
  final String? selected;
  final ValueChanged<String> onSelected;

  const _ChipRow({
    required this.options,
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: List.generate(options.length, (i) {
        final isSel = selected == options[i];
        return ChoiceChip(
          label: Text(labels[i]),
          selected: isSel,
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSel ? Colors.white : null,
            fontWeight: isSel ? FontWeight.w600 : FontWeight.normal,
          ),
          onSelected: (_) => onSelected(options[i]),
        );
      }),
    );
  }
}
