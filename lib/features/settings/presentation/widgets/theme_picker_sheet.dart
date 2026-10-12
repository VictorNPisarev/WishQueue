// lib/features/settings/presentation/widgets/theme_picker_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/theme_seed.dart';
import '../theme_provider.dart';

/// Показывает нижнюю панель с выбором цвета темы.
Future<void> showThemePicker(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (_) => const _ThemePickerSheet(),
  );
}

class _ThemePickerSheet extends ConsumerWidget {
  const _ThemePickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current =
        ref.watch(themeSeedProvider).valueOrNull ?? ThemeSeed.defaultSeed;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Цвет темы',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: ThemeSeed.values
                  .map(
                    (seed) => _SeedCircle(
                      seed: seed,
                      isSelected: seed == current,
                      onTap: () => _onSelect(context, ref, seed),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> _onSelect(
    BuildContext context,
    WidgetRef ref,
    ThemeSeed seed,
  ) async {
    Navigator.pop(context); // закрываем меню
    await ref.read(themeSeedProvider.notifier).setSeed(seed);
  }
}

class _SeedCircle extends StatelessWidget {
  const _SeedCircle({
    required this.seed,
    required this.isSelected,
    required this.onTap,
  });

  final ThemeSeed seed;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: seed.color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 3,
                    )
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 28)
                : null,
          ),
          const SizedBox(height: 6),
          if (isSelected)
            const Text(
              'Выбрано',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
