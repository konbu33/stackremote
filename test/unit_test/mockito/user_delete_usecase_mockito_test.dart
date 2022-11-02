import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stackremote/rtc_video/rtc_video.dart';
import 'package:stackremote/user/domain/user_repository.dart';
import 'package:stackremote/user/infrastructure/user_repository_firestore.dart';
import 'package:stackremote/user/usecace/user_delete_usecase.dart';

import '../../common/dotenvtest.dart';
import '../user_mock.dart';
import 'user_delete_usecase_mockito_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  // UserRepositoryのインスタンス生成(モック)
  final MockUserRepository userRepository = MockUserRepository();

  setUpAll(() {
    // dotenv読み込み
    dotEnvTestLoad();

    // path_providerのFake作成
    createFakePathProviderPlatform();
  });

  test("ユースケースに渡した引数と同値が、リポジトリのメソッドの引数として利用されていること", () async {
    // given
    // ユースケース内で利用している、該当ProviderをMock,Fakeで上書き
    // override対象のプロバイダーが、Providerの場合は、overrideWithValue メソッドで済みそう。
    // 一方、StateNotifierProviderの場合は、overrideWith メソッドを利用する必要がありそう。
    final container = ProviderContainer(overrides: [
      //
      RtcChannelStateNotifierProviderList.rtcChannelStateNotifierProvider
          .overrideWith((ref) => FakeRtcChannelStateNotifier()),
      //
      userRepositoryFirebaseProvider.overrideWithValue(userRepository),
    ]);

    // ユースケースのインスタンス生成
    final userDeleteUsecase = container.read(userDeleteUsecaseProvider);

    // モックの戻り値を生成
    final Future<void> mockResponse = Future.value();

    // ユースケース内で該当するリポジトリのメソッドが呼ばれた場合、引数をキャプチャするように指定
    when(userRepository.delete(
      channelName: anyNamed("channelName"),
      email: anyNamed("email"),
    )).thenAnswer(((realInvocation) => mockResponse));

    // when
    // ユースケース実行
    await userDeleteUsecase(email: FakeFirebaseAuthUser().email);

    // then
    // キャプチャされた値を変数に取得。
    // この時点で必須ではないが試しに、that引数で指定したマッチャーで検証
    final captured = verify(userRepository.delete(
      channelName: captureThat(
        equals(FakeRtcChannelState().channelName),
        named: "channelName",
      ),
      email: captureThat(
        equals(FakeFirebaseAuthUser().email),
        named: "email",
      ),
    )).captured;

    // キャプチャされた値が配列で格納されているため、それぞれ変数に詰め直し
    final String capturedChannelName = captured[0];
    final String capturedEmail = captured[1];

    // キャプチャされた値毎に期待する値になっているか否か検証
    expect(capturedChannelName, FakeRtcChannelState().channelName);

    expect(capturedEmail, FakeFirebaseAuthUser().email);
  });
}

// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:stackremote/user/usecace/user_delete_usecase.dart';
// import 'package:stackremote/user/domain/user_repository.dart';
// import 'package:stackremote/user/domain/userid.dart';
// import 'user_delete_usecase_mockito_test.mocks.dart';

// @GenerateMocks([UserRepository])
// void main() {
//   // UserRepositoryのインスタンス生成(モック)
//   final MockUserRepository userRepository = MockUserRepository();

//   // ユースケースのインスタンス生成
//   final UserDeleteUseCase userDeleteUseCase =
//       UserDeleteUseCase(userRepository: userRepository);

//   // UserIdのインスタンス生成
//   final String userId = UserId.create().value.toString();

//   // モックの戻り値生成
//   const returnMessage = "Delete Complete.";
//   final future = Future.value(returnMessage);
//   //
//   test("ユースケースに渡した引数と同値が、リポジトリのメソッドの引数として利用されていること", () async {
//     // given
//     when(userRepository.delete(any)).thenAnswer((realInvocation) => future);

//     // when
//     final res = await userDeleteUseCase.execute(userId);

//     // then
//     final captured = verify(userRepository.delete(captureAny)).captured;
//     final d = captured.last;
//     // print("userId :  ${userId}");
//     // print("res :  ${res}");
//     // print("captured:  ${d}");
//     expect(d, userId);
//     expect(res, returnMessage);
//   });
// }
