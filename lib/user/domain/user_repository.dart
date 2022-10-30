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

  Stream<Users> fetchAll();

  Future<User> fetchById(String userId);

  Future<void> set({
    required String channelName,
    required String email,
    required User user,
  });

  Future<UserId> add(User user);

  Future<String> delete(String userId);

  void update(User user);
}
