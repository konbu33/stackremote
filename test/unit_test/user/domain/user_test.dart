import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stackremote/user/domain/user.dart';

void main() {
  group("userインスタンス生成テスト", () {
    // given
    const String comment = "test_comment";
    const String email = "xxx@test.com";
    const bool isHost = false;
    const bool isOnLongPressing = true;
    Timestamp? joinedAt = Timestamp.now();
    Timestamp? leavedAt = Timestamp.now();
    const String nickName = "xxx";
    const Offset pointerPosition = Offset(10, 10);

    // when
    final user = User.reconstruct(
      comment: comment,
      email: email,
      isHost: isHost,
      isOnLongPressing: isOnLongPressing,
      joinedAt: joinedAt,
      leavedAt: leavedAt,
      nickName: nickName,
      pointerPosition: pointerPosition,
    );

    test(
        "createファクトリメソッドでインスタンス生成した場合、引数の値が設定されること。また、引数で未指定の属性には、デフォルト値が設定されていること",
        () {
      // given
      const String comment = "";
      const String email = "xxx@test.com";
      const bool isHost = true;
      const bool isOnLongPressing = false;
      const Timestamp? joinedAt = null;
      const Timestamp? leavedAt = null;
      const String nickName = "";
      const Offset pointerPosition = Offset(0, 0);

      // when
      final user = User.create(
        email: email,
      );

      // then
      expect(user.comment, comment);
      expect(user.email, email);
      expect(user.isHost, isHost);
      expect(user.isOnLongPressing, isOnLongPressing);
      expect(user.joinedAt, joinedAt);
      expect(user.leavedAt, leavedAt);
      expect(user.nickName, nickName);
      expect(user.pointerPosition, pointerPosition);
    });

    test("reconstructファクトリメソッドでインスタンス生成した場合、各属性の値が引数の値と同じであること", () {
      // given

      // when

      // then
      expect(user.comment, comment);
      expect(user.email, email);
      expect(user.isHost, isHost);
      expect(user.isOnLongPressing, isOnLongPressing);
      expect(user.joinedAt, joinedAt);
      expect(user.leavedAt, leavedAt);
      expect(user.nickName, nickName);
      expect(user.pointerPosition, pointerPosition);
    });

    test("userの生成的コンストラクタ,プライベートコンストラクタを利用したインスタンス生成が不可なこと", () {
      // when
      // final user = User();
      // final user = User._(email: email);

      // then
    });

    test("userインスタンスからtoJsonでjson変換し、fromJsonでオブジェクトに戻した場合、各属性の値が変わっていないこと",
        () {
      // given

      // when

      // then
      // Object -> Json
      final Map<String, dynamic> userToJson = user.toJson();
      expect(userToJson["comment"], user.comment);
      expect(userToJson["email"], user.email);
      expect(userToJson["isHost"], user.isHost);
      expect(userToJson["isOnLongPressing"], user.isOnLongPressing);

      expect(userToJson["joinedAt"].toString(),
          user.joinedAt!.toDate().toString());
      expect(userToJson["leavedAt"].toString(),
          user.leavedAt!.toDate().toString());

      expect(userToJson["nickName"], user.nickName);
      expect(userToJson["pointerPosition"],
          '{"dx":${user.pointerPosition.dx},"dy":${user.pointerPosition.dy}}');

      // Object <- Json
      final User userFromJson = User.fromJson(userToJson);
      expect(userFromJson.comment, user.comment);
      expect(userFromJson.email, user.email);
      expect(userFromJson.isHost, user.isHost);
      expect(userFromJson.isOnLongPressing, user.isOnLongPressing);
      expect(userFromJson.joinedAt!.toDate(), user.joinedAt!.toDate());
      expect(userFromJson.leavedAt!.toDate(), user.leavedAt!.toDate());
      expect(userFromJson.nickName, user.nickName);
      expect(userFromJson.pointerPosition, user.pointerPosition);
    });
  });
}
