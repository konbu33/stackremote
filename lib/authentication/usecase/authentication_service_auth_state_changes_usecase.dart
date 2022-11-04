import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/common.dart';
import '../authentication.dart';
import '../infrastructure/authentication_service.dart';

final authenticationServiceAuthStateChangesUsecaseProvider = Provider((ref) {
  final AuthenticationService authenticationService =
      ref.read(authenticationServiceFirebaseProvider);

  final firebaseAuthUser = ref.watch(firebaseAuthUserStateNotifierProvider);
  final notifier = ref.read(firebaseAuthUserStateNotifierProvider.notifier);

//   return AuthenticationServiceAuthStateChangesUsecase(
//       authenticationService: authenticationService);
// });

// class AuthenticationServiceAuthStateChangesUsecase {
//   AuthenticationServiceAuthStateChangesUsecase({
//     required this.authenticationService,
//   });

  // final AuthenticationService authenticationService;

  void execute() {
    final stream = authenticationService.authStateChanges();

    logger.d("authenticationServiceAuthStateChangesUsecaseProvider");

    stream.listen(
      (fbuser) {
        final FirebaseAuthUser user;
        if (fbuser == null) {
          user = FirebaseAuthUser.reconstruct(
            isSignIn: false,
          );
        } else {
          final firebaseAuthUid = fbuser.uid;

          user = FirebaseAuthUser.reconstruct(
            email: fbuser.email ?? "",
            emailVerified: fbuser.emailVerified,
            firebaseAuthUid: firebaseAuthUid,
            isSignIn: true,
          );
        }

        if (user.isSignIn != firebaseAuthUser.isSignIn) {
          notifier.userInformationRegiser(user);
        }
      },
    );
  }

  return execute;
});
