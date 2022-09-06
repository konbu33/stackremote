import 'package:flutter/material.dart';
import 'package:stackremote/presentation/widget/router_widget.dart';
import '../domain/user.dart';
import '../domain/user_repository.dart';
import '../domain/userid.dart';

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
    String firebaseAuthUid,
    String firebaseAuthGetIdToken, {
    Offset? pointerPosition,
    bool? isOnLongPressing,
  }) {
    // Construct Dimain Model Object
    final User user = User.reconstruct(
      userId: userId,
      email: email,
      password: password,
      firebaseAuthUid: firebaseAuthUid,
      firebaseAuthIdToken: firebaseAuthGetIdToken,
      pointerPosition: pointerPosition,
      isOnLongPressing: isOnLongPressing,
    );

    // Repository Execute
    userRepository.update(user);

    // Construct View Model Object
  }
}
