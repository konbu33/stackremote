import 'package:cloud_firestore/cloud_firestore.dart';

import 'user.dart';
import 'users.dart';

typedef JsonMap = Map<String, dynamic>;

abstract class UserRepository {
  UserRepository({
    required this.firebaseFirestoreInstance,
    required this.channelName,
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
