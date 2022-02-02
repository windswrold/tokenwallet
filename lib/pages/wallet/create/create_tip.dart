import 'package:cstoken/pages/wallet/create/create_wallet_page.dart';
import 'package:cstoken/pages/wallet/restore/restore_wallet_page.dart';
import 'package:cstoken/utils/extension.dart';

import '../../../public.dart';

class CreateTip extends StatelessWidget {
  const CreateTip({Key? key, required this.isCreate}) : super(key: key);

  final bool isCreate;

  void _onTap(BuildContext context) {
    if (isCreate) {
      Routers.push(context, CreateWalletPage());
    } else {
      Routers.push(context, RestoreWalletPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: CustomPageView(
          leading: CustomPageView.getCloseLeading(() {
            Routers.goBack(context);
          }),
          title: CustomPageView.getTitle(title: "createwallet_tip".local()),
          child: Container(
            padding: EdgeInsets.only(
                left: 24.width,
                right: 24.width,
                top: 32.width,
                bottom: 40.width),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "createwallet_tip1".local(),
                      style: TextStyle(
                        fontSize: 14.font,
                        fontWeight: FontWeightUtils.regular,
                        color: ColorUtils.fromHex("#CC000000"),
                      ),
                    ),
                    25.columnWidget,
                    Text(
                      "createwallet_tip2".local(),
                      style: TextStyle(
                        fontSize: 14.font,
                        fontWeight: FontWeightUtils.regular,
                        color: ColorUtils.fromHex("#CC000000"),
                      ),
                    ),
                    25.columnWidget,
                    Text(
                      "createwallet_tip3".local(),
                      style: TextStyle(
                        fontSize: 14.font,
                        fontWeight: FontWeightUtils.regular,
                        color: ColorUtils.fromHex("#CC000000"),
                      ),
                    ),
                    25.columnWidget,
                    Text(
                      "createwallet_tip4".local(),
                      style: TextStyle(
                        fontSize: 14.font,
                        fontWeight: FontWeightUtils.regular,
                        color: ColorUtils.fromHex("#CC000000"),
                      ),
                    ),
                  ],
                ),
                NextButton(
                    bgc: ColorUtils.blueColor,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeightUtils.medium,
                      fontSize: 16.font,
                    ),
                    onPressed: () {
                      _onTap(context);
                    },
                    title: "createwallet_next".local()),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }
}
