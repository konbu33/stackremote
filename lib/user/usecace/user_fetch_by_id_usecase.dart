import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../user.dart';

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
