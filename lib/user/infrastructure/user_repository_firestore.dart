import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/user.dart';
import '../domain/user_repository.dart';
import '../domain/userid.dart';
import '../domain/users.dart';

final userRepositoryFirebaseProvider = Provider<UserRepository>((ref) {
  return UserRepositoryFireBase(
      firebaseFirestoreInstance: FirebaseFirestore.instance);
});

class UserRepositoryFireBase implements UserRepository {
  UserRepositoryFireBase({
    required this.firebaseFirestoreInstance,
  }) {
    // ref = firebaseFirestoreInstance.collection('channels');
  }

  @override
  final FirebaseFirestore firebaseFirestoreInstance;

  @override
  late CollectionReference<JsonMap> ref;

  // --------------------------------------------------
  //
  //   fetchAll
  //
  // --------------------------------------------------
  @override
  Stream<Users> fetchAll({
    required String channelName,
  }) {
    // Firestore Data Stream Listen
    try {
      // final Stream<QuerySnapshot<JsonMap>> snapshotStream = ref.snapshots();

      // // Stream Data Transfar from Firestore Stream to Object Stream
      // Stream<Users> transferStream(
      //     Stream<QuerySnapshot<JsonMap>> snapshotStream) async* {
      //   // Out snapshot from Stream
      //   await for (final snapshot in snapshotStream) {
      //     // from Firestore Snapshot to User Type Object Collection.
      //     final docDatas = snapshot.docs.map(((doc) {
      //       final docData = doc.data();
      //       return User.fromJson(docData);
      //     })).toList();

      //     final Users users = Users.reconstruct(users: docDatas);
      //     yield users;
      //   }
      // }

      // return transferStream(snapshotStream);

      // Stream<QuerySnapshot> execute() {
      final Stream<QuerySnapshot<JsonMap>> snapshotStream =
          firebaseFirestoreInstance
              .collection('channels')
              .doc(channelName)
              .collection('users')
              .snapshots();

      // logger.d("execute : ");

      Stream<Users> transferStream(
          Stream<QuerySnapshot<JsonMap>> snapshotStream) async* {
        // Out snapshot from Stream
        await for (final snapshot in snapshotStream) {
          // from Firestore Snapshot to User Type Object Collection.
          final docDatas = snapshot.docs.map(((doc) {
            final docData = doc.data();
            // final User user = User.create(
            //   nickName: docData["nickName"],
            //   isHost: docData["isHost"],
            //   joinedAt: const TimestampConverter().fromJson(docData["joinedAt"]),
            //   leavedAt: docData["leavedAt"],
            //   isOnLongPressing: docData["isOnLongPressing"],
            //   pointerPosition:
            //       const OffsetConverter().fromJson(docData["pointerPosition"]),
            // );
            // return user;
            // logger.d("$docData");

            // final manualData = {
            //   "isHost": true,
            //   "nickName": "ホストユーザ",
            //   "joinedAt": Timestamp(1666833125, 741000000),
            //   "leavedAt": null,
            //   "pointerPosition": {"dx": 0.0, "dy": 0.0},
            //   "isOnLongPressing": false,
            // };
            // return User.fromJson(manualData);
            return User.fromJson(docData);
          })).toList();

          final Users users = Users.reconstruct(users: docDatas);
          yield users;
        }
      }

      // logger.d("transferStream :  ");
      return transferStream(snapshotStream);
    } catch (e) {
      rethrow;
    }
  }

  // --------------------------------------------------
  //
  //   fetchById
  //
  // --------------------------------------------------

  @override
  Stream<User> fetchById({
    required String channelName,
    required String email,
  }) {
    try {
      // final DocumentSnapshot<Map<String, dynamic>> doc =
      //     await ref.doc(userId).get();
      // final docData = doc.data();
      // if (docData == null) {
      //   throw FirebaseException(
      //       plugin: "userRepository", code: "fetchById", message: "ユーザが存在しません");
      // }
      // final user = User.fromJson(docData);
      // return user;

      final Stream<DocumentSnapshot<JsonMap>> snapshotStream =
          firebaseFirestoreInstance
              .collection('channels')
              .doc(channelName)
              .collection('users')
              .doc(email)
              .snapshots();

      // logger.d("execute : ");

      Stream<User> transferStream(
          Stream<DocumentSnapshot<JsonMap>> snapshotStream) async* {
        await for (final snapshot in snapshotStream) {
          if (snapshot.data() != null) {
            final docData = snapshot.data() as JsonMap;

            yield User.fromJson(docData);
          } else {
            throw FirebaseException(
              plugin: "userRepository",
              code: "fetchById",
              message: "ユーザが存在しません",
            );
          }
        }
      }

      // logger.d("transferStream :  ");
      return transferStream(snapshotStream);
      //

    } on FirebaseException catch (_) {
      rethrow;
    }
  }

  // --------------------------------------------------
  //
  //  set
  //
  // --------------------------------------------------
  @override
  Future<void> set({
    required String channelName,
    required String email,
    required User user,
  }) async {
    // final userJson = user.toJson();
    // // final String docId = user.userId.value.toString();
    // await ref.doc(docId).set(userJson);
    // return user;

    // await FirebaseFirestore.instance
    await firebaseFirestoreInstance
        .collection('channels')
        .doc(channelName)
        .collection('users')
        .doc(email)
        .set({...user.toJson(), "joinedAt": FieldValue.serverTimestamp()});
  }

  // --------------------------------------------------
  //
  //   add
  //
  // --------------------------------------------------
  @override
  Future<UserId> add(User user) async {
    // final userJson = user.toJson();
    // final String docId = user.userId.value.toString();
    // await ref.doc(docId).set(userJson);
    // return user.userId;
    return UserId.create();
  }

  // --------------------------------------------------
  //
  //   delete
  //
  // --------------------------------------------------
  @override
  Future<void> delete({
    required String channelName,
    required String email,
  }) async {
    // await ref.doc(userId).delete();
    // return "Delete Complete.";

    await firebaseFirestoreInstance
        .collection('channels')
        .doc(channelName)
        .collection('users')
        .doc(email)
        .delete();
  }

  // --------------------------------------------------
  //
  //   update
  //
  // --------------------------------------------------
  @override
  void update({
    required String channelName,
    required String email,
    required Map<String, dynamic> data,
  }) async {
    await firebaseFirestoreInstance
        .collection('channels')
        .doc(channelName)
        .collection('users')
        .doc(email)
        .update(data);

    // final userJson = user.toJson();
    // final String docId = user.userId.value.toString();
    // await ref.doc(docId).set(userJson);
  }
}
