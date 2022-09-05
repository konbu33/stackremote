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
    required String password,
    required String firebaseAuthUid,
    required String firebaseAuthIdToken,
    @Default(false) bool isSignIn,
    @OffsetConverter() required Offset pointerPosition,
    @Default(false) bool isOnLongPressing,
  }) = _User;

  factory User.create({
    required String email,
    required String password,
    required String firebaseAuthUid,
    required String firebaseAuthIdToken,
    bool? isSignIn,
    Offset? pointerPosition,
    bool? isOnLongPressing,
  }) =>
      User._(
        userId: UserId.create(),
        email: email,
        password: password,
        firebaseAuthUid: "",
        firebaseAuthIdToken: "",
        isSignIn: isSignIn ?? false,
        pointerPosition: pointerPosition ?? const Offset(0, 0),
        isOnLongPressing: isOnLongPressing ?? false,
      );

  factory User.reconstruct({
    required UserId userId,
    required String email,
    required String password,
    required String firebaseAuthUid,
    required String firebaseAuthIdToken,
    bool? isSignIn,
    Offset? pointerPosition,
    bool? isOnLongPressing,
  }) =>
      User._(
        userId: userId,
        email: email,
        password: password,
        firebaseAuthUid: firebaseAuthUid,
        firebaseAuthIdToken: "",
        isSignIn: isSignIn ?? false,
        pointerPosition: pointerPosition ?? const Offset(0, 0),
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
          email: "ini",
          password: "ini",
          firebaseAuthUid: "ini",
          firebaseAuthIdToken: "ini",
        )) {
    initial();
  }

  void initial() {
    state = User.create(
      email: "ini",
      password: "ini",
      firebaseAuthUid: "ini",
      firebaseAuthIdToken: "ini",
    );
  }

  void userInformationRegiser(User user) {
    state = state.copyWith(
      firebaseAuthUid: user.firebaseAuthUid,
      firebaseAuthIdToken: user.firebaseAuthIdToken,
      email: user.email,
      password: user.password,
      isSignIn: user.isSignIn,
    );
  }

  void updateFirebaseAuthIdToken(String firebaseAuthIdToken) {
    state = state.copyWith(
      firebaseAuthIdToken: firebaseAuthIdToken,
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
