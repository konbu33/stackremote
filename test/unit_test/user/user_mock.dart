import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

// path_providerのFake作成に必要なimport
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stackremote/authentication/authentication.dart';
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

class MocktailSharedPreferences extends Mock implements SharedPreferences {}

final MocktailSharedPreferences sharedPreferences = MocktailSharedPreferences();

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

class FakeFirebaseAuthUserStateNotifier extends Notifier<FirebaseAuthUser>
    implements FirebaseAuthUserStateNotifier {
  @override
  FirebaseAuthUser build() {
    return FakeFirebaseAuthUser();
  }

  @override
  void updateEmailVerified(bool value) {}
  @override
  void userInformationRegiser(FirebaseAuthUser value) {}
  @override
  void updateIsSignIn(bool value) {}
}

final fakeChannelNameProvider =
    StateProvider<String>((ref) => "fake_channel_name");

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
  final DateTime? joinedAt = user.joinedAt;
  @override
  final DateTime? leavedAt = user.leavedAt;
  @override
  final bool isOnLongPressing = user.isOnLongPressing;
  @override
  final Offset pointerPosition = user.pointerPosition;
  @override
  final Offset displayPointerPosition = user.displayPointerPosition;
  @override
  final Size displaySizeVideoMain = user.displaySizeVideoMain;
  @override
  final UserColor userColor = UserColor.red;
  @override
  final bool isMuteVideo = true;
}

class FakeUserStateNotifier extends AutoDisposeNotifier<User>
    implements UserStateNotifier {
  @override
  User build() {
    return FakeUserState();
  }
}
