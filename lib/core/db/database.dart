// lib/core/db/database.dart
import 'package:drift/drift.dart';

import 'tables/categories.dart';
import 'tables/incomes.dart';
import 'tables/wish_items.dart';

part 'database.g.dart';

/// Системные категории, вставляемые при первом создании БД.
/// nameKey должен совпадать с ключами в .arb-файлах.
const _systemCategories =
    <({String id, String nameKey, String icon, int sortOrder})>[
      (
        id: 'cat_auto',
        nameKey: 'cat_auto',
        icon: 'directions_car',
        sortOrder: 10,
      ),
      (id: 'cat_home', nameKey: 'cat_home', icon: 'home', sortOrder: 20),
      (id: 'cat_tools', nameKey: 'cat_tools', icon: 'build', sortOrder: 30),
      (id: 'cat_other', nameKey: 'cat_other', icon: 'category', sortOrder: 100),
    ];

@DriftDatabase(tables: [Categories, Incomes, WishItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedSystemCategories();
    },
    beforeOpen: (details) async {
      // Включаем FK-энфорс в SQLite. По умолчанию выключен.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _seedSystemCategories() async {
    final now = DateTime.now().toUtc();
    await batch((b) {
      b.insertAll(
        categories,
        _systemCategories.map(
          (c) => CategoriesCompanion.insert(
            id: c.id,
            nameKey: Value(c.nameKey),
            icon: Value(c.icon),
            sortOrder: Value(c.sortOrder),
            isSystem: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
        ),
      );
    });
  }
}
