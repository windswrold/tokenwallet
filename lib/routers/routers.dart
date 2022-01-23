import 'dart:async';

import 'package:cstoken/utils/custom_toast.dart';

import '../public.dart';

class Routers {
  static bool canGoPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  /// 返回
  static void goBack(BuildContext context, {String? routeName}) {
    HWToast.hiddenAllToast();
    if (canGoPop(context)) {
      Navigator.of(context).pop();
    }
  }

  /// 带参数返回
  static void goBackWithParams(
      BuildContext context, Map<String, dynamic>? result) {
    HWToast.hiddenAllToast();
    Navigator.of(context).pop(result);
  }

  static Future<dynamic> push(BuildContext context, Widget page,
      {bool replace = false, bool clearStack = false}) {
    Completer completer = Completer();
    Future future = completer.future;

    if (clearStack) {
      future = Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => page),
          (check) => false);
    } else {
      future = replace
          ? Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => page))
          : Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) => page));
    }

    return future;
  }
}
