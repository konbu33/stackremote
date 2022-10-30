import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

// path_providerのFake作成に必要
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package:stackremote/authentication/authentication.dart';
import 'package:stackremote/rtc_video/rtc_video.dart';

import 'package:stackremote/user/domain/user.dart';
import 'package:stackremote/user/domain/user_repository.dart';
import 'package:stackremote/user/infrastructure/user_repository_firestore.dart';
import 'package:stackremote/user/usecace/user_set_usecase.dart';

import '../common/dotenvtest.dart';

// --------------------------------------------------
//
// FakePathProviderPlatform
//
// --------------------------------------------------

// path_providerのFake作成
// path_provider内部の構成として、
// 「プラットフォーム毎のpathを提供するインスタンス」が存在しているイメージ？
// このインスタンスのFakeを作成するイメージ？
class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    return Directory.current.toString();
  }
}

// --------------------------------------------------
//
// MockUserRepository
//
// --------------------------------------------------
// UserRepositoryのMockクラス作成
// メソッドを利用する場合は、Mockで済みそう。メンバ変数を利用する場合は、Fakeが必要そう。
class MockUserRepository extends Mock implements UserRepository {}

// --------------------------------------------------
//
// FakeFirebaseAuthUser
//
// --------------------------------------------------
// メソッドを利用する場合は、Mockで済みそう。メンバ変数を利用する場合は、Fakeが必要そう。
class FakeFirebaseAuthUser extends Fake implements FirebaseAuthUser {
  FakeFirebaseAuthUser();

  @override
  final String email = "fakexxx@test.com";
}

class FakeFirebaseAuthUserStateNotifier extends StateNotifier<FirebaseAuthUser>
    implements FirebaseAuthUserStateNotifier {
  FakeFirebaseAuthUserStateNotifier() : super(FakeFirebaseAuthUser());

  @override
  void initial() {}
  @override
  void updateEmailVerified(bool value) {}
  @override
  void updateFirebaseAuthIdToken(String value) {}
  @override
  void updatePassword(String value) {}
  @override
  void userInformationRegiser(FirebaseAuthUser value) {}
}

final fakeFirebaseAuthUserStateNotifierProvider =
    StateNotifierProvider<FakeFirebaseAuthUserStateNotifier, FirebaseAuthUser>(
        (ref) => FakeFirebaseAuthUserStateNotifier());

// --------------------------------------------------
//
// FakeRtcChannelState
//
// --------------------------------------------------
// メソッドを利用する場合は、Mockで済みそう。メンバ変数を利用する場合は、Fakeが必要そう。
class FakeRtcChannelState extends Fake implements RtcChannelState {
  FakeRtcChannelState();

  @override
  final String channelName = "fake_cnannel_name";
}

class FakeRtcChannelStateNotifier extends StateNotifier<RtcChannelState>
    implements RtcChannelStateNotifier {
  FakeRtcChannelStateNotifier() : super(FakeRtcChannelState());

  @override
  void changeJoined(bool value) {}
  @override
  void setRemoteUid(int value) {}
  @override
  void setTempLogConfig() {}
  @override
  void toggleViewSwitch() {}
  @override
  void initial() {}
  @override
  void updateChannelName(String value) {}
  @override
  void updateToken(String value) {}
}

final fakeRtcChannelStateNotifierProvider =
    StateNotifierProvider<FakeRtcChannelStateNotifier, RtcChannelState>(
        (ref) => FakeRtcChannelStateNotifier());

void main() {
  // path_providerのFake作成
  // path_provider内部の構成として、
  // 「プラットフォーム毎のpathを提供するインスタンス」が存在しているイメージ？
  // そのインスタンスをFakeのインスタンスに差し替えることで、任意のパスを応答可能にするイメージ？
  PathProviderPlatform.instance = FakePathProviderPlatform();

  // UserRepositoryのMockインスタンス生成
  final userRepository = MockUserRepository();

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
        )).thenAnswer((invocation) => Future.value());

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

    // logger.d("$captured, ${captured.length}");
    // logger.d(
    //     "${FakeRtcChannelState().channelName}, ${FakeFirebaseAuthUser().email}");

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
