import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/user/domain/user_repository.dart';
import 'package:stackremote/user/infrastructure/user_repository_firestore.dart';

import '../domain/user.dart';

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
