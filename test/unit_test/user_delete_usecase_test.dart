import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stackremote/user_delete_usecase.dart';
import 'package:stackremote/user_repository.dart';
import 'package:stackremote/userid.dart';

// UserRepositoryのMockクラス作成
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  // UserRepositoryのMockインスタンス生成
  final userRepository = MockUserRepository();

  // ユースケースのインスタンス生成
  final userDeleteUseCase = UserDeleteUseCase(userRepository: userRepository);

  // 削除対象のUserId生成
  final String userId = UserId.create().value.toString();

  // モックの戻り値を生成
  const String returnMessage = "Delete Complete.";
  final Future<String> future = Future.value(returnMessage);

  test("ユースケースに渡した引数と同値が、リポジトリのメソッドの引数として利用されていること", () async {
    // given
    when(() => userRepository.delete(any())).thenAnswer((invocation) => future);

    // when
    final res = await userDeleteUseCase.execute(userId);

    // then
    final captured = verify(() => userRepository.delete(captureAny())).captured;
    final String capturedUserId = captured.single;

    expect(capturedUserId, userId);
    expect(res, returnMessage);

    // print("capturedUserId : $capturedUserId");
    // print("userId: $userId");
    // print("res: $res");
  });
}
