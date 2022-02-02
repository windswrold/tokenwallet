import 'package:cstoken/component/chain_type.dart';
import 'package:cstoken/component/custom_underline.dart';
import 'package:cstoken/pages/wallet/create/create_wallet_page.dart';
import 'package:cstoken/pages/wallet/restore/restore_wallet_page.dart';
import 'package:cstoken/state/create/create_wallet_state.dart';

import '../../../public.dart';

class ImportsWallet extends StatefulWidget {
  ImportsWallet({Key? key}) : super(key: key);

  @override
  State<ImportsWallet> createState() => _ImportsWalletState();
}

class _ImportsWalletState extends State<ImportsWallet> {
  final CreateWalletProvider _prvProvider =
      CreateWalletProvider.init(leadType: KLeadType.Prvkey);

  final CreateWalletProvider _restoreProvider =
      CreateWalletProvider.init(leadType: KLeadType.Restore);
  final List<Tab> _myTabs = [
    Tab(text: 'importwallet_prv'.local()),
    Tab(text: 'importwallet_memo'.local())
  ];

  Widget _getPageViewWidget(Tab leadtype) {
    int lead = _myTabs.indexOf(leadtype);
    if (lead == 0) {
      return ChangeNotifierProvider(
        create: (_) => _prvProvider,
        child: Container(
          padding: EdgeInsets.all(16.width),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const ChooseChainType(),
                      CustomTextField.getInputTextField(context,
                          padding: EdgeInsets.only(top: 16.width),
                          controller: _prvProvider.contentEC,
                          titleText: "importwallet_prvtitle".local(),
                          hintText: "input_prvkey".local()),
                      CustomTextField.getInputTextField(context,
                          padding: EdgeInsets.only(top: 16.width),
                          controller: _prvProvider.walletNameEC,
                          titleText: "createwallet_walletname".local(),
                          hintText: "input_name".local()),
                      CustomTextField.getInputTextField(context,
                          padding: EdgeInsets.only(top: 16.width),
                          controller: _prvProvider.pwdEC,
                          obscureText: _prvProvider.pwdisClose,
                          isPasswordText: true,
                          titleText: "importwallet_pwdtitlenew".local(),
                          onPressBack: () {
                        _prvProvider.changePwdisClose();
                      }, hintText: "input_pwd".local()),
                      CustomTextField.getInputTextField(context,
                          padding: EdgeInsets.only(top: 16.width),
                          controller: _prvProvider.pwdAgainEC,
                          obscureText: _prvProvider.pwdAgainisClose,
                          titleText: "createwallet_walletpwdagain".local(),
                          onPressBack: () {
                        _prvProvider.changePwdAgainisClose();
                      },
                          isPasswordText: true,
                          hintText: "input_pwdagain".local()),
                      CustomTextField.getInputTextField(context,
                          padding: EdgeInsets.only(top: 16.width),
                          controller: _prvProvider.pwdTipEC,
                          titleText: "createwallet_pwdtip".local(),
                          hintText: "input_pwdtip".local()),
                      Container(
                        padding: EdgeInsets.only(top: 16.width),
                        child: RichText(
                          text: TextSpan(
                            text: "createwallet_warning".local() + "：",
                            style: TextStyle(
                              color: ColorUtils.fromHex("#FFFF233E"),
                              fontSize: 12.font,
                              fontWeight: FontWeightUtils.semiBold,
                            ),
                            children: [
                              TextSpan(
                                text: "createwallet_warningvalue".local(),
                                style: TextStyle(
                                  color: ColorUtils.fromHex("#FFFF233E"),
                                  fontSize: 12.font,
                                  fontWeight: FontWeightUtils.regular,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              NextButton(
                onPressed: () {
                  _prvProvider.createWallet(context);
                },
                bgc: ColorUtils.blueColor,
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.font,
                    fontWeight: FontWeightUtils.medium),
                title: "createwallet_createnext".local(),
              ),
            ],
          ),
        ),
      );
    } else {
      return ChangeNotifierProvider(
        create: (_) => _restoreProvider,
        child: Container(
          padding: EdgeInsets.all(16.width),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _restoreProvider.contentEC,
                        maxLines: 5,
                        decoration: CustomTextField.getBorderLineDecoration(
                          context: context,
                          fillColor: Colors.white,
                          borderColor: ColorUtils.lineColor,
                          hintText: "input_memos".local(),
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                      CustomTextField.getInputTextField(context,
                          padding: EdgeInsets.only(top: 16.width),
                          controller: _restoreProvider.walletNameEC,
                          titleText: "createwallet_walletname".local(),
                          hintText: "input_name".local()),
                      CustomTextField.getInputTextField(context,
                          padding: EdgeInsets.only(top: 16.width),
                          controller: _restoreProvider.pwdEC,
                          obscureText: _restoreProvider.pwdisClose,
                          isPasswordText: true,
                          titleText: "createwallet_walletpwd".local(),
                          onPressBack: () {
                        _restoreProvider.changePwdisClose();
                      }, hintText: "input_pwd".local()),
                      CustomTextField.getInputTextField(context,
                          padding: EdgeInsets.only(top: 16.width),
                          controller: _restoreProvider.pwdAgainEC,
                          obscureText: _restoreProvider.pwdAgainisClose,
                          titleText: "createwallet_walletpwdagain".local(),
                          onPressBack: () {
                        _restoreProvider.changePwdAgainisClose();
                      },
                          isPasswordText: true,
                          hintText: "input_pwdagain".local()),
                      CustomTextField.getInputTextField(context,
                          padding: EdgeInsets.only(top: 16.width),
                          controller: _restoreProvider.pwdTipEC,
                          titleText: "createwallet_pwdtip".local(),
                          hintText: "input_pwdtip".local()),
                      Container(
                        padding: EdgeInsets.only(top: 16.width),
                        child: RichText(
                          text: TextSpan(
                            text: "createwallet_warning".local() + "：",
                            style: TextStyle(
                              color: ColorUtils.fromHex("#FFFF233E"),
                              fontSize: 12.font,
                              fontWeight: FontWeightUtils.semiBold,
                            ),
                            children: [
                              TextSpan(
                                text: "createwallet_warningvalue".local(),
                                style: TextStyle(
                                  color: ColorUtils.fromHex("#FFFF233E"),
                                  fontSize: 12.font,
                                  fontWeight: FontWeightUtils.regular,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              NextButton(
                onPressed: () {
                  _restoreProvider.createWallet(context);
                },
                bgc: ColorUtils.blueColor,
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.font,
                    fontWeight: FontWeightUtils.medium),
                title: "createwallet_createnext".local(),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _myTabs.length,
      child: CustomPageView(
        title: Material(
          color: Colors.transparent,
          child: Theme(
            data: ThemeData(
                splashColor: Color.fromRGBO(0, 0, 0, 0),
                highlightColor: Color.fromRGBO(0, 0, 0, 0)),
            child: TabBar(
              tabs: _myTabs,
              isScrollable: true,
              indicator: const CustomUnderlineTabIndicator(
                  gradientColor: [ColorUtils.blueColor, ColorUtils.blueColor]),
              indicatorWeight: 4,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: ColorUtils.fromHex("#FF000000"),
              labelStyle: TextStyle(
                fontSize: 18.font,
                fontWeight: FontWeightUtils.semiBold,
              ),
              unselectedLabelColor: ColorUtils.fromHex("#99000000"),
              unselectedLabelStyle: TextStyle(
                fontSize: 18.font,
                fontWeight: FontWeightUtils.regular,
              ),
              onTap: (value) {},
            ),
          ),
        ),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(), //禁止左右滑动
          children: _myTabs.map((Tab tab) {
            return _getPageViewWidget(tab);
          }).toList(),
        ),
      ),
    );
  }
}
