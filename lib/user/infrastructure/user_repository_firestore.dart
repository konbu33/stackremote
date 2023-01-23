import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../channel/channel.dart';
import '../../common/common.dart';

import '../domain/user.dart';
import '../domain/user_repository.dart';
import '../domain/users.dart';

final userRepositoryFirebaseProvider = Provider<UserRepository>((ref) {
  final firebaseFirestoreInstance =
      ref.watch(firebaseFirestoreInstanceProvider);

  final channelName = ref.watch(channelNameProvider);

  return UserRepositoryFireBase(
    channelName: channelName,
    firebaseFirestoreInstance: firebaseFirestoreInstance,
  );
});

class UserRepositoryFireBase implements UserRepository {
  UserRepositoryFireBase({
    required this.channelName,
    required this.firebaseFirestoreInstance,
  }) {
    ref = firebaseFirestoreInstance
        .collection('channels')
        .doc(channelName)
        .collection('users');
  }

  @override
  late String channelName;

  @override
  final FirebaseFirestore firebaseFirestoreInstance;

  @override
  late CollectionReference<JsonMap> ref;

  // --------------------------------------------------
  //
  //   delete
  //
  // --------------------------------------------------
  @override
  Future<void> delete({
    required String email,
  }) async {
    try {
      await ref.doc(email).delete();

      //
    } on FirebaseException catch (e) {
      logger.d("$e");

      throw StackremoteException(
        plugin: e.plugin,
        message: e.message ?? "",
        code: e.code,
        stackTrace: e.stackTrace,
      );
    }
  }

  // --------------------------------------------------
  //
  //  docDataToUser
  //
  // --------------------------------------------------

  User docDataToUser(JsonMap docData) {
    //
    String? timestampToDateTimeString(Timestamp? timestamp) {
      if (timestamp == null) return null;
      return timestamp.toDate().toString();
    }

    final joinedAt =
        timestampToDateTimeString(docData["joinedAt"] as Timestamp?);

    final leavedAt =
        timestampToDateTimeString(docData["leavedAt"] as Timestamp?);

    final jsonData = {
      ...docData,
      "joinedAt": joinedAt,
      "leavedAt": leavedAt,
    };

    final user = User.fromJson(jsonData);

    return user;
  }

  // --------------------------------------------------
  //
  //   fetchAll
  //
  // --------------------------------------------------
  @override
  Stream<Users> fetchAll() {
    // Firestore Data Stream Listen
    try {
      final Stream<QuerySnapshot<JsonMap>> snapshotStream = ref.snapshots();

      Stream<Users> transferStream(
          Stream<QuerySnapshot<JsonMap>> snapshotStream) async* {
        // Out snapshot from Stream
        await for (final snapshot in snapshotStream) {
          // from Firestore Snapshot to User Type Object Collection.
          final docDatas = snapshot.docs.map(((doc) {
            final docData = doc.data();

            final user = docDataToUser(docData);
            return user;

            //
          })).toList();

          final Users users = Users.reconstruct(users: docDatas);
          yield users;
        }
      }

      return transferStream(snapshotStream);

      //
    } on FirebaseException catch (e) {
      logger.d("$e");

      throw StackremoteException(
        plugin: e.plugin,
        message: e.message ?? "",
        code: e.code,
        stackTrace: e.stackTrace,
      );
    }
  }

  // --------------------------------------------------
  //
  //   fetchById
  //
  // --------------------------------------------------

  @override
  Stream<User> fetchById({
    required String email,
  }) {
    try {
      final Stream<DocumentSnapshot<JsonMap>> snapshotStream =
          ref.doc(email).snapshots();

      Stream<User> transferStream(
          Stream<DocumentSnapshot<JsonMap>> snapshotStream) async* {
        await for (final snapshot in snapshotStream) {
          if (snapshot.data() != null) {
            final docData = snapshot.data() as JsonMap;

            final user = docDataToUser(docData);
            yield user;

            //
          } else {
            throw FirebaseException(
              plugin: "userRepository",
              code: "fetchById",
              message: "ユーザが存在しません",
            );
          }
        }
      }

      return transferStream(snapshotStream);

      //
    } on FirebaseException catch (e) {
      logger.d("$e");

      throw StackremoteException(
        plugin: e.plugin,
        message: e.message ?? "",
        code: e.code,
        stackTrace: e.stackTrace,
      );
    }
  }

  // --------------------------------------------------
  //
  //  getAll
  //
  // --------------------------------------------------
  @override
  Future<Users> getAll() async {
    try {
      final res = await ref.get();

      final docDataList = res.docs.map((doc) {
        return doc.data();
      }).toList();

      final userList = docDataList.map((docData) {
        final user = User.fromJson(docData);
        return user;
      }).toList();

      final users = Users.create(users: userList);

      return users;

      //
    } on FirebaseException catch (e) {
      logger.d("$e");

      throw StackremoteException(
        plugin: e.plugin,
        message: e.message ?? "",
        code: e.code,
        stackTrace: e.stackTrace,
      );
    }
  }

  // --------------------------------------------------
  //
  //  set
  //
  // --------------------------------------------------
  @override
  Future<void> set({
    required String email,
    required User user,
  }) async {
    try {
      await ref
          .doc(email)
          .set({...user.toJson(), "joinedAt": FieldValue.serverTimestamp()});

      //
    } on FirebaseException catch (e) {
      logger.d("$e");

      throw StackremoteException(
        plugin: e.plugin,
        message: e.message ?? "",
        code: e.code,
        stackTrace: e.stackTrace,
      );
    }
  }

  // --------------------------------------------------
  //
  //   update
  //
  // --------------------------------------------------
  @override
  Future<void> update({
    required String email,
    required Map<String, dynamic> data,
    required bool isJoinedAt,
    required bool isLeavedAt,
  }) async {
    try {
      final Map<String, dynamic> registerData = data;

      if (isJoinedAt) {
        registerData.addAll(
            {...registerData, "joinedAt": FieldValue.serverTimestamp()});
      }

      if (isLeavedAt) {
        registerData.addAll(
            {...registerData, "leavedAt": FieldValue.serverTimestamp()});
      }

      await ref.doc(email).update(registerData);

      //
    } on FirebaseException catch (e) {
      logger.d("$e");

      throw StackremoteException(
        plugin: e.plugin,
        message: e.message ?? "",
        code: e.code,
        stackTrace: e.stackTrace,
      );
    }
  }
}
