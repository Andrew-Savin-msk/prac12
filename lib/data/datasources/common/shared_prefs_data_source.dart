// Data-слой: обёртка над SharedPreferences для работы с локальным хранилищем
import 'package:shared_preferences/shared_preferences.dart';

/// Data source для работы с SharedPreferences.
/// Инкапсулирует работу с локальным хранилищем и обрабатывает ошибки.
class SharedPrefsDataSource {
  SharedPreferences? _prefs;

  /// Инициализация SharedPreferences. Должна быть вызвана перед использованием.
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      // В случае ошибки _prefs останется null, методы вернут значения по умолчанию
    }
  }

  /// Получить bool значение по ключу
  Future<bool?> getBool(String key) async {
    try {
      if (_prefs == null) {
        await init();
      }
      return _prefs?.getBool(key);
    } catch (e) {
      return null;
    }
  }

  /// Сохранить bool значение по ключу
  Future<bool> setBool(String key, bool value) async {
    try {
      if (_prefs == null) {
        await init();
      }
      return await _prefs?.setBool(key, value) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Получить String значение по ключу
  Future<String?> getString(String key) async {
    try {
      if (_prefs == null) {
        await init();
      }
      return _prefs?.getString(key);
    } catch (e) {
      return null;
    }
  }

  /// Сохранить String значение по ключу
  Future<bool> setString(String key, String value) async {
    try {
      if (_prefs == null) {
        await init();
      }
      return await _prefs?.setString(key, value) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Удалить значение по ключу
  Future<bool> remove(String key) async {
    try {
      if (_prefs == null) {
        await init();
      }
      return await _prefs?.remove(key) ?? false;
    } catch (e) {
      return false;
    }
  }
}
