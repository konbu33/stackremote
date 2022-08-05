import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stackremote/user.dart';
import 'package:stackremote/user_fetch_by_id_usecase.dart';
import 'package:stackremote/user_repository.dart';
import 'package:stackremote/userid.dart';

// UserRepositoryのMockクラス作成
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  // UserRepositoryのMockインスタンス生成
  final MockUserRepository userRepository = MockUserRepository();

  // ユースケースのインスタンス生成
  final UserFetchByIdUseCase userFetchByIdUseCase =
      UserFetchByIdUseCase(userRepository: userRepository);

  // Userインスタンス生成
  final String userId = UserId.create().value.toString();
  const email = "take@test.com";
  const password = "password";
  final User user = User.create(email: email, password: password);

  // モックの戻り値を生成
  final future = Future.value(user);

  test("ユースケースに渡した引数と同値が、リポジトリのメソッドの引数として利用されていること", () async {
    // given
    when(() => userRepository.fetchById(any()))
        .thenAnswer((invocation) => future);

    // when
    final resUser = await userFetchByIdUseCase.execute(userId);

    // then
    final captured =
        verify(() => userRepository.fetchById(captureAny())).captured;
    final String capturedUserId = captured.single;

    expect(capturedUserId, userId);
    // print("        userId : $userId");
    // print("capturedUserId : $capturedUserId");

    expect(resUser, user);
    // print("   user : $user");
    // print("resUser : $resUser");
  });
}
