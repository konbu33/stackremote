import '../domain/user_repository.dart';

class UserDeleteUseCase {
  // Constructor
  const UserDeleteUseCase({
    required this.userRepository,
  });

  // Repository
  final UserRepository userRepository;

  // UseCase Execute
  Future<String> execute(
    String userId,
  ) async {
    // Construct Dimain Model Object

    // Repository Execute
    final data = await userRepository.delete(userId);

    return data;
  }
}
