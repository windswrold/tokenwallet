import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../public.dart';

class SortIndexButton extends StatelessWidget {
  const SortIndexButton(
      {Key? key,
      required this.index,
      required this.value,
      required this.width,
      required this.height,
      required this.type,
      required this.onTap})
      : super(key: key);
  final int index;
  final String value;
  final double width;
  final double height;
  final SortIndexType type;

  final Function(int index) onTap;

  Widget _getLeftIndex() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            child: AutoSizeText(
              value,
              maxLines: 1,
              minFontSize: 6,
              style: TextStyle(
                fontSize: 14.font,
                fontWeight: FontWeightUtils.medium,
                color: ColorUtils.fromHex("#CC000000"),
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Text(
              (index + 1).toString(),
              style: TextStyle(
                fontSize: 24.font,
                fontWeight: FontWeightUtils.medium,
                color: ColorUtils.fromHex("#0D000000"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getWrongIndex() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap(index);
      },
      child: Container(
        height: height + 8.width,
        width: width,
        // color: Colors.blue,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              height: height,
              alignment: Alignment.center,
              width: width - 8.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
                border: Border.all(
                  color: ColorUtils.fromHex("#FFFF233E"),
                ),
              ),
              child: value.isEmpty
                  ? AutoSizeText(
                      (index + 1).toString(),
                      maxLines: 1,
                      minFontSize: 6,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.font,
                        fontWeight: FontWeightUtils.medium,
                        color: ColorUtils.fromHex("#0D000000"),
                      ),
                    )
                  : AutoSizeText(
                      value,
                      maxLines: 1,
                      minFontSize: 6,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.font,
                        fontWeight: FontWeightUtils.medium,
                        color: ColorUtils.fromHex("#CC000000"),
                      ),
                    ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: LoadAssetsImage(
                "icons/icon_redclose.png",
                width: 16,
                height: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getNormalIndex() {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          onTap(index);
        },
        child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: ColorUtils.fromHex("#0D000000"),
              border: Border.all(
                color: ColorUtils.fromHex("#1A000000"),
                width: 0.5,
              ),
            ),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Positioned(
                  child: AutoSizeText(
                    value,
                    maxLines: 1,
                    minFontSize: 6,
                    style: TextStyle(
                      fontSize: 14.font,
                      fontWeight: FontWeightUtils.medium,
                      color: ColorUtils.fromHex("#CC000000"),
                    ),
                  ),
                ),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return type == SortIndexType.leftIndex
        ? _getLeftIndex()
        : type == SortIndexType.wrongIndex
            ? _getWrongIndex()
            : _getNormalIndex();
  }
}
