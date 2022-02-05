import 'package:cstoken/component/custom_underline.dart';
import 'package:cstoken/component/systemmessage_cell.dart';
import 'package:cstoken/component/transfermessage_cell.dart';
import 'package:flutter/material.dart';

import '../../public.dart';

class MineMessagePage extends StatefulWidget {
  MineMessagePage({Key? key}) : super(key: key);

  @override
  State<MineMessagePage> createState() => _MineMessagePageState();
}

class _MineMessagePageState extends State<MineMessagePage> {
  final List<Tab> _myTabs = [
    Tab(text: 'minepage_systemmessage'.local()),
    Tab(text: 'minepage_transfermessage'.local())
  ];

  @override
  Widget _getPageViewWidget(Tab leadtype) {
    int lead = _myTabs.indexOf(leadtype);
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) {
        return lead == 0 ? SystemMessageCell() : TransferMessageCell();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _myTabs.length,
      child: CustomPageView(
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
