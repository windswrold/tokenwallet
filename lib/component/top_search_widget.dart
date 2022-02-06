import 'package:cstoken/pages/apps/dapp_search_page.dart';
import 'package:cstoken/pages/scan/scan.dart';
import 'package:cstoken/pages/wallet/wallets/wallets_manager.dart';
import 'package:cstoken/utils/custom_toast.dart';

import '../public.dart';

class TopSearchView extends StatelessWidget {
  const TopSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      
      child: Container(
        padding: EdgeInsets.only(left: 16.width),
        height: 32.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipOval(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  TRWallet? trWallet =
                      await Provider.of<CurrentChooseWalletState>(context,
                              listen: false)
                          .loadWallet();
                  if (trWallet == null) {
                    HWToast.showText(text: "minepage_pleasecreate".local());
                    return;
                  }
                  Routers.push(context, WalletsManager());
                },
                child: Container(
                  width: 32,
                  height: 32,
                  color: ColorUtils.blueColor,
                  child: Center(
                    child: LoadAssetsImage(
                      "icons/icon_white_wallet.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Routers.push(context, DAppSearch());
                },
                child: Container(
                  height: 32.width,
                  margin: EdgeInsets.only(left: 16.width, right: 16.width),
                  padding: EdgeInsets.only(left: 16.width),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.width),
                      color: ColorUtils.fromHex("#FFF6F8FF")),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      LoadAssetsImage(
                        "icons/icon_search.png",
                        width: 20,
                        height: 20,
                      ),
                      Text(
                        "dApp_top_search".local(),
                        style: TextStyle(
                            color: ColorUtils.fromHex("#807685A2"),
                            fontWeight: FontWeightUtils.regular,
                            fontSize: 14.font),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CustomPageView.getScan(() async {
              Map? params = await Routers.push(context, ScanCodePage());
              String? result = params?["data"];
            }),
          ],
        ),
      ),
    );
  }
}
