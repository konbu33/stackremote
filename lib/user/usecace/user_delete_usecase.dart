import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../user.dart';

final userDeleteUsecaseProvider = Provider((ref) {
  final UserRepository userRepository =
      ref.watch(userRepositoryFirebaseProvider);

  Future<void> execute({
    required String email,
  }) async {
    userRepository.delete(
      email: email,
    );
  }

  return execute;
});
