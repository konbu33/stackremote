import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'userid.dart';

part 'user.freezed.dart';
part 'user.g.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class User with _$User {
  const factory User._({
    @UserIdConverter() required UserId userId,
    required String email,
    @Default(false) bool isSignIn,
    @OffsetConverter() required Offset cursorPosition,
    @Default(false) bool isOnLongPressing,
  }) = _User;

  factory User.create({
    required UserId userId,
    required String email,
    bool? isSignIn,
    Offset? cursorPosition,
    bool? isOnLongPressing,
  }) =>
      User._(
        userId: userId,
        email: email,
        isSignIn: isSignIn ?? false,
        cursorPosition: cursorPosition ?? const Offset(0, 0),
        isOnLongPressing: isOnLongPressing ?? false,
      );

  factory User.reconstruct({
    required UserId userId,
    required String email,
    bool? isSignIn,
    Offset? cursorPosition,
    bool? isOnLongPressing,
  }) =>
      User._(
        userId: userId,
        email: email,
        isSignIn: isSignIn ?? false,
        cursorPosition: cursorPosition ?? const Offset(0, 0),
        isOnLongPressing: isOnLongPressing ?? false,
      );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

// --------------------------------------------------
//
//  JsonConverter
//
// --------------------------------------------------
class OffsetConverter extends JsonConverter<Offset, String> {
  const OffsetConverter();

  @override
  String toJson(Offset object) {
    final double dx = object.dx;
    final double dy = object.dy;
    final Map<String, double> jsonMap = {
      "dx": dx,
      "dy": dy,
    };
    return jsonEncode(jsonMap);
  }

  @override
  Offset fromJson(String json) {
    final Map<String, dynamic> jsonMap = jsonDecode(json);
    final double dx = jsonMap["dx"];
    final double dy = jsonMap["dy"];

    return Offset(dx, dy);
  }
}

// --------------------------------------------------
//
//  StateNotifier
//
// --------------------------------------------------
class UserStateNotifier extends StateNotifier<User> {
  UserStateNotifier()
      : super(User.create(
          userId: UserId.create(value: "ini"),
          email: "ini",
        )) {
  }


  void userInformationRegiser(User user) {
    state = state.copyWith(
      userId: user.userId,
      email: user.email,
      isSignIn: user.isSignIn,
    );
  }
}

// --------------------------------------------------
//
//  StateNotifierProvider
//
// --------------------------------------------------
final userStateNotifierProvider =
    StateNotifierProvider<UserStateNotifier, User>(
  (ref) => UserStateNotifier(),
);
