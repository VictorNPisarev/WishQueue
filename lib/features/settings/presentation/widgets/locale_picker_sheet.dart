// lib/features/settings/presentation/widgets/locale_picker_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/app_locale.dart';
import '../locale_provider.dart';

/// Показывает нижнюю панель с выбором языка.
Future<void> showLocalePicker(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (_) => const _LocalePickerSheet(),
  );
}

class _LocalePickerSheet extends ConsumerWidget {
  const _LocalePickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final current =
        ref.watch(appLocaleProvider).valueOrNull ?? AppLocale.defaultLocale;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.language,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const Divider(height: 1),
          ...AppLocale.values.map(
            (locale) => ListTile(
              title: Text(_localeLabel(locale, l10n)),
              trailing: locale == current
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              onTap: () => _onSelect(context, ref, locale),
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
    AppLocale locale,
  ) async {
    Navigator.pop(context);
    await ref.read(appLocaleProvider.notifier).setLocale(locale);
  }

  String _localeLabel(AppLocale locale, AppLocalizations l10n) {
    return switch (locale) {
      AppLocale.system => l10n.languageSystem,
      AppLocale.en => l10n.languageEnglish,
      AppLocale.ru => l10n.languageRussian,
      AppLocale.esMx => l10n.languageSpanishMx,
      AppLocale.zhHans => l10n.languageChineseSimplified,
    };
  }
}
