import '../user.dart';
import 'custom_mouse_cursor_repository.dart';

class CustomMouseCursorPositionListenUseCase {
  const CustomMouseCursorPositionListenUseCase({
    required this.customMouseCursorRepository,
  });

  final CustomMouseCursorRepository customMouseCursorRepository;

  Stream<User> execute(String userId) async* {
    //
    final stream = customMouseCursorRepository.listen(userId);
  }
}
