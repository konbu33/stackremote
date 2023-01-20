import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'local_storage_repository.dart';
import 'local_storage_repository_shared_preferences.dart';

part 'get_string_usecase.g.dart';

typedef GetStringUsecaseFunction = String? Function({required String key});

@Riverpod(keepAlive: true)
GetStringUsecaseFunction getStringUsecase(GetStringUsecaseRef ref) {
  String? execute({
    required String key,
  }) {
    final LocalStorageRepository localStorageRepository =
        ref.watch(localStorageRepositorySharedPreferencesProvider);

    final res = localStorageRepository.getString(key: key);

    return res;
  }

  return execute;
}
