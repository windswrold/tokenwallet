// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cstoken/model/client/sign_client.dart';
import 'package:cstoken/model/mnemonic/mnemonic.dart';
import 'package:cstoken/public.dart';
import 'package:cstoken/utils/date_util.dart';
import 'package:cstoken/utils/encode.dart';
import 'package:encrypt/encrypt.dart';
import 'package:cstoken/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trustdart/trustdart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip32/src/utils/wif.dart' as wif;
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';
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
    int ms = DateUtil.getNowDateMs();
    print(ms);
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
    // print(prv);

    // child = root.derivePath("m/44'/195'/0'/0/0");
    // print(TREncode.kBytesToHex(child.privateKey!));

    // child = root.derivePath("m/44'/501'/0'/0/0");
    // print(TREncode.kBytesToHex(child.privateKey!));
    prv = "Kxd5FfWEZNixbs8yg8U86DShrcYzK6f7u5zV8sYRKpWT6e4axyvC";
    final bigWif = wif.decode(prv);
    String wifprv = TREncode.kBytesToHex(bigWif.privateKey);
    // print(wifprv);

    String value = "TP6BrDAV6Zz5U7MytoBJHimd7dBSP4RQ8Q";
    value = TREncode.base58HexString(value);
    print(value);
    value = base58CheckEncode(
        hexToBytes("418feb95b65129f0101b6b5d1b6cd01d3ff72fb9d7"));
    print(value);

    String content_hash =
        '39bdc34790465b6203363d9d98d925fc46fabb9f4c09ade4cac32c97da234423';
    // String cid = bytesToHex(base58CheckDecode("1220" + content_hash));
    String cid = base58BitcoinEncode(hexToBytes("1220" + content_hash));
    print("cid " + cid);

    // final contractAddress =
    //     EthereumAddress.fromHex("0x88b48f654c30e99bc2e4a1559b4dcf1ad93fa656");
    // final contract = DeployedContract(_erc1155Abi, contractAddress);
    // final function = contract.function('balanceOf');
    // final abi = bytesToHex(function.encodeCall([
    //   contractAddress,
    //   BigInt.parse(
    //       "50122364812794259909901293353502058643127092878053915726483470122051514138625")
    // ]));
    // print(abi);

    // final contract2 = DeployedContract(_erc721Abi, contractAddress);
    // final function2 = contract2.function('balanceOf');
    // final abi2 = bytesToHex(function2.encodeCall([contractAddress]));
    // print(abi2);

    String string = SignTransactionClient.get721TokenURI(
        "0x064e16771A4864561f767e4Ef4a6989fc4045aE7", "78932");
    print("string");
    print(string);

    // ascii.encode(string);
  });
}

final ContractAbi _erc721Abi = ContractAbi('ERC721', [
  const ContractFunction('safeTransferFrom', [
    FunctionParameter('from', AddressType()),
    FunctionParameter('to', AddressType()),
    FunctionParameter('id', UintType(length: 256)),
    FunctionParameter('data', DynamicBytes()),
  ]),
  const ContractFunction(
      'balanceOf', [FunctionParameter('from', AddressType())]),
], []);

final ContractAbi _erc1155Abi = ContractAbi('ERC721', [
  const ContractFunction('safeTransferFrom', [
    FunctionParameter('_from', AddressType()),
    FunctionParameter('_to', AddressType()),
    FunctionParameter('_id', UintType(length: 256)),
    FunctionParameter('_value', UintType(length: 256)),
    FunctionParameter('_data', DynamicBytes()),
  ]),
  const ContractFunction('balanceOf', [
    FunctionParameter('from', AddressType()),
    FunctionParameter('_id', UintType(length: 256)),
  ]),
], []);
