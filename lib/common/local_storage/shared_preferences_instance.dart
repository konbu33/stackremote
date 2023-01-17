import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stackremote/common/util/stackremote_exception.dart';

import '../util/logger.dart';

part 'shared_preferences_instance.g.dart';

@riverpod
SharedPreferences sharedPreferencesInstance(SharedPreferencesInstanceRef ref) {
  throw UnimplementedError();

  // 下記の通り、ProviderScopeで上書きする想定のため、
  // 初期状態としては、中身はUnimplementedErrorとして、Providerだけ用意しておく。

  // ProviderScope(
  //   overrides: [
  //     // sharedPreferencesインスタンス生成
  //     sharedPreferencesInstanceProvider
  //         .overrideWithValue(await createSharedPreferencesInstance()),
  //   ],
}

Future<SharedPreferences> createSharedPreferencesInstance() async {
  try {
    // shared_preferenceインスタンス生成
    final prefs = await SharedPreferences.getInstance();

    const message = "shared preference の instance生成に成功しました。";
    logger.d(message);

    return prefs;
    //
  } on Exception catch (e, s) {
    final message = "shared preference の instance生成に失敗しました。: $e, $s";
    logger.d(message);

    throw StackremoteException(plugin: 'local_storage', message: message);
  }
}
