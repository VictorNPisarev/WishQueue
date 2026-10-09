// lib/features/categories/data/category_repository.dart

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database.dart';
import '../../../core/errors/app_exception.dart';

/// Репозиторий категорий.
///
/// Все операции — над таблицей `categories`. Работа с drift инкапсулирована:
/// наружу торчат только domain-модели ([Category]) и доменные исключения
/// ([AppException] и наследники).
class CategoryRepository {
  CategoryRepository(this._db);

  final AppDatabase _db;

  static const _uuid = Uuid();

  /// Все неудалённые категории, отсортированные по `sortOrder`, затем по имени.
  ///
  /// Возвращает стрим — UI автоматически обновится при любом изменении таблицы.
  Stream<List<Category>> watchAll() {
    final query = _db.select(_db.categories)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm.asc(t.sortOrder),
        (t) => OrderingTerm.asc(t.nameKey),
        (t) => OrderingTerm.asc(t.nameCustom),
      ]);
    return query.watch();
  }

  /// Одна категория по id. Бросает [NotFoundException], если нет.
  Future<Category> getById(String id) async {
    try {
      final row =
          await (_db.select(_db.categories)
                ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
              .getSingleOrNull();
      if (row == null) {
        throw NotFoundException('Category $id not found');
      }
      return row;
    } on DriftWrappedException catch (e) {
      throw DatabaseException('Failed to search category', cause: e);
    } on CouldNotRollBackException catch (e) {
      throw DatabaseException('Transaction failed', cause: e);
    }
  }

  /// Создаёт пользовательскую категорию.
  ///
  /// [nameCustom] — обязательное непустое название (системные категории
  /// создаются только через сиды в [AppDatabase]).
  Future<Category> create({
    required String nameCustom,
    String? icon,
    String? color,
    int sortOrder = 0,
  }) async {
    _validateNameCustom(nameCustom);

    final now = DateTime.now().toUtc();
    final id = _uuid.v4();

    final companion = CategoriesCompanion.insert(
      id: id,
      nameCustom: Value(nameCustom),
      icon: Value(icon),
      color: Value(color),
      sortOrder: Value(sortOrder),
      isSystem: const Value(false),
      createdAt: now,
      updatedAt: now,
    );

    try {
      await _db.into(_db.categories).insert(companion);
    } on DriftWrappedException catch (e) {
      throw DatabaseException('Failed to insert category', cause: e);
    } on CouldNotRollBackException catch (e) {
      throw DatabaseException('Transaction failed', cause: e);
    }

    return getById(id);
  }

  /// Обновляет пользовательскую категорию.
  ///
  /// Системные категории обновлять нельзя — бросает [ValidationException].
  Future<Category> update({
    required String id,
    String? nameCustom,
    String? icon,
    String? color,
    int? sortOrder,
  }) async {
    final existing = await getById(id);
    if (existing.isSystem) {
      throw ValidationException('Cannot update system category $id');
    }
    if (nameCustom != null) {
      _validateNameCustom(nameCustom);
    }

    final companion = CategoriesCompanion(
      id: Value(id),
      nameCustom: Value.absentIfNull(nameCustom),
      icon: Value.absentIfNull(icon),
      color: Value.absentIfNull(color),
      sortOrder: Value.absentIfNull(sortOrder),
      updatedAt: Value(DateTime.now().toUtc()),
    );

    try {
      await (_db.update(
        _db.categories,
      )..where((t) => t.id.equals(id))).write(companion);
    } on DriftWrappedException catch (e) {
      throw DatabaseException('Failed to update category', cause: e);
    } on CouldNotRollBackException catch (e) {
      throw DatabaseException('Transaction failed', cause: e);
    }

    return getById(id);
  }

  /// Мягкое удаление. Системные категории удалять нельзя.
  Future<void> softDelete(String id) async {
    final now = DateTime.now().toUtc();
    try {
      final affected =
          await (_db.update(_db.categories)..where(
                (t) =>
                    t.id.equals(id) &
                    t.isSystem.equals(false) &
                    t.deletedAt.isNull(),
              ))
              .write(
                CategoriesCompanion(
                  deletedAt: Value(now),
                  updatedAt: Value(now),
                ),
              );
      if (affected == 0) {
        throw NotFoundException(
          'Category $id not found, is system, or already deleted',
        );
      }
    } on DriftWrappedException catch (e) {
      throw DatabaseException('Failed to delete category', cause: e);
    } on CouldNotRollBackException catch (e) {
      throw DatabaseException('Transaction failed', cause: e);
    }
  }

  void _validateNameCustom(String value) {
    if (value.trim().isEmpty) {
      throw const ValidationException('Category name must not be empty');
    }
  }
}
