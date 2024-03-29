import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:stackremote/channel/channel.dart';
import 'package:stackremote/common/common.dart';
import 'package:stackremote/user/user.dart';

import '../../../common/dotenvtest.dart';
import '../user_mock.dart';

void main() {
  late ProviderContainer container;
  late UserRepository userRepository;

  setUpAll(() {
    // dotenv読み込み
    dotEnvTestLoad();

    // path_providerのFake作成
    createFakePathProviderPlatform();
  });

  setUp(() {
    // 各テスト毎に初期化
    // Firebaseのモック用インスタンス生成
    container = ProviderContainer(overrides: [
      firebaseFirestoreInstanceProvider
          .overrideWithValue(FakeFirebaseFirestore()),
      channelNameProvider
          .overrideWith((ref) => ref.watch(fakeChannelNameProvider)),
    ]);

    // userRepository生成
    userRepository = container.read(userRepositoryFirebaseProvider);
  });

  test("ユーザデータを登録可能なこと、かつ、email指定でユーザデータを取得可能なこと", () async {
    // given
    // when
    await userRepository.set(
      email: user.email,
      user: user,
    );

    final responseStream = userRepository.fetchById(
      email: user.email,
    );

    final responseStreamBroadcast = responseStream.asBroadcastStream();

    // then
    // emits利用してテストするパターン
    expect(
      responseStreamBroadcast,
      emits(
        allOf(
          predicate<User>(
            (resUser) {
              expect(resUser.comment, user.comment);
              expect(resUser.email, user.email);
              expect(resUser.isHost, user.isHost);
              expect(resUser.isOnLongPressing, user.isOnLongPressing);

              // expect(resUser.joinedAt, user.joinedAt);
              expect(resUser.joinedAt, isA<DateTime?>());
              expect(resUser.joinedAt, isNot(equals(user.joinedAt)));

              expect(resUser.leavedAt, user.leavedAt);
              expect(resUser.nickName, user.nickName);
              expect(resUser.pointerPosition, user.pointerPosition);

              return true;
            },
          ),
        ),
      ),
    );

    // emits利用せずに、listenでテストするパターン
    responseStreamBroadcast.listen(
      (resUser) {
        expect(resUser.comment, user.comment);
        expect(resUser.email, user.email);
        expect(resUser.isHost, user.isHost);
        expect(resUser.isOnLongPressing, user.isOnLongPressing);

        expect(resUser.joinedAt, isA<DateTime?>());
        expect(resUser.joinedAt, isNot(equals(user.joinedAt)));

        expect(resUser.leavedAt, user.leavedAt);
        expect(resUser.nickName, user.nickName);
        expect(resUser.pointerPosition, user.pointerPosition);
      },
    );
  });

  test("email指定でユーザデータを検索時、該当するユーザデータが存在しない場合、例外を返すこと", () async {
    // given

    // when
    final responseStream = userRepository.fetchById(
      email: FakeFirebaseAuthUser().email,
    );

    final responseStreamBroadcast = responseStream.asBroadcastStream();

    // then
    expect(
      responseStreamBroadcast,
      emitsError(equals(isA<FirebaseException>())),
    );

    expect(
      responseStreamBroadcast,
      emitsError(
        allOf(
          isA<FirebaseException>(),
          predicate<FirebaseException>(
            (firebaseException) {
              expect(firebaseException.plugin, "userRepository");
              expect(firebaseException.code, 'fetchById');
              expect(firebaseException.message, "ユーザが存在しません");
              return true;
            },
          ),
        ),
      ),
    );
  });

  test("全ユーザデータを取得可能なこと", () async {
    // given

    // Userインスタンスを複数生成
    final user1 = User.create(
      email: "axxx@test.com",
    );

    final user2 = User.create(
      email: "ixxx@test.com",
    );

    final user4 = User.create(
      email: "exxx@test.com",
    );

    // when
    await userRepository.set(
      email: user1.email,
      user: user1,
    );

    await userRepository.set(
      email: user2.email,
      user: user2,
    );

    await userRepository.set(
      email: user4.email,
      user: user4,
    );

    final Stream<Users> resUsers = userRepository.fetchAll();

    // then

    // 複数箇所でStreamをlistenするため、Broadcastする
    final broadcastResUsers = resUsers.asBroadcastStream();

    // 各Userの各属性単位で比較確認
    broadcastResUsers.listen(((event) {
      final srcUserList = [user1, user2, user4];
      for (final resUser in event.users) {
        final srcUser = srcUserList.removeAt(0);

        expect(resUser.comment, srcUser.comment);
        expect(resUser.email, srcUser.email);
        expect(resUser.isHost, srcUser.isHost);
        expect(resUser.isOnLongPressing, srcUser.isOnLongPressing);

        expect(resUser.joinedAt, isA<DateTime?>());
        expect(resUser.joinedAt, isNot(equals(srcUser.joinedAt)));

        expect(resUser.leavedAt, srcUser.leavedAt);
        expect(resUser.nickName, srcUser.nickName);
        expect(resUser.pointerPosition, srcUser.pointerPosition);
      }
    }));
  });

  test("ユーザデータを登録可能なこと、かつ、email指定でユーザデータを更新可能なこと", () async {
    // given

    final addUser = User.reconstruct(
      email: "axxx@test.com",
      nickName: "non_update_nickname",
    );

    await userRepository.set(
      email: addUser.email,
      user: addUser,
    );

    final resAddUserStream = userRepository.fetchById(
      email: addUser.email,
    );

    resAddUserStream.listen(
      (resAddUser) {
        expect(resAddUser.comment, addUser.comment);
        expect(resAddUser.email, addUser.email);
        expect(resAddUser.isHost, addUser.isHost);
        expect(resAddUser.isOnLongPressing, addUser.isOnLongPressing);

        expect(resAddUser.joinedAt, isA<DateTime?>());
        expect(resAddUser.joinedAt, isNot(equals(addUser.joinedAt)));

        expect(resAddUser.leavedAt, addUser.leavedAt);
        expect(resAddUser.nickName, addUser.nickName);
        expect(resAddUser.pointerPosition, addUser.pointerPosition);
      },
    );

    // when
    final User updateUser = User.reconstruct(
      email: "axxx@test.com",
      nickName: "update_nickname",
    );

    userRepository.update(
      email: updateUser.email,
      data: {"nickName": updateUser.nickName},
      isJoinedAt: false,
      isLeavedAt: false,
    );

    final resUpdateUserStream = userRepository.fetchById(
      email: updateUser.email,
    );

    // then
    resUpdateUserStream.listen(
      (resUpdateUser) {
        expect(resUpdateUser.comment, addUser.comment);
        expect(resUpdateUser.email, updateUser.email);
        expect(resUpdateUser.isHost, addUser.isHost);
        expect(resUpdateUser.isOnLongPressing, addUser.isOnLongPressing);

        expect(resUpdateUser.joinedAt, isA<DateTime?>());
        expect(resUpdateUser.joinedAt, isNot(equals(addUser.joinedAt)));

        expect(resUpdateUser.leavedAt, addUser.leavedAt);
        expect(resUpdateUser.nickName, isNot(equals(addUser.nickName)));
        expect(resUpdateUser.nickName, updateUser.nickName);
        expect(resUpdateUser.pointerPosition, addUser.pointerPosition);
      },
    );
  });

  test("ユーザデータを登録可能なこと、かつ、email指定でユーザデータを削除可能なこと", () async {
    // given

    final addUser = User.reconstruct(
      email: "axxx@test.com",
      nickName: "non_update_nickname",
    );

    await userRepository.set(
      email: addUser.email,
      user: addUser,
    );

    final resAddUserStream = userRepository.fetchById(
      email: addUser.email,
    );

    resAddUserStream.listen((resAddUser) {
      expect(resAddUser.comment, addUser.comment);
      expect(resAddUser.email, addUser.email);
      expect(resAddUser.isHost, addUser.isHost);
      expect(resAddUser.isOnLongPressing, addUser.isOnLongPressing);

      expect(resAddUser.joinedAt, isA<DateTime?>());
      expect(resAddUser.joinedAt, isNot(equals(addUser.joinedAt)));

      expect(resAddUser.leavedAt, addUser.leavedAt);
      expect(resAddUser.nickName, addUser.nickName);
      expect(resAddUser.pointerPosition, addUser.pointerPosition);
    });

    // when
    userRepository.delete(
      email: addUser.email,
    );

    // then
    final responseStream = userRepository.fetchById(
      email: addUser.email,
    );

    // responseStreamを複数箇所でexpectするために、broadcastに変換する。
    final responseStreamBroadcast = responseStream.asBroadcastStream();

    // 例外が応答されることを確認 シンプルなパターン
    expect(
      responseStreamBroadcast,
      emitsError(
        equals(isA<FirebaseException>()),
      ),
    );

    // 例外が応答されることを確認 ？するため expectLaterを使ったパターン
    expectLater(
      responseStreamBroadcast,
      emitsError(
        equals(isA<FirebaseException>()),
      ),
    ).then((value) => null);

    // 例外が応答されることを確認 応答順序を意識するため onEmitsInOrder使ったバターン
    expect(
      responseStreamBroadcast,
      emitsInOrder(
        [
          emitsError(equals(isA<FirebaseException>())),
        ],
      ),
    );

    // 例外が応答されることを確認 例外のObjectの内容まで確認するパターン
    expect(
      responseStreamBroadcast,
      emitsInOrder(
        [
          emitsError(
            allOf(
              isA<FirebaseException>(),
              predicate<FirebaseException>((firebaseException) {
                expect(firebaseException.plugin, "userRepository");
                expect(firebaseException.code, 'fetchById');
                expect(firebaseException.message, "ユーザが存在しません");
                return true;
              }),
            ),
          ),
        ],
      ),
    );
  });
}
