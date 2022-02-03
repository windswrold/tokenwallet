import '../../../public.dart';

class WalletModifyPwd extends StatefulWidget {
  const WalletModifyPwd({Key? key, required this.wallet}) : super(key: key);
  final TRWallet wallet;

  @override
  State<WalletModifyPwd> createState() => _WalletModifyPwdState();
}

class _WalletModifyPwdState extends State<WalletModifyPwd> {
  TextEditingController _oldEC = TextEditingController();
  TextEditingController _newEC = TextEditingController();
  TextEditingController _againEC = TextEditingController();
  TextEditingController _pinTipEC = TextEditingController();

  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;

  void _modifyPwd() {
    Provider.of<CurrentChooseWalletState>(context, listen: false).modifyPwd(
        context,
        wallet: widget.wallet,
        oldPin: _oldEC.text,
        newPin: _newEC.text,
        againPin: _againEC.text,
        pinTip: _pinTipEC.text);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: CustomPageView.getTitle(title: "walletssetting_modifypwd".local()),
      child: Container(
        padding: EdgeInsets.only(
            top: 24.width, left: 16.width, right: 16.width, bottom: 20.width),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField.getInputTextField(
                      context,
                      controller: _oldEC,
                      obscureText: _obscureText1,
                      isPasswordText: true,
                      onPressBack: () {
                        setState(() {
                          _obscureText1 = !_obscureText1;
                        });
                      },
                      titleText: "walletssetting_oldpwd".local(),
                      hintText: "walletssetting_oldpwdhint".local(),
                    ),
                    CustomTextField.getInputTextField(
                      context,
                      controller: _newEC,
                      obscureText: _obscureText2,
                      isPasswordText: true,
                      onPressBack: () {
                        setState(() {
                          _obscureText2 = !_obscureText2;
                        });
                      },
                      padding: EdgeInsets.only(top: 16.width),
                      titleText: "walletssetting_newpwd".local(),
                      hintText: "walletssetting_newpwdhint".local(),
                    ),
                    CustomTextField.getInputTextField(
                      context,
                      controller: _againEC,
                      obscureText: _obscureText3,
                      onPressBack: () {
                        setState(() {
                          _obscureText3 = !_obscureText3;
                        });
                      },
                      isPasswordText: true,
                      padding: EdgeInsets.only(top: 16.width),
                      titleText: "walletssetting_againnewpwd".local(),
                      hintText: "walletssetting_againnewpwdhint".local(),
                    ),
                    CustomTextField.getInputTextField(
                      context,
                      controller: _pinTipEC,
                      padding: EdgeInsets.only(top: 16.width),
                      titleText: "createwallet_pwdtip".local(),
                      hintText: "input_pwdtip".local(),
                    ),
                  ],
                ),
              ),
            ),
            NextButton(
              onPressed: _modifyPwd,
              bgc: ColorUtils.blueColor,
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16.font,
                  fontWeight: FontWeightUtils.medium),
              title: "walletssetting_modifyok".local(),
            ),
          ],
        ),
      ),
    );
  }
}
