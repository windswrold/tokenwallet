import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../public.dart';

class ChooseChainType extends StatelessWidget {
  const ChooseChainType({Key? key, this.padding}) : super(key: key);

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 0),
            child: Text(
              "importwallet_chaintype".local(),
              style: TextStyle(
                fontSize: 14.font,
                fontWeight: FontWeightUtils.medium,
                color: ColorUtils.fromHex("#99000000"),
              ),
            ),
          ),
          Container(
            height: 44.width,
            alignment: Alignment.centerLeft,
            child: Text(
              "ETH,Heco,BSC",
              style: TextStyle(
                fontSize: 14.font,
                fontWeight: FontWeightUtils.medium,
                color: ColorUtils.fromHex("#FF000000"),
              ),
            ),
          ),
          Container(
            height: 0.5,
            color: ColorUtils.lineColor,
          ),
        ],
      ),
    );
    ;
  }
}
