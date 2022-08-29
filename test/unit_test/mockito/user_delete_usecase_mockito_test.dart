import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stackremote/usecase/user_delete_usecase.dart';
import 'package:stackremote/domain/user_repository.dart';
import 'package:stackremote/domain/userid.dart';
import 'user_delete_usecase_mockito_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  // UserRepositoryのインスタンス生成(モック)
  final MockUserRepository userRepository = MockUserRepository();

  // ユースケースのインスタンス生成
  final UserDeleteUseCase userDeleteUseCase =
      UserDeleteUseCase(userRepository: userRepository);

  // UserIdのインスタンス生成
  final String userId = UserId.create().value.toString();

  // モックの戻り値生成
  const returnMessage = "Delete Complete.";
  final future = Future.value(returnMessage);
  //
  test("ユースケースに渡した引数と同値が、リポジトリのメソッドの引数として利用されていること", () async {
    // given
    when(userRepository.delete(any)).thenAnswer((realInvocation) => future);

    // when
    final res = await userDeleteUseCase.execute(userId);

    // then
    final captured = verify(userRepository.delete(captureAny)).captured;
    final d = captured.last;
    print("userId :  ${userId}");
    print("res :  ${res}");
    print("captured:  ${d}");
    expect(d, userId);
    expect(res, returnMessage);
  });
}
