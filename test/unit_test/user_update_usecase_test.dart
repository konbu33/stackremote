import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stackremote/authentication/domain/firebase_auth_user.dart';
import 'package:stackremote/common/json_converter.dart';
import 'package:stackremote/rtc_video/rtc_video.dart';
import 'package:stackremote/user/infrastructure/user_repository_firestore.dart';
import 'package:stackremote/user/usecace/user_update_usecase.dart';

import '../common/dotenvtest.dart';
import 'user_mock.dart';

void main() {
  setUpAll(() {
    // dotenv読み込み
    dotEnvTestLoad();

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
    // 一方、StateNotifierProviderの場合は、overrideWithProvider メソッドを利用する必要がありそう。
    final container = ProviderContainer(overrides: [
      //
      RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider
          .overrideWithProvider(fakeRtcChannelStateNotifierProvider),
      //
      firebaseAuthUserStateNotifierProvider
          .overrideWithProvider(fakeFirebaseAuthUserStateNotifierProvider),
      //
      userRepositoryFirebaseProvider.overrideWithValue(userRepository),
    ]);

    // ユースケースのインスタンス生成
    final userUpdateUsecase = container.read(userUpdateUsecaseProvider);

    // モックの戻り値を生成
    final Future<void> mockResponse = Future.value();

    // ユースケース内で該当するリポジトリのメソッドが呼ばれた場合、引数をキャプチャするように指定
    when(() => userRepository.update(
          channelName: any(named: "channelName"),
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
          channelName: captureAny(
            named: "channelName",
            that: equals(
              FakeRtcChannelState().channelName,
            ),
          ),
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
    final String capturedCnannelName = captured[0];
    final String capturedeEmail = captured[1];
    final Map<String, dynamic> capturedData = captured[2];

    // キャプチャされた値毎に期待する値になっているか否か検証
    expect(capturedCnannelName, FakeRtcChannelState().channelName);

    expect(capturedeEmail, FakeFirebaseAuthUser().email);

    expect(capturedData, isA<Map<String, dynamic>>());
    expect(capturedData["nickName"], user.nickName);
    expect(capturedData["isHost"], user.isHost);
    expect(capturedData["joinedAt"], user.joinedAt);
    expect(capturedData["leavedAt"], user.leavedAt);
    expect(capturedData["isOnLongPressing"], user.isOnLongPressing);
    expect(capturedData["pointerPosition"],
        const OffsetConverter().toJson(user.pointerPosition));
  });
}
