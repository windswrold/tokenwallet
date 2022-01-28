import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import '../public.dart';

class SortViewItem {
  String value;
  bool? select;
  bool? isWrong;
  final int index;
  int? bottomIndex;
  SortViewItem(
      {required this.value, this.select, this.isWrong, required this.index});
}

class SortIndexButton extends StatelessWidget {
  const SortIndexButton(
      {Key? key,
      required this.item,
      required this.width,
      required this.height,
      required this.type,
      required this.onTap})
      : super(key: key);
  final SortViewItem item;
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
              item.value,
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
              (item.index + 1).toString(),
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
        onTap(item.index);
      },
      child: Container(
        height: height + 8.width,
        width: width,
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
                border: item.isWrong == true
                    ? Border.all(
                        color: ColorUtils.fromHex("#FFFF233E"),
                      )
                    : null,
              ),
              child: item.value.isEmpty
                  ? AutoSizeText(
                      (item.index + 1).toString(),
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
                      item.value,
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
            Visibility(
              visible: item.isWrong == true,
              child: Positioned(
                top: 0,
                right: 0,
                child: LoadAssetsImage(
                  "icons/icon_redclose.png",
                  width: 16,
                  height: 16,
                ),
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
          onTap(item.index);
        },
        child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: item.select == true
                  ? ColorUtils.fromHex("#0D000000")
                  : Colors.white,
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
                    item.value,
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
