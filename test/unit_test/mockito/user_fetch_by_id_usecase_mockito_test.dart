import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stackremote/domain/user.dart';
import 'package:stackremote/usecase/user_fetch_by_id_usecase.dart';
import 'package:stackremote/domain/user_repository.dart';
import 'package:stackremote/domain/userid.dart';

import 'user_add_usecase_mockito_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  // UserRepositoryのインスタンス生成(モック)
  final MockUserRepository userRepository = MockUserRepository();

  // ユースケースのインスタンス生成
  final UserFetchByIdUseCase userFetchByIdUseCase =
      UserFetchByIdUseCase(userRepository: userRepository);

  final String userId = UserId.create().value.toString();

  // Userインスタンス生成
  const email = "tao@test.com";
  const password = "password";
  const firebaseAuthUid = "firebaseAuthUid";
  final User user = User.create(
    email: email,
    password: password,
    firebaseAuthUid: firebaseAuthUid,
  );

  // モモッの戻り値生成
  final future = Future.value(user);

  test("ユースケースに渡した引数と同値が、リポジトリのメソッドの引数として利用されていること", () async {
    // given
    when(userRepository.fetchById(any)).thenAnswer((realInvocation) => future);

    // when
    final res = await userFetchByIdUseCase.execute(userId);

    // then
    final captured = verify(userRepository.fetchById(captureAny)).captured;
    final String d = captured.last;
    print("userId : ${userId}");
    print("d : ${d}");
    expect(d, userId);

    print("user : ${user}");
    print("res: ${res}");
    expect(res, user);
  });
}
