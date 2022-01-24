import 'package:cstoken/component/custom_image.dart';
import 'package:cstoken/component/custom_pageview.dart';
import 'package:flutter/material.dart';

import '../../public.dart';

class HomeTabbar extends StatefulWidget {
  HomeTabbarState createState() => HomeTabbarState();
}

class HomeTabbarState extends State<HomeTabbar> {
  int currentIndex = 0;

  get items => [
        BottomNavigationBarItem(
            icon: LoadAssetsImage("tabbar/tab_home_normal.png",
                width: 24, height: 24),
            activeIcon:
                LoadAssetsImage("tabbar/tab_home.png", width: 24, height: 24),
            label: "tabbar_home".local()),
        BottomNavigationBarItem(
            icon: LoadAssetsImage("tabbar/tab_wallet_normal.png",
                width: 24, height: 24),
            activeIcon:
                LoadAssetsImage("tabbar/tab_wallet.png", width: 24, height: 24),
            label: "tabbar_wallet".local()),
        BottomNavigationBarItem(
            icon: LoadAssetsImage("tabbar/tab_apps_normal.png",
                width: 24, height: 24),
            activeIcon:
                LoadAssetsImage("tabbar/tab_apps.png", width: 24, height: 24),
            label: "tabbar_dapp".local()),
        BottomNavigationBarItem(
            icon: LoadAssetsImage("tabbar/tab_news_normal.png",
                width: 24, height: 24),
            activeIcon:
                LoadAssetsImage("tabbar/tab_news.png", width: 24, height: 24),
            label: "tabbar_news".local()),
        BottomNavigationBarItem(
            icon: LoadAssetsImage("tabbar/tab_mine_normal.png",
                width: 24, height: 24),
            activeIcon:
                LoadAssetsImage("tabbar/tab_mine.png", width: 24, height: 24),
            label: "tabbar_mine".local()),
      ];

  List<Widget> bodyList = [Container(), Container(), Container()];

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
        hiddenScrollView: true,
        hiddenAppBar: true,
        safeAreaTop: false,
        hiddenLeading: true,
        bottomNavigationBar: Theme(
            data: ThemeData(
                splashColor: Color.fromRGBO(0, 0, 0, 0),
                highlightColor: Color.fromRGBO(0, 0, 0, 0)),
            child: BottomNavigationBar(
              items: items,
              currentIndex: currentIndex,
              onTap: onTap,
              elevation: 8,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeightUtils.medium,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeightUtils.medium,
              ),
              selectedItemColor: Color(0xffFF0080FF),
              unselectedItemColor: Color(0xffFF909DB2),
              selectedFontSize: 9.font,
              unselectedFontSize: 9.font,
            )),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            IndexedStack(
              index: currentIndex,
              children: bodyList,
            ),
          ],
        ));
  }
}
