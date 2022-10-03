import 'package:flutter_test/flutter_test.dart';
import 'package:stackremote/user/domain/userid.dart';
import 'package:ulid/ulid.dart';

void main() {
  group("UserIdインスタンス生成テスト", () {
    test("useridのファクトリメソッドでインスタンス生成すると、ulidが採番されていること", () {
      // when
      final userId = UserId.create();

      // then
      expect(userId.value, isA<Ulid>());
      // print("userId : ${userId.value.runtimeType}");
      // print("userId : ${userId.value}");
    });

    test("useridの生成的コンストラクタ,プライベートコンストラクタを利用したインスタンス生成が不可なこと", () {
      // when
      // final userId = UserId(value: Ulid());
      // final userId = UserId._(value: Ulid());

      // then
      // print("userId : ${userId.value}");
    });
  });
}
