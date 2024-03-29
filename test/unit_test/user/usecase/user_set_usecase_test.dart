import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stackremote/user/user.dart';

import '../user_mock.dart';

void main() {
  setUpAll(() {
    /*
      UserPepository.updateメソッドの引数をキャプチャしたいため、引数マッチャーである any() を利用します。
      この引数の型が、FakeUser型(というカスタム型)であるため、registerFallbackVale で事前登録しておく必要がある。
    */
    registerFallbackValue(user);
  });

  test("ユースケースに渡した引数と同値が、リポジトリのメソッドの引数として利用されていること", () async {
    // given

    // ユースケース内で利用している、該当ProviderをMock,Fakeで上書き
    // override対象のプロバイダーが、Providerの場合は、overrideWithValue メソッドで済みそう。
    // 一方、StateNotifierProviderの場合は、overrideWith メソッドを利用する必要がありそう。
    final container = ProviderContainer(overrides: [
      //
      userStateNotifierProvider.overrideWith(() => FakeUserStateNotifier()),

      //
      userRepositoryFirebaseProvider.overrideWithValue(userRepository),
    ]);

    // ユースケースのインスタンス生成
    final userSetUsecase = container.read(userSetUsecaseProvider);

    // モックの戻り値を生成
    final Future<void> mockResponse = Future.value();

    // ユースケース内で該当するリポジトリのメソッドが呼ばれた場合、引数をキャプチャするように指定
    when(() => userRepository.set(
          email: any(named: "email"),
          user: any(named: "user"),
        )).thenAnswer((invocation) => mockResponse);

    // when
    // ユースケース実行
    await userSetUsecase();

    // then
    // キャプチャされた値を変数に取得。
    // この時点で必須ではないが試しに、that引数で指定したマッチャーで検証
    final captured = verify(() => userRepository.set(
          email: captureAny(
            named: "email",
            that: equals(FakeFirebaseAuthUser().email),
          ),
          user: captureAny(
            named: "user",
            // that: equals(user),
          ),
        )).captured;

    // キャプチャされた値が配列で格納されているため、それぞれ変数に詰め直し
    final String capturedeEmail = captured[0];
    final User capturedUser = captured[1];

    // キャプチャされた値毎に期待する値になっているか否か検証
    expect(capturedeEmail, FakeFirebaseAuthUser().email);

    // expect(capturedUser, FakeUserState());
    expect(capturedUser.comment, user.comment);
    expect(capturedUser.email, user.email);
    expect(capturedUser.isHost, user.isHost);
    expect(capturedUser.isOnLongPressing, user.isOnLongPressing);
    expect(capturedUser.joinedAt, user.joinedAt);
    expect(capturedUser.leavedAt, user.leavedAt);
    expect(capturedUser.nickName, user.nickName);
    expect(capturedUser.pointerPosition, user.pointerPosition);
  });
}
