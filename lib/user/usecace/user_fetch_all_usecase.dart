import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/user_repository.dart';
import '../domain/users.dart';
import '../infrastructure/user_repository_firestore.dart';

final userFetchAllUsecaseProvider = Provider((ref) {
  final UserRepository userRepository =
      ref.watch(userRepositoryFirebaseProvider);

  Stream<Users> execute() {
    return userRepository.fetchAll();
  }

  return execute;
});
