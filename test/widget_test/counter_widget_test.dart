import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stackremote/counter_widget.dart';

void main() {
  testWidgets('', (tester) async {
    const key = Key("a");

    await tester.pumpWidget(const CounterWidget(key: key));

    // final State<CounterWidget> a = tester.state(find.byType(CounterWidget));
    final StatefulElement statefulElement = tester.state(find.byKey(key));

    // final State<CounterWidget> statefulElementState =
    //     statefulElement.state as State<CounterWidget>;

    //
  });
  testWidgets('resync stateful widget', (WidgetTester tester) async {
    const Key innerKey = Key('inner');

    const inner1 =
        MaterialApp(home: Scaffold(body: CounterWidget(key: innerKey)));

    await tester.pumpWidget(inner1);

    final StatefulElement innerElement = tester.element(find.byKey(innerKey));
    final CounterWidgetState innerElementState =
        innerElement.state as CounterWidgetState;

    // expect(innerElementState.widget, equals(inner1));
    expect(innerElementState.counter, 0);
    innerElementState.setCounter(5);
    innerElementState.setCounter(5);
    expect(innerElementState.counter, equals(10));
  });
}
