import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repository/local_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageServiceImpl implements LocalStorageService {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  // Constructor mein dependencies inject hongi (main.dart se)
  LocalStorageServiceImpl({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences sharedPreferences,
  }) : _secureStorage = secureStorage,
       _sharedPreferences = sharedPreferences;

  // ==================================================
  // SECURE STORAGE METHODS (For Sensitive Data)
  // ==================================================

  @override
  Future<void> setSecureString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> getSecureString(String key) async {
    return await _secureStorage.read(key: key);
  }

  @override
  Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key);
  }

  // ==================================================
  // SHARED PREFERENCES METHODS (For Non-Sensitive Data)
  // ==================================================

  @override
  Future<void> setBool(String key, bool value) async {
    await _sharedPreferences.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    // Default value null return karte hain taaki pata chale key exist karti hai ya nahi
    return _sharedPreferences.getBool(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _sharedPreferences.getString(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    await _sharedPreferences.setInt(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    return _sharedPreferences.getInt(key);
  }

  @override
  Future<void> remove(String key) async {
    await _sharedPreferences.remove(key);
  }

  // ==================================================
  // CLEAR ALL (For Logout - The Nuclear Option)
  // ==================================================
  @override
  Future<void> clearAll() async {
    await Future.wait([_secureStorage.deleteAll(), _sharedPreferences.clear()]);
  }
}
