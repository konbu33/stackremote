import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stackremote/rtc_video/rtc_video.dart';
import 'package:stackremote/user/domain/user.dart';
import 'package:stackremote/user/domain/user_repository.dart';
import 'package:stackremote/user/infrastructure/user_repository_firestore.dart';
import 'package:stackremote/user/usecace/user_fetch_by_id_usecase.dart';

import '../../common/dotenvtest.dart';
import '../user_mock.dart';
import 'user_fetch_by_id_usecase_mockito_test.mocks.dart';

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
    final userFetchByIdUsecase = container.read(userFetchByIdUsecaseProvider);

    // モックの戻り値を生成
    final Stream<User> mockResponse = Stream.value(user);

    // ユースケース内で該当するリポジトリのメソッドが呼ばれた場合、引数をキャプチャするように指定
    when(userRepository.fetchById(
      channelName: anyNamed("channelName"),
      email: anyNamed("email"),
    )).thenAnswer((invocation) => mockResponse);

    // when
    // ユースケース実行
    final res = userFetchByIdUsecase(
      email: FakeFirebaseAuthUser().email,
    );

    // then
    // キャプチャされた値を変数に取得。
    // この時点で必須ではないが試しに、that引数で指定したマッチャーで検証
    final captured = verify(userRepository.fetchById(
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
    final String capturedCnannelName = captured[0];
    final String capturedeEmail = captured[1];

    // キャプチャされた値毎に期待する値になっているか否か検証
    expect(capturedCnannelName, FakeRtcChannelState().channelName);

    expect(capturedeEmail, FakeFirebaseAuthUser().email);

    // responseの値も確認
    final resUser = await res.single;

    expect(resUser, equals(user));
  });
}

// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:stackremote/user/domain/user.dart';
// import 'package:stackremote/user/usecace/user_fetch_by_id_usecase.dart';
// import 'package:stackremote/user/domain/user_repository.dart';
// import 'package:stackremote/user/domain/userid.dart';

// import 'user_add_usecase_mockito_test.mocks.dart';

// @GenerateMocks([UserRepository])
// void main() {
//   // UserRepositoryのインスタンス生成(モック)
//   final MockUserRepository userRepository = MockUserRepository();

//   // ユースケースのインスタンス生成
//   final UserFetchByIdUseCase userFetchByIdUseCase =
//       UserFetchByIdUseCase(userRepository: userRepository);

//   final String userId = UserId.create().value.toString();

//   // Userインスタンス生成
//   const email = "tao@test.com";
//   const password = "password";
//   const firebaseAuthUid = "firebaseAuthUid";
//   const firebaseAuthIdToken = "firebaseAuthIdToken";

//   final User user = User.create(
//     email: email,
//     password: password,
//     firebaseAuthUid: firebaseAuthUid,
//     firebaseAuthIdToken: firebaseAuthIdToken,
//   );

//   // モモッの戻り値生成
//   final future = Future.value(user);

//   test("ユースケースに渡した引数と同値が、リポジトリのメソッドの引数として利用されていること", () async {
//     // given
//     when(userRepository.fetchById(any)).thenAnswer((realInvocation) => future);

//     // when
//     final res = await userFetchByIdUseCase.execute(userId);

//     // then
//     final captured = verify(userRepository.fetchById(captureAny)).captured;
//     final String d = captured.last;
//     // print("userId : ${userId}");
//     // print("d : ${d}");
//     expect(d, userId);

//     // print("user : ${user}");
//     // print("res: ${res}");
//     expect(res, user);
//   });
// }
