import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/user.dart';
import '../domain/user_repository.dart';
import '../infrastructure/user_repository_firestore.dart';

final userFetchByIdUsecaseProvider = Provider((ref) {
  final UserRepository userRepository =
      ref.watch(userRepositoryFirebaseProvider);

  Stream<User> execute({
    required String email,
  }) {
    return userRepository.fetchById(
      email: email,
    );
  }

  return execute;
});
