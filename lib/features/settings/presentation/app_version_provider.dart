// lib/features/settings/presentation/app_version_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Информация о версии приложения.
///
/// `FutureProvider` — читается асинхронно при первом обращении,
/// кэшируется на всё время работы приложения.
final appVersionProvider = FutureProvider<String>((ref) async {
  final info = await PackageInfo.fromPlatform();
  return '${info.version} (build ${info.buildNumber})';
});
