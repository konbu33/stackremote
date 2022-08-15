import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/authentication/presentation/widget/login_state.dart';
// import 'package:stackremote/authentication/common/use_auth.dart';

import '../../../user_detail_page.dart';
import '../../../user_page.dart';
import '../../domain/user.dart';
import '../../domain/userid.dart';
import '../../usecase/authentication_service.dart';
import '../../usecase/authentication_service_auth_state_changes_usecase.dart';
import '../authentication_service_firebase.dart';
import '../page/signin_page.dart';
import '../page/signup_page.dart';

final authenticationServiceProvider = StateNotifierProvider<
    AuthenticationServiceStateNotifier,
    AuthenticationService>((ref) => AuthenticationServiceStateNotifier());

class AuthenticationServiceStateNotifier
    extends StateNotifier<AuthenticationService> {
  AuthenticationServiceStateNotifier()
      : super(AuthenticationServiceFirebase(
            instance: firebase_auth.FirebaseAuth.instance));

  Stream<User> authStateChanges() {
    return state.authStateChanges();
  }
}

class AuthStateChangesStateNotifier
    extends StateNotifier<Stream<firebase_auth.User?>> {
  AuthStateChangesStateNotifier()
      : super(
          firebase_auth.FirebaseAuth.instance.authStateChanges(),
        );

  void listen() {
    state.listen((event) {
      print(" event : $event");
    });
  }
}

final authStateChangesStateNotifierProvider = StateNotifierProvider<
    AuthStateChangesStateNotifier,
    Stream<firebase_auth.User?>>((ref) => AuthStateChangesStateNotifier());

final authStateChangesStreamProvider =
    StreamProvider.autoDispose<firebase_auth.User?>((ref) {
  Stream<firebase_auth.User?> stream =
      firebase_auth.FirebaseAuth.instance.authStateChanges();

  stream.listen((fbuser) {
    final user;
    if (fbuser == null) {
      user = User.create(userId: UserId.create(value: ""), email: "");
    } else {
      user = User.create(userId: UserId.create(value: fbuser.uid), email: "");
    }

    final notifier = ref.read(userStateNotifierProvider.notifier);
    notifier.userInformationRegiser(user);
  });

  return stream;
});

final authStateChangesProvider2 =
    Provider.autoDispose((ref) => AuthenticationServiceAuthStateChangesUsecase(
          authenticationService: AuthenticationServiceFirebase(
              instance: firebase_auth.FirebaseAuth.instance),
        ).execute());

final authStateChangesProvider3 = Provider((ref) =>
    AuthenticationServiceFirebase(instance: firebase_auth.FirebaseAuth.instance)
        .authStateChanges());

final authStateChangesProvider4 = Provider((ref) {
  final notifier = ref.read(userStateNotifierProvider.notifier);

  // final stream = AuthenticationServiceAuthStateChangesUsecase(
  //         authenticationService: AuthenticationServiceFirebase(
  //             instance: firebase_auth.FirebaseAuth.instance))
  //     .execute();

  // final stream = AuthenticationServiceFirebase(
  //         instance: firebase_auth.FirebaseAuth.instance)
  //     .authStateChanges();

  // final authenticationService = ref.read(authenticationServiceProvider);
  final stream = ref.watch(authenticationServiceProvider.notifier);

  stream.authStateChanges().listen((user) {
    print(" await for user : ${user.toJson()}");
    notifier.userInformationRegiser(user);
  });

  // final stream = firebase_auth.FirebaseAuth.instance.authStateChanges();
  // stream.listen((fbuser) {
  //   print(" await for user : ${fbuser.toString()}");

  //   final user;
  //   if (fbuser == null) {
  //     user = User.create(
  //         userId: UserId.create(value: ""), email: "", isSignIn: false);
  //   } else {
  //     user = User.create(
  //         userId: UserId.create(value: fbuser.uid), email: "", isSignIn: true);
  //   }

  //   notifier.userInformationRegiser(user);
  // });
});

class RouterWidget extends HookConsumerWidget {
  const RouterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      // Routeing
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,

      // Design Theme
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light(primary: Colors.cyan),
        textTheme: GoogleFonts.mPlus1TextTheme(
          Typography.material2018().black,
        ),
      ).copyWith(
        scaffoldBackgroundColor: Colors.white.withOpacity(0.8),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none),
          fillColor: Colors.grey.withOpacity(0.3),
          filled: true,
          helperStyle: const TextStyle(color: Colors.cyan),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
          iconTheme: IconThemeData(color: Colors.black26),
        ),
      ),
    );
  }
}

// final routerProvider = Provider.autoDispose(
final routerProvider = Provider(
  (ref) {
    // final loginState = ref.read(LoginStateProvider);
    // final userStream = ref.watch(authStateChangesStreamProvider.stream);

    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const UserPage()),
        GoRoute(
            path: '/signin', builder: (context, state) => const SignInPage()),
        GoRoute(
            path: '/signup', builder: (context, state) => const SignUpPage()),
        GoRoute(path: '/user', builder: (context, state) => const UserPage()),
        GoRoute(
            path: '/userdetail',
            builder: (context, state) => const UserDetailPage()),
      ],
      redirect: (state) {
        // userStream.listen((event) {
        //   print(" +++++++++++++++++++++++++++++++++++++++++++++++ ");
        //   print("event inside : ${event}");
        //   print(" +++++++++++++++++++++++++++++++++++++++++++++++ ");
        // });

        // final isSignIn = ref.watch(userStateNotifierProvider).isSignIn;
        final userState = ref.watch(userStateNotifierProvider);
        final isSignIn = userState.isSignIn;
        ref.read(authStateChangesProvider4);

        print(
            "ridirect : ------------------------------- : userState : ${userState.toJson()} , subloc : ${state.subloc}");

        // if (!isSignIn) {
        // userStream.listen((user) {
        //   print(" userStream -------------- : ${user.toString()}");
        //   if (user == null) {
        //     isLogin.sink.add(false);
        //   }
        //   if (user != null) {
        //     isLogin.sink.add(true);
        //   }
        // });

        // if (!loginState.value) {
        if (!isSignIn) {
          if (state.subloc == '/') {
            return '/signin';
          } else if (state.subloc == '/signin') {
            return null;
          } else if (state.subloc == '/signup') {
            return null;
          } else {
            return '/signin';
          }
        } else {
          if (state.subloc == '/') {
            return null;
          } else if (state.subloc == '/signin') {
            return '/';
          } else if (state.subloc == '/signup') {
            return '/';
          } else {
            return null;
          }
        }
      },
      // refreshListenable: ValueNotifier(userState),
      // refreshListenable: GoRouterRefreshStream(
      //   // loginState.stream
      //   // firebase_auth.FirebaseAuth.instance.authStateChanges(),
      //   // ref.watch(authStateChangesStateNotifierProvider),
      //   // ref.watch(authStateChangesStreamProvider.stream),
      //   // userStream,
      // ),
    );
  },
);
