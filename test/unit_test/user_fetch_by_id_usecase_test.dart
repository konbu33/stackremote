import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stackremote/user/domain/user.dart';
import 'package:stackremote/user/domain/userid.dart';
import 'package:stackremote/user/usecace/user_fetch_by_id_usecase.dart';
import 'package:stackremote/user/domain/user_repository.dart';

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
  const firebaseAuthUid = "firebaseAuthUid";
  const firebaseAuthIdToken = "firebaseAuthIdToken";

  final User user = User.create(
    email: email,
    password: password,
    firebaseAuthUid: firebaseAuthUid,
    firebaseAuthIdToken: firebaseAuthIdToken,
  );

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
