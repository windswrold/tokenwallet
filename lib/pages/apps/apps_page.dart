import 'package:cstoken/component/custom_refresher.dart';
import 'package:cstoken/component/custom_underline.dart';
import 'package:cstoken/component/dapp_records_cell.dart';
import 'package:cstoken/component/empty_data.dart';
import 'package:cstoken/component/swipe_widget.dart';
import 'package:cstoken/component/top_search_widget.dart';
import 'package:cstoken/model/dapps_record/dapps_record.dart';
import 'package:cstoken/pages/apps/apps_content.dart';
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
          CustomSwipe(),
          Consumer<DappDataState>(
            builder: (_, kprovider, child) {
              return Expanded(
                child: _kdataState.myTabs.isEmpty
                    ? EmptyDataPage()
                    : DefaultTabController(
                        length: _kdataState.myTabs.length,
                        child: Column(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: Theme(
                                data: ThemeData(
                                    splashColor:
                                        const Color.fromRGBO(0, 0, 0, 0),
                                    highlightColor:
                                        const Color.fromRGBO(0, 0, 0, 0)),
                                child: TabBar(
                                  tabs: _kdataState.myTabs,
                                  isScrollable: true,
                                  indicatorColor: ColorUtils.blueColor,
                                  indicatorWeight: 2,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  labelColor: ColorUtils.fromHex("#FF000000"),
                                  labelStyle: TextStyle(
                                    fontSize: 14.font,
                                    fontWeight: FontWeightUtils.semiBold,
                                  ),
                                  unselectedLabelColor:
                                      ColorUtils.fromHex("#99000000"),
                                  unselectedLabelStyle: TextStyle(
                                    fontSize: 14.font,
                                    fontWeight: FontWeightUtils.regular,
                                  ),
                                  onTap: (value) {
                                    _kdataState.getdappListData(value);
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                physics:
                                    const NeverScrollableScrollPhysics(), //禁止左右滑动
                                children: _kdataState.myTabs.map((Tab tab) {
                                  return AppsContentPage(
                                    datas: _kdataState.dappListData,
                                  );
                                  // ListView.builder(
                                  //   itemCount: _kdataState.dappListData.length,
                                  //   itemBuilder: (BuildContext tx, int index) {
                                  //     DAppRecordsDBModel? mdoel;
                                  //     try {
                                  //       mdoel = _kdataState.dappListData
                                  //           .elementAt(index);
                                  //     } catch (e) {}

                                  //     return mdoel == null
                                  //         ? EmptyDataPage()
                                  //         : DAppListCell(
                                  //             model: mdoel,
                                  //             onTap: (DAppRecordsDBModel
                                  //                 tapModel) {
                                  //               _kdataState.dappTap(
                                  //                   context, tapModel);
                                  //             },
                                  //           );
                                  //   },
                                  // );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
