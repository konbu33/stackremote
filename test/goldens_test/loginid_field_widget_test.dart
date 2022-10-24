import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:stackremote/authentication/presentation/widget/loginid_field_state.dart';
import 'package:stackremote/authentication/presentation/widget/loginid_field_widget.dart';

void main() {
  String title = "LoginId_field_widget";
  group("$title group", () {
    testGoldens("$title test", (WidgetTester tester) async {
      // given
      const size = Size(414, 896);

      // フォント読み込み
      await loadAppFonts();

      // given
      final LoginIdFieldStateProvider loginIdFieldStateProvider =
          loginIdFieldStateNotifierProviderCreator();

      final widget = LoginIdFieldWidget(
        loginIdFieldStateProvider: loginIdFieldStateProvider,
      );

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

