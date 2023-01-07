import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/common.dart';

import 'user.dart';
import 'users.dart';

abstract class UserRepository {
  UserRepository({
    required this.channelName,
    required this.firebaseFirestoreInstance,
  });

  late String channelName;

  final FirebaseFirestore firebaseFirestoreInstance;

  late CollectionReference<JsonMap> ref;

  Future<void> delete({
    required String email,
  });

  Stream<Users> fetchAll();

  Stream<User> fetchById({
    required String email,
  });

  Future<void> set({
    required String email,
    required User user,
  });

  Future<void> update({
    required String email,
    required Map<String, dynamic> data,
  });
}
