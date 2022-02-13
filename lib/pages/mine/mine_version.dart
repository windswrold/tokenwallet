import 'package:cstoken/net/wallet_services.dart';
import 'package:cstoken/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:share_plus/share_plus.dart';

import '../../public.dart';

class MineVersion extends StatefulWidget {
  MineVersion({Key? key}) : super(key: key);

  @override
  State<MineVersion> createState() => _MineVersionState();
}

class _MineVersionState extends State<MineVersion> {
  String _version = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData();
  }

  void _initData() async {
    final PackageInfo appInfo = await PackageInfo.fromPlatform();
    String appversion = appInfo.version;
    setState(() {
      _version = appversion;
    });
  }

  void _getLastversion() async {
    HWToast.showLoading();
    Map? result = await WalletServices.getAppversion(_version);
    HWToast.hiddenAllToast();
    if (result == null) {
      return;
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: CustomPageView.getTitle(title: "minepage_version".local()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 160.width),
            child: LoadAssetsImage(
              "bg/icon_applogo.png",
              width: 112,
              height: 112,
            ),
          ),
          Text(
            "CSToken",
            style: TextStyle(
              color: ColorUtils.fromHex("#FF000000"),
              fontSize: 24.font,
              fontWeight: FontWeightUtils.semiBold,
            ),
          ),
          4.columnWidget,
          Text(
            "minepage_version".local() + _version,
            style: TextStyle(
              color: ColorUtils.fromHex("#FF000000"),
              fontSize: 16.font,
              fontWeight: FontWeightUtils.regular,
            ),
          ),
          Expanded(
              child: Center(
                  child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _getLastversion();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorUtils.blueBGColor,
              ),
              padding:
                  EdgeInsets.symmetric(horizontal: 28.width, vertical: 8.width),
              child: Text(
                "minepage_checkversion".local(),
                style: TextStyle(
                  fontSize: 14.font,
                  fontWeight: FontWeightUtils.medium,
                  color: ColorUtils.blueColor,
                ),
              ),
            ),
          ))),
        ],
      ),
    );
  }
}
