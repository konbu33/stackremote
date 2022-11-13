import 'package:flutter_test/flutter_test.dart';
import 'package:stackremote/user/domain/user.dart';
import 'package:stackremote/user/domain/users.dart';

void main() {
  group("usersインスタンス生成テスト", () {
    test('createファクトリメソッドでインスタンス生成した場合、users属性の値がデフォルト値(空リスト)であること', () {
      // given
      // when
      final users = Users.create();

      // then
      expect(users.users, []);
    });
    test("usersの生成的コンストラクタ,プライベートコンストラクタを利用したインスタンス生成が不可なこと", () {
      // when
      // final users = Users();
      // final users = Users._(users: []);
    });

    test('reconstructファクトリメソッドでインスタンス生成した場合、users属性の値が引数の値と同じであること', () {
      // given
      final List<User> userList = [
        User.reconstruct(
          email: "axxx@test.com",
          nickName: "axxx",
        ),
        User.reconstruct(
          email: "bxxx@test.com",
          nickName: "bxxx",
        ),
        User.reconstruct(
          email: "cxxx@test.com",
          nickName: "cxxx",
        ),
      ];

      // when
      final users = Users.reconstruct(users: userList);

      // then
      expect(users.users, userList);
      expect(users.users[0] == userList[0], isTrue);
    });
  });
}
