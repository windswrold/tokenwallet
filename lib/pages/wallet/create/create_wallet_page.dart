import '../../../public.dart';

class CreateWalletPage extends StatefulWidget {
  CreateWalletPage({Key? key}) : super(key: key);

  @override
  State<CreateWalletPage> createState() => _CreateWalletPageState();
}

class _CreateWalletPageState extends State<CreateWalletPage> {
  @override
  Widget build(BuildContext context) {
    return CustomPageView(
        leading: CustomPageView.getCloseLeading(() {
          Routers.goBack(context);
        }),
        hiddenScrollView: true,
        title: CustomPageView.getTitle(title: "createwallet_title".local()),
        child: Container(
          padding: EdgeInsets.all(16.width),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "createwallet_toptip".local(),
                    style: TextStyle(
                      fontSize: 14.font,
                      fontWeight: FontWeightUtils.medium,
                      color: ColorUtils.fromHex("#FF000000"),
                    ),
                  ),
                  CustomTextField.getInputTextField(context,
                      padding: EdgeInsets.only(top: 24.width),
                      titleText: "createwallet_walletname".local(),
                      hintText: "input_name".local()),
                  CustomTextField.getInputTextField(context,
                      padding: EdgeInsets.only(top: 16.width),
                      titleText: "createwallet_walletpwd".local(),
                      isPasswordText: true,
                      hintText: "input_pwd".local()),
                  CustomTextField.getInputTextField(context,
                      padding: EdgeInsets.only(top: 16.width),
                      titleText: "createwallet_walletpwdagain".local(),
                      isPasswordText: true,
                      hintText: "input_pwdagain".local()),
                  CustomTextField.getInputTextField(context,
                      padding: EdgeInsets.only(top: 16.width),
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
              NextButton(
                onPressed: () {},
                bgc: ColorUtils.fromHex("#FF0060FF"),
                title: "createwallet_createnext".local(),
              ),
            ],
          ),
        ));
  }
}
