// Freezed
import 'package:freezed_annotation/freezed_annotation.dart';
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

  factory Users.create() => const Users._(
        users: [],
      );

  factory Users.reconstruct({
    List<User>? users,
  }) =>
      Users._(
        users: users ?? [],
      );
}
