import 'package:cstoken/public.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPManager {
  static SharedPreferences? _sp;
  static SharedPreferences get sp {
    return _sp!;
  }

  static spInit(SharedPreferences sp) {
    _sp = sp;
  }

  static const String _languageSET = 'LANGUAGE_SET';
  static const String _aMOUNT_SET = "AMOUNT_SET";

  static String getAppLanguage() {
    return _sp!.getString(_languageSET) ?? KAppLanguage.zh_cn.value;
  }

  static KAppLanguage getAppLanguageMode() {
    final String mode = getAppLanguage();
    switch (mode) {
      case '简体中文':
        return KAppLanguage.zh_cn;
      case 'English':
        return KAppLanguage.en_us;
      default:
        return KAppLanguage.system;
    }
  }

  static void setAppLanguage(KAppLanguage value) {
    _sp!.setString(_languageSET, value.value);
  }

  static String getAppCurrency() {
    return _sp!.getString(_aMOUNT_SET) ?? KCurrencyType.CNY.value;
  }

  static KCurrencyType getAppCurrencyMode() {
    final String mode = getAppCurrency();
    switch (mode) {
      case '人民币(CNY)':
        return KCurrencyType.CNY;
      case '美国(USD)':
        return KCurrencyType.USD;
      default:
        return KCurrencyType.CNY;
    }
  }

  static void setAppCurrency(KCurrencyType value) {
    _sp!.setString(_aMOUNT_SET, value.value);
  }
}
