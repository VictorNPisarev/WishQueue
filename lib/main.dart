// lib/main.dart

import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'core/db/database.dart';
import 'core/db/database_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbDir = await getApplicationDocumentsDirectory();
  final dbFile = File(p.join(dbDir.path, 'wishqueue.sqlite'));

  final db = AppDatabase(NativeDatabase(dbFile));

  runApp(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const WishQueueApp(),
    ),
  );
}
