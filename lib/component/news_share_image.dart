import 'package:cstoken/component/share_default.dart';
import 'package:cstoken/model/news/news_model.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';

import '../public.dart';

class NewsShare extends StatefulWidget {
  NewsShare({Key? key, required this.model}) : super(key: key);
  final NewsModel model;

  @override
  State<NewsShare> createState() => _NewsShareState();
}

class _NewsShareState extends State<NewsShare> {
  final _repaintKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _shareImage();
    });
  }

  void _shareImage() async {
    await Future.delayed(Duration(seconds: 1));
    final ok = await shareImage(_repaintKey);
    Share.shareFiles([ok.absolute.path]);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
        child: SingleChildScrollView(
      child: RepaintBoundary(
        key: _repaintKey,
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  LoadAssetsImage("bg/new_sharebg.png"),
                  Text(
                    "CSTOKEN " + "newspage_sharenews".local(),
                    style: TextStyle(
                      fontSize: 24.font,
                      fontWeight: FontWeightUtils.semiBold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 32.width),
                padding: EdgeInsets.symmetric(horizontal: 24.width),
                child: Text(
                  widget.model.createTime ?? "",
                  style: TextStyle(
                    fontSize: 12.font,
                    fontWeight: FontWeightUtils.regular,
                    color: ColorUtils.fromHex("#66000000"),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16.width),
                padding: EdgeInsets.symmetric(horizontal: 24.width),
                child: Text(
                  widget.model.title ?? "",
                  style: TextStyle(
                    fontSize: 16.font,
                    fontWeight: FontWeightUtils.bold,
                    color: ColorUtils.fromHex("#FF000000"),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16.width),
                padding: EdgeInsets.symmetric(horizontal: 24.width),
                child: Html(
                  data: (widget.model.content ?? ''),
                  // style: TextStyle(
                  //   fontSize: 14.font,
                  //   fontWeight: FontWeightUtils.regular,
                  //   color: ColorUtils.fromHex("#FF000000"),
                  // ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16.width),
                padding: EdgeInsets.symmetric(horizontal: 24.width),
                child: Text(
                  "newspage_sharenewssouce".local() +
                      "：" +
                      (widget.model.source ?? ''),
                  style: TextStyle(
                    fontSize: 12.font,
                    fontWeight: FontWeightUtils.regular,
                    color: ColorUtils.fromHex("#66000000"),
                  ),
                ),
              ),
              69.columnWidget,
              ShareDefaultWidget(),
            ],
          ),
        ),
      ),
    ));
  }
}
