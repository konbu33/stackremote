import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../user_detail_page.dart';
import '../../../user_page.dart';
import '../../common/use_auth.dart';
import '../page/signin_page.dart';
import '../page/signup_page.dart';

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
        final loggedIn = ref.watch(authenticationServiceProvider).loggedIn;
        // print(
        //     "call go_router ridirect : ------------------------------- : loggedIn : ${loggedIn} , subloc : ${state.subloc}");

        if (!loggedIn) {
          if (state.subloc == '/signin') {
            return null;
          } else if (state.subloc == '/signup') {
            return null;
          } else {
            return '/signin';
          }
        } else {
          if (state.subloc == '/signin') {
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
