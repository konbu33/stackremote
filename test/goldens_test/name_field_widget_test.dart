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

          final minMax = MinMax<int>.create(min: 8, max: 20);
          final minMaxLenghtValidator =
              ref.watch(minMaxLenghtValidatorProvider(minMax));

          final nameFieldStateNotifierProvider =
              nameFieldStateNotifierProviderCreator(
            name: name,
            icon: const Icon(Icons.email_sharp),
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
