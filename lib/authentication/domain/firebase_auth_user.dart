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
    @Default("") String firebaseAuthUid,
    @Default(false) bool isSignIn,
  }) = _FirebaseAuthUser;

  factory FirebaseAuthUser.create({
    required String email,
  }) =>
      FirebaseAuthUser._(
        email: email,
      );

  factory FirebaseAuthUser.reconstruct({
    String? email,
    bool? emailVerified,
    String? firebaseAuthUid,
    bool? isSignIn,
  }) =>
      FirebaseAuthUser._(
        email: email ?? "",
        emailVerified: emailVerified ?? false,
        firebaseAuthUid: firebaseAuthUid ?? "",
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
  FirebaseAuthUserStateNotifier({
    String? email,
  }) : super(FirebaseAuthUser.create(
          email: email ?? "",
        )) {
    initial();
  }

  void initial() {
    state = FirebaseAuthUser.create(
      email: "",
    );
  }

  void userInformationRegiser(FirebaseAuthUser user) {
    state = state.copyWith(
      firebaseAuthUid: user.firebaseAuthUid,
      email: user.email,
      emailVerified: user.emailVerified,
      isSignIn: user.isSignIn,
    );
  }

  void updateIsSignIn(bool isSignIn) {
    state = state.copyWith(isSignIn: isSignIn);
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
