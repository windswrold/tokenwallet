import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/digests/ripemd160.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/digests/sha512.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:web3dart/crypto.dart';
import 'package:crypto/crypto.dart';

class TREncode {
  static String kBytesToHex(List<int> bytes, {bool include0x = false}) {
    return bytesToHex(bytes, include0x: include0x);
  }

  static Uint8List kValueToBytes(String value) {
    return Uint8List.fromList(utf8.encode(value));
  }

  static Uint8List kHexToBytes(String hexStr) {
    return hexToBytes(hexStr);
  }

  static String encrypt(String input, String pwd) {
    pwd = pwd.padRight(32, "0");
    final key = Key.fromUtf8(pwd);
    final iv = IV.fromLength(0);
    final encrypter = Encrypter(AES(key));
    final encrypt = encrypter.encrypt(input, iv: iv);
    return encrypt.base64;
  }

  static String decrypt(String input, String pwd) {
    pwd = pwd.padRight(32, "0");
    final key = Key.fromUtf8(pwd);
    final iv = IV.fromLength(0);
    final encrypter = Encrypter(AES(key));
    final decrypted = encrypter.decrypt64(input, iv: iv);
    return decrypted;
  }

  static String SHA256(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  static Uint8List? convertbits(Uint8List data, int frombits, int tobits,
      [pad = true]) {
    /// General power-of-2 base conversion.

    var acc = 0;
    var bits = 0;
    var result = <int>[];
    var maxv = (1 << tobits) - 1;
    var max_acc = (1 << (frombits + tobits - 1)) - 1;
    for (var value in data) {
      if (value < 0 || (value >> frombits) >= 1) {
        return null;
      }
      acc = ((acc << frombits) | value) & max_acc;
      bits += frombits;
      while (bits >= tobits) {
        bits -= tobits;
        result.add((acc >> bits) & maxv);
      }
    }
    if (pad) {
      if (bits != 0) {
        result.add((acc << (tobits - bits)) & maxv);
      }
    } else if (bits >= frombits || ((acc << (tobits - bits)) & maxv) >= 1) {
      return null;
    }
    return Uint8List.fromList(result);
  }

  static String CHARSET = 'qpzry9x8gf2tvdw0s3jn54khce6mua7l';

  static int bech32_polymod(List values) {
    ///Internal function that computes the Bech32 checksum.

    final generator = [
      0x3b6a57b2,
      0x26508e6d,
      0x1ea119fa,
      0x3d4233dd,
      0x2a1462b3
    ];

    var chk = 1;
    int top;
    for (int value in values) {
      top = chk >> 25;
      chk = (chk & 0x1ffffff) << 5 ^ value;
      for (var i in [0, 1, 2, 3, 4]) {
        chk ^= ((top >> i) & 1) >= 1 ? generator[i] : 0;
      }
    }
    return chk;
  }

  static Uint8List bech32_hrp_expand(String hrp) {
    /// Expand the HRP into values for checksum computation.

    var result = <int>[];
    result += List<int>.generate(hrp.length, (i) => hrp.codeUnitAt(i) >> 5);
    result += [0];
    result += List<int>.generate(hrp.length, (i) => hrp.codeUnitAt(i) & 31);

    return Uint8List.fromList(result);
  }

  static Uint8List bech32_create_checksum(String hrp, Uint8List data) {
    ///Compute the checksum values given HRP and data.

    var values = bech32_hrp_expand(hrp) + data;

    var polymod = bech32_polymod(values + [0, 0, 0, 0, 0, 0]) ^ 1;

    var result = List<int>.generate(6, (i) => (polymod >> 5 * (5 - i)) & 31);

    return Uint8List.fromList(result);
  }

  bool bech32_verify_checksum(hrp, data) {
    //Verify a checksum given HRP and converted data characters.

    return bech32_polymod(bech32_hrp_expand(hrp) + data) == 1;
  }

  static String bech32_encode(String hrp, Uint8List data) {
    /// Compute a Bech32 string given HRP and data values.

    var combined = data + bech32_create_checksum(hrp, data);

    return hrp +
        '1' +
        List<String>.generate(combined.length, (i) => CHARSET[combined[i]])
            .join('');
  }

  List bech32_decode(String bech) {
    /// Validate a Bech32 string, and determine HRP and data.

    //validation
    if ((<bool>[for (var x in bech.codeUnits) (x < 33 && x > 126)].firstWhere(
              (element) => element,
              orElse: () => false,
            ) !=
            null) ||
        ((bech.toLowerCase() != bech && bech.toUpperCase() != bech))) {
      return [null, null];
    }
    bech = bech.toLowerCase();
    var pos = bech.lastIndexOf('1');
    if (pos < 1 || pos + 7 > bech.length || bech.length > 90) {
      return [null, null];
    }
    if (<bool>[
          for (var x in List<int>.generate(
              bech.substring(pos + 1).length, (index) => index + pos + 1))
            CHARSET.contains(bech[x])
        ].firstWhere((element) => element == false, orElse: () => false) !=
        null) {
      return [null, null];
    }

    var hrp = bech.substring(0, pos);
    var data = List<int>.generate(bech.substring(pos + 1).length,
        (index) => CHARSET.indexOf(bech[index + pos + 1]));

    if (!bech32_verify_checksum(hrp, data)) {
      return [null, null];
    }

    return [hrp, data.sublist(0, data.length - 6)];
  }

  Uint8List? decode_address(String address) {
    var components = bech32_decode(address);
    if (components[0] == null) {
      return null;
    }

    var bits = convertbits(Uint8List.fromList(components[1]), 5, 8, false);
    return bits;
  }

  String encode(String hrp, Uint8List witprog) {
    /// Encode a segwit address.

    return bech32_encode(hrp, convertbits(witprog, 8, 5)!);
  }

  final ONE1 = Uint8List.fromList([1]);
  final ZERO1 = Uint8List.fromList([0]);

  Uint8List hash160(Uint8List buffer) {
    var _tmp = SHA256Digest().process(buffer);
    return RIPEMD160Digest().process(_tmp);
  }

  Uint8List hmacSHA512(Uint8List key, Uint8List data) {
    final _tmp = HMac(SHA512Digest(), 128)..init(KeyParameter(key));
    return _tmp.process(data);
  }
}
