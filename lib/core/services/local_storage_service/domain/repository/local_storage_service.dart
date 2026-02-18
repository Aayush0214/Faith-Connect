abstract interface class LocalStorageService {
  // --- Secure Methods (Tokens ke liye) ---
  Future<void> setSecureString(String key, String value);
  Future<String?> getSecureString(String key);
  Future<void> deleteSecureData(String key);

  // --- Normal Methods (Settings/Flags ke liye) ---
  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);

  Future<void>  setString(String key, String value);
  Future<String?> getString(String key);

  Future<void> setInt(String key, int value);
  Future<int?> getInt(String key);

  // --- Common Methods ---
  Future<void> clearAll(); // Logout ke time sab saaf karne ke liye
  Future<void> remove(String key); // Normal storage se specific key hatane ke liye
}