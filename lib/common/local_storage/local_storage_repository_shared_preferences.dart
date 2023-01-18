import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage_repository.dart';
import 'shared_preferences_instance.dart';

part 'local_storage_repository_shared_preferences.g.dart';

@Riverpod(keepAlive: true)
LocalStorageRepositorySharedPreferences localStorageRepositorySharedPreferences(
    LocalStorageRepositorySharedPreferencesRef ref) {
  //
  final sharedPreferencesInstance =
      ref.watch(sharedPreferencesInstanceProvider);

  final localStorageRepositorySharedPreferences =
      LocalStorageRepositorySharedPreferences(
          sharedPreferencesInstance: sharedPreferencesInstance);

  return localStorageRepositorySharedPreferences;
}

class LocalStorageRepositorySharedPreferences
    implements LocalStorageRepository {
  const LocalStorageRepositorySharedPreferences({
    required this.sharedPreferencesInstance,
  });

  @override
  final SharedPreferences sharedPreferencesInstance;

  @override
  Future<bool> setBool({
    required String key,
    required bool value,
  }) async {
    final bool = await sharedPreferencesInstance.setBool(key, value);

    return bool;
  }

  @override
  bool? getBool({
    required String key,
  }) {
    final bool = sharedPreferencesInstance.getBool(key);

    return bool;
  }

  @override
  Future<bool> setString({
    required String key,
    required String value,
  }) async {
    final bool = await sharedPreferencesInstance.setString(key, value);

    return bool;
  }

  @override
  String? getString({
    required String key,
  }) {
    final string = sharedPreferencesInstance.getString(key);

    return string;
  }
}
