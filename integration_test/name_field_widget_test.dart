import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:integration_test/integration_test.dart';

import 'package:stackremote/common/common.dart';

void main() {
  // Integration Test 有効化
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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

    await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: Scaffold(body: widget))));

    await tester.pumpAndSettle();

    sleep(const Duration(seconds: 1));

    expect(find.text("メールアドレス"), findsOneWidget);

    const String email = "xxxxx@test.com";
    expect(find.text(email), findsNothing);

    // when
    await tester.enterText(find.byType(TextFormField), email);
    await tester.pumpAndSettle();

    sleep(const Duration(seconds: 1));

    // then
    expect(find.text(email), findsOneWidget);
  });
}
