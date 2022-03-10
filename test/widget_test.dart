// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:math';

import 'package:cstoken/model/mnemonic/mnemonic.dart';
import 'package:cstoken/public.dart';
import 'package:cstoken/utils/encode.dart';
import 'package:encrypt/encrypt.dart';
import 'package:cstoken/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trustdart/trustdart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip32/src/utils/wif.dart' as wif;
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:web3dart/crypto.dart';
import 'package:base_codecs/base_codecs.dart';

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
    // String pwd = "222222";
    // final iv = IV.fromLength(0);
    // pwd = pwd.padRight(32, "0");
    // final key = Key.fromUtf8(pwd);
    // final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
    // final decrypted = encrypter.encrypt(input, iv: iv);
    // print(decrypted.base64);

    // String enc = TREncode.encrypt(input, pwd);
    // print(enc);
    // String dec = TREncode.decrypt(enc, pwd);
    // print(dec);
    String dondo =
        "imitate embody law mammal exotic transfer roof hope price swift ordinary uncle";
    var seed = bip39.mnemonicToSeed(dondo);
    var root = bip32.BIP32.fromSeed(seed);
    var child = root.derivePath("m/44'/0'/0'/0/0");
    String prv = child.toWIF();
    print(prv);

    // child = root.derivePath("m/44'/195'/0'/0/0");
    // print(TREncode.kBytesToHex(child.privateKey!));

    // child = root.derivePath("m/44'/501'/0'/0/0");
    // print(TREncode.kBytesToHex(child.privateKey!));
    prv = "Kxd5FfWEZNixbs8yg8U86DShrcYzK6f7u5zV8sYRKpWT6e4axyvC";
    final bigWif = wif.decode(prv);
    String wifprv = TREncode.kBytesToHex(bigWif.privateKey);
    print(wifprv);

    String value = "TP6BrDAV6Zz5U7MytoBJHimd7dBSP4RQ8Q";
    value = TREncode.base58HexString(value);

    print(value.padLeft(64,"0"));
    // ascii.encode(string);
  });
}
