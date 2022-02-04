import 'dart:math';

import 'package:cstoken/model/mnemonic/mnemonic.dart';

import '../public.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/src/public.dart' as ez;

extension StringTranslateExtension on String {
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

  bool checkPrv(KChainType kChainType) {
    int len = 0;
    switch (kChainType) {
      case KChainType.ETH:
        len = 64;
        break;
      default:
    }
    String regex = "^[0-9A-Fa-f]{$len}\$";
    try {
      RegExp reg = RegExp(regex);
      print("checkPrv $this hasMatch${reg.hasMatch(this)} regex $regex");
      return reg.hasMatch(this);
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
}

extension offsetExtension on num {
  Widget get rowWidget => SizedBox(width: w);
  Widget get columnWidget => SizedBox(height: h);
  double get width => w;

  double get height => h;

  double get font => sp;

  KLeadType getLeadType() {
    List<KLeadType> datas = KLeadType.values;
    for (var item in datas) {
      if (item.index == this) {
        return item;
      }
    }
    return KLeadType.Prvkey;
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
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
