import 'dart:io';
import 'dart:typed_data';

import 'package:cstoken/component/share_default.dart';
import 'package:cstoken/model/wallet/tr_wallet_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import '../../../public.dart';
import 'package:path_provider/path_provider.dart';

class RecervePaymentPage extends StatefulWidget {
  RecervePaymentPage({
    Key? key,
    this.params,
  }) : super(key: key);
  Map? params = Map();

  @override
  _RecervePaymentPageState createState() => _RecervePaymentPageState();
}

class _RecervePaymentPageState extends State<RecervePaymentPage> {
  String qrCodeStr = "";
  String walletName = "";
  bool _isShare = false;
  final _repaintKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    TRWallet wallet =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet!;
    TRWalletInfo info =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .walletinfo!;
    qrCodeStr = info.walletAaddress!;
    walletName =
        info.coinType!.geCoinType().coinTypeString() + "tabbar_wallet".local();
  }

  void _shareImage() async {
    final ok = await shareImage(_repaintKey);
    Share.shareFiles([ok.absolute.path]);
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _isShare = false;
    });
  }

  Widget _topView() {
    return Container(
      height: 44,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      padding: EdgeInsets.only(left: 16.width, right: 16.width),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Routers.goBack(context);
            },
            child: Center(
              child: Image.asset(
                ASSETS_IMG + "icons/icon_back_white.png",
                width: 24,
                height: 24,
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              setState(() {
                _isShare = true;
              });
              Future.delayed(Duration(seconds: 1)).then((value) => {
                    _shareImage(),
                  });
            },
            child: Center(
              child: Image.asset(
                ASSETS_IMG + "icons/icon_white_share.png",
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: CustomPageView(
        title: CustomPageView.getTitle(
          title: "transferetype_receive".local(),
        ),
        hiddenAppBar: true,
        hiddenLeading: true,
        safeAreaTop: false,
        safeAreaBottom: false,
        child: _isShare == true
            ? RepaintBoundary(
                key: _repaintKey,
                child: Container(
                  height: 600.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage(ASSETS_IMG + "bg/big_share.png"),
                        alignment: Alignment.topCenter,
                      )),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 55.width),
                        child: Text(
                          walletName,
                          style: TextStyle(
                            fontSize: 20.font,
                            fontWeight: FontWeightUtils.medium,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40.width),
                        child: Container(
                          width: 234.width,
                          height: 234.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(20.width),
                          child: Center(
                            child: QrImage(
                              data: qrCodeStr,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 33.width),
                        child: Text(
                          "transferetype_receiveaddress".local(),
                          style: TextStyle(
                            color: ColorUtils.fromHex("#99FFFFFF"),
                            fontSize: 13.font,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 4.width),
                        width: 280.width,
                        child: Text(
                          qrCodeStr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.font,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 50.width),
                        child: ShareDefaultWidget(),
                      ),
                    ],
                  ),
                ))
            : Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorUtils.fromHex("#FF3487FF"),
                      ColorUtils.blueColor,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    _topView(),
                    Container(
                      margin: EdgeInsets.only(
                          top: 40.width, left: 24.width, right: 24.width),
                      padding: EdgeInsets.only(bottom: 8.width),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 60.width,
                            alignment: Alignment.center,
                            color: ColorUtils.fromHex("#1A7685A2"),
                            padding: EdgeInsets.symmetric(horizontal: 10.width),
                            child: Text(
                              walletName,
                              style: TextStyle(
                                fontSize: 20.font,
                                fontWeight: FontWeightUtils.medium,
                                color: ColorUtils.fromHex("#FF000000"),
                              ),
                            ),
                          ),
                          Container(
                            width: 170.width,
                            margin: EdgeInsets.only(top: 50.width),
                            child: QrImage(
                              data: qrCodeStr,
                              size: 170.width,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 32.width),
                            height: 0.5,
                            color: ColorUtils.lineColor,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin:
                                EdgeInsets.only(left: 16.width, top: 10.width),
                            child: Text(
                              "transferetype_receiveaddress".local(),
                              style: TextStyle(
                                color: ColorUtils.fromHex("#66000000"),
                                fontSize: 13.font,
                                fontWeight: FontWeightUtils.regular,
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              qrCodeStr.copy();
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 16.width,
                                  right: 16.width,
                                  top: 4.width),
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                maxLines: 3,
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  text: qrCodeStr,
                                  style: TextStyle(
                                    color: ColorUtils.fromHex("#FF000000"),
                                    fontSize: 14.font,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: [
                                    WidgetSpan(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 9.width),
                                        child: LoadAssetsImage(
                                          "icons/icon_copy.png",
                                          width: 16,
                                          height: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
