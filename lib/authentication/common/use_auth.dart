import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/user.dart';
import '../domain/userid.dart';
import '../presentation/authentication_service_firebase.dart';
import '../usecase/authentication_service_auth_state_changes_usecase.dart';

// final authStatusChangesProvider = StreamProvider<User>(
//   (ref) => AuthenticationServiceAuthStatusChangesUsecase(
//           authenticationService: AuthenticationServiceFirebase(
//               instance: firebase_auth.FirebaseAuth.instance))
//       .execute(),
// );

// final authStatusChangesProvider = StreamProvider.autoDispose<User>(
//     (ref) => AuthenticationServiceAuthStatusChangesUsecase(
//           authenticationService: AuthenticationServiceFirebase(
//               instance: firebase_auth.FirebaseAuth.instance),
//         ).execute());

final authStatusChangesProvider =
    Provider.autoDispose((ref) => AuthenticationServiceAuthStateChangesUsecase(
          authenticationService: AuthenticationServiceFirebase(
              instance: firebase_auth.FirebaseAuth.instance),
        ).execute());

// final useAuthProvider = Provider.autoDispose((ref) {
//   void useAuth() {
//     final userState = ref.watch(userStateNotifierProvider);
//     final notifier = ref.read(userStateNotifierProvider.notifier);
//     final authStatusChanges = ref.watch(authStatusChangesProvider);

//     useEffect(() {
//       authStatusChanges.when(
//         data: (user) {
//           print(
//               " useAuth : --------------------- ${user.isSignIn}, ${userState.isSignIn}");
//           if (user.isSignIn != userState.isSignIn) {
//             notifier.userInformationRegiser(user);
//           }
//         },
//         error: (error, stacktrace) {},
//         loading: () {},
//       );
//     }, []);
//   }

//   return useAuth;
// });

final useAuthProvider = Provider.autoDispose((ref) {
  void useAuth() {
    useEffect(() {
      final userState = ref.watch(userStateNotifierProvider);
      final notifier = ref.read(userStateNotifierProvider.notifier);

      // final authStatusChanges = AuthenticationServiceAuthStatusChangesUsecase(
      //         authenticationService:
      //             AuthenticationServiceFirebase(instance: FirebaseAuth.instance))
      //     .execute;

      final authStatesChanges = AuthenticationServiceAuthStateChangesUsecase(
              authenticationService: AuthenticationServiceFirebase(
                  instance: firebase_auth.FirebaseAuth.instance))
          .execute();

      authStatesChanges.listen((user) {
        // print(" useAuth execute 0 -----------------------------------------");
        print(" ---------------------------------------------------------------------\n" +
            " useAuth : --------------------- ${user.isSignIn}, ${userState.isSignIn}" +
            "\n --------------- ------------------------------------------------------");
        if (!user.isSignIn && userState.isSignIn) {
          print(
              " useAuth execute 0-1 -----------------------------------------");
          notifier.userInformationRegiser(user);
        } else if (user.isSignIn && !userState.isSignIn) {
          print(
              " useAuth execute 0-2 -----------------------------------------");
          notifier.userInformationRegiser(user);
        } else {
          print("use Auth : ---------------------------------- else pattern");
          print(
              " useAuth : --------------------- ${user.isSignIn}, ${userState.isSignIn}");
        }
      });

      // AuthenticationServiceFirebase(
      //         instance: firebase_auth.FirebaseAuth.instance)
      //     .authStatusChanges()
      //     .listen((user) {
      //   //

      //   print(" useAuth execute 0 -----------------------------------------");
      //   print(" ---------------------------------------------------------------------\n" +
      //       " useAuth : --------------------- ${user.toString()}, ${userState.isSignIn}" +
      //       "\n --------------- ------------------------------------------------------");
      //   // if (user.isSignIn != userState.isSignIn) {
      //   notifier.userInformationRegiser(user);
      //   // }
      // });

      // firebase_auth.FirebaseAuth.instance.authStateChanges().listen((user) {
      //   //
      //   print(" useAuth execute 0 -----------------------------------------");
      //   print(" ---------------------------------------------------------------------\n" +
      //       " useAuth : --------------------- ${user.toString()}, ${userState.isSignIn}" +
      //       "\n --------------- ------------------------------------------------------");

      //   if (user != null) {
      //     final user1 = User.create(
      //         userId: UserId.create(value: user.uid),
      //         email: user.email!,
      //         isSignIn: true);
      //     notifier.userInformationRegiser(user1);
      //   } else {
      //     final user1 = User.create(
      //         userId: UserId.create(value: "isNull"),
      //         email: "isNull",
      //         isSignIn: false);
      //     notifier.userInformationRegiser(user1);
      //   }
      // });

      // final authStatusChanges = ref.watch(authStatusChangesProvider);

      // print(" useAuth execute 2 -----------------------------------------");

      // // try {
      // authStatusChanges.when(
      //   data: (user) {
      //     print(
      //         " useAuth execute 1-1 -----------------------------------------");
      //     print(" ---------------------------------------------------------------------\n" +
      //         " useAuth : --------------------- ${user.isSignIn}, ${userState.isSignIn}" +
      //         "\n --------------- ------------------------------------------------------");
      //     if (user.isSignIn != userState.isSignIn) {
      //       notifier.userInformationRegiser(user);
      //     }
      //   },
      //   error: (error, stacktrace) {
      //     print(
      //         " useAuth execute 1-2 -----------------------------------------");
      //   },
      //   loading: () {
      //     print(
      //         " useAuth execute 1-3 -----------------------------------------");
      //   },
      // );

      // authStatusChanges().listen((user) {
      //   // print(" useAuth execute 2 -----------------------------------------");
      //   // print(" useAuth : --------------------- ${user.toJson()}}");
      //   print(
      //       " useAuth : --------------------- ${user.isSignIn}, ${userState.isSignIn}");
      //   if (user.isSignIn != userState.isSignIn) {
      //     notifier.userInformationRegiser(user);
      //   }
      // });

      // print(" useAuth execute 3 -----------------------------------------");
      // } on FirebaseAuthException catch (e) {
      //   print(" useAuth Exception : ------------------------- ${e}");
      // }
    }, []);
  }

  return useAuth;
});
