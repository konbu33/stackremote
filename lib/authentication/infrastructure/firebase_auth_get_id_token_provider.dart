// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../domain/firebase_auth_user.dart';
// import '../usecase/authentication_service_get_id_token_usecase.dart';

// import 'authentication_service_firebase.dart';

// final firebaseAuthGetIdTokenProvider = Provider((ref) {
//   final notifier = ref.read(firebaseAuthUserStateNotifierProvider.notifier);

//   final AuthenticationServiceGetIdTokenUsecase
//       authenticationServiceGetIdTokenUsecase =
//       AuthenticationServiceGetIdTokenUsecase(
//     authenticationService: AuthenticationServiceFirebase(
//         instance: firebase_auth.FirebaseAuth.instance),
//   );

//   authenticationServiceGetIdTokenUsecase.execute().then((value) {
//     notifier.updateFirebaseAuthIdToken(value);
//   });
// });
