import 'package:cstoken/component/chain_listtype.dart';
import 'package:cstoken/model/dapps_record/dapps_record.dart';
import 'package:cstoken/model/node/node_model.dart';
import 'package:cstoken/model/wallet/tr_wallet_info.dart';
import 'package:cstoken/net/wallet_services.dart';
import 'package:cstoken/pages/browser/dapp_browser.dart';
import 'package:cstoken/utils/custom_toast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../public.dart';

class DappDataState extends ChangeNotifier {
  List _bannerData = [];
  List get bannerData => _bannerData;
  List _myTabs = [];
  List<Tab> get myTabs =>
      _myTabs.map((e) => Tab(text: e["dAppTypeName"] ?? '')).toList();

  void getBannerData() async {
    _bannerData = await WalletServices.getdappbannerInfo();
    notifyListeners();
  }

  void getdappType() async {
    _myTabs = await WalletServices.getdappType();

    notifyListeners();
  }

  Future<List<DAppRecordsDBModel>> getdappListData(int index) async {
    LogUtil.v("getdappListData  $index");
    if (index < 0) {
      return [];
    }
    final dAppType = _myTabs[index]["dAppType"] ?? "1";
    List result = await WalletServices.getdapptypeList(dAppType.toString());
    List<DAppRecordsDBModel> _datas = [];
    for (var item in result) {
      final title = item["title"] ?? "";
      final introduction = item["introduction"] ?? "";
      final jumpLinks = item["jumpLinks"] ?? "";
      final logoUrl = item["logoUrl"] ?? "";
      final marketId = item["marketId"] ?? "1";
      DAppRecordsDBModel mdoel = DAppRecordsDBModel(
          url: jumpLinks,
          name: title,
          imageUrl: logoUrl,
          description: introduction,
          marketId: marketId.toString());
      _datas.add(mdoel);
    }
    return _datas;
  }

  KCoinType? getCoinTypeWithDappType(int dappType) {
    if (dappType < 0) return null;
    int dAppType = _myTabs[dappType]["dAppType"] ?? 9;
    KCoinType? coinType = dAppType.getDappSuppertCoinType();
    return coinType;
  }

  void getDataOnRefresh() {
    getBannerData();
    getdappType();
  }

  void getDataOnLoading() {}
}
