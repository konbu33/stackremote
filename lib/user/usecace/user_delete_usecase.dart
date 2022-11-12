import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/user/domain/user_repository.dart';
import 'package:stackremote/user/infrastructure/user_repository_firestore.dart';

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
