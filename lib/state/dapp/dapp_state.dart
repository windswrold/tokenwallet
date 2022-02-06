import 'package:cstoken/net/wallet_services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../public.dart';

class DappDataState extends ChangeNotifier {
  List _bannerData = [{}, {}];
  List get bannerData => _bannerData;

  List<Tab> _myTabs = [];
  List<Tab> get myTabs => _myTabs;

  RefreshController refreshController = RefreshController(initialRefresh: true);

  void getBannerData() {
    WalletServices.getdappbannerInfo();
  }

  void getDataOnRefresh() {
    getBannerData();
    refreshController.loadComplete();
    refreshController.refreshCompleted(resetFooterState: true);
  }

  void getDataOnLoading() {
    refreshController.loadComplete();
    refreshController.refreshCompleted(resetFooterState: true);
  }
}
