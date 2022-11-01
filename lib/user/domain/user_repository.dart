import 'package:cloud_firestore/cloud_firestore.dart';

import 'user.dart';
import 'userid.dart';
import 'users.dart';

typedef JsonMap = Map<String, dynamic>;

abstract class UserRepository {
  UserRepository({
    required this.firebaseFirestoreInstance,
  });

  final FirebaseFirestore firebaseFirestoreInstance;

  late CollectionReference<JsonMap> ref;

  Stream<Users> fetchAll({
    required String channelName,
  });

  Stream<User> fetchById({
    required String channelName,
    required String email,
  });

  Future<void> set({
    required String channelName,
    required String email,
    required User user,
  });

  Future<UserId> add(User user);

  Future<void> delete({
    required String channelName,
    required String email,
  });

  void update({
    required String channelName,
    required String email,
    required Map<String, dynamic> data,
  });
}
