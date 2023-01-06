import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../user.dart';

final userFetchAllUsecaseProvider = Provider((ref) {
  final UserRepository userRepository =
      ref.watch(userRepositoryFirebaseProvider);

  Stream<Users> execute() {
    return userRepository.fetchAll();
  }

  return execute;
});
