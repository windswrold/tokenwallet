import 'package:cstoken/component/custom_underline.dart';
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
    _myTabs.add(Tab(text: 'import_prv'.local()));
    _myTabs.add(Tab(text: 'import_memo'.local()));
  }

  Widget _getPageViewWidget(int leadtype) {
    return Container(
      color: Colors.red,
      alignment: Alignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _myTabs.length,
      child: CustomPageView(
        hiddenLeading: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.width),
          child: Material(
            color: Colors.transparent,
            child: Theme(
              data: ThemeData(
                  splashColor: Color.fromRGBO(0, 0, 0, 0),
                  highlightColor: Color.fromRGBO(0, 0, 0, 0)),
              child: TabBar(
                tabs: _myTabs,
                // isScrollable: true,
                // indicator: CustomUnderlineTabIndicator(),
                indicatorWeight: 1,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.black,
                onTap: (value) {
                  // _changeLeadType(value);
                },
              ),
            ),
          ),
        ),
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(), //禁止左右滑动
          children: _myTabs.map((Tab tab) {
            return _getPageViewWidget(1);
          }).toList(),
        ),
      ),
    );
  }
}
