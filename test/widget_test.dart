// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cstoken/const/constant.dart';
import 'package:cstoken/model/chain/bsc.dart';
import 'package:cstoken/model/hd_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cstoken/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(App());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  test("hdwallet", () async {
    String memo =
        "rich blouse coyote spirit sting rack forward tooth jar glove fossil clever";

    // final prv = TREncode.decrypt(bscwallet!.prv!, "123456");
    // final eth = TREncode.decrypt(ethwallet!.prv!, "123456");

    // print(prv);
    // print(eth);
  });
}
