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
  final CreateWalletProvider _kprovier =
      CreateWalletProvider.init(leadType: KLeadType.Prvkey);

  final List<Tab> _myTabs = [
    Tab(text: 'importwallet_prv'.local()),
    Tab(text: 'importwallet_memo'.local())
  ];

  void _onTap(int index) {
    KLeadType leadType = KLeadType.Prvkey;
    if (index == 0) {
      leadType = KLeadType.Prvkey;
    } else {
      leadType = KLeadType.Restore;
    }
    _kprovier.updateLeadType(leadType);
  }

  Widget _getPageViewWidget(Tab leadtype) {
    int lead = _myTabs.indexOf(leadtype);
    List<Widget> widgets = [];
    if (lead == 0) {
      widgets.add(const ChooseChainType());
      widgets.add(CustomTextField.getInputTextField(context,
          padding: EdgeInsets.only(top: 16.width),
          controller: _kprovier.contentEC,
          titleText: "importwallet_prvtitle".local(),
          hintText: "input_prvkey".local()));
    } else {
      widgets.add(CustomTextField(
        controller: _kprovier.contentEC,
        maxLines: 5,
        decoration: CustomTextField.getBorderLineDecoration(
          context: context,
          fillColor: Colors.white,
          borderColor: ColorUtils.lineColor,
          hintText: "input_memos".local(),
          contentPadding: EdgeInsets.all(10),
        ),
      ));
    }
    widgets.addAll([
      CustomTextField.getInputTextField(context,
          padding: EdgeInsets.only(top: 16.width),
          controller: _kprovier.walletNameEC,
          titleText: "createwallet_walletname".local(),
          hintText: "input_name".local()),
      Consumer<CreateWalletProvider>(builder: (_, kprovider, child) {
        return CustomTextField.getInputTextField(context,
            padding: EdgeInsets.only(top: 16.width),
            controller: _kprovier.pwdEC,
            obscureText: _kprovier.pwdisClose,
            isPasswordText: true,
            titleText: "createwallet_walletpwd".local(), onPressBack: () {
          _kprovier.changePwdisClose();
        }, hintText: "input_pwd".local());
      }),
      Consumer<CreateWalletProvider>(builder: (_, kprovider, child) {
        return CustomTextField.getInputTextField(context,
            padding: EdgeInsets.only(top: 16.width),
            controller: _kprovier.pwdAgainEC,
            obscureText: _kprovier.pwdAgainisClose,
            titleText: "createwallet_walletpwdagain".local(), onPressBack: () {
          _kprovier.changePwdAgainisClose();
        }, isPasswordText: true, hintText: "input_pwdagain".local());
      }),
      CustomTextField.getInputTextField(context,
          padding: EdgeInsets.only(top: 16.width),
          controller: _kprovier.pwdTipEC,
          titleText: "createwallet_pwdtip".local(),
          hintText: "input_pwdtip".local()),
      Container(
        padding: EdgeInsets.only(top: 16.width, bottom: 32.width),
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
    ]);
    return Container(
      padding: EdgeInsets.all(16.width),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: widgets,
              ),
            ),
          ),
          NextButton(
            onPressed: () {
              _kprovier.createWallet(context);
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _kprovier,
      child: DefaultTabController(
        length: _myTabs.length,
        child: CustomPageView(
          title: Material(
            color: Colors.transparent,
            child: Theme(
              data: ThemeData(
                  splashColor: const Color.fromRGBO(0, 0, 0, 0),
                  highlightColor: const Color.fromRGBO(0, 0, 0, 0)),
              child: TabBar(
                tabs: _myTabs,
                isScrollable: true,
                indicator: const CustomUnderlineTabIndicator(gradientColor: [
                  ColorUtils.blueColor,
                  ColorUtils.blueColor
                ]),
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
                onTap: (value) {
                  _onTap(value);
                },
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
      ),
    );
  }
}
