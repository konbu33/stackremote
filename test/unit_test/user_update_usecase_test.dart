import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stackremote/domain/user.dart';
import 'package:stackremote/usecase/user_update_usecase.dart';
import 'package:stackremote/domain/user_repository.dart';
import 'package:stackremote/domain/userid.dart';

// UserRepositoryのMockクラス作成
class MockUserRepository extends Mock implements UserRepository {}

// UserのFakeクラス作成
class FakeUser extends Fake implements User {
  @override
  final UserId userId = UserId.create();

  @override
  final String email = "waki@test.com";

  @override
  final String password = "password";

  @override
  final String firebaseAuthUid = "firebaseAuthUid";

  @override
  final String firebaseAuthIdToken = "firebaseAuthIdToken";
}

void main() {
  // UserRepositoryのMockインスタンス生成
  final MockUserRepository userRepository = MockUserRepository();

  // ユースケースのインスタンス生成
  final userUpdateUseCase = UserUpdateUseCase(userRepository: userRepository);

  // Fakeクラスから(Fake)Userインスタンス生成
  final fakeUser = FakeUser();

  setUpAll(() {
    /*
      UserPepository.updateメソッドの引数をキャプチャしたいため、引数マッチャーである any() を利用します。
      この引数の型が、FakeUser型(というカスタム型)であるため、registerFallbackVale で事前登録しておく必要がある。
    */
    registerFallbackValue(FakeUser());
  });

  test("ユースケースに渡した引数と同値が、リポジトリのメソッドの引数として利用されていること", () async {
    // given
    when(() => userRepository.update(any()));

    // when
    userUpdateUseCase.execute(
      fakeUser.userId,
      fakeUser.email,
      fakeUser.password,
      fakeUser.firebaseAuthUid,
      fakeUser.firebaseAuthIdToken,
    );

    // then
    final captured = verify(() => userRepository.update(captureAny())).captured;
    final User user = captured.single;

    expect(user.userId, fakeUser.userId);
    expect(user.email, fakeUser.email);
    expect(user.password, fakeUser.password);

    // print(
    //     "    user : userId : ${user.userId}, email : ${user.email}, password : ${user.password}");
    // print(
    //     "fakeUser : userId : ${fakeUser.userId}, email : ${fakeUser.email}, password : ${fakeUser.password}");
  });
}
