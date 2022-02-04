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

  static String? getAppLanguage() {
    return _sp!.getString(_languageSET);
  }

  static void setAppLanguage(String value) {
    _sp!.setString(_languageSET, value);
  }
}
