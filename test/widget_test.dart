// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';

import 'package:cstoken/utils/encode.dart';
import 'package:encrypt/encrypt.dart';
import 'package:cstoken/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // await tester.pumpWidget(App());

    // // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  test("hdwallet", () async {
    // String input = "0xB74693f2DAbdb84570755E536e016d3CBDEB0810";
    // String pwd = "BpLnfgDsc2WD8F2qNfHK5a84jjJkwzDk";
    // final iv = IV.fromLength(0);
    // pwd = pwd.padRight(32, "0");
    // final key = Key.fromUtf8(pwd);
    // final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
    // final decrypted = encrypter.encrypt(input, iv: iv);
    // print(decrypted.base64);

    for (var i = 0; i < 10; i++) {
      int random = Random().nextInt(9999);
      print(random);
    }
  });
}
