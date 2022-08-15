import '../domain/user.dart';

import '../domain/user_repository.dart';
import '../domain/userid.dart';

class UserAddUseCase {
  // Constructor
  const UserAddUseCase({
    required this.userRepository,
  });

  // Repository
  final UserRepository userRepository;

  // UseCase Execute
  Future<UserId> execute(
    String firebaseAuthUid,
    String email,
  ) async {
    // Construct Dimain Model Object
    final userId = UserId.create(value: firebaseAuthUid);
    final User user = User.create(userId: userId, email: email);

    // Repository Execute
    await userRepository.add(user);

    return user.userId;

    // Construct View Model Object
  }
}
