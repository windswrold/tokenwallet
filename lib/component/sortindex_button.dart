import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../public.dart';

class SortIndexButton extends StatelessWidget {
  const SortIndexButton({Key? key, required this.index, required this.value})
      : super(key: key);
  final int index;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            index.toString(),
            style: TextStyle(
              fontSize: 24.font,
              fontWeight: FontWeightUtils.medium,
              color: ColorUtils.fromHex("#0D000000"),
            ),
          ),
        ),
      ],
    );
  }
}

class SortIndexView extends StatelessWidget {
  const SortIndexView(
      {Key? key, required this.memos, required this.offsetWidth})
      : super(key: key);

  final List<String> memos;
  final double offsetWidth;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double _screenWidth = mediaQuery.size.width;
    double _paddingWidth = 16.width;
    double itemWidth = (_screenWidth - offsetWidth - _paddingWidth * 4) / 3;

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(_paddingWidth),
      margin: EdgeInsets.only(top: _paddingWidth),
      decoration: BoxDecoration(
        color: ColorUtils.fromHex("#FFF6F8FF"),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Wrap(
        spacing: _paddingWidth,
        runSpacing: 13.width,
        children: memos
            .map(
              (e) => Container(
                  height: 40.width,
                  width: itemWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                  child: SortIndexButton(index: memos.indexOf(e), value: e)),
            )
            .toList(),
      ),
    );
  }
}
