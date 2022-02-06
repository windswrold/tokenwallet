import 'package:cstoken/component/custom_underline.dart';
import 'package:cstoken/component/news_cell.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../public.dart';

class NewsPage extends StatefulWidget {
  NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<Tab> _myTabs = [];

  @override
  void initState() {
    super.initState();
    _myTabs.add(Tab(text: 'NFT'));
    _myTabs.add(Tab(text: 'newspage_common'.local()));
  }

  Widget _getPageViewWidget(Tab leadtype) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return NewsCell();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context);
    return DefaultTabController(
      length: _myTabs.length,
      child: CustomPageView(
        hiddenLeading: true,
        title: Material(
          color: Colors.transparent,
          child: Theme(
            data: ThemeData(
                splashColor: const Color.fromRGBO(0, 0, 0, 0),
                highlightColor: const Color.fromRGBO(0, 0, 0, 0)),
            child: TabBar(
              tabs: _myTabs,
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
                // _onTap(value);
              },
            ),
          ),
        ),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(), //禁止左右滑动
          children: _myTabs.map((Tab tab) {
            return _getPageViewWidget(tab);
          }).toList(),
        ),
      ),
    );
  }
}
