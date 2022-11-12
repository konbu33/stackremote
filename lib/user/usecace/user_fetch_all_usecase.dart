import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/user/domain/user_repository.dart';
import 'package:stackremote/user/infrastructure/user_repository_firestore.dart';

import '../domain/users.dart';

final userFetchAllUsecaseProvider = Provider((ref) {
  final UserRepository userRepository =
      ref.watch(userRepositoryFirebaseProvider);

  Stream<Users> execute() {
    return userRepository.fetchAll();
  }

  return execute;
});
