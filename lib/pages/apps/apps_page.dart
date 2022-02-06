import 'package:cstoken/component/custom_refresher.dart';
import 'package:cstoken/component/custom_underline.dart';
import 'package:cstoken/component/empty_data.dart';
import 'package:cstoken/component/swipe_widget.dart';
import 'package:cstoken/component/top_search_widget.dart';
import 'package:cstoken/state/dapp/dapp_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../public.dart';

class AppsPage extends StatefulWidget {
  AppsPage({Key? key}) : super(key: key);

  @override
  State<AppsPage> createState() => _AppsPageState();
}

class _AppsPageState extends State<AppsPage> {
  DappDataState _kdataState = DappDataState();

  List _imageList = [
    "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.jj20.com%2Fup%2Fallimg%2F1115%2F101021113337%2F211010113337-2-1200.jpg&refer=http%3A%2F%2Fimg.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1646729018&t=247df82bd2d48879131b89e27bce4054",
    "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fnimg.ws.126.net%2F%3Furl%3Dhttp%253A%252F%252Fdingyue.ws.126.net%252F2021%252F0729%252F62439d90j00qwyx3l0023c000hs00vlc.jpg%26thumbnail%3D650x2147483647%26quality%3D80%26type%3Djpg&refer=http%3A%2F%2Fnimg.ws.126.net&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1646729018&t=393ca1e53c62e0abbe38d6466035ce46"
  ];

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context)!.delegates;
    return ChangeNotifierProvider(
      create: (_) => _kdataState,
      child: CustomPageView(
        hiddenAppBar: true,
        hiddenLeading: true,
        child: Column(
          children: [
            const TopSearchView(),
            Expanded(child: _bodyListView()),
          ],
        ),
      ),
    );
  }

  Widget _bodyListView() {
    return CustomRefresher(
        refreshController: _kdataState.refreshController,
        onRefresh: () {
          _kdataState.getDataOnRefresh();
        },
        onLoading: () {
          _kdataState.getDataOnLoading();
        },
        child: Column(
          children: [
            CustomSwipe(imageList: _imageList),
            Expanded(
                child: DefaultTabController(
              length: _kdataState.myTabs.length,
              child: Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: Theme(
                      data: ThemeData(
                          splashColor: const Color.fromRGBO(0, 0, 0, 0),
                          highlightColor: const Color.fromRGBO(0, 0, 0, 0)),
                      child: TabBar(
                        tabs: _kdataState.myTabs,
                        isScrollable: true,
                        indicator: const CustomUnderlineTabIndicator(
                            gradientColor: [
                              ColorUtils.blueColor,
                              ColorUtils.blueColor
                            ]),
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
                  Expanded(
                    child: _kdataState.myTabs.isEmpty
                        ? const EmptyDataPage()
                        : TabBarView(
                            physics:
                                const NeverScrollableScrollPhysics(), //禁止左右滑动
                            children: _kdataState.myTabs.map((Tab tab) {
                              return Text(tab.text!);
                            }).toList(),
                          ),
                  ),
                ],
              ),
            )),
          ],
        ));
  }
}
