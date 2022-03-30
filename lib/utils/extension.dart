import 'dart:math';

import 'package:cstoken/model/mnemonic/mnemonic.dart';
import 'package:cstoken/utils/custom_toast.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/credentials.dart';

import '../public.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/src/public.dart' as ez;
import 'package:bip32/src/utils/wif.dart' as wif;
import 'package:trustdart/trustdart.dart';

extension StringUtil on String {
  KCoinType? chainTypeGetCoinType() {
    if (toLowerCase().contains("bsc")) {
      return KCoinType.BSC;
    }
    if (toLowerCase().contains("eth")) {
      return KCoinType.ETH;
    }
    if (toLowerCase().contains("heco")) {
      return KCoinType.HECO;
    }
    if (toLowerCase().contains("okchain")) {
      return KCoinType.OKChain;
    }
    if (toLowerCase().contains("polygon")) {
      return KCoinType.Matic;
    }
    if (toLowerCase().contains("avax")) {
      return KCoinType.AVAX;
    }
    if (toLowerCase().contains("arbitrum")) {
      return KCoinType.Arbitrum;
    }
    if (toLowerCase().contains("btc")) {
      return KCoinType.BTC;
    }
    if (toLowerCase().contains("tron")) {
      return KCoinType.TRX;
    }
  }

  String breakWord() {
    if (this == null || this.isEmpty) {
      return this;
    }
    String breakWord = ' ';
    this.runes.forEach((element) {
      breakWord += String.fromCharCode(element);
      breakWord += '\u200B';
    });
    return breakWord;
  }

  bool isValidUrl() {
    String regStr = "http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    RegExp reg = RegExp(regStr);
    bool isResult = reg.hasMatch(this);
    if (!isResult) {
      final ipArray = this.split(".");
      if (ipArray.length == 4) {
        for (final ipnumberStr in ipArray) {
          int ipnumber = int.parse(ipnumberStr);
          if (!(ipnumber >= 0 && ipnumber <= 255)) {
            return false;
          }
        }
        return true;
      }
    }
    return isResult;
  }

  bool checkPassword() {
    //密码长度8位数以上，建议使用英文字母、数字和标点符号组成，不采用特殊字符。
    if (this.length < 8) {
      return false;
    }
    String symbols = "\\s\\p{P}\n\r=+\$￥<>^`~|,./;'!@#^&*()_+"; //符号Unicode 编码
    String zcCharNumber = "^(?![$symbols]+\$)[a-zA-Z\\d$symbols]+\$";
    try {
      RegExp reg = RegExp(zcCharNumber);
      return reg.hasMatch(this);
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkPrv(KChainType kChainType) async {
    try {
      bool result = false;
      if (kChainType == KChainType.ETH) {
        String regex = "^[0-9A-Fa-f]{64}\$";
        RegExp reg = RegExp(regex);
        print("checkPrv $this hasMatch${reg.hasMatch(this)} regex $regex");
        result = reg.hasMatch(this);
      }
      if (kChainType == KChainType.BTC) {
        final originprv = wif.decode(this);
        result = true;
      }
      if (kChainType == KChainType.TRX) {
        result = true;
      }

      return result;
    } catch (e) {
      LogUtil.v("checkPassword $e");
      return false;
    }
  }

  bool checkMemo() {
    try {
      return Mnemonic.validateMnemonic(this);
    } catch (e) {
      return false;
    }
  }

  String local(
          {BuildContext? context,
          List<String>? args,
          Map<String, String>? namedArgs,
          String? gender}) =>
      ez.tr(this, args: args, namedArgs: namedArgs, gender: gender);

  bool checkAmount(int decimals) {
    String amount = '^[0-9]{0,$decimals}(\\.[0-9]{0,$decimals})?\$';
    RegExp reg = RegExp(amount);
    return reg.hasMatch(this);
  }

  ///合约地址缩略
  String contractAddress({int end = 7, int start = 7}) {
    String contractAddress = '';
    if (isNotEmpty && length > 14) {
      String startString = substring(0, start);
      String afterString = substring(length - end);
      contractAddress = startString + '...' + afterString;
    } else {
      contractAddress = this;
    }
    return contractAddress;
  }

  Future<bool> checkAddress(KCoinType coinType) async {
    bool isValid = false;
    try {
      if (coinType == KCoinType.BTC) {
        return Trustdart.validateAddress("BTC", this);
      } else if (coinType == KCoinType.TRX) {
        return Trustdart.validateAddress("TRX", this);
      } else {
        isValid = EthereumAddress.fromHex(toLowerCase()).hexEip55.isNotEmpty
            ? true
            : false;
      }
    } catch (e) {
      LogUtil.v("校验失败" + e.toString());
    }
    return isValid;
  }

  int compare(String str1, String str2) {
    List<String> strInt1 = str1.trim().split(".");
    List<String> strInt2 = str2.trim().split(".");
    int maxLen = max(strInt1.length, strInt2.length);
    for (var i = 0; i < maxLen; i++) {
      int a = 0;
      int b = 0;
      if (i < strInt1.length) {
        a = int.tryParse(strInt1[i])!;
      }
      if (i < strInt2.length) {
        b = int.tryParse(strInt2[i])!;
      }
      if (a > b) {
        LogUtil.v("比对结果  1");
        return 1;
      } else if (a == b) {
        continue;
      } else {
        LogUtil.v("比对结果  -1");
        return -1;
      }
    }
    LogUtil.v("比对结果  0");
    return 0;
  }

  void copy() {
    if (isEmpty) return;
    Clipboard.setData(ClipboardData(text: this));
    HWToast.showText(text: "copy_success".local());
  }

  static String dataFormat(double number, int decimalPlaces) {
    if (number == 0) {
      return '0.0000';
    }
    String balance = Decimal.parse(number.toString()).toString();
    if (balance.contains('.')) {
      String b = balance.split('.')[1];
      if (b.length > decimalPlaces) {
        balance =
            balance.substring(0, balance.indexOf(".") + decimalPlaces + 1);
      }
    } else {
      balance = balance + '.0';
    }
    return balance;
  }

  BigInt tokenInt(int decimals) {
    Decimal value = Decimal.parse(this);
    value = value * Decimal.fromInt(10).pow(decimals);
    return BigInt.parse(value.toString());
  }
}

extension FormatterString on Decimal {
  String tokenString(int decimals) {
    if (this == null) {
      return BigInt.zero.toString();
    }
    Decimal decimalValue =
        (this / Decimal.fromInt(10).pow(decimals)).toDecimal();
    return decimalValue.toString();
  }
}

extension FormatterBalance on BigInt {
  String tokenString(int decimals) {
    if (this == null) {
      return BigInt.zero.toString();
    }
    Decimal value = Decimal.fromBigInt(this);
    Decimal decimalValue =
        (value / Decimal.fromInt(10).pow(decimals)).toDecimal();
    return decimalValue.toString();
  }

  double tokenDouble(int decimals) {
    if (this == null) {
      return BigInt.zero.toDouble();
    }
    Decimal value = Decimal.fromBigInt(this);
    Decimal decimalValue =
        (value / Decimal.fromInt(10).pow(decimals)).toDecimal();
    return decimalValue.toDouble();
  }
}

extension Numextension on num {
  Widget get rowWidget => SizedBox(width: w);
  Widget get columnWidget => SizedBox(height: h);
  double get width => w;

  double get height => h;

  double get font => sp;

  KChainType getChainType() {
    List<KChainType> datas = KChainType.values;
    for (var item in datas) {
      if (item.index == this) {
        return item;
      }
    }
    return KChainType.HD;
  }

  KLeadType getLeadType() {
    List<KLeadType> datas = KLeadType.values;
    for (var item in datas) {
      if (item.index == this) {
        return item;
      }
    }
    return KLeadType.Prvkey;
  }

  KCoinType geCoinType() {
    List<KCoinType> datas = KCoinType.values;
    for (var item in datas) {
      if (item.index == this) {
        return item;
      }
    }
    return KCoinType.ETH;
  }

  KCoinType chainGetCoinType() {
    if (this == 1 || this == 4) {
      return KCoinType.ETH;
    }
    if (this == 42161 || this == 421611) {
      return KCoinType.Arbitrum;
    }
    if (this == 43114 || this == 43113) {
      return KCoinType.AVAX;
    }
    if (this == 56 || this == 97) {
      return KCoinType.BSC;
    }
    if (this == 128 || this == 256) {
      return KCoinType.HECO;
    }
    if (this == 137 || this == 80001) {
      return KCoinType.Matic;
    }
    if (this == 66 || this == 65) {
      return KCoinType.OKChain;
    }
    return KCoinType.OKChain;
  }

  KCoinType? getDappSuppertCoinType() {
    if (this == 4) {
      return KCoinType.Arbitrum;
    }
    if (this == 5) {
      return KCoinType.AVAX;
    }
    if (this == 6) {
      return KCoinType.Matic;
    }
    if (this == 7) {
      return KCoinType.HECO;
    }
    if (this == 8) {
      return KCoinType.BSC;
    }
    if (this == 9) {
      return KCoinType.ETH;
    }
  }

  KCurrencyType getCurrencyType() {
    List<KCurrencyType> datas = KCurrencyType.values;
    for (var item in datas) {
      if (item.index == this) {
        return item;
      }
    }
    return KCurrencyType.CNY;
  }

  KAppLanguage getAppLanguageType() {
    List<KAppLanguage> datas = KAppLanguage.values;
    for (var item in datas) {
      if (item.index == this) {
        return item;
      }
    }
    return KAppLanguage.zh_cn;
  }
}

extension UrlPatch on Map {
  String url() {
    String a = '?';
    forEach((key, value) {
      a += key + '=' + value.toString() + '&';
    });
    a = a.replaceRange(a.length - 1, a.length, '');
    return a;
  }
}

class FontWeightUtils {
  ///400
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight semiBold = FontWeight.w600;
}

class ColorUtils {
  static const Color blueColor = Color(0xff2cabec);
  static Color blueBGColor = fromHex("#1A216EFF");
  static const Color lineColor = Color(0x1A000000);
  static Color backgroudColor = fromHex("#FFF6F8FF");
  static Color redColor = fromHex("FFFF233E");
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
