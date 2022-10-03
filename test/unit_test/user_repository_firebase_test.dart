import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stackremote/user/domain/user.dart';
import 'package:stackremote/user/domain/user_repository.dart';
import 'package:stackremote/user/infrastructure/user_repository_firestore.dart';
import 'package:stackremote/user/domain/userid.dart';
import 'package:stackremote/user/domain/users.dart';

void main() {
  // Firebaseのモック用インスタンス生成
  FakeFirebaseFirestore instance = FakeFirebaseFirestore();

  // userRepository生成
  UserRepository userRepository =
      UserRepositoryFireBase(firebaseFirestoreInstance: instance);

  setUp(() {
    // 各テスト毎に初期化
    instance = FakeFirebaseFirestore();
    userRepository =
        UserRepositoryFireBase(firebaseFirestoreInstance: instance);
  });

  test("ユーザデータを登録可能なこと、かつ、UserId指定でユーザデータを取得可能なこと", () async {
    // given
    final user = User.create(
      email: "take@test.com",
      password: "take",
      firebaseAuthUid: "firebaseAuthUid",
      firebaseAuthIdToken: "firebaseAuthIdToken",
    );
    final String userId = user.userId.value.toString();

    // when
    final UserId resUserId = await userRepository.add(user);
    final User resUser = await userRepository.fetchById(userId);
    // print("dump : ${instance.dump()}");

    // then
    expect(resUserId.value.toString(), userId);

    expect(resUser.userId.value.toString(), userId);
    expect(resUser.email, user.email);
    expect(resUser.password, user.password);
  });

  test("UserId指定でユーザデータを検索時、該当するユーザデータが存在しない場合、例外を返すこと", () async {
    // given
    final String userId = UserId.create().value.toString();

    // when and then
    final target = userRepository.fetchById(userId);
    expect(() async => await target, throwsA(isA<FirebaseException>()));
  });

  test("全ユーザデータを取得可能なこと", () async {
    // given

    // Userインスタンスを複数生成
    final user1 = User.create(
      email: "ake@test.com",
      password: "ake",
      firebaseAuthUid: "firebaseAuthUid",
      firebaseAuthIdToken: "firebaseAuthIdToken",
    );
    final user2 = User.create(
      email: "ike@test.com",
      password: "ike",
      firebaseAuthUid: "firebaseAuthUid",
      firebaseAuthIdToken: "firebaseAuthIdToken",
    );
    // final user3 = User.create(email: "uke@test.com", password: "uke", firebaseAuthUid: "firebaseAuthUid");
    final user4 = User.create(
      email: "eke@test.com",
      password: "eke",
      firebaseAuthUid: "firebaseAuthUid",
      firebaseAuthIdToken: "firebaseAuthIdToken",
    );

    // 複数のUserからUsersコレクションオブジェクト生成
    final srcUsers = Users.reconstruct(users: [
      user1,
      user2,
      // user3,
      user4,
    ]);

    // when
    // final UserId resUserId1 = await userRepository.add(user1);
    // final UserId resUserId2 = await userRepository.add(user2);
    // // final UserId resUserId3 = await userRepository.add(user3);
    // final UserId resUserId4 = await userRepository.add(user4);

    await userRepository.add(user1);
    await userRepository.add(user2);
    // await userRepository.add(user3);
    await userRepository.add(user4);

    final Stream<Users> resUsers = userRepository.fetchAll();

    // print("dump : ${instance.dump()}");

    // then

    // 複数箇所でStreamをlistenするため、Broadcastする
    final broadcastResUsers = resUsers.asBroadcastStream();

    // 各User単位で比較確認
    expect(
      broadcastResUsers,
      emitsInOrder(
        [
          equals(srcUsers),
        ],
      ),
    );

    // 各Userの各属性単位で比較確認
    broadcastResUsers.listen(((event) {
      final srcUserList = [user1, user2, user4];
      for (final user in event.users) {
        final srcUser = srcUserList.removeAt(0);

        expect(user.userId, srcUser.userId);
        expect(user.email, srcUser.email);
        expect(user.password, srcUser.password);
      }
    }));
  });

  test("ユーザデータを登録可能なこと、かつ、UserId指定でユーザデータを更新可能なこと", () async {
    // given
    final addUser = User.create(
      email: "take@test.com",
      password: "take",
      firebaseAuthUid: "firebaseAuthUid",
      firebaseAuthIdToken: "firebaseAuthIdToken",
    );
    final String addUserId = addUser.userId.value.toString();

    final UserId resAddUserId = await userRepository.add(addUser);
    final User resAddUser = await userRepository.fetchById(addUserId);
    // print("dump add user : ${instance.dump()}");

    expect(resAddUserId.value.toString(), addUserId);

    expect(resAddUser.userId, addUser.userId);
    expect(resAddUser.userId.value.toString(), addUserId);
    expect(resAddUser.email, addUser.email);
    expect(resAddUser.password, addUser.password);

    // when
    final User updateUser = User.reconstruct(
      userId: resAddUserId,
      email: "take_updated@test.com",
      password: "take_updated",
      firebaseAuthUid: "firebaseAuthUid",
      firebaseAuthIdToken: "firebaseAuthIdToken",
    );
    final String updateUserId = updateUser.userId.value.toString();

    userRepository.update(updateUser);

    final User resUpdateUser = await userRepository.fetchById(updateUserId);

    // then
    expect(resUpdateUser.userId, updateUser.userId);
    expect(resUpdateUser.userId.value.toString(), updateUserId);
    expect(resUpdateUser.email, updateUser.email);
    expect(resUpdateUser.password, updateUser.password);

    // print("dump update user : ${instance.dump()}");
  });

  test("ユーザデータを登録可能なこと、かつ、UserId指定でユーザデータを削除可能なこと", () async {
    // given
    final addUser = User.create(
      email: "take@test.com",
      password: "take",
      firebaseAuthUid: "firebaseAuthUid",
      firebaseAuthIdToken: "firebaseAuthIdToken",
    );
    final String addUserId = addUser.userId.value.toString();

    final UserId resAddUserId = await userRepository.add(addUser);
    final User resAddUser = await userRepository.fetchById(addUserId);
    // print("dump add user : ${instance.dump()}");

    expect(resAddUserId.value.toString(), addUserId);

    expect(resAddUser.userId, addUser.userId);
    expect(resAddUser.userId.value.toString(), addUserId);
    expect(resAddUser.email, addUser.email);
    expect(resAddUser.password, addUser.password);

    // when
    final String deleteUserId = addUser.userId.value.toString();
    userRepository.delete(deleteUserId);

    // then
    final target = userRepository.fetchById(deleteUserId);
    expect(() async => await target, throwsA(isA<FirebaseException>()));

    // print("dump delete user : ${instance.dump()}");
  });
}
