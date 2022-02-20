import 'package:cstoken/component/custom_refresher.dart';
import 'package:cstoken/component/custom_underline.dart';
import 'package:cstoken/component/empty_data.dart';
import 'package:cstoken/component/news_cell.dart';
import 'package:cstoken/model/news/news_model.dart';
import 'package:cstoken/net/wallet_services.dart';
import 'package:cstoken/pages/news/letter_news.dart';
import 'package:cstoken/pages/news/nft_news.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../public.dart';

class NewsPage extends StatefulWidget {
  NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int _currentPage = 0;
  Map<int, List<NewsModel>>? _datas = {};
  RefreshController _refreshController = RefreshController();
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _initData(_page);
  }

  void _initData(int page) async {
    _page = page;
    Future.delayed(Duration(seconds: 2)).then((value) => {
          _refreshController.refreshCompleted(),
          _refreshController.loadComplete(),
        });
    List<NewsModel> result = [];
    if (_currentPage == 0) {
      result = await WalletServices.getnftnews(_page, 20);
    } else {
      result = await WalletServices.getlettersnews(_page, 20);
    }
    setState(() {
      if (page == 1) {
        _datas?[_currentPage]?.clear();
      }
      _datas?[_currentPage]?.addAll(result);
    });
  }

  Widget _getPageViewWidget(Tab leadtype) {
    return _datas?[_currentPage]?.length == 0
        ? EmptyDataPage()
        : ListView.builder(
            itemCount: _datas?[_currentPage]?.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              LogUtil.v("object $_currentPage ${_datas?.length} index $index");
              NewsModel? model = _datas?[_currentPage]?[index];
              return NewsCell(model: model!);
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context);
    return DefaultTabController(
      length: 2,
      child: CustomPageView(
        hiddenLeading: true,
        title: Material(
          color: Colors.transparent,
          child: Theme(
            data: ThemeData(
                splashColor: const Color.fromRGBO(0, 0, 0, 0),
                highlightColor: const Color.fromRGBO(0, 0, 0, 0)),
            child: TabBar(
              tabs: [
                Tab(text: "newspage_title".local(context: context)),
                Tab(text: 'newspage_common'.local(context: context)),
              ],
              isScrollable: true,
              indicator: const CustomUnderlineTabIndicator(
                  gradientColor: [ColorUtils.blueColor, ColorUtils.blueColor]),
              indicatorWeight: 4,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: ColorUtils.fromHex("#FF000000"),
              labelStyle: TextStyle(
                fontSize: 18.font,
                fontWeight: FontWeightUtils.semiBold,
              ),
              unselectedLabelColor: ColorUtils.fromHex("#99000000"),
              unselectedLabelStyle: TextStyle(
                fontSize: 18.font,
                fontWeight: FontWeightUtils.regular,
              ),
              onTap: (value) {
                // LogUtil.v("onTap $value");
                // _currentPage = value;
                // _initData(1);
              },
            ),
          ),
        ),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(), //禁止左右滑动
          children: [NFTNewsPage(), LetterNewsPage()],
        ),
      ),
    );
  }
}
