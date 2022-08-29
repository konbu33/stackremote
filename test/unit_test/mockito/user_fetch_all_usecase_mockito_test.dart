import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stackremote/domain/user.dart';
import 'package:stackremote/usecase/user_fetch_all_usecase.dart';
import 'package:stackremote/domain/user_repository.dart';
import 'package:stackremote/domain/users.dart';

import 'user_fetch_all_usecase_mockito_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  // UserRepositoryのインスタンス生成(モック)
  final MockUserRepository userRepository = MockUserRepository();

  // ユースケースのインスタンス生成
  final UserFetchAllUseCase userFetchAllUseCase =
      UserFetchAllUseCase(userRepository: userRepository);

  // Usersインスタンス生成
  final List<User> userList = [
    User.create(
        email: "ake@test.com",
        password: "ake",
        firebaseAuthUid: "firebaseAuthUid"),
    User.create(
        email: "ike@test.com",
        password: "ike",
        firebaseAuthUid: "firebaseAuthUid"),
    User.create(
        email: "uke@test.com",
        password: "uke",
        firebaseAuthUid: "firebaseAuthUid"),
  ];

  final Users users = Users.reconstruct(users: userList);

  // モモッの戻り値生成
  final Stream<Users> stream = Stream.value(users);

  test("ユースケースに渡した引数と同値が、リポジトリのメソッドの引数として利用されていること", () async {
    // given
    when(userRepository.fetchAll()).thenAnswer((realInvocation) => stream);

    // when
    final res = userFetchAllUseCase.execute();

    // then
    final resUsers = await res.single;
    final resUserList = resUsers.users;
    print("resUserList : $resUserList");

    expect(listEquals(resUserList, userList), isTrue);
    expect(const ListEquality().equals(resUserList, userList), isTrue);
  });
}
