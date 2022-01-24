import 'package:cstoken/pages/tabbar/tabbar.dart';
import 'package:cstoken/state/wallet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'component/custom_app.dart';

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
  }

  void getSkip() async {
    _walletState.loadWallet();
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
