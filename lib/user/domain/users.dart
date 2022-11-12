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
    @Default([]) List<User> users,
  }) = _Users;

  factory Users.create() => const Users._();

  factory Users.reconstruct({
    List<User>? users,
  }) =>
      Users._(
        users: users ?? [],
      );
}
