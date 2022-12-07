import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stackremote/authentication/domain/firebase_auth_user.dart';
import 'package:stackremote/common/json_converter.dart';
import 'package:stackremote/user/infrastructure/user_repository_firestore.dart';
import 'package:stackremote/user/usecace/user_update_usecase.dart';

import '../user_mock.dart';

void main() {
  test("ユースケースに渡した引数と同値が、リポジトリのメソッドの引数として利用されていること", () async {
    // given

    // ユースケース内で利用している、該当ProviderをMock,Fakeで上書き
    // override対象のプロバイダーが、Providerの場合は、overrideWithValue メソッドで済みそう。
    // 一方、StateNotifierProviderの場合は、overrideWith メソッドを利用する必要がありそう。
    final container = ProviderContainer(overrides: [
      //
      firebaseAuthUserStateNotifierProvider
          .overrideWith(() => FakeFirebaseAuthUserStateNotifier()),
      //
      userRepositoryFirebaseProvider.overrideWithValue(userRepository),
    ]);

    // ユースケースのインスタンス生成
    final userUpdateUsecase = container.read(userUpdateUsecaseProvider);

    // モックの戻り値を生成
    final Future<void> mockResponse = Future.value();

    // ユースケース内で該当するリポジトリのメソッドが呼ばれた場合、引数をキャプチャするように指定
    when(() => userRepository.update(
          email: any(named: "email"),
          data: any(named: "data"),
        )).thenAnswer((invocation) => mockResponse);

    // when
    // ユースケース実行
    await userUpdateUsecase(
      comment: user.comment,
      email: user.email,
      isHost: user.isHost,
      isOnLongPressing: user.isOnLongPressing,
      joinedAt: user.joinedAt,
      leavedAt: user.leavedAt,
      nickName: user.nickName,
      pointerPosition: user.pointerPosition,
    );

    // then
    // キャプチャされた値を変数に取得。
    // この時点で必須ではないが試しに、that引数で指定したマッチャーで検証
    final captured = verify(() => userRepository.update(
          email: captureAny(
            named: "email",
            that: equals(FakeFirebaseAuthUser().email),
          ),
          data: captureAny(
            named: "data",
            that: isA<Map<String, dynamic>>(),
          ),
        )).captured;

    // キャプチャされた値が配列で格納されているため、それぞれ変数に詰め直し
    final String capturedeEmail = captured[0];
    final Map<String, dynamic> capturedData = captured[1];

    // キャプチャされた値毎に期待する値になっているか否か検証
    expect(capturedeEmail, FakeFirebaseAuthUser().email);

    expect(capturedData, isA<Map<String, dynamic>>());
    expect(capturedData["comment"], user.comment);
    expect(capturedData["email"], user.email);
    expect(capturedData["isHost"], user.isHost);
    expect(capturedData["isOnLongPressing"], user.isOnLongPressing);
    expect(capturedData["joinedAt"], user.joinedAt);
    expect(capturedData["leavedAt"], user.leavedAt);
    expect(capturedData["nickName"], user.nickName);
    expect(capturedData["pointerPosition"],
        const OffsetConverter().toJson(user.pointerPosition));
  });
}
