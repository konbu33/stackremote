import 'package:stackremote/user.dart';

import 'user_repository.dart';
import 'userid.dart';

class UserAddUseCase {
  // Constructor
  const UserAddUseCase({
    required this.userRepository,
  });

  // Repository
  final UserRepository userRepository;

  // UseCase Execute
  Future<UserId> execute(
    String email,
    String password,
  ) async {
    // Construct Dimain Model Object
    final User user = User.create(email: email, password: password);

    // Repository Execute
    await userRepository.add(user);

    return user.userId;

    // Construct View Model Object
  }
}