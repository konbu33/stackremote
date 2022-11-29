import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

// path_providerのFake作成に必要なimport
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package:stackremote/authentication/authentication.dart';
// import 'package:stackremote/rtc_video/rtc_video.dart';
import 'package:stackremote/user/domain/user.dart';

import 'package:stackremote/user/domain/user_repository.dart';
import 'package:stackremote/user/domain/users.dart';

// --------------------------------------------------
//
// User
//
// --------------------------------------------------

final user = User.create(
  email: FakeFirebaseAuthUser().email,
);

// --------------------------------------------------
//
// User
//
// --------------------------------------------------
// Userインスタンスの配列生成
final List<User> userList = [
  User.create(
    email: "ake@test.com",
  ),
  User.create(
    email: "ike@test.com",
  ),
  User.create(
    email: "uke@test.com",
  ),
];

// Usersコレクションオブジェクト生成
final Users users = Users.reconstruct(users: userList);

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
// MocktailUserRepository
//
// --------------------------------------------------
// UserRepositoryのMockクラス作成
// メソッドを利用する場合は、Mockで済みそう。メンバ変数を利用する場合は、Fakeが必要そう。
class MocktailUserRepository extends Mock implements UserRepository {}

// UserRepositoryのMockインスタンス生成
final MocktailUserRepository userRepository = MocktailUserRepository();

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
  void userInformationRegiser(FirebaseAuthUser value) {}
  @override
  void updateIsSignIn(bool value) {}
}

// --------------------------------------------------
//
// FakeRtcChannelState
//
// --------------------------------------------------
// メソッドを利用する場合は、Mockで済みそう。メンバ変数を利用する場合は、Fakeが必要そう。
// class FakeRtcChannelState extends Fake implements RtcChannelState {
//   FakeRtcChannelState();

//   @override
//   final String channelName = "fake_cnannel_name";
// }

final fakeChannelNameProvider =
    StateProvider<String>((ref) => "fake_channel_name");

// class FakeRtcChannelStateNotifier extends StateNotifier<RtcChannelState>
//     implements RtcChannelStateNotifier {
//   FakeRtcChannelStateNotifier() : super(FakeRtcChannelState());

//   @override
//   void changeJoined(bool value) {}
//   @override
//   void setRemoteUid(int value) {}
//   @override
//   void setTempLogConfig() {}
//   @override
//   void initial() {}
//   @override
//   void updateChannelName(String value) {}
//   @override
//   void updateToken(String value) {}
// }

// --------------------------------------------------
//
// FakeUserState
//
// --------------------------------------------------
// メソッドを利用する場合は、Mockで済みそう。メンバ変数を利用する場合は、Fakeが必要そう。
class FakeUserState extends Fake implements User {
  FakeUserState();

  @override
  final String email = FakeFirebaseAuthUser().email;
  @override
  final String nickName = user.nickName;
  @override
  final String comment = user.comment;
  @override
  final bool isHost = user.isHost;
  @override
  final Timestamp? joinedAt = user.joinedAt;
  @override
  final Timestamp? leavedAt = user.leavedAt;
  @override
  final bool isOnLongPressing = user.isOnLongPressing;
  @override
  final Offset pointerPosition = user.pointerPosition;
}

class FakeUserStateNotifier extends StateNotifier<User>
    implements UserStateNotifier {
  FakeUserStateNotifier() : super(FakeUserState());

  @override
  void initial() {}

  @override
  void setNickName(String value) {}

  @override
  void updateIsHost(bool value) {}
}
