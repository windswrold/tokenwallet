//flutter emulators --launch Pixel XL API 24
//flutter run -d emulator-5554
//flutter build apk --obfuscate --split-debug-info=./symbols
import 'dart:async';
import 'dart:io';

import 'package:cstoken/utils/sp_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'public.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //不加这个强制横/竖屏会报错
  await EasyLocalization.ensureInitialized();
  //状态栏颜色改为透明
  SystemUiOverlayStyle systemUiOverlayStyle =
      const SystemUiOverlayStyle(statusBarColor: Colors.white);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);
    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();
      serviceWorkerController.serviceWorkerClient = AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          print(request);
          return null;
        },
      );
    }
  }
  SystemChrome.setPreferredOrientations([
    // 强制竖屏
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  SPManager.spInit(prefs);
  FlutterError.onError = (FlutterErrorDetails details) {
    if (inProduction == false) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  Provider.debugCheckInvalidValueType = null;
  runApp(EasyLocalization(
    child: MyApp(),
    // 支持的语言
    supportedLocales: const [
      Locale('en', 'US'),
      Locale('zh', 'CN'),
    ],
    startLocale: const Locale('zh', 'CN'),
    // 语言资源包目录
    path: 'resources/lang',
  ));
}
