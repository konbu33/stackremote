import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stackremote/menu/presentation/widget/alert_dialog_widget.dart';

void main() {
  group('', () {
    //
    testWidgets('', (tester) async {
      const Key widgetKey = Key('alert');
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(body: AlertDialogWidget(key: widgetKey))));

      // final AlertDialogWidgetState alertDialogWidgetState =
      //     tester.state(find.byType(AlertDialogWidget));

      // final StatefulElement statefulElement =
      //     tester.element(find.byKey(widgetKey));

      // final AlertDialogWidgetState statefulElementState =
      //     statefulElement.state as AlertDialogWidgetState;

      // final AlertDialogWidgetState statefulElementState =
      //     tester.state(find.byKey(widgetKey)) as AlertDialogWidgetState;

      final AlertDialogWidgetState statefulElementState =
          tester.state(find.byType(AlertDialogWidget));

      expect(statefulElementState.message, equals(""));
      statefulElementState.setMessage("changeMessage");
      // expect(statefulElementState.message, equals(""));
      expect(statefulElementState.message, isNot(equals("")));
      expect(statefulElementState.message, equals("changeMessage"));
    });
  });
}
