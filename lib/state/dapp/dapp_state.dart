import 'package:cstoken/model/dapps_record/dapps_record.dart';
import 'package:cstoken/net/wallet_services.dart';
import 'package:cstoken/pages/browser/dapp_browser.dart';
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
    //"title": "SWFT闪兑",
    // "introduction": "多鏈幣種一鍵跨鏈閃兌",
    // "jumpLinks": "https://defi.swft.pro/?sourceFlag=Consensus",
    // "logoUrl": "https://token-new.oss-cn-shenzhen.aliyuncs.com/CONSENSUS/pics/swft.png",
    // "marketId": 1
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
    // Future.delayed(Duration(seconds: 1)).then((value) => {
    //       notifyListeners(),
    //     });
  }

  void bannerTap(BuildContext context, String jumpLinks) {
    LogUtil.v("bannerTap  $jumpLinks");

    Routers.push(
        context, DappBrowser(model: DAppRecordsDBModel(url: jumpLinks)));
  }

  void dappTap(BuildContext context, DAppRecordsDBModel model) {
    LogUtil.v("dappTap  ");
    Routers.push(context, DappBrowser(model: model));
  }

  void getDataOnRefresh() {
    getBannerData();
    getdappType();
  }

  void getDataOnLoading() {}
}
