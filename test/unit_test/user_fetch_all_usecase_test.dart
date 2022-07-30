import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stackremote/user.dart';
import 'package:stackremote/user_fetch_all_usecase.dart';
import 'package:stackremote/user_repository.dart';
import 'package:stackremote/users.dart';

// UserRepositoryのMockクラス作成
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  // UserRepositoryのMockインスタンス生成
  final MockUserRepository userRepository = MockUserRepository();

  // ユースケースのインスタンス生成
  final UserFetchAllUseCase userFetchAllUseCase =
      UserFetchAllUseCase(userRepository: userRepository);

  // Userインスタンスの配列生成
  final List<User> userList = [
    User.create(email: "ake@test.com", password: "ake"),
    User.create(email: "ike@test.com", password: "ike"),
    User.create(email: "uke@test.com", password: "uke"),
  ];

  // Usersコレクションオブジェクト生成
  final Users users = Users.reconstruct(users: userList);

  // モックの戻り値を生成
  final Stream<Users> stream = Stream.value(users);

  //
  test("ユースケースに渡した引数と同値が、リポジトリのメソッドの引数として利用されていること", () async {
    // given
    when(() => userRepository.fetchAll()).thenAnswer((invocation) => stream);

    // when
    final res = userFetchAllUseCase.execute();

    // when
    final resUsers = await res.single;
    final resUserList = resUsers.users;

    expect(listEquals(userList, resUserList), isTrue);

    // print("resUsers : ${resUsers.users}");
    // print("   users : ${users.users}");
  });
}
