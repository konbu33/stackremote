import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/user.dart';
import '../domain/user_repository.dart';
import '../infrastructure/user_repository_firestore.dart';

final userSetUsecaseProvider = Provider.autoDispose((ref) {
  final UserRepository userRepository =
      ref.watch(userRepositoryFirebaseProvider);

  final userState = ref.watch(userStateNotifierProvider);

  Future<void> execute() async {
    await userRepository.set(
      email: userState.email,
      user: userState,
    );
  }

  return execute;
});
