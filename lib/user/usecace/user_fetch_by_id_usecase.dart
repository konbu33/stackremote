import '../domain/user.dart';
import '../domain/user_repository.dart';

class UserFetchByIdUseCase {
  // Constructor
  const UserFetchByIdUseCase({
    required this.userRepository,
  });

  // Repository
  final UserRepository userRepository;

  // UseCase Execute
  Future<User> execute(String userId) {
    // Construct Dimain Model Object

    // Repository Execute
    final data = userRepository.fetchById(userId);

    // return users;
    return data;
  }
}
