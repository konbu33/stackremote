// StateNotifier
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// Freezed
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'user.dart';

part 'users.freezed.dart';

// --------------------------------------------------
//
// Freezed
// First Colection
//
// --------------------------------------------------
@freezed
class Users with _$Users {
  const factory Users._({
    required List<User> users,
  }) = _Users;

  factory Users.create() => const Users._(users: []);

  factory Users.reconstruct({
    required List<User> users,
  }) =>
      Users._(
        users: users,
      );
}

/*
// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class UsersController extends StateNotifier<Users> {
  UsersController() : super(Users.create()) {
    _getInitData();
  }

  void resetData(List<User> users) {
    state = state.copyWith(users: users);
  }

  void _getInitData() {
    state = state.copyWith(
      users: [
        User.create(email: "init@test.com", password: "password"),
      ],
    );
  }

  void reconstruct(List<User> users) {
    state = state.copyWith(users: users);
  }
}
*/
