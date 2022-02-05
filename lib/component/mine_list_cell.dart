import 'package:flutter/material.dart';

import '../public.dart';

class MineListViewCell extends StatelessWidget {
  const MineListViewCell(
      {Key? key,
      required this.leftTitle,
      required this.iconName,
      this.content,
      this.onTap})
      : super(key: key);
  final String leftTitle;
  final String iconName;
  final String? content;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.width),
        child: Column(
          children: [
            Container(
              height: 55.width,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      LoadAssetsImage(
                        iconName,
                        width: 24,
                        height: 24,
                      ),
                      8.rowWidget,
                      Text(
                        leftTitle,
                        style: TextStyle(
                          color: ColorUtils.fromHex("#FF000000"),
                          fontWeight: FontWeightUtils.regular,
                          fontSize: 16.font,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        content ?? '',
                        style: TextStyle(
                          color: ColorUtils.fromHex("#66000000"),
                          fontWeight: FontWeightUtils.regular,
                          fontSize: 13.font,
                        ),
                      ),
                      8.rowWidget,
                      LoadAssetsImage(
                        "icons/icon_arrow_right.png",
                        width: 16,
                        height: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: ColorUtils.lineColor,
              height: 0.5,
              margin: EdgeInsets.only(left: 32.width),
            ),
          ],
        ),
      ),
    );
  }
}
