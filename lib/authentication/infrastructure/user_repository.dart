import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/value_object/user.dart';
import '../domain/value_object/userid.dart';
// import 'users.dart';

typedef JsonMap = Map<String, dynamic>;

abstract class UserRepository {
  UserRepository({
    required this.firebaseFirestoreInstance,
  });

  final FirebaseFirestore firebaseFirestoreInstance;

  late CollectionReference<JsonMap> ref;

  Future<UserId> add(User user);
  // Future<String> delete(String userId);
  // void update(User user);
  // Stream<Users> fetchAll();
  // Future<User> fetchById(String userId);
}
