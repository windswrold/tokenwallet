import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

import '../public.dart';

class NewsCell extends StatelessWidget {
  const NewsCell({Key? key}) : super(key: key);

  Widget _buildTime() {
    return Container(
      // padding: EdgeInsets.only(top: 25.width),
      // decoration: BoxDecoration(
      //     border: Border(
      //         left: BorderSide(
      //   width: 0.5,
      //   color: ColorUtils.lineColor,
      // ))),
      child: Stack(
        children: [
          ClipOval(
            child: Container(
              width: 6.5,
              height: 6.5,
              color: ColorUtils.blueColor,
            ),
          ),
          Positioned(
            left: 3,
            child: Container(
              width: 0.5,
              height: 100,
              color: ColorUtils.redColor,
            ),
          ),

          Text(
            "21:12",
            style: TextStyle(
              color: ColorUtils.fromHex("#FF000000"),
              fontSize: 12.font,
              fontWeight: FontWeightUtils.regular,
            ),
          ),
          // Text(
          //   "21:123",
          //   style: TextStyle(
          //     color: ColorUtils.fromHex("#FF000000"),
          //     fontSize: 12.font,
          //     fontWeight: FontWeightUtils.regular,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _builTitle() {
    return Container(
      padding: EdgeInsets.only(top: 8.width, left: 12.width),
      margin: EdgeInsets.only(left: 3),
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
        width: 0.5,
        color: ColorUtils.lineColor,
      ))),
      child: Text(
        "SumSwap模拟Staking奖励将于2021年6月9日增长至3倍",
        style: TextStyle(
          color: ColorUtils.fromHex("#FF000000"),
          fontSize: 16.font,
          fontWeight: FontWeightUtils.semiBold,
        ),
      ),
    );
  }

  Widget _builContent() {
    return Container(
      padding: EdgeInsets.only(top: 16.width, left: 12.width),
      margin: EdgeInsets.only(left: 3),
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
        width: 0.5,
        color: ColorUtils.lineColor,
      ))),
      child: Text(
        "据官方消息，SumSwap模拟Staking奖励将于6月9日由原来每天产出512枚SUM增长至3倍，即每日产出1536枚SUM。模拟Staking是SumSwap为了让用户理解正式Staking的精妙设计而对正式Staking的而对正式Staking的",
        style: TextStyle(
          color: ColorUtils.fromHex("#99000000"),
          fontSize: 14.font,
          fontWeight: FontWeightUtils.regular,
        ),
      ),
    );
  }

  Widget _builfromTypeAndShare() {
    return Container(
      padding: EdgeInsets.only(top: 16.width, left: 12.width),
      margin: EdgeInsets.only(left: 3),
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
        width: 0.5,
        color: ColorUtils.lineColor,
      ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 20.width,
            padding: EdgeInsets.only(left: 4.width, right: 4.width),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: ColorUtils.fromHex("#FFB2BBC9"),
                  width: 0.5,
                )),
            child: Text(
              "星球日报",
              style: TextStyle(
                color: ColorUtils.fromHex("#FF909DB2"),
                fontSize: 12.font,
                fontWeight: FontWeightUtils.regular,
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Share.share("text");
            },
            child: SizedBox(
              width: 30,
              height: 30,
              child: Center(
                  child: LoadAssetsImage(
                "icons/icon_share.png",
                width: 16,
                height: 16,
              )),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 18.width, right: 18.width),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTime(),
            _builTitle(),
            _builContent(),
            _builfromTypeAndShare(),
          ],
        ));
  }
}
