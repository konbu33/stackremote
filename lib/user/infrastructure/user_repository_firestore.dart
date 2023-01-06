import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../channel/channel.dart';
import '../../common/common.dart';

import '../domain/user.dart';
import '../domain/user_repository.dart';
import '../domain/users.dart';

final firebaseFirestoreInstanceProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

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
            return User.fromJson(docData);
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
  }) async {
    try {
      await ref.doc(email).update(data);

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
