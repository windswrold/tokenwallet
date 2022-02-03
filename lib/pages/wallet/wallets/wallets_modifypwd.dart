import '../../../public.dart';

class WalletModifyPwd extends StatefulWidget {
  WalletModifyPwd({Key? key}) : super(key: key);

  @override
  State<WalletModifyPwd> createState() => _WalletModifyPwdState();
}

class _WalletModifyPwdState extends State<WalletModifyPwd> {

  

  void _modifyPwd() {}

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
                      titleText: "walletssetting_oldpwd".local(),
                      hintText: "walletssetting_oldpwdhint".local(),
                    ),
                    CustomTextField.getInputTextField(
                      context,
                      padding: EdgeInsets.only(top: 16.width),
                      titleText: "walletssetting_newpwd".local(),
                      hintText: "walletssetting_newpwdhint".local(),
                    ),
                    CustomTextField.getInputTextField(
                      context,
                      padding: EdgeInsets.only(top: 16.width),
                      titleText: "walletssetting_againnewpwd".local(),
                      hintText: "walletssetting_againnewpwdhint".local(),
                    ),
                    CustomTextField.getInputTextField(
                      context,
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
