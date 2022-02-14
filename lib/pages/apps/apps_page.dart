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

  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData();
  }

  void _initData() {
    _kdataState.getDataOnRefresh();
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
            Expanded(
              child: _bodyListView(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getChildren(List<Tab> tabs) {
    List<Widget> datass = [];
    for (var i = 0; i < tabs.length; i++) {
      datass.add(AppsContentPage(
          dappTap: (DAppRecordsDBModel model, int type) {
            KCoinType? coinType = _kdataState.getCoinTypeWithDappType(type);
            Provider.of<CurrentChooseWalletState>(context, listen: false)
                .dappTap(context, model, coinType: coinType);
          },
          type: i));
    }
    return datass;
  }

  Widget _bodyListView() {
    return Column(
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
                                  splashColor: const Color.fromRGBO(0, 0, 0, 0),
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
                                onTap: (value) {},
                              ),
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              physics:
                                  const NeverScrollableScrollPhysics(), //禁止左右滑动
                              children: _getChildren(_kdataState.myTabs),
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          },
        ),
      ],
    );
  }
}
