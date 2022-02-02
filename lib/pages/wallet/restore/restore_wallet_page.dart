import 'package:cstoken/state/create/create_wallet_state.dart';

import '../../../public.dart';

class RestoreWalletPage extends StatefulWidget {
  RestoreWalletPage({Key? key}) : super(key: key);

  @override
  State<RestoreWalletPage> createState() => _RestoreWalletPageState();
}

class _RestoreWalletPageState extends State<RestoreWalletPage> {
  final CreateWalletProvider _kprovier =
      CreateWalletProvider.init(isRestore: true);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _kprovier,
      child: CustomPageView(
        title: CustomPageView.getTitle(title: "restorewallet_title".local()),
        child: Container(
          padding: EdgeInsets.all(16.width),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "createwallet_toptip".local(),
                        style: TextStyle(
                          fontSize: 14.font,
                          fontWeight: FontWeightUtils.medium,
                          color: ColorUtils.fromHex("#FF000000"),
                        ),
                      ),
                      CustomTextField(
                        controller: _kprovier.memoEC,
                        padding: EdgeInsets.only(top: 24.width),
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
                          controller: _kprovier.walletNameEC,
                          titleText: "createwallet_walletname".local(),
                          hintText: "input_name".local()),
                      Consumer<CreateWalletProvider>(
                          builder: (_, provider, child) {
                        return CustomTextField.getInputTextField(context,
                            padding: EdgeInsets.only(top: 16.width),
                            controller: _kprovier.pwdEC,
                            obscureText: _kprovier.pwdisClose,
                            isPasswordText: true,
                            titleText: "createwallet_walletpwd".local(),
                            onPressBack: () {
                          _kprovier.changePwdisClose();
                        }, hintText: "input_pwd".local());
                      }),
                      Consumer<CreateWalletProvider>(
                          builder: (_, provider, child) {
                        return CustomTextField.getInputTextField(context,
                            padding: EdgeInsets.only(top: 16.width),
                            controller: _kprovier.pwdAgainEC,
                            obscureText: _kprovier.pwdAgainisClose,
                            titleText: "createwallet_walletpwdagain".local(),
                            onPressBack: () {
                          _kprovier.changePwdAgainisClose();
                        },
                            isPasswordText: true,
                            hintText: "input_pwdagain".local());
                      }),
                      CustomTextField.getInputTextField(context,
                          padding: EdgeInsets.only(top: 16.width),
                          controller: _kprovier.pwdTipEC,
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
        ),
      ),
    );
  }
}
