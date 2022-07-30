import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stackremote/home_page.dart';

void main() {
  // Integration Test 有効化
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("＋ボタン押下時、1カウントアップされること", (tester) async {
    // given
    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    await tester.pumpAndSettle();

    sleep(const Duration(seconds: 1));

    expect(find.text("0"), findsOneWidget);

    // when
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    sleep(const Duration(seconds: 1));

    await tester.tap(find.byKey(const ValueKey("incrementButton")));
    await tester.pumpAndSettle();

    sleep(const Duration(seconds: 1));

    // then
    expect(find.text("0"), findsNothing);
    expect(find.text("1"), findsNothing);
    expect(find.text("2"), findsOneWidget);

    sleep(const Duration(seconds: 1));
  });
}
