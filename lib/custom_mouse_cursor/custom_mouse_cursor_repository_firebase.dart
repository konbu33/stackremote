import 'package:cloud_firestore/cloud_firestore.dart';

import '../user.dart';
import '../user_repository.dart';
import '../userid.dart';
import 'custom_mouse_cursor_repository.dart';

class CustomMouseCursorRepositoryFirebase
    implements CustomMouseCursorRepository {
  CustomMouseCursorRepositoryFirebase({required this.instance}) {
    ref = instance.collection('users');
  }

  @override
  final FirebaseFirestore instance;

  @override
  late CollectionReference<JsonMap> ref;

  @override
  Stream<User> listen(String userId) async* {
    final Stream<DocumentSnapshot<JsonMap>> userStream =
        ref.doc(userId).snapshots();

    await for (final user in userStream) {
      final d = user.data();
      if (d != null) {
        final User data = User.fromJson(d);
        yield data;
      }
    }
  }

  @override
  Future<UserId> update(User user) async {
    final userJson = user.toJson();
    await instance.doc(user.userId.value.toString()).set(userJson);

    return UserId.create();
  }
}
