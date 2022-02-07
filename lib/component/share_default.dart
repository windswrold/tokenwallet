import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../public.dart';

class ShareDefaultWidget extends StatelessWidget {
  const ShareDefaultWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.width,
      alignment: Alignment.center,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.width),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadAssetsImage(
                "bg/icon_applogo.png",
                height: 33,
                // width: 150,
              ),
              10.columnWidget,
              Container(
                color: ColorUtils.fromHex("#1C7685A2"),
                child: Text(
                  "CSToken",
                  style: TextStyle(
                    color: ColorUtils.fromHex("#BA0B0D10"),
                    fontSize: 11.font,
                    fontWeight: FontWeightUtils.regular,
                  ),
                ),
              ),
            ],
          ),
          QrImage(
            data: "aaaaa",
            size: 80.width,
          )
        ],
      ),
    );
  }
}