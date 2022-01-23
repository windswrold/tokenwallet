import '../public.dart';

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

  bool checkAmount(int decimals) {
    String amount = '^[0-9]{0,$decimals}(\\.[0-9]{0,$decimals})?\$';
    RegExp reg = RegExp(amount);
    return reg.hasMatch(this);
  }
}

extension FormatterBalance on BigInt {}


