import 'package:cstoken/net/wallet_services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../public.dart';

class DappDataState extends ChangeNotifier {
  List _bannerData = [];
  List get bannerData => _bannerData;
  List _myTabs = [];
  List<Tab> get myTabs =>
      _myTabs.map((e) => Tab(text: e["dAppTypeName"] ?? '')).toList();

  RefreshController refreshController = RefreshController(initialRefresh: true);
  
  List _dappListData = [];
  List get dappListData => _dappListData;

  void getBannerData() async {
    _bannerData = await WalletServices.getdappbannerInfo();
    notifyListeners();
  }

  void getdappType() async {
    _myTabs = await WalletServices.getdappType();
    if (_myTabs.isNotEmpty) {
      getdappListData(0);
    }
    notifyListeners();
  }

  void getdappListData(int index) async {
    LogUtil.v("getdappListData  $index");
    final dAppType = _myTabs[index]["dAppType"] ?? "1";
    List data = await WalletServices.getdapptypeList(dAppType.toString());

    notifyListeners();
  }

  void bannerTap(String jumpLinks) {
    LogUtil.v("bannerTap  $jumpLinks");
  }

  void getDataOnRefresh() {
    getBannerData();
    getdappType();
    refreshController.loadComplete();
    refreshController.refreshCompleted(resetFooterState: true);
  }

  void getDataOnLoading() {
    refreshController.loadComplete();
    refreshController.refreshCompleted(resetFooterState: true);
  }
}
