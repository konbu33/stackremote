import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stackremote/domain/user.dart';
import 'package:stackremote/domain/user_repository.dart';
import 'package:stackremote/usecase/user_update_usecase.dart';

import 'user_add_usecase_mockito_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  // UserRepositoryのインスタンス生成(モック)
  final MockUserRepository userRepository = MockUserRepository();

  // ユースケースのインスタンス生成
  final UserUpdateUseCase userUpdateUseCase =
      UserUpdateUseCase(userRepository: userRepository);

  // Userインスタンス生成
  const email = "nao@test.com";
  const password = "password";
  const firebaseAuthUid = "firebaseAuthUid";
  const firebaseAuthIdToken = "firebaseAuthIdToken";

  User user = User.create(
    email: email,
    password: password,
    firebaseAuthUid: firebaseAuthUid,
    firebaseAuthIdToken: firebaseAuthIdToken,
  );

  test("ユースケースに渡した引数と同値が、リポジトリのメソッドの引数として利用されていること", () async {
    // given
    when(userRepository.update(any));

    // when
    userUpdateUseCase.execute(
      user.userId,
      user.email,
      user.password,
      user.firebaseAuthUid,
      user.firebaseAuthIdToken,
    );

    // then
    final captured = verify(userRepository.update(captureAny)).captured;
    final User d = captured.last;
    print("user : ${user}");
    print("captured d: ${d}");

    expect(d.userId.value.toString(), user.userId.value.toString());
    expect(d.email, user.email);
    expect(d.password, user.password);
  });
}
