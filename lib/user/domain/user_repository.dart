import 'package:cloud_firestore/cloud_firestore.dart';

import 'user.dart';
import 'users.dart';

typedef JsonMap = Map<String, dynamic>;

abstract class UserRepository {
  UserRepository({
    required this.firebaseFirestoreInstance,
    required this.channelName,
  });

  final FirebaseFirestore firebaseFirestoreInstance;

  late CollectionReference<JsonMap> ref;

  late String channelName;

  Stream<Users> fetchAll();

  Stream<User> fetchById({
    required String email,
  });

  Future<void> set({
    required String email,
    required User user,
  });

  Future<void> delete({
    required String email,
  });

  Future<void> update({
    required String email,
    required Map<String, dynamic> data,
  });
}
