import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'firebase_auth_user.freezed.dart';
part 'firebase_auth_user.g.dart';

// --------------------------------------------------
//
//   Freezed
//
// --------------------------------------------------
@freezed
class FirebaseAuthUser with _$FirebaseAuthUser {
  const factory FirebaseAuthUser._({
    required String email,
    @Default(false) bool emailVerified,
    required String password,
    required String firebaseAuthUid,
    required String firebaseAuthIdToken,
    @Default(false) bool isSignIn,
  }) = _FirebaseAuthUser;

  factory FirebaseAuthUser.create({
    required String email,
    required String password,
    required String firebaseAuthUid,
    required String firebaseAuthIdToken,
    bool? isSignIn,
  }) =>
      FirebaseAuthUser._(
        email: email,
        password: password,
        firebaseAuthUid: "",
        firebaseAuthIdToken: "",
        isSignIn: isSignIn ?? false,
      );

  factory FirebaseAuthUser.reconstruct({
    required String email,
    required bool emailVerified,
    required String password,
    required String firebaseAuthUid,
    required String firebaseAuthIdToken,
    bool? isSignIn,
  }) =>
      FirebaseAuthUser._(
        email: email,
        emailVerified: emailVerified,
        password: password,
        firebaseAuthUid: firebaseAuthUid,
        firebaseAuthIdToken: "",
        isSignIn: isSignIn ?? false,
      );

  factory FirebaseAuthUser.fromJson(Map<String, dynamic> json) =>
      _$FirebaseAuthUserFromJson(json);
}

// --------------------------------------------------
//
//  StateNotifier
//
// --------------------------------------------------
class FirebaseAuthUserStateNotifier extends StateNotifier<FirebaseAuthUser> {
  FirebaseAuthUserStateNotifier()
      : super(FirebaseAuthUser.create(
          email: "ini",
          password: "ini",
          firebaseAuthUid: "ini",
          firebaseAuthIdToken: "ini",
        )) {
    initial();
  }

  void initial() {
    state = FirebaseAuthUser.create(
      email: "ini",
      password: "ini",
      firebaseAuthUid: "ini",
      firebaseAuthIdToken: "ini",
    );
  }

  void userInformationRegiser(FirebaseAuthUser user) {
    state = state.copyWith(
      firebaseAuthUid: user.firebaseAuthUid,
      firebaseAuthIdToken: user.firebaseAuthIdToken,
      email: user.email,
      password: user.password,
      isSignIn: user.isSignIn,
    );
  }

  void updatePassword(String password) {
    state = state.copyWith(
      password: password,
    );
  }

  void updateFirebaseAuthIdToken(String firebaseAuthIdToken) {
    state = state.copyWith(
      firebaseAuthIdToken: firebaseAuthIdToken,
    );
  }

  void updateEmailVerified(bool isEmailVerified) {
    state = state.copyWith(
      emailVerified: isEmailVerified,
    );
  }
}

// --------------------------------------------------
//
//  StateNotifierProvider
//
// --------------------------------------------------
final firebaseAuthUserStateNotifierProvider =
    StateNotifierProvider<FirebaseAuthUserStateNotifier, FirebaseAuthUser>(
  (ref) => FirebaseAuthUserStateNotifier(),
);
