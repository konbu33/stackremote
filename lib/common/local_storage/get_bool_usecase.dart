import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'local_storage_repository.dart';
import 'local_storage_repository_shared_preferences.dart';

part 'get_bool_usecase.g.dart';

typedef GetBoolUsecaseFunction = bool? Function({required String key});

@riverpod
GetBoolUsecaseFunction getBoolUsecase(GetBoolUsecaseRef ref) {
  bool? execute({
    required String key,
  }) {
    final LocalStorageRepository localStorageRepository =
        ref.watch(localStorageRepositorySharedPreferencesProvider);

    final res = localStorageRepository.getBool(key: key);

    return res;
  }

  return execute;
}
