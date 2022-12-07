import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:stackremote/common/common.dart';

void main() {
  String title = "LoginId_field_widget";
  group("$title group", () {
    testGoldens("$title test", (WidgetTester tester) async {
      // given
      const size = Size(414, 896);

      // フォント読み込み
      await loadAppFonts();

      // given

      final container = ProviderContainer();

      final loginIdFieldStateNotifierProviderOfProvider =
          StateProvider.autoDispose((ref) {
        NameFieldStateNotifierProvider
            loginIdFieldStateNotifierProviderCreator() {
          const name = "メールアドレス";

          const minMax = MinMax(min: 8, max: 20);
          final minMaxLenghtValidator =
              ref.watch(minMaxLenghtValidatorProvider(minMax));

          final nameFieldStateNotifierProvider =
              nameFieldStateNotifierProviderCreator(
            name: name,
            validator: minMaxLenghtValidator,
            minLength: minMax.min,
            maxLength: minMax.max,
          );

          return nameFieldStateNotifierProvider;
        }

        return loginIdFieldStateNotifierProviderCreator();
      });

      final NameFieldStateNotifierProvider loginIdFieldStateNotifierProvider =
          container.read(loginIdFieldStateNotifierProviderOfProvider);

      final widget = NameFieldWidget(
        nameFieldStateNotifierProvider: loginIdFieldStateNotifierProvider,
      );

      // final LoginIdFieldStateProvider loginIdFieldStateProvider =
      //     loginIdFieldStateNotifierProviderCreator();

      // final widget = LoginIdFieldWidget(
      //   loginIdFieldStateProvider: loginIdFieldStateProvider,
      // );

      await tester.pumpWidgetBuilder(
          ProviderScope(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(body: widget),
            ),
          ),
          surfaceSize: size);

      String idString = "";
      String outFileName = "";

      const String email = "xxx@test.com";

      // when initial
      idString = "initial";
      outFileName = "${title}_$idString";
      await screenMatchesGolden(tester, outFileName);

      // when increment
      await tester.enterText(find.byType(TextFormField), email);
      await tester.pump();

      idString = "enter_text";
      outFileName = "${title}_$idString";
      await screenMatchesGolden(tester, outFileName);
    });
  });
}

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:golden_toolkit/golden_toolkit.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import 'package:stackremote/home_page.dart';

// void main() {
//   String title = "home_page";
//   group("$title group", () {
//     testGoldens("$title test", (WidgetTester tester) async {
//       // given
//       const size = Size(414, 896);

//       // フォント読み込み
//       await loadAppFonts();

//       await tester.pumpWidgetBuilder(const ProviderScope(child: HomePage()),
//           surfaceSize: size);

//       String idString = "";
//       String outFileName = "";

//       // when initial
//       idString = "initial";
//       outFileName = "${title}_$idString";
//       await screenMatchesGolden(tester, outFileName);

//       // when increment
//       await tester.tap(find.byIcon(Icons.add));
//       await tester.pump();

//       idString = "increment";
//       outFileName = "${title}_$idString";
//       await screenMatchesGolden(tester, outFileName);
//     });
//   });
// }

