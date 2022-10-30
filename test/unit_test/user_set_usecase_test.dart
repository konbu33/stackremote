import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:stackremote/authentication/authentication.dart';
import 'package:stackremote/rtc_video/rtc_video.dart';

import 'package:stackremote/user/domain/user.dart';
import 'package:stackremote/user/infrastructure/user_repository_firestore.dart';
import 'package:stackremote/user/usecace/user_set_usecase.dart';

import '../common/dotenvtest.dart';
import 'user_mock.dart';

void main() {
  // UserRepositoryのMockインスタンス生成
  final userRepository = MockUserRepository();

  // モックの戻り値を生成
  final Future<void> mockResponse = Future.value();

  // const String email = "xxx@test.com";
  const String nickName = "test_user";
  const String comment = "";
  const bool isHost = true;
  const Timestamp? joinedAt = null;
  const Timestamp? leavedAt = null;
  const bool isOnLongPressing = false;
  const Offset pointerPosition = Offset(0, 0);

  final user = User.create(
    // email: email,
    email: FakeFirebaseAuthUser().email,
    nickName: nickName,
    comment: comment,
    isHost: isHost,
    joinedAt: joinedAt,
    leavedAt: leavedAt,
    isOnLongPressing: isOnLongPressing,
    pointerPosition: pointerPosition,
  );

  setUpAll(() {
    // dotenv読み込み
    dotEnvTestLoad();

    // path_providerのFake作成
    createFakePathProviderPlatform();

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
      userRepositoryFirebaseProvider.overrideWithValue(userRepository),
      firebaseAuthUserStateNotifierProvider
          .overrideWithProvider(fakeFirebaseAuthUserStateNotifierProvider),
      RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider
          .overrideWithProvider(fakeRtcChannelStateNotifierProvider),
    ]);

    // ユースケースのインスタンス生成
    final userSetUsecase = container.read(userSetUsecaseProvider);

    // ユースケース内でgetTemporaryDirectoryメソッドが利用されているのだが、
    // getTemporaryDirectoryメソッドが実行された場合、
    // FakeのgetTemporaryDirectoryメソッドが実行されているか確認
    // final Directory dir = await getTemporaryDirectory();
    // print("dir : ------------------ : ${dir.path}");

    // ユースケース内で該当するリポジトリのメソッドが呼ばれた場合、引数をキャプチャするように指定
    when(() => userRepository.set(
          channelName: any(named: "channelName"),
          email: any(named: "email"),
          user: any(named: "user"),
        )).thenAnswer((invocation) => mockResponse);

    // when
    // ユースケース実行
    await userSetUsecase(
      nickName: nickName,
      isHost: isHost,
      joinedAt: joinedAt,
      leavedAt: leavedAt,
      isOnLongPressing: isOnLongPressing,
      pointerPosition: pointerPosition,
    );

    // then
    // キャプチャされた値を変数に取得。
    // この時点で必須ではないが試しに、that引数で指定したマッチャーで検証
    final captured = verify(() => userRepository.set(
          channelName: captureAny(
            named: "channelName",
            that: equals(FakeRtcChannelState().channelName),
          ),
          email: captureAny(
            named: "email",
            that: equals(FakeFirebaseAuthUser().email),
          ),
          user: captureAny(
            named: "user",
            that: equals(user),
          ),
        )).captured;

    // キャプチャされた値が配列で格納されているため、それぞれ変数に詰め直し
    final String capturedCnannelName = captured[0];
    final String capturedeEmail = captured[1];
    final User capturedUser = captured[2];

    // キャプチャされた値毎に期待する値になっているか否か検証
    expect(capturedCnannelName, FakeRtcChannelState().channelName);

    expect(capturedeEmail, FakeFirebaseAuthUser().email);

    expect(capturedUser, user);
    expect(capturedUser.nickName, user.nickName);
    expect(capturedUser.isHost, user.isHost);
    expect(capturedUser.joinedAt, user.joinedAt);
    expect(capturedUser.leavedAt, user.leavedAt);
    expect(capturedUser.isOnLongPressing, user.isOnLongPressing);
    expect(capturedUser.pointerPosition, user.pointerPosition);
  });
}
