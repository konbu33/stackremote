import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:stackremote/common/common.dart';

void main() {
  testWidgets("メールアドレス入力可能なこと", (WidgetTester tester) async {
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

    await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: Scaffold(body: widget))));

    expect(find.text("メールアドレス"), findsOneWidget);

    const String email = "xxx@test.com";
    expect(find.text(email), findsNothing);

    // when
    await tester.enterText(find.byType(TextFormField), email);
    await tester.pump();

    // then
    expect(find.text(email), findsOneWidget);
  });
}


// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:stackremote/home_page.dart';

// void main() {
//   testWidgets("+ボタン押下時、1カウントアップされること", (WidgetTester tester) async {
//     // given
//     const widget = HomePage();
//     await tester.pumpWidget(const MaterialApp(home: widget));

//     expect(find.text("0"), findsOneWidget);

//     // when
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.tap(find.byKey(const ValueKey("incrementButton")));
//     await tester.pump();

//     // then
//     expect(find.text("0"), findsNothing);
//     expect(find.text("1"), findsNothing);
//     expect(find.text("2"), findsOneWidget);
//   });
// }
