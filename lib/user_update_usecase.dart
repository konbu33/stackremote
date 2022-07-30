import 'package:stackremote/user.dart';

import 'user_repository.dart';
import 'userid.dart';

class UserUpdateUseCase {
  // Constructor
  const UserUpdateUseCase({
    required this.userRepository,
  });

  // Repository
  final UserRepository userRepository;

  // UseCase Execute
  void execute(
    UserId userId,
    String email,
    String password,
  ) {
    // Construct Dimain Model Object
    final User user =
        User.reconstruct(userId: userId, email: email, password: password);

    // Repository Execute
    userRepository.update(user);

    // Construct View Model Object
  }
}
