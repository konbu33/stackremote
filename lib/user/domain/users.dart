// Freezed
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

  factory Users.create({
    List<User>? users,
  }) =>
      Users._(
        users: users ?? [],
      );

  factory Users.reconstruct({
    List<User>? users,
  }) =>
      Users._(
        users: users ?? [],
      );
}

// --------------------------------------------------
//
// StateNotifier
//
// --------------------------------------------------
class UsersStateNotifier extends StateNotifier<Users> {
  UsersStateNotifier() : super(Users.create());
}

// --------------------------------------------------
//
// StateNotifierProvider
//
// --------------------------------------------------

final usersStateNotifierProvider =
    StateNotifierProvider<UsersStateNotifier, Users>((ref) {
  return UsersStateNotifier();
});
