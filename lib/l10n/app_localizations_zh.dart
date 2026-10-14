// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'WishQueue';

  @override
  String get wishlistTitle => '愿望清单';

  @override
  String get addItem => '添加项目';

  @override
  String get addIncome => '添加收入';

  @override
  String get distribute => '分配';

  @override
  String get cat_auto => '汽车';

  @override
  String get cat_home => '家居';

  @override
  String get cat_tools => '工具';

  @override
  String get cat_other => '其他';

  @override
  String get priority_urgent => '紧急';

  @override
  String get priority_high => '高';

  @override
  String get priority_normal => '普通';

  @override
  String get priority_someday => '将来';

  @override
  String get status_planned => '已计划';

  @override
  String get status_reserved => '已预留';

  @override
  String get status_bought => '已购买';

  @override
  String get status_cancelled => '已取消';

  @override
  String get wishlistTabActive => '活跃';

  @override
  String get wishlistTabBought => '已购买';

  @override
  String get addItemTooltip => '添加项目';

  @override
  String get wishlistEmptyActive => '列表为空。\n点击 + 添加第一个项目。';

  @override
  String get wishlistEmptyBought => '已购买的项目将显示在此处。';

  @override
  String get wishlistLoadError => '无法加载列表。';

  @override
  String get actionReserve => '我会买';

  @override
  String get actionBuyNow => '立即购买';

  @override
  String get actionCancel => '取消项目';

  @override
  String get actionUnreserve => '返回队列';

  @override
  String get actionDelete => '删除';

  @override
  String get deleteItemTitle => '删除项目？';

  @override
  String deleteItemMessage(String title) {
    return '「$title」将被永久删除。';
  }

  @override
  String get cancel => '取消';

  @override
  String get themeColor => '主题颜色';

  @override
  String get selected => '已选择';

  @override
  String get newItemTitle => '新项目';

  @override
  String get editItemTitle => '编辑项目';

  @override
  String get fieldTitle => '标题';

  @override
  String get fieldPriceRub => '价格 (₽)';

  @override
  String get fieldPriceHint => '例如：30000';

  @override
  String get fieldPriority => '优先级';

  @override
  String get fieldCategory => '类别';

  @override
  String get categoryNone => '无类别';

  @override
  String get fieldNotes => '备注';

  @override
  String get fieldUrl => '链接';

  @override
  String get save => '保存';

  @override
  String get validationTitleEmpty => '标题不能为空';

  @override
  String get saveFailed => '保存失败';

  @override
  String get loadError => '错误';

  @override
  String get categoriesLoadError => '无法加载类别';

  @override
  String get language => '语言';

  @override
  String get languageSystem => '系统';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get appTitle => 'WishQueue';

  @override
  String get wishlistTitle => '愿望清单';

  @override
  String get addItem => '添加项目';

  @override
  String get addIncome => '添加收入';

  @override
  String get distribute => '分配';

  @override
  String get cat_auto => '汽车';

  @override
  String get cat_home => '家居';

  @override
  String get cat_tools => '工具';

  @override
  String get cat_other => '其他';

  @override
  String get priority_urgent => '紧急';

  @override
  String get priority_high => '高';

  @override
  String get priority_normal => '普通';

  @override
  String get priority_someday => '将来';

  @override
  String get status_planned => '已计划';

  @override
  String get status_reserved => '已预留';

  @override
  String get status_bought => '已购买';

  @override
  String get status_cancelled => '已取消';

  @override
  String get wishlistTabActive => '活跃';

  @override
  String get wishlistTabBought => '已购买';

  @override
  String get addItemTooltip => '添加项目';

  @override
  String get wishlistEmptyActive => '列表为空。\n点击 + 添加第一个项目。';

  @override
  String get wishlistEmptyBought => '已购买的项目将显示在此处。';

  @override
  String get wishlistLoadError => '无法加载列表。';

  @override
  String get actionReserve => '我会买';

  @override
  String get actionBuyNow => '立即购买';

  @override
  String get actionCancel => '取消项目';

  @override
  String get actionUnreserve => '返回队列';

  @override
  String get actionDelete => '删除';

  @override
  String get deleteItemTitle => '删除项目？';

  @override
  String deleteItemMessage(String title) {
    return '「$title」将被永久删除。';
  }

  @override
  String get cancel => '取消';

  @override
  String get themeColor => '主题颜色';

  @override
  String get selected => '已选择';

  @override
  String get newItemTitle => '新项目';

  @override
  String get editItemTitle => '编辑项目';

  @override
  String get fieldTitle => '标题';

  @override
  String get fieldPriceRub => '价格 (₽)';

  @override
  String get fieldPriceHint => '例如：30000';

  @override
  String get fieldPriority => '优先级';

  @override
  String get fieldCategory => '类别';

  @override
  String get categoryNone => '无类别';

  @override
  String get fieldNotes => '备注';

  @override
  String get fieldUrl => '链接';

  @override
  String get save => '保存';

  @override
  String get validationTitleEmpty => '标题不能为空';

  @override
  String get saveFailed => '保存失败';

  @override
  String get loadError => '错误';

  @override
  String get categoriesLoadError => '无法加载类别';

  @override
  String get language => '语言';

  @override
  String get languageSystem => '系统';
}
