import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/providers.dart';

class RouterWidget extends HookConsumerWidget {
  const RouterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(Providers.routerProvider);
    // final themeData = ref.watch(themeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      // theme: themeData,
      // theme: ref.watch(themeProvider),
      // darkTheme: ThemeData.dark(),
      // darkTheme: themeData,
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light(primary: Colors.cyan),
        // textTheme: Typography.material2018().black,
        // textTheme: GoogleFonts.notoSansJavaneseTextTheme(
        textTheme: GoogleFonts.mPlus1TextTheme(
          Typography.material2018().black,
        ),
        // notoSansJavanese,
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

// theme: ThemeData(
//         primarySwatch: Colors.cyan,
//         primaryTextTheme: const TextTheme(
//           titleLarge: TextStyle(
//             color: Colors.green,
//           ),
//         ),
//         // backgroundColor: Colors.transparent,
//         // scaffoldBackgroundColor: Colors.transparent,
//         scaffoldBackgroundColor: Colors.white.withOpacity(0.8),
//         inputDecorationTheme: InputDecorationTheme(
//           // 入力フィールドの装飾
//           // decoration: InputDecoration(
//           // フィールド名
//           // label: Text(state.loginFieldName),

//           // 入力フィールドの色・枠
//           // prefixIcon: state.loginIdIcon.value,
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(30),
//               borderSide: BorderSide.none),
//           // fillColor: Colors.grey[100],
//           // fillColor: Colors.transparent,
//           fillColor: Colors.grey.withOpacity(0.3),
//           filled: true,

//           // ヘルパー・エラーメッセージ表示
//           // counterText: "",
//           // helperText: state.validateSuccess ? "Check : OK" : "",
//           helperStyle: const TextStyle(color: Colors.cyan),
//         ),
//         // ),

//         appBarTheme: const AppBarTheme(
//           elevation: 0,
//           // backgroundColor: Color.fromARGB(0, 0, 0, 0),
//           backgroundColor: Colors.transparent,
//           // foregroundColor: Colors.black87,
//           // titleTextStyle: TextStyle(
//           //   color: Colors.black87,
//           // ),
//           iconTheme: IconThemeData(color: Colors.black26),
//           // actionsIconTheme: IconThemeData(color: Colors.green),
//           // color: Colors.amber,
//           // backgroundColor: Colors.amber.withOpacity(0.5),
//           // foregroundColor: Colors.amber,
//         ),
//       ),
    );
  }
}

// final themeProvider = Provider((ref) {
//   ThemeData themeData = ThemeData(
//     primarySwatch: Colors.green,
//     primaryTextTheme: const TextTheme(
//       titleLarge: TextStyle(
//         color: Colors.green,
//       ),
//     ),
//     appBarTheme: const AppBarTheme(
//       elevation: 0,
//       titleTextStyle: TextStyle(
//         color: Colors.black26,
//       ),
//       // color: Colors.amber,
//       // backgroundColor: Colors.amber.withOpacity(0.5),
//       // foregroundColor: Colors.amber,
//     ),
//   );

//   return themeData;
// });
