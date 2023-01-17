import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'local_storage_repository.dart';
import 'local_storage_repository_shared_preferences.dart';

part 'set_bool_usecase.g.dart';

typedef SetBoolUsecaseFunction = Future<bool> Function(
    {required String key, required bool value});

@riverpod
SetBoolUsecaseFunction setBoolUsecase(SetBoolUsecaseRef ref) {
  //
  Future<bool> execute({
    required String key,
    required bool value,
  }) async {
    final LocalStorageRepository localStorageRepository =
        ref.watch(localStorageRepositorySharedPreferencesProvider);

    final res = await localStorageRepository.setBool(key: key, value: value);

    return res;
  }

  return execute;
}
