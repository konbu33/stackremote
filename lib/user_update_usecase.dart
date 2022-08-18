import 'package:flutter/material.dart';
import 'user.dart';

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
    String password, {
    Offset? cursorPosition,
    bool? isOnLongPressing,
  }) {
    // Construct Dimain Model Object
    final User user = User.reconstruct(
      userId: userId,
      email: email,
      password: password,
      cursorPosition: cursorPosition,
      isOnLongPressing: isOnLongPressing,
      // cursorPosition: CursorPosition.initial(),
      // customMouseCursorOerlayerState: CustomMouseCursorOerlayerState.initial(),
    );

    // Repository Execute
    userRepository.update(user);

    // Construct View Model Object
  }
}
