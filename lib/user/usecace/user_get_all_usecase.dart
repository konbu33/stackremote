import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/user_repository.dart';
import '../domain/users.dart';
import '../infrastructure/user_repository_firestore.dart';

final userGetAllUsecaseProvider = Provider((ref) {
  final UserRepository userRepository =
      ref.watch(userRepositoryFirebaseProvider);

  Future<Users> execute() async {
    final users = userRepository.getAll();

    return users;
  }

  return execute;
});
