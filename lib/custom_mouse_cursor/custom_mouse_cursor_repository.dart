import 'package:cloud_firestore/cloud_firestore.dart';

import '../user.dart';
import '../user_repository.dart';
import '../userid.dart';

abstract class CustomMouseCursorRepository {
  CustomMouseCursorRepository({required this.instance}) {
    ref = instance.collection('users');
  }

  final FirebaseFirestore instance;
  late CollectionReference<JsonMap> ref;

  Stream<User> listen(String userId);
  Future<UserId> update(User user);
}
