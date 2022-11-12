import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stackremote/rtc_video/rtc_video.dart';
import 'package:stackremote/user/domain/user_repository.dart';
import 'package:stackremote/user/domain/users.dart';
import 'package:stackremote/user/infrastructure/user_repository_firestore.dart';
import 'package:stackremote/user/usecace/user_fetch_all_usecase.dart';

import '../../../common/dotenvtest.dart';
import '../user_mock.dart';
import 'user_fetch_all_usecase_mockito_test.mocks.dart';

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

  //
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
    final userFetchAllUsecase = container.read(userFetchAllUsecaseProvider);

    // モックの戻り値を生成
    final Stream<Users> mockResponse = Stream.value(users);

    // ユースケース内で該当するリポジトリのメソッドが呼ばれた場合、引数をキャプチャするように指定
    when(userRepository.fetchAll()).thenAnswer((invocation) => mockResponse);

    // when
    // ユースケース実行
    final res = userFetchAllUsecase();

    // then
    // キャプチャされた値を変数に取得。
    // この時点で必須ではないが試しに、that引数で指定したマッチャーで検証
    final captured = verify(userRepository.fetchAll()).captured;

    // キャプチャされた値毎に期待する値になっているか否か検証
    expect(captured.isEmpty, isTrue);

    // responseの値も確認
    final resUsers = await res.single;
    final resUserList = resUsers.users;

    expect(listEquals(userList, resUserList), isTrue);
  });
}
