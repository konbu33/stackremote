import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stackremote/presentation/authentication_service_firebase.dart';
import 'package:stackremote/presentation/page/agora_video_page.dart';
import 'package:stackremote/usecase/authentication_service_get_id_token_usecase.dart';
import 'package:stackremote/usecase/rtc_channel_state.dart';

import '../../domain/firebase_auth_user.dart';
// import '../../domain/user.dart';
import '../page/agora_video_channel_join_page.dart';
import '../page/signin_page.dart';
import '../page/signup_page.dart';
import '../page/user_detail_page.dart';
import '../page/user_page.dart';

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

final routerProvider = Provider(
  (ref) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
            path: '/',
            builder: (context, state) => const AgoraVideoChannelJoinPage()),
        GoRoute(
            path: '/signin', builder: (context, state) => const SignInPage()),
        GoRoute(
            path: '/signup', builder: (context, state) => const SignUpPage()),
        GoRoute(path: '/user', builder: (context, state) => const UserPage()),
        GoRoute(
            path: '/userdetail',
            builder: (context, state) => const UserDetailPage()),
        GoRoute(
            path: '/agoravideochanneljoin',
            builder: (context, state) => const AgoraVideoChannelJoinPage()),
        GoRoute(
            path: '/agoravideo',
            builder: (context, state) => const AgoraVideoPage()),
      ],
      redirect: (state) {
        // Firebase Authentication側のログイン状態をwatch。
        // Firebase Authentication側のログイン状態が変化したら、本アプリ側のログイン状態に反映される。
        ref.read(authStateChangesProvider);
        ref.read(firebaseAuthGetIdTokenProvider);

        // 本アプリ側のログイン状態をwatch。
        // 本アプリ側のログイン状態が変化したら、ルーティングに反映される。
        // final userState = ref.watch(userStateNotifierProvider);
        final userState = ref.watch(firebaseAuthUserStateNotifierProvider);
        final isSignIn = userState.isSignIn;

        // rtc channel join済・未joinの状態監視
        final RtcChannelState rtcChannelState = ref.watch(
            RtcChannelStateNotifierProviderList
                .rtcChannelStateNotifierProvider);

        // サインイン済みの場合のリダイレクト動作
        // rtc channel join済・未joinの状態を監視し、
        // 状態が変化した場合、リダイレクト操作が実施される。
        if (isSignIn) {
          if (rtcChannelState.joined) {
            if (state.subloc == '/agoravideo') {
              return null;
            } else {
              return '/agoravideo';
            }
          } else {
            if (state.subloc == '/agoravideochanneljoin') {
              return null;
            } else {
              return '/agoravideochanneljoin';
            }
          }
        }

        // 未サインインの場合のリダイレクト動作
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
    );
  },
);

final authStateChangesProvider = Provider((ref) {
  // final notifier = ref.read(userStateNotifierProvider.notifier);
  final notifier = ref.read(firebaseAuthUserStateNotifierProvider.notifier);

  final stream = firebase_auth.FirebaseAuth.instance.authStateChanges();
  // final stream = firebase_auth.FirebaseAuth.instance.userChanges();
  stream.listen(
    (fbuser) {
      final user;
      if (fbuser == null) {
        user = FirebaseAuthUser.create(
          // userId: UserId.create(value: ""),
          email: "",
          emailVerified: false,
          password: "",
          firebaseAuthUid: "",
          firebaseAuthIdToken: "",
          isSignIn: false,
        );
      } else {
        final firebaseAuthUid = fbuser.uid;

        user = FirebaseAuthUser.create(
          // userId: UserId.create(value: fbuser.uid),
          email: fbuser.email ?? "",
          emailVerified: fbuser.emailVerified,
          password: "",
          firebaseAuthUid: firebaseAuthUid,
          firebaseAuthIdToken: "",
          isSignIn: true,
        );
      }

      notifier.userInformationRegiser(user);
      print("userInformationRegiser fbUser: --------------: $fbuser");
      print("userInformationRegiser user: --------------: $user");
    },
  );
});

final firebaseAuthGetIdTokenProvider = Provider((ref) {
  // final notifier = ref.watch(userStateNotifierProvider.notifier);
  final notifier = ref.watch(firebaseAuthUserStateNotifierProvider.notifier);

  final AuthenticationServiceGetIdTokenUsecase
      authenticationServiceGetIdTokenUsecase =
      AuthenticationServiceGetIdTokenUsecase(
    authenticationService: AuthenticationServiceFirebase(
        instance: firebase_auth.FirebaseAuth.instance),
  );

  authenticationServiceGetIdTokenUsecase.execute().then((value) {
    print("value ------------ : $value");
    notifier.updateFirebaseAuthIdToken(value);
  });
});
