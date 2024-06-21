import 'package:get_storage/get_storage.dart';

class TLocalStorage {
  static final TLocalStorage _instance = TLocalStorage._internal();

  final GetStorage _storage = GetStorage();

  factory TLocalStorage() {
    return _instance;
  }

  TLocalStorage._internal();

  // Method to save data
  Future<void> saveData<T>(String key,T value)async {
    await _storage.write(key, value);
  }

  // Method to read data
  T? readData<T>(String key) {
    return _storage.read<T>(key);
  }

  // Method to delete data
  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  // Method to clear all data
  Future<void> clearAll() async {
    await _storage.erase();
  }
}

