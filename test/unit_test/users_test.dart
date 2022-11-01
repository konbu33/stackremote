import 'package:flutter_test/flutter_test.dart';
import 'package:stackremote/user/domain/user.dart';
import 'package:stackremote/user/domain/users.dart';

void main() {
  group("usersインスタンス生成テスト", () {
    test('createメソッドでインスタンス生成した場合、users属性の値が空リストであること', () {
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

      // then
      // print("users : ${users.value}");
    });

    test('reconstructメソッドでインスタンス生成した場合、users属性の値が引数の値と同じであること', () {
      // given
      final List<User> userList = [
        User.create(
          email: "ake@test.com",
          nickName: "ake",
          comment: "",
          isHost: true,
          joinedAt: null,
          leavedAt: null,
          isOnLongPressing: false,
          pointerPosition: const Offset(0, 0),
        ),
        User.create(
          email: "ike@test.com",
          nickName: "ike",
          comment: "",
          isHost: true,
          joinedAt: null,
          leavedAt: null,
          isOnLongPressing: false,
          pointerPosition: const Offset(0, 0),
        ),
        User.create(
          email: "uke@test.com",
          nickName: "uke",
          comment: "",
          isHost: true,
          joinedAt: null,
          leavedAt: null,
          isOnLongPressing: false,
          pointerPosition: const Offset(0, 0),
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
