import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'local_storage_repository.dart';
import 'local_storage_repository_shared_preferences.dart';

part 'set_string_usecase.g.dart';

typedef SetStringUsecaseFunction = Future<bool> Function(
    {required String key, required String value});

@riverpod
SetStringUsecaseFunction setStringUsecase(SetStringUsecaseRef ref) {
  //
  Future<bool> execute({
    required String key,
    required String value,
  }) async {
    final LocalStorageRepository localStorageRepository =
        ref.watch(localStorageRepositorySharedPreferencesProvider);

    final res = await localStorageRepository.setString(key: key, value: value);

    return res;
  }

  return execute;
}
