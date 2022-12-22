import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';
import '../authentication.dart';

part 'firebase_auth_user.freezed.dart';

// --------------------------------------------------
//
//   FirebaseAuthUser
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
}

// --------------------------------------------------
//
//  FirebaseAuthUserStateNotifier
//
// --------------------------------------------------
class FirebaseAuthUserStateNotifier extends Notifier<FirebaseAuthUser> {
  @override
  FirebaseAuthUser build() {
    // 認証状況の変移をwatch開始
    final firebaseAuthUserSteram = ref.watch(firebaseAuthUserSteramProvider);

    final firebaseAuthUser = firebaseAuthUserSteram.when(data: (data) {
      return data;
    }, error: (error, stackTrace) {
      return FirebaseAuthUser.create(email: "");
    }, loading: () {
      return FirebaseAuthUser.create(email: "");
    });

    logger.d(firebaseAuthUser);

    return firebaseAuthUser;
  }

  void userInformationRegiser(FirebaseAuthUser user) {
    state = state.copyWith(
      email: user.email,
      emailVerified: user.emailVerified,
      firebaseAuthUid: user.firebaseAuthUid,
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
//  firebaseAuthUserStateNotifierProviderCreator
//
// --------------------------------------------------
typedef FirebaseAuthUserStateNotifierProvider
    = NotifierProvider<FirebaseAuthUserStateNotifier, FirebaseAuthUser>;

FirebaseAuthUserStateNotifierProvider
    firebaseAuthUserStateNotifierProviderCreator() {
  return NotifierProvider<FirebaseAuthUserStateNotifier, FirebaseAuthUser>(
    () => FirebaseAuthUserStateNotifier(),
  );
}

// --------------------------------------------------
//
//  firebaseAuthUserStateNotifierProvider
//
// --------------------------------------------------
final firebaseAuthUserStateNotifierProvider =
    firebaseAuthUserStateNotifierProviderCreator();

// --------------------------------------------------
//
//  firebaseAuthUserStateNotifierProvider
//
// --------------------------------------------------
final firebaseAuthUserSteramProvider = StreamProvider((ref) {
  final checkAuthStateChangesUsecase =
      ref.watch(checkAuthStateChangesUsecaseProvider);

  final Stream<FirebaseAuthUser> firebaseAuthUserStream =
      checkAuthStateChangesUsecase();

  return firebaseAuthUserStream;
});
