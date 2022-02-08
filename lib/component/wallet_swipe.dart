import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../public.dart';

class WalletSwipe extends StatelessWidget {
  const WalletSwipe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.width, right: 10.width),
      margin: EdgeInsets.only(
          top: 12.width, bottom: 16.width, left: 16.width, right: 16.width),
      height: 120.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: ColorUtils.fromHex("#66FF731E"),
                offset: const Offset(0.0, 7.0),
                blurRadius: 16.0,
                spreadRadius: 1.0),
          ],
          gradient: LinearGradient(colors: [
            ColorUtils.fromHex("#FFFF6613"),
            ColorUtils.fromHex("#FFFFC967"),
          ])),
      child: Column(
        children: [
          Container(
            height: 40.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "walletpage_assets".local(),
                      style: TextStyle(
                        fontSize: 14.font,
                        fontWeight: FontWeightUtils.regular,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Provider.of<CurrentChooseWalletState>(context,
                                listen: false)
                            .assetsHidden(context);
                      },
                      child: Consumer<CurrentChooseWalletState>(
                          builder: (_, kprovider, child) {
                        return Container(
                          width: 45,
                          height: 45,
                          child: Center(
                            child: LoadAssetsImage(
                              kprovider.currentWallet?.hiddenAssets == true
                                  ? "icons/icon_wallet_eye_close.png"
                                  : "icons/icon_wallet_eye_open.png",
                              width: 16,
                              height: 16,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Provider.of<CurrentChooseWalletState>(context,
                            listen: false)
                        .tapWalletSetting(context);
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    child: Center(
                      child: LoadAssetsImage(
                        "icons/icon_wallet_three.png",
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Consumer<CurrentChooseWalletState>(builder: (_, kprovider, child) {
            return Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 31.width),
              child: RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  text: kprovider.currencySymbolStr,
                  style: TextStyle(
                    fontSize: 20.font,
                    fontWeight: FontWeightUtils.bold,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: kprovider.totalAssets(),
                      style: TextStyle(
                        fontSize: 32.font,
                        fontWeight: FontWeightUtils.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
