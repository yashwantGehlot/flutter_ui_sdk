import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageUtil {
  static final SecureStorageUtil _instance = SecureStorageUtil._internal();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final DEVICE_ID_KEY = "DEVICE_ID_KEY";
  final SECRET_KEY = "SECRET_KEY";
  final SECRET_TIMESTAMP_KEY = "SECRET_TIMESTAMP_KEY";

  SecureStorageUtil._internal();

  factory SecureStorageUtil() {
    return _instance;
  }

  Future<void> store(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }
}
