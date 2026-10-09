// lib/core/errors/error_handler_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'error_handler.dart';

/// Глобальный [ErrorHandler]. Один на приложение.
final errorHandlerProvider = Provider<ErrorHandler>((ref) {
  return const ErrorHandler();
});