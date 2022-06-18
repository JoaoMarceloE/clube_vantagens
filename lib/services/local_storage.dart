import 'package:localstorage/localstorage.dart';

class LocalStorageService {
  static final LocalStorage _storage = LocalStorage('app.json');

  /// Save in storage local device
  static Future<void> save(String key, Map<String, dynamic> map) async {
    try {
      await _storage.setItem(key, map);
    } catch (error) {
      print('ERROR ===> ' + error.toString());
    }
  }

  /// Read data of storage
  static Future ready() {
    return _storage.ready;
  }

  /// Get data storage local
  static Future<Map<String, dynamic>> find(String key) async {
    await _storage.ready;
    return _storage.getItem(key);
  }

  /// Get data storage local
  static Future<Map<String, dynamic>> findAsync(String key) async {
    await LocalStorageService.ready();
    return _storage.getItem(key);
  }

  static Future<void> delete(String key) async {
    _storage.deleteItem(key);
  }
}
