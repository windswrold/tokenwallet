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
    dappTap(context, DAppRecordsDBModel(url: jumpLinks));
  }

  void dappTap(BuildContext context, DAppRecordsDBModel model) {
    LogUtil.v("dappTap  ");
    bool isAuthorization = SPManager.getDappAuthorization(model.url ?? "");
    if (isAuthorization == false) {
      ShowCustomAlert.showCustomAlertType(
          context, KAlertType.text, "dapppage_nextjump".local(), null,
          subtitleText: "dapppage_warningtip"
              .local(namedArgs: {"dappName": model.name ?? ""}),
          leftButtonTitle: "dapppage_stop".local(),
          rightButtonTitle: "dapppage_iknowit".local(),
          rightButtonStyle: TextStyle(
            color: ColorUtils.blueColor,
            fontSize: 16.font,
          ), confirmPressed: (result) {
        SPManager.setDappAuthorization(model.url ?? "");
        Routers.push(context, DappBrowser(model: model));
      });
      return;
    }
    Routers.push(context, DappBrowser(model: model));
  }

  void getDataOnRefresh() {
    getBannerData();
    getdappType();
  }

  void getDataOnLoading() {}
}
