import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:stackremote/user/user.dart';

import '../user_mock.dart';

void main() {
  test("ユースケースに渡した引数と同値が、リポジトリのメソッドの引数として利用されていること", () async {
    // given

    // ユースケース内で利用している、該当ProviderをMock,Fakeで上書き
    // override対象のプロバイダーが、Providerの場合は、overrideWithValue メソッドで済みそう。
    // 一方、StateNotifierProviderの場合は、overrideWith メソッドを利用する必要がありそう。
    final container = ProviderContainer(overrides: [
      userRepositoryFirebaseProvider.overrideWithValue(userRepository),
    ]);

    // ユースケースのインスタンス生成
    final userFetchByIdUsecase = container.read(userFetchByIdUsecaseProvider);

    // モックの戻り値を生成
    final Stream<User> mockResponse = Stream.value(user);

    // ユースケース内で該当するリポジトリのメソッドが呼ばれた場合、引数をキャプチャするように指定
    when(() => userRepository.fetchById(
          email: any(named: "email"),
        )).thenAnswer((invocation) => mockResponse);

    // when
    // ユースケース実行
    final res = userFetchByIdUsecase(
      email: FakeFirebaseAuthUser().email,
    );

    // then
    // キャプチャされた値を変数に取得。
    // この時点で必須ではないが試しに、that引数で指定したマッチャーで検証
    final captured = verify(() => userRepository.fetchById(
          email: captureAny(
            named: "email",
            that: equals(FakeFirebaseAuthUser().email),
          ),
        )).captured;

    // キャプチャされた値が配列で格納されているため、それぞれ変数に詰め直し
    final String capturedeEmail = captured[0];

    // キャプチャされた値毎に期待する値になっているか否か検証
    expect(capturedeEmail, FakeFirebaseAuthUser().email);

    // responseの値も確認
    final resUser = await res.single;

    expect(resUser, equals(user));
  });
}
