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

        final minMax = MinMax<int>.create(min: 8, max: 20);
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
