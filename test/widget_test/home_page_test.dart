import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stackremote/presentation/page/home_page.dart';

void main() {
  testWidgets("+ボタン押下時、1カウントアップされること", (WidgetTester tester) async {
    // given
    const widget = HomePage();
    await tester.pumpWidget(const MaterialApp(home: widget));

    expect(find.text("0"), findsOneWidget);

    // when
    await tester.tap(find.byIcon(Icons.add));
    await tester.tap(find.byKey(const ValueKey("incrementButton")));
    await tester.pump();

    // then
    expect(find.text("0"), findsNothing);
    expect(find.text("1"), findsNothing);
    expect(find.text("2"), findsOneWidget);
  });
}
