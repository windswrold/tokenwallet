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

  void bannerTap(BuildContext context, String jumpLinks) {
    LogUtil.v("bannerTap  $jumpLinks");
    dappTap(context, DAppRecordsDBModel(url: jumpLinks));
  }

  ///先判断是否授权
  ///没有cointype 弹窗手动选链
  ///有则继续找数据
  Future<void> dappTap(BuildContext context, DAppRecordsDBModel model,
      {int? dappType}) async {
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
        _queryCoinType(context, model, dappType: dappType);
      });
      return;
    }
    _queryCoinType(context, model, dappType: dappType);
  }

  void _queryCoinType(BuildContext context, DAppRecordsDBModel model,
      {int? dappType}) {
    if (dappType != null) {
      if (dappType < 0) return;
      int dAppType = _myTabs[dappType]["dAppType"] ?? 9;
      KCoinType? coinType = dAppType.getDappSuppertCoinType();
      if (coinType == null) {
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (_) {
              return ChainListType(onTap: (KCoinType coinType) {
                _queryWalletInfo(context, model, coinType);
              });
            });
        return;
      }
      _queryWalletInfo(context, model, coinType);
    } else {
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (_) {
            return ChainListType(onTap: (KCoinType coinType) {
              _queryWalletInfo(context, model, coinType);
            });
          });
    }
  }

  void _queryWalletInfo(BuildContext context, DAppRecordsDBModel model,
      KCoinType coinType) async {
    TRWallet wallet =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet!;
    List<TRWalletInfo> infos =
        await wallet.queryWalletInfos(coinType: coinType);
    if (infos.isEmpty) {
      HWToast.showText(text: "dapppage_chooseright".local());
      return;
    }
    NodeModel node = NodeModel.queryNodeByChainType(coinType.index);
    LogUtil.v(
        "dapp address ${infos.first.walletAaddress} chain ${node.content}");
    Routers.push(
        context, DappBrowser(model: model, info: infos.first, node: node));
  }

  void getDataOnRefresh() {
    getBannerData();
    getdappType();
  }

  void getDataOnLoading() {}
}
