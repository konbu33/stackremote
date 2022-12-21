import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/authentication/domain/firebase_auth_user.dart';
import 'package:stackremote/user/domain/user.dart';

import '../user_mock.dart';

void main() {
  group("userインスタンスのメソッドテスト", () {
    // given
    const String comment = "";
    final String email = FakeFirebaseAuthUser().email;
    const bool isHost = true;
    const bool isOnLongPressing = false;
    const Timestamp? joinedAt = null;
    const Timestamp? leavedAt = null;
    final String nickName = FakeFirebaseAuthUser().email.split("@")[0];
    const Offset pointerPosition = Offset(0, 0);

    late ProviderContainer container;
    late User userState;
    // late UserStateNotifier userStateNotifier;

    setUp(() {
      container = ProviderContainer(overrides: [
        firebaseAuthUserStateNotifierProvider
            .overrideWith(() => FakeFirebaseAuthUserStateNotifier()),
      ]);

      // userStateNotifier = container.read(userStateNotifierProvider.notifier);

      // given
      userState = container.read(userStateNotifierProvider);
      expect(userState.comment, comment);
      expect(userState.email, email);
      expect(userState.isHost, isHost);
      expect(userState.isOnLongPressing, isOnLongPressing);
      expect(userState.joinedAt, joinedAt);
      expect(userState.leavedAt, leavedAt);
      expect(userState.nickName, nickName);
      expect(userState.pointerPosition, pointerPosition);
    });

/*
    test("updateIsHostメソッドを実行した場合、isHost属性のみ値が変更され、それ以外の属性は値が変更されないこと", () {
      // given

      // when
      userStateNotifier.updateIsHost(false);

      // then
      userState = container.read(userStateNotifierProvider);
      expect(userState.comment, comment);
      expect(userState.email, email);
      expect(userState.isHost, !isHost);
      expect(userState.isOnLongPressing, isOnLongPressing);
      expect(userState.joinedAt, joinedAt);
      expect(userState.leavedAt, leavedAt);
      expect(userState.nickName, nickName);
      expect(userState.pointerPosition, pointerPosition);
    });
    test(
        "setNickNameメソッドを実行した場合、nickName属性のみ値が変更され、それ以外の属性は値が変更されないこと(nicknameが8文字以内の場合)",
        () {
      // given

      // when
      const String changeNickName = "change";
      userStateNotifier.setNickName(changeNickName);

      // then
      userState = container.read(userStateNotifierProvider);
      expect(userState.comment, comment);
      expect(userState.email, email);
      expect(userState.isHost, isHost);
      expect(userState.isOnLongPressing, isOnLongPressing);
      expect(userState.joinedAt, joinedAt);
      expect(userState.leavedAt, leavedAt);
      expect(userState.nickName, isNot(equals(nickName)));
      expect(userState.nickName, changeNickName);
      expect(userState.pointerPosition, pointerPosition);
    });
    test(
        "setNickNameメソッドを実行した場合、nickName属性のみ値が変更され、それ以外の属性は値が変更されないこと(nicknameが8文字より多いの場合)",
        () {
      // given

      // when
      const String changeNickName = "changeNickName";
      userStateNotifier.setNickName(changeNickName);

      // then
      userState = container.read(userStateNotifierProvider);
      expect(userState.comment, comment);
      expect(userState.email, email);
      expect(userState.isHost, isHost);
      expect(userState.isOnLongPressing, isOnLongPressing);
      expect(userState.joinedAt, joinedAt);
      expect(userState.leavedAt, leavedAt);
      expect(userState.nickName, isNot(equals(nickName)));
      expect(userState.nickName, "${changeNickName.substring(0, 8)}...");
      expect(userState.pointerPosition, pointerPosition);
    });

    test("buildメソッドを実行した場合、元の属性の値にリセットされること", () {
      // given

      // when
      const String changeNickName = "changeNickName";
      userStateNotifier.setNickName(changeNickName);

      // then
      userState = container.read(userStateNotifierProvider);
      expect(userState.comment, comment);
      expect(userState.email, email);
      expect(userState.isHost, isHost);
      expect(userState.isOnLongPressing, isOnLongPressing);
      expect(userState.joinedAt, joinedAt);
      expect(userState.leavedAt, leavedAt);
      expect(userState.nickName, isNot(equals(nickName)));
      expect(userState.nickName, "${changeNickName.substring(0, 8)}...");
      expect(userState.pointerPosition, pointerPosition);

      userStateNotifier.build();
      userState = container.read(userStateNotifierProvider);
      expect(userState.comment, comment);
      expect(userState.email, email);
      expect(userState.isHost, isHost);
      expect(userState.isOnLongPressing, isOnLongPressing);
      expect(userState.joinedAt, joinedAt);
      expect(userState.leavedAt, leavedAt);
      expect(userState.nickName, nickName);
      expect(userState.pointerPosition, pointerPosition);
    });

*/
  });
}
