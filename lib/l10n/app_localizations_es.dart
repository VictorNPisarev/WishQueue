// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'WishQueue';

  @override
  String get wishlistTitle => 'Lista de deseos';

  @override
  String get addItem => 'Agregar artículo';

  @override
  String get addIncome => 'Agregar ingreso';

  @override
  String get distribute => 'Distribuir';

  @override
  String get cat_auto => 'Auto';

  @override
  String get cat_home => 'Hogar';

  @override
  String get cat_tools => 'Herramientas';

  @override
  String get cat_other => 'Otros';

  @override
  String get priority_urgent => 'Urgente';

  @override
  String get priority_high => 'Alta';

  @override
  String get priority_normal => 'Normal';

  @override
  String get priority_someday => 'Algún día';

  @override
  String get status_planned => 'Planificado';

  @override
  String get status_reserved => 'Reservado';

  @override
  String get status_bought => 'Comprado';

  @override
  String get status_cancelled => 'Cancelado';

  @override
  String get wishlistTabActive => 'Activos';

  @override
  String get wishlistTabBought => 'Comprados';

  @override
  String get addItemTooltip => 'Agregar artículo';

  @override
  String get wishlistEmptyActive =>
      'La lista está vacía.\nToca + para agregar tu primer artículo.';

  @override
  String get wishlistEmptyBought => 'Los artículos comprados aparecerán aquí.';

  @override
  String get wishlistLoadError => 'No se pudo cargar la lista.';

  @override
  String get actionReserve => 'Lo compraré';

  @override
  String get actionBuyNow => 'Comprar ahora';

  @override
  String get actionCancel => 'Cancelar artículo';

  @override
  String get actionUnreserve => 'Volver a la cola';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get deleteItemTitle => '¿Eliminar artículo?';

  @override
  String deleteItemMessage(String title) {
    return '«$title» se eliminará permanentemente.';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get themeColor => 'Color del tema';

  @override
  String get selected => 'Seleccionado';

  @override
  String get newItemTitle => 'Nuevo artículo';

  @override
  String get editItemTitle => 'Editar artículo';

  @override
  String get fieldTitle => 'Título';

  @override
  String get fieldPriceRub => 'Precio (₽)';

  @override
  String get fieldPriceHint => 'Por ejemplo: 30000';

  @override
  String get fieldPriority => 'Prioridad';

  @override
  String get fieldCategory => 'Categoría';

  @override
  String get categoryNone => 'Sin categoría';

  @override
  String get fieldNotes => 'Notas';

  @override
  String get fieldUrl => 'Enlace';

  @override
  String get save => 'Guardar';

  @override
  String get validationTitleEmpty => 'El título no puede estar vacío';

  @override
  String get saveFailed => 'Error al guardar';

  @override
  String get loadError => 'Error';

  @override
  String get categoriesLoadError => 'No se pudieron cargar las categorías';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Sistema';

  @override
  String get newIncomeTitle => 'Nuevo ingreso';

  @override
  String get editIncomeTitle => 'Editar ingreso';

  @override
  String get fieldAmount => 'Monto';

  @override
  String get fieldAmountHint => 'Por ejemplo: 80000';

  @override
  String get fieldDate => 'Fecha';

  @override
  String get fieldWorkedHours => 'Horas trabajadas';

  @override
  String get fieldWorkedHoursHint => 'Por ejemplo: 120';

  @override
  String get validationAmountInvalid => 'Ingresa un monto positivo';

  @override
  String get incomesTitle => 'Ingresos';

  @override
  String get addIncomeTooltip => 'Agregar ingreso';

  @override
  String get incomesEmpty =>
      'Aún no hay ingresos.\nToca + para agregar el primero.';

  @override
  String get incomesLoadError => 'No se pudieron cargar los ingresos.';

  @override
  String get actionMarkReceived => 'Marcar como recibido';

  @override
  String get incomesLoadFailed => 'Error al cargar';

  @override
  String get deleteIncomeTitle => '¿Eliminar ingreso?';

  @override
  String deleteIncomeMessage(String title) {
    return '«$title» se eliminará permanentemente.';
  }

  @override
  String get statusLabelPlanned => 'Esperado';

  @override
  String get statusLabelReceived => 'Recibido';

  @override
  String get statusLabelCancelled => 'Cancelado';

  @override
  String get balanceCurrent => 'Actual';

  @override
  String get balancePlanned => 'Planificado';

  @override
  String get balanceSpent => 'Gastado';

  @override
  String get balanceReserved => 'Reservado';

  @override
  String get balanceRemaining => 'Libre';

  @override
  String balancePositionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count artículos',
      one: '1 artículo',
    );
    return '$_temp0';
  }

  @override
  String get fieldReceivedAt => 'Fecha de recepción';

  @override
  String get fieldBoughtAt => 'Fecha de compra';
}

/// The translations for Spanish Castilian, as used in Mexico (`es_MX`).
class AppLocalizationsEsMx extends AppLocalizationsEs {
  AppLocalizationsEsMx() : super('es_MX');

  @override
  String get appTitle => 'WishQueue';

  @override
  String get wishlistTitle => 'Lista de deseos';

  @override
  String get addItem => 'Agregar artículo';

  @override
  String get addIncome => 'Agregar ingreso';

  @override
  String get distribute => 'Distribuir';

  @override
  String get cat_auto => 'Carro';

  @override
  String get cat_home => 'Casa';

  @override
  String get cat_tools => 'Herramientas';

  @override
  String get cat_other => 'Otros';

  @override
  String get priority_urgent => 'Urgente';

  @override
  String get priority_high => 'Alta';

  @override
  String get priority_normal => 'Normal';

  @override
  String get priority_someday => 'Algún día';

  @override
  String get status_planned => 'Planificado';

  @override
  String get status_reserved => 'Reservado';

  @override
  String get status_bought => 'Comprado';

  @override
  String get status_cancelled => 'Cancelado';

  @override
  String get wishlistTabActive => 'Activos';

  @override
  String get wishlistTabBought => 'Comprados';

  @override
  String get addItemTooltip => 'Agregar artículo';

  @override
  String get wishlistEmptyActive =>
      'La lista está vacía.\nToca + para agregar tu primer artículo.';

  @override
  String get wishlistEmptyBought => 'Los artículos comprados aparecerán aquí.';

  @override
  String get wishlistLoadError => 'No se pudo cargar la lista.';

  @override
  String get actionReserve => 'Lo compraré';

  @override
  String get actionBuyNow => 'Comprar ahora';

  @override
  String get actionCancel => 'Cancelar artículo';

  @override
  String get actionUnreserve => 'Volver a la cola';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get deleteItemTitle => '¿Eliminar artículo?';

  @override
  String deleteItemMessage(String title) {
    return '«$title» se eliminará permanentemente.';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get themeColor => 'Color del tema';

  @override
  String get selected => 'Seleccionado';

  @override
  String get newItemTitle => 'Nuevo artículo';

  @override
  String get editItemTitle => 'Editar artículo';

  @override
  String get fieldTitle => 'Título';

  @override
  String get fieldPriceRub => 'Precio (₽)';

  @override
  String get fieldPriceHint => 'Por ejemplo: 30000';

  @override
  String get fieldPriority => 'Prioridad';

  @override
  String get fieldCategory => 'Categoría';

  @override
  String get categoryNone => 'Sin categoría';

  @override
  String get fieldNotes => 'Notas';

  @override
  String get fieldUrl => 'Enlace';

  @override
  String get save => 'Guardar';

  @override
  String get validationTitleEmpty => 'El título no puede estar vacío';

  @override
  String get saveFailed => 'Error al guardar';

  @override
  String get loadError => 'Error';

  @override
  String get categoriesLoadError => 'No se pudieron cargar las categorías';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Sistema';

  @override
  String get newIncomeTitle => 'Nuevo ingreso';

  @override
  String get editIncomeTitle => 'Editar ingreso';

  @override
  String get fieldAmount => 'Monto';

  @override
  String get fieldAmountHint => 'Por ejemplo: 80000';

  @override
  String get fieldDate => 'Fecha';

  @override
  String get fieldWorkedHours => 'Horas trabajadas';

  @override
  String get fieldWorkedHoursHint => 'Por ejemplo: 120';

  @override
  String get validationAmountInvalid => 'Ingresa un monto positivo';

  @override
  String get incomesTitle => 'Ingresos';

  @override
  String get addIncomeTooltip => 'Agregar ingreso';

  @override
  String get incomesEmpty =>
      'Aún no hay ingresos.\nToca + para agregar el primero.';

  @override
  String get incomesLoadError => 'No se pudieron cargar los ingresos.';

  @override
  String get actionMarkReceived => 'Marcar como recibido';

  @override
  String get incomesLoadFailed => 'Error al cargar';

  @override
  String get deleteIncomeTitle => '¿Eliminar ingreso?';

  @override
  String deleteIncomeMessage(String title) {
    return '«$title» se eliminará permanentemente.';
  }

  @override
  String get statusLabelPlanned => 'Esperado';

  @override
  String get statusLabelReceived => 'Recibido';

  @override
  String get statusLabelCancelled => 'Cancelado';

  @override
  String get balanceCurrent => 'Actual';

  @override
  String get balancePlanned => 'Planificado';

  @override
  String get balanceSpent => 'Gastado';

  @override
  String get balanceReserved => 'Reservado';

  @override
  String get balanceRemaining => 'Libre';

  @override
  String balancePositionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count artículos',
      one: '1 artículo',
    );
    return '$_temp0';
  }

  @override
  String get fieldReceivedAt => 'Fecha de recepción';

  @override
  String get fieldBoughtAt => 'Fecha de compra';
}
