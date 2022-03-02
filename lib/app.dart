import 'package:cstoken/pages/tabbar/tabbar.dart';
import 'package:cstoken/public.dart';
import 'package:cstoken/state/wallet_state.dart';
import 'package:cstoken/utils/sp_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'component/custom_app.dart';
import 'package:easy_localization/easy_localization.dart';

class MyApp extends StatefulWidget {
  //launch
  //tabbar
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final CurrentChooseWalletState _walletState = CurrentChooseWalletState();
  @override
  void initState() {
    super.initState();
    getSkip();
    _getLanguage();
  }

  void getSkip() async {
    _walletState.loadWallet();
  }

  void _getLanguage() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      if (SPManager.getAppLanguageMode() == KAppLanguage.system) {
        Locale first = context.deviceLocale;
        for (var element in context.supportedLocales) {
          if (element.languageCode.contains(first.languageCode)) {
            LogUtil.v("element " + element.languageCode);
            context.setLocale(element);
            SPManager.setSystemAppLanguage(element.languageCode == "zh"
                ? KAppLanguage.zh_cn
                : KAppLanguage.en_us);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 667),
        builder: () => MultiProvider(
                providers: [
                  ChangeNotifierProvider.value(value: _walletState),
                ],
                child: CustomApp(
                  child: HomeTabbar(),
                )));
    ;
  }
}
