import 'package:flutter_test/flutter_test.dart';
import 'package:stackremote/domain/user.dart';
import 'package:stackremote/domain/userid.dart';
import 'package:ulid/ulid.dart';

void main() {
  group("userインスタンス生成テスト", () {
    const String email = "xxxx@example.com";
    const String password = "password";
    const String firebaseAuthUid = "firebaseAuthUid";
    const String firebaseAuthIdToken = "firebaseAuthIdToken";

    test(
        "userのファクトリメソッドでインスタンス生成すると、userId属性にulidが採番され、userId以外の属性に引数の値が設定されていること",
        () {
      // when
      final user = User.create(
        email: email,
        password: password,
        firebaseAuthUid: firebaseAuthUid,
        firebaseAuthIdToken: firebaseAuthIdToken,
      );

      // then
      expect(user.userId.value, isA<Ulid>());
      expect(user.email, email);
      // print("userId : ${userId.value.runtimeType}");
      // print("userId : ${userId.value}");
      expect(user.email, email);
      expect(user.password, password);
    });

    test("reconstructメソッドでインスタンス生成した場合、各属性の値が引数の値と同じであること", () {
      // given
      final userId = UserId.create();
      const email = "test@test.com";
      const password = "password";
      const firebaseAuthUid = "firebaseAuthUid";

      // when
      final user = User.reconstruct(
        userId: userId,
        email: email,
        password: password,
        firebaseAuthUid: firebaseAuthUid,
        firebaseAuthIdToken: firebaseAuthIdToken,
      );

      // then
      expect(user.userId, userId);
      expect(user.email, email);
      expect(user.password, password);
    });

    test("userの生成的コンストラクタ,プライベートコンストラクタを利用したインスタンス生成が不可なこと", () {
      // when
      // final user = User(userId: Ulid());
      // final user = User._(userId: Ulid());

      // then
      // print("userId : ${userId.value}");
    });

    test("userインスタンスからtoJsonでjson変換し、fromJsonでオブジェクトに戻した場合、各属性の値が変わっていないこと",
        () {
      // given
      final user = User.create(
        email: email,
        password: password,
        firebaseAuthUid: firebaseAuthUid,
        firebaseAuthIdToken: firebaseAuthIdToken,
      );

      // when
      // then
      final Map<String, dynamic> userToJson = user.toJson();
      expect(userToJson["userId"], user.userId.value.toString());
      expect(userToJson["email"], user.email);
      expect(userToJson["password"], user.password);

      final User userFromJson = User.fromJson(userToJson);
      expect(userFromJson.userId, user.userId);
      expect(userFromJson.email, user.email);
      expect(userFromJson.password, user.password);

      // print("user         : ${user} ");
      // print("userToJson   : $userToJson");
      // print("userFromJson : ${userFromJson}");
    });
  });
}
