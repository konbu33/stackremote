import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stackremote/user/domain/user.dart';
import 'package:stackremote/user/usecace/user_add_usecase.dart';
import 'package:stackremote/user/domain/user_repository.dart';

// UserRepositoryのMockクラス作成
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  // UserRepositoryのMockインスタンス生成
  final userRepository = MockUserRepository();

  // ユースケースのインスタンス生成
  final userAddUseCase = UserAddUseCase(userRepository: userRepository);

  // Userインスタンス生成
  const email = "aki@test.com";
  const password = "password";
  const firebaseAuthUid = "firebaeAuthUid";
  const firebaseAuthIdToken = "firebaeAuthIdToken";

  final user = User.create(
    email: email,
    password: password,
    firebaseAuthUid: firebaseAuthUid,
    firebaseAuthIdToken: firebaseAuthIdToken,
  );

  setUpAll(() {
    /*
      UserPepository.updateメソッドの引数をキャプチャしたいため、引数マッチャーである any() を利用します。
      この引数の型が、FakeUser型(というカスタム型)であるため、registerFallbackVale で事前登録しておく必要がある。
    */
    registerFallbackValue(user);
  });

  test("ユースケースに渡した引数と同値が、リポジトリのメソッドの引数として利用されていること", () async {
    // given
    when(() => userRepository.add(any()))
        .thenAnswer((invocation) => Future.value(user.userId));

    // when
    // final res = await userAddUseCase.execute(email, password);
    await userAddUseCase.execute(email, password);

    // then
    final captured = verify(() => userRepository.add(captureAny())).captured;
    final User capturedUser = captured.single;

    expect(capturedUser.email, user.email);
    expect(capturedUser.password, user.password);

    // print(
    //     "         user: userId : ${user.userId}, email : ${user.email}, password : ${user.password}");
    // print(
    //     "captured user: userId : ${capturedUser.userId}, email : ${capturedUser.email}, password : ${capturedUser.password}");

    // print("     res user: userId : $res");
  });
}
