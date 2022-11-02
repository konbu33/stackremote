import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stackremote/rtc_video/rtc_video.dart';
import 'package:stackremote/user/infrastructure/user_repository_firestore.dart';
import 'package:stackremote/user/usecace/user_delete_usecase.dart';

import '../common/dotenvtest.dart';
import 'user_mock.dart';

void main() {
  setUpAll(() {
    // dotenv読み込み
    dotEnvTestLoad();

    // path_providerのFake作成
    createFakePathProviderPlatform();
  });

  test("ユースケースに渡した引数と同値が、リポジトリのメソッドの引数として利用されていること", () async {
    // given
    // ユースケース内で利用している、該当ProviderをMock,Fakeで上書き
    // override対象のプロバイダーが、Providerの場合は、overrideWithValue メソッドで済みそう。
    // 一方、StateNotifierProviderの場合は、overrideWith メソッドを利用する必要がありそう。
    final container = ProviderContainer(overrides: [
      //
      RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider
          .overrideWith((ref) => FakeRtcChannelStateNotifier()),
      //
      userRepositoryFirebaseProvider.overrideWithValue(userRepository),
    ]);

    // ユースケースのインスタンス生成
    final userDeleteUsecase = container.read(userDeleteUsecaseProvider);

    // モックの戻り値を生成
    final Future<void> mockResponse = Future.value();

    // ユースケース内で該当するリポジトリのメソッドが呼ばれた場合、引数をキャプチャするように指定
    when(() => userRepository.delete(
          channelName: any(named: "channelName"),
          email: any(named: "email"),
        )).thenAnswer((invocation) => mockResponse);

    // when
    // ユースケース実行
    await userDeleteUsecase(email: FakeFirebaseAuthUser().email);

    // then
    // キャプチャされた値を変数に取得。
    // この時点で必須ではないが試しに、that引数で指定したマッチャーで検証
    final captured = verify(() => userRepository.delete(
          channelName: captureAny(
            named: "channelName",
            that: equals(FakeRtcChannelState().channelName),
          ),
          email: captureAny(
            named: "email",
            that: equals(FakeFirebaseAuthUser().email),
          ),
        )).captured;

    // キャプチャされた値が配列で格納されているため、それぞれ変数に詰め直し
    final String capturedChannelName = captured[0];
    final String capturedEmail = captured[1];

    // キャプチャされた値毎に期待する値になっているか否か検証
    expect(capturedChannelName, FakeRtcChannelState().channelName);

    expect(capturedEmail, FakeFirebaseAuthUser().email);
  });
}
