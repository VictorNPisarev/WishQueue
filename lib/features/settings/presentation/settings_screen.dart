// lib/features/settings/presentation/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import 'app_version_provider.dart';
import 'widgets/locale_picker_sheet.dart';
import 'widgets/theme_picker_sheet.dart';

/// Экран настроек приложения.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final versionAsync = ref.watch(appVersionProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          // Секция «Оформление».
          _SectionHeader(title: l10n.settingsAppearance),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(l10n.themeColor),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => showThemePicker(context),
          ),

          const Divider(),

          // Секция «Язык».
          _SectionHeader(title: l10n.settingsLanguage),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => showLocalePicker(context),
          ),

          const Divider(),

          // Секция «О программе».
          _SectionHeader(title: l10n.settingsAbout),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.settingsAboutApp),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showAboutDialog(context, l10n),
          ),
          ListTile(
            leading: const Icon(Icons.numbers),
            title: Text(l10n.settingsVersion),
            subtitle: versionAsync.when(
              loading: () => const Text('...'),
              error: (_, __) => const Text('—'),
              data: (v) => Text(v),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsAboutApp),
        content: Text(l10n.settingsAboutText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
