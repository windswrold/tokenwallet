import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import '../public.dart';

class WalletSwipe extends StatefulWidget {
  WalletSwipe({Key? key}) : super(key: key);

  @override
  State<WalletSwipe> createState() => _WalletSwipeState();
}

class _WalletSwipeState extends State<WalletSwipe> {
  final SwiperController _controller = SwiperController();
  final Gradient _tokenGradient = LinearGradient(
    colors: [
      ColorUtils.fromHex("#FFFF6613"),
      ColorUtils.fromHex("#FFFFC967"),
    ],
  );
  final Gradient _nftGradient = LinearGradient(
    colors: [
      ColorUtils.fromHex("#ff3487FF"),
      ColorUtils.fromHex("#ff1566FE"),
    ],
  );

  _tapNext(int homeTokenType) {
    _controller.next();
  }

  Widget _assetsCell(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20.width, right: 10.width),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: _tokenGradient,
        ),
        child: Stack(
          children: [
            Column(
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
                                    kprovider.currentWallet?.hiddenAssets ==
                                            true
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
                Consumer<CurrentChooseWalletState>(
                    builder: (_, kprovider, child) {
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
                            text: kprovider.totalTokenAssets(),
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
            Positioned(
              right: 0,
              bottom: 0,
              child: LoadAssetsImage(
                "bg/wallet_moneybox.png",
                height: 80.width,
              ),
            ),
          ],
        ));
  }

  Widget _nftCell(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20.width, right: 10.width),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: _nftGradient,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 40.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "homepage_nft".local(),
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
                                    kprovider.currentWallet?.hiddenAssets ==
                                            true
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
                Consumer<CurrentChooseWalletState>(
                    builder: (_, kprovider, child) {
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
                            text: kprovider.totalNFTAssets(),
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
            Positioned(
              right: 0,
              bottom: 0,
              child: LoadAssetsImage(
                "bg/wallet_nft_bg.png",
                height: 80.width,
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentChooseWalletState>(
      builder: (_, provider, child) {
        int homeTokenType = provider.homeTokenType;
        String icon = "";
        String nextNAME = "";
        Color color = Colors.white;
        if (homeTokenType == 0) {
          icon = "icons/icon_nft.png";
          nextNAME = "homepage_nft".local();
          color = _tokenGradient.colors.first.withOpacity(0.3);
        } else {
          icon = "icons/icon_nft_token.png";
          nextNAME = "walletpage_assets".local();
          color = _nftGradient.colors.first.withOpacity(0.3);
        }

        return Container(
          margin:
              EdgeInsets.only(top: 12.width, bottom: 16.width, right: 16.width),
          height: 120.width,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: color,
                  offset: const Offset(7, 7.0),
                  blurRadius: 16.0,
                  spreadRadius: 1.0),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0.width,
                width: 320.width,
                height: 120.width,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _tapNext(provider.homeTokenType);
                  },
                  child: AnimatedContainer(
                    alignment: Alignment.centerRight,
                    curve: Curves.easeIn,
                    padding: EdgeInsets.only(right: 15.width),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: provider.homeTokenType == 0
                          ? _nftGradient
                          : _tokenGradient,
                    ),
                    duration: Duration(milliseconds: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadAssetsImage(icon, width: 24, height: 24),
                        5.columnWidget,
                        Text(
                          nextNAME,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.font,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 50.width,
                left: 0,
                height: 120.width,
                child: Swiper(
                  outer: true,
                  itemBuilder: (BuildContext tx, int index) {
                    return index == 0
                        ? _assetsCell(context)
                        : _nftCell(context);
                  },
                  index: 0,
                  itemCount: 2,
                  itemWidth: 290.width,
                  layout: SwiperLayout.CUSTOM,
                  controller: _controller,
                  customLayoutOption:
                      CustomLayoutOption(startIndex: -1, stateCount: 3)
                        ..addTranslate([
                          Offset(-380.width, 0),
                          Offset(10.width, 0.0),
                          Offset(380.0.width, 0)
                        ]),
                  onIndexChanged: (value) {
                    Provider.of<CurrentChooseWalletState>(context,
                            listen: false)
                        .onIndexChanged(context, value);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
