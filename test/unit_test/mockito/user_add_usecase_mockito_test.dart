import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stackremote/domain/user.dart';
import 'package:stackremote/usecase/user_add_usecase.dart';
import 'package:stackremote/domain/user_repository.dart';
import 'user_add_usecase_mockito_test.mocks.dart';

// Real class

// Annotation which generates the cat.mocks.dart library and the MockCat class.
@GenerateMocks([UserRepository])
void main() {
  // UserRepositoryのインスタンス生成(モック)
  final userRepository = MockUserRepository();

  // ユースケースのインスタンス生成
  final userAddUseCase = UserAddUseCase(userRepository: userRepository);

  // Userインスタンス生成
  const email = "seki@test.com";
  const password = "password";
  const firebaseAuthUid = "firebaseAuthUid";
  const firebaseAuthIdToken = "firebaseAuthIdToken";

  final user = User.create(
    email: email,
    password: password,
    firebaseAuthUid: firebaseAuthUid,
    firebaseAuthIdToken: firebaseAuthIdToken,
  );

  // モックの戻り値生成
  final future = Future.value(user.userId);

  test("ユースケースに渡した引数と同値が、リポジトリのメソッドの引数として利用されていること", () async {
    // given
    when(userRepository.add(any)).thenAnswer((invocation) => future);

    // when
    final res = await userAddUseCase.execute(email, password);

    // then
    final captured = verify(userRepository.add(captureAny)).captured;
    final User d = captured.last;
    print("user: ${user}");
    print("res : ${res}");
    print("captured: ${captured}");
    // expect(d.userId.value.toString(), user.userId.value.toString());
    expect(d.email, user.email);
    expect(d.password, user.password);
  });
}
