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

  static String getAppLanguage() {
    int value = _sp!.getInt(_languageSET) ?? KAppLanguage.zh_cn.index;
    return value.getAppLanguageType().value;
  }

  static void setAppLanguage(KAppLanguage value) {
    _sp!.setInt(_languageSET, value.index);
  }

  static String getAppCurrency() {
    int value = _sp!.getInt(_aMOUNT_SET) ?? KCurrencyType.CNY.index;
    return value.getCurrencyType().value;
  }

  static void setAppCurrency(KCurrencyType value) {
    _sp!.setInt(_aMOUNT_SET, value.index);
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
}
