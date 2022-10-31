import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stackremote/user/domain/user.dart';
// import 'package:stackremote/user/domain/userid.dart';
// import 'package:ulid/ulid.dart';

void main() {
  group("userインスタンス生成テスト", () {
    // const String email = "xxx@test.com";
    // const String password = "password";
    // const String firebaseAuthUid = "firebaseAuthUid";
    // const String firebaseAuthIdToken = "firebaseAuthIdToken";

    const String email = "xxx@test.com";
    const String nickName = "test_user";
    const String comment = "";
    const bool isHost = true;
    const Timestamp? joinedAt = null;
    const Timestamp? leavedAt = null;
    const bool isOnLongPressing = false;
    const Offset pointerPosition = Offset(0, 0);

    // test(
    //     "userのファクトリメソッドでインスタンス生成すると、userId属性にulidが採番され、userId以外の属性に引数の値が設定されていること",
    //     () {
    test("userのファクトリメソッドでインスタンス生成すると、引数の値が設定されていること", () {
      // when
      // final user = User.create(
      //   email: email,
      //   password: password,
      //   firebaseAuthUid: firebaseAuthUid,
      //   firebaseAuthIdToken: firebaseAuthIdToken,
      // );

      final user = User.create(
        email: email,
        nickName: nickName,
        comment: comment,
        isHost: isHost,
        joinedAt: joinedAt,
        leavedAt: leavedAt,
        isOnLongPressing: isOnLongPressing,
        pointerPosition: pointerPosition,
      );

      // then
      // expect(user.userId.value, isA<Ulid>());
      // expect(user.email, email);
      // print("userId : ${userId.value.runtimeType}");
      // print("userId : ${userId.value}");
      // expect(user.email, email);
      // expect(user.password, password);

      expect(user.email, email);
      expect(user.nickName, nickName);
      expect(user.comment, comment);
      expect(user.isHost, isHost);
      expect(user.joinedAt, joinedAt);
      expect(user.leavedAt, leavedAt);
      expect(user.isOnLongPressing, isOnLongPressing);
      expect(user.pointerPosition, pointerPosition);
    });

    test("reconstructメソッドでインスタンス生成した場合、各属性の値が引数の値と同じであること", () {
      // given
      // final userId = UserId.create();
      // const String email = "xxx@test.com";
      // const password = "password";
      // const firebaseAuthUid = "firebaseAuthUid";

      // when
      // final user = User.reconstruct(
      //   userId: userId,
      //   email: email,
      //   password: password,
      //   firebaseAuthUid: firebaseAuthUid,
      //   firebaseAuthIdToken: firebaseAuthIdToken,
      // );

      final user = User.reconstruct(
        email: email,
        nickName: nickName,
        comment: comment,
        isHost: isHost,
        joinedAt: joinedAt,
        leavedAt: leavedAt,
        isOnLongPressing: isOnLongPressing,
        pointerPosition: pointerPosition,
      );

      // then
      // expect(user.userId, userId);
      expect(user.email, email);
      expect(user.nickName, nickName);
      expect(user.comment, comment);
      expect(user.isHost, isHost);
      expect(user.joinedAt, joinedAt);
      expect(user.leavedAt, leavedAt);
      expect(user.isOnLongPressing, isOnLongPressing);
      expect(user.pointerPosition, pointerPosition);
      // expect(user.password, password);
    });

    // test("userの生成的コンストラクタ,プライベートコンストラクタを利用したインスタンス生成が不可なこと", () {
    //   // when
    //   // final user = User(userId: Ulid());
    //   // final user = User._(userId: Ulid());

    //   // then
    //   // print("userId : ${userId.value}");
    // });

    test("userインスタンスからtoJsonでjson変換し、fromJsonでオブジェクトに戻した場合、各属性の値が変わっていないこと",
        () {
      // given
      // final user = User.create(
      //   email: email,
      //   password: password,
      //   firebaseAuthUid: firebaseAuthUid,
      //   firebaseAuthIdToken: firebaseAuthIdToken,
      // );

      final user = User.create(
        email: "xxx@test.com",
        nickName: "test_user",
        comment: "",
        isHost: true,
        joinedAt: null,
        leavedAt: null,
        isOnLongPressing: false,
        pointerPosition: const Offset(0, 0),
      );

      // when
      // then
      final Map<String, dynamic> userToJson = user.toJson();
      // expect(userToJson["userId"], user.userId.value.toString());
      expect(userToJson["email"], user.email);
      expect(userToJson["nickName"], user.nickName);
      expect(userToJson["comment"], user.comment);
      expect(userToJson["isHost"], user.isHost);
      expect(userToJson["joinedAt"], user.joinedAt);
      expect(userToJson["leavedAt"], user.leavedAt);
      expect(userToJson["isOnLongPressing"], user.isOnLongPressing);
      expect(userToJson["pointerPosition"],
          '{"dx":${user.pointerPosition.dx},"dy":${user.pointerPosition.dy}}');
      // expect(userToJson["password"], user.password);

      final User userFromJson = User.fromJson(userToJson);
      // expect(userFromJson.userId, user.userId);
      expect(userFromJson.email, user.email);
      expect(userFromJson.nickName, user.nickName);
      expect(userFromJson.comment, user.comment);
      expect(userFromJson.isHost, user.isHost);
      expect(userFromJson.joinedAt, user.joinedAt);
      expect(userFromJson.leavedAt, user.leavedAt);
      expect(userFromJson.isOnLongPressing, user.isOnLongPressing);
      expect(userFromJson.pointerPosition, user.pointerPosition);
      // expect(userFromJson.password, user.password);

      // print("user         : ${user} ");
      // print("userToJson   : $userToJson");
      // print("userFromJson : ${userFromJson}");
    });
  });
}
