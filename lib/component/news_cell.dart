import 'package:cstoken/component/news_share_image.dart';
import 'package:cstoken/model/news/news_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../public.dart';

class NewsCell extends StatelessWidget {
  const NewsCell({Key? key, required this.model}) : super(key: key);
  final NewsModel model;

  Widget _buildTime() {
    String date = model.createTime ?? "";
    return Container(
      child: Stack(
        children: [
          Positioned(
            left: 3,
            child: Container(
              width: 0.5,
              height: 100,
              color: ColorUtils.lineColor,
            ),
          ),
          ClipOval(
            child: Container(
              width: 6.5,
              height: 6.5,
              color: ColorUtils.blueColor,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15.width),
            child: Text(
              date,
              style: TextStyle(
                color: ColorUtils.fromHex("#FF000000"),
                fontSize: 12.font,
                fontWeight: FontWeightUtils.regular,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _builTitle() {
    String title = model.title ?? "";
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
        title,
        style: TextStyle(
          color: ColorUtils.fromHex("#FF000000"),
          fontSize: 16.font,
          fontWeight: FontWeightUtils.semiBold,
        ),
      ),
    );
  }

  Widget _builContent() {
    String content = model.content ?? "";
    return Container(
      padding: EdgeInsets.only(top: 16.width, left: 12.width),
      margin: const EdgeInsets.only(left: 3),
      decoration: const BoxDecoration(
          border: Border(
              left: BorderSide(
        width: 0.5,
        color: ColorUtils.lineColor,
      ))),
      child: Html(
        // content,
        // style: TextStyle(
        //   color: ColorUtils.fromHex("#99000000"),
        //   fontSize: 14.font,
        //   fontWeight: FontWeightUtils.regular,
        // ),
        data: content,
        onLinkTap: (url, context, attributes, element) {
          if (url == null || url.isEmpty) {
            return;
          }
          launch(url);
        },
      ),
    );
  }

  Widget _builfromTypeAndShare(BuildContext context) {
    String source = model.source ?? "";
    String share = model.content ?? "";
    return Container(
      padding: EdgeInsets.only(top: 16.width, left: 12.width, bottom: 25.width),
      margin: EdgeInsets.only(left: 3),
      decoration: const BoxDecoration(
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
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 4.width, right: 4.width),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: ColorUtils.fromHex("#FFB2BBC9"),
                  width: 0.5,
                )),
            child: Text(
              source,
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
              Routers.push(context, NewsShare(model: model));
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
            _builfromTypeAndShare(context),
          ],
        ));
  }
}
