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
            icon: LoadAssetsImage("tabbar/icon_wallet_normal.png",
                width: 24, height: 24),
            activeIcon: LoadAssetsImage("tabbar/icon_wallet_selected.png",
                width: 24, height: 24),
            label: "钱包"),
        BottomNavigationBarItem(
            icon: LoadAssetsImage("tabbar/icon_home_normal.png",
                width: 24, height: 24),
            activeIcon: LoadAssetsImage("tabbar/icon_home_selected.png",
                width: 24, height: 24),
            label: "浏览"),
        BottomNavigationBarItem(
            icon: LoadAssetsImage("tabbar/icon_mine_normal.png",
                width: 24, height: 24),
            activeIcon: LoadAssetsImage("tabbar/icon_mine_selected.png",
                width: 24, height: 24),
            label: "设置"),
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
              selectedFontSize: 10,
              unselectedFontSize: 10,
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
