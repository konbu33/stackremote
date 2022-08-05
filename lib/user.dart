import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import 'userid.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User._({
    @UserIdConverter() required UserId userId,
    required String email,
    required String password,
  }) = _User;

  factory User.create({
    required String email,
    required String password,
  }) =>
      User._(
        userId: UserId.create(),
        email: email,
        password: password,
      );

  factory User.reconstruct({
    required UserId userId,
    required String email,
    required String password,
  }) =>
      User._(
        userId: userId,
        email: email,
        password: password,
      );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
