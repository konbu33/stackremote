import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageRepository {
  const LocalStorageRepository({
    required this.sharedPreferencesInstance,
  });

  final SharedPreferences sharedPreferencesInstance;

  Future<bool> setBool({
    required String key,
    required bool value,
  });

  bool? getBool({
    required String key,
  });

  Future<bool> setString({
    required String key,
    required String value,
  });

  String? getString({
    required String key,
  });
}
