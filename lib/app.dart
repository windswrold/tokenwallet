import 'package:cstoken/pages/choose/choose_type_page.dart';
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
  int state = 0; //0 load  1 skin, 2 create ,3 tabbar

  CurrentChooseWalletState _walletState = CurrentChooseWalletState();
  @override
  void initState() {
    super.initState();
    getSkip();
  }

  void getSkip() async {
    // final prefs = await SharedPreferences.getInstance();
    // bool? isSkip = prefs.getBool("skip");
    // if (isSkip != null && isSkip) {
    // List<MHWallet> wallets = await MHWallet.findAllWallets();
    // if (wallets.length > 0) {
    //   setState(() {
    //     state = 3;
    //   });
    // } else {
    //   setState(() {
    //     state = 2;
    //   });
    // }
    // } else {
    //   setState(() {
    //     state = 1;
    //   });
    // }
  }

  Widget buildEmptyView() {
    return Container();
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
                  // state == 3
                  //         ? SplashPage() //TabbarPage()
                  //         : state == 2
                  //             ? ChooseTypePage()
                  //             : ChooseTypePage(),
                  child: HomeTabbar(),
                )));
    ;
  }
}
