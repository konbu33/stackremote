import '../domain/user_repository.dart';
import '../domain/users.dart';

class UserFetchAllUseCase {
  // Constructor
  const UserFetchAllUseCase({
    required this.userRepository,
  });

  // Repository
  final UserRepository userRepository;

  // UseCase Execute
  Stream<Users> execute() {
    // Construct Dimain Model Object

    // Repository Execute
    final data = userRepository.fetchAll();

    // return users;
    return data;
  }
}
