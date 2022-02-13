import 'package:flutter/material.dart';

import '../public.dart';

class NoScreentshots extends StatelessWidget {
  const NoScreentshots({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.width),
      height: 340.width,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16.width),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            height: 260.width,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16.width),
                  child: ClipOval(
                    child: Container(
                      width: 80.width,
                      height: 80.width,
                      color: ColorUtils.fromHex("#12FF2F23"),
                      child: Center(
                        child: LoadAssetsImage(
                          "icons/no_screenshots.png",
                          width: 56.width,
                          height: 56.width,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 16.width),
                  child: Text(
                    "dialog_noscreenshots".local(),
                    style: TextStyle(
                      color: ColorUtils.fromHex("#FF000000"),
                      fontSize: 20.font,
                      fontWeight: FontWeightUtils.medium,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 16.width),
                  child: Text(
                    "dialog_noscreenshotstips".local(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorUtils.fromHex("#99000000"),
                      fontSize: 14.font,
                      fontWeight: FontWeightUtils.regular,
                    ),
                  ),
                ),
              ],
            ),
          ),
          NextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onTap();
              },
              margin: EdgeInsets.only(top: 16.width),
              bgc: Colors.white,
              textStyle: TextStyle(
                color: ColorUtils.blueColor,
                fontSize: 16.font,
                fontWeight: FontWeightUtils.medium,
              ),
              title: "dialog_next".local()),
        ],
      ),
    );
  }
}
