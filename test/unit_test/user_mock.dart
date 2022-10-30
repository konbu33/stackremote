import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

// path_providerのFake作成に必要なimport
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package:stackremote/authentication/authentication.dart';
import 'package:stackremote/rtc_video/rtc_video.dart';

import 'package:stackremote/user/domain/user_repository.dart';

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

// path_providerのFake作成
// path_provider内部の構成として、
// 「プラットフォーム毎のpathを提供するインスタンス」が存在しているイメージ？
// そのインスタンスをFakeのインスタンスに差し替えることで、任意のパスを応答可能にするイメージ？
void createFakePathProviderPlatform() {
  PathProviderPlatform.instance = FakePathProviderPlatform();
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
