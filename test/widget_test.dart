import 'package:fire_fighter/views/screens/launch/safety/battery_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('battery warning must be accepted before continuing', (
    WidgetTester tester,
  ) async {
    var accepted = false;

    await tester.pumpWidget(
      MaterialApp(home: BatterySafetyScreen(onAccepted: () => accepted = true)),
    );

    expect(find.text('CAUTION: Vehicle Battery Safety'), findsOneWidget);
    expect(find.textContaining('electrical shock'), findsOneWidget);
    expect(accepted, isFalse);

    final okButton = find.byKey(const Key('battery-safety-ok-button'));
    await tester.ensureVisible(okButton);
    await tester.tap(okButton);
    await tester.pump();

    expect(accepted, isTrue);
  });
}
