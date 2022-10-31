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
  Stream<Users> fetchAll() {
    // Firestore Data Stream Listen
    try {
      final Stream<QuerySnapshot<JsonMap>> snapshotStream = ref.snapshots();

      // Stream Data Transfar from Firestore Stream to Object Stream
      Stream<Users> transferStream(
          Stream<QuerySnapshot<JsonMap>> snapshotStream) async* {
        // Out snapshot from Stream
        await for (final snapshot in snapshotStream) {
          // from Firestore Snapshot to User Type Object Collection.
          final docDatas = snapshot.docs.map(((doc) {
            final docData = doc.data();
            return User.fromJson(docData);
          })).toList();

          final Users users = Users.reconstruct(users: docDatas);
          yield users;
        }
      }

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
  Future<User> fetchById(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await ref.doc(userId).get();
      final docData = doc.data();
      if (docData == null) {
        throw FirebaseException(
            plugin: "userRepository", code: "fetchById", message: "ユーザが存在しません");
      }
      final user = User.fromJson(docData);
      return user;
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

    await FirebaseFirestore.instance
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
    await FirebaseFirestore.instance
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
