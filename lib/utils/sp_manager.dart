import 'package:shared_preferences/shared_preferences.dart';

class SPManager {
  static SharedPreferences? _sp;
  static SharedPreferences get sp {
    return _sp!;
  }

  static spInit(SharedPreferences sp) {
    _sp = sp;
  }

  static const String _theme = 'AppTheme';

  static String? getAppTheme() {
    return _sp!.getString(_theme);
  }

  static void setAppTheme(String value) {
    _sp!.setString(_theme, value);
  }
}
