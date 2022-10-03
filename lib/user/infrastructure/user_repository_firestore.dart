import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/user.dart';
import '../domain/user_repository.dart';
import '../domain/userid.dart';
import '../domain/users.dart';

class UserRepositoryFireBase implements UserRepository {
  UserRepositoryFireBase({
    required this.firebaseFirestoreInstance,
  }) {
    ref = firebaseFirestoreInstance.collection('users');
  }

  @override
  final FirebaseFirestore firebaseFirestoreInstance;

  @override
  late CollectionReference<JsonMap> ref;

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
      // print("error: $e");
      rethrow;
    }
  }

  @override
  Future<User> fetchById(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await ref.doc(userId).get();
      final docData = doc.data();
      // if (docData == null) throw FirebaseException;
      if (docData == null) {
        throw FirebaseException(
            plugin: "userRepository", code: "fetchById", message: "ユーザが存在しません");
      }
      final user = User.fromJson(docData);
      return user;
    } on FirebaseException catch (_) {
      // print(" error code : ${e.code}, error message : ${e.message}");
      rethrow;
    }
  }

  @override
  Future<UserId> add(User user) async {
    final userJson = user.toJson();
    final String docId = user.userId.value.toString();
    await ref.doc(docId).set(userJson);
    return user.userId;
  }

  @override
  Future<String> delete(String userId) async {
    await ref.doc(userId).delete();
    return "Delete Complete.";
  }

  @override
  void update(User user) async {
    final userJson = user.toJson();
    final String docId = user.userId.value.toString();
    await ref.doc(docId).set(userJson);
  }
}
