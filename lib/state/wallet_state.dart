import 'dart:async';

import 'package:cstoken/component/chain_listtype.dart';
import 'package:cstoken/model/dapps_record/dapps_record.dart';
import 'package:cstoken/model/node/node_model.dart';
import 'package:cstoken/model/token_price/tokenprice.dart';
import 'package:cstoken/model/tokens/collection_tokens.dart';
import 'package:cstoken/model/transrecord/trans_record.dart';
import 'package:cstoken/model/wallet/tr_wallet.dart';
import 'package:cstoken/model/wallet/tr_wallet_info.dart';
import 'package:cstoken/net/chain_services.dart';
import 'package:cstoken/net/wallet_services.dart';
import 'package:cstoken/pages/browser/dapp_browser.dart';
import 'package:cstoken/pages/wallet/create/backup_tip_memo.dart';
import 'package:cstoken/pages/wallet/create/create_wallet_page.dart';
import 'package:cstoken/pages/wallet/transfer/receive_page.dart';
import 'package:cstoken/pages/wallet/transfer/transfer_list.dart';
import 'package:cstoken/pages/wallet/transfer/transfer_payment.dart';
import 'package:cstoken/pages/wallet/wallets/wallets_setting.dart';
import 'package:cstoken/utils/custom_toast.dart';
import 'package:cstoken/utils/sp_manager.dart';
import 'package:cstoken/utils/timer_util.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import '../public.dart';

class CurrentChooseWalletState with ChangeNotifier {
  TRWallet? _currentWallet;
  KCurrencyType? _currencyType;
  TRWallet? get currentWallet => _currentWallet;
  KCurrencyType? get currencyType => _currencyType;
  String get currencySymbolStr =>
      _currencyType == KCurrencyType.CNY ? "￥" : "\$";

  Map<String, Map> _nftIndexInfo = {};
  Map? get nftIndexInfo =>
      _currentWallet == null ? null : _nftIndexInfo[_currentWallet?.walletID];
  Map<String?, String> _totalAssets = {}; //总资产数额

  Map<String?, List<MCollectionTokens>> _tokens = {};
  List<MCollectionTokens> get tokens =>
      _currentWallet == null ? [] : _tokens[_currentWallet?.walletID] ?? [];
  KCoinType? _chooseChainType;
  String get chooseChain => _chooseChainType == null
      ? "walletmanager_asset_all".local()
      : _chooseChainType!.coinTypeString();

  TimerUtil? _timer;
  int _tokenIndex = 0;
  TRWalletInfo? _walletinfo;
  TRWalletInfo? get walletinfo => _walletinfo;

  MCollectionTokens? chooseTokens() {
    if (tokens.length > _tokenIndex) {
      return tokens[_tokenIndex];
    } else {
      LogUtil.v("chooseTokens越界");
      assert(false, "chooseTokens越界");
      return null;
    }
  }

  String? totalAssets() {
    if (_currentWallet == null) {
      return "0.00";
    }
    if (_currentWallet!.hiddenAssets == true) {
      return "****";
    }
    return _totalAssets[_currentWallet?.walletID] ?? "0.00";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  Future<TRWallet?> loadWallet() async {
    _chooseChainType = null;
    _tokenIndex = 0;
    _currentWallet = await TRWallet.queryChooseWallet();
    _currencyType = SPManager.getAppCurrencyMode();
    initNFTIndex();
    requestAssets();
    _configTimerRequest();
    notifyListeners();
    return _currentWallet;
  }

  void initNFTIndex() async {
    if (_currentWallet == null) {
      return;
    }
    String? ethAdress;
    String? chainType;
    List<TRWalletInfo> infos =
        await _currentWallet!.queryWalletInfos(coinType: KCoinType.ETH);
    if (infos.isEmpty) {
      return;
    }
    ethAdress = infos.first.walletAaddress;
    chainType = infos.first.coinType!.geCoinType().coinTypeString();
    if (ethAdress == null) {
      return;
    }
    Map? result = await WalletServices.getindexnftInfo(ethAdress, chainType);
    if (result == null) {
      return;
    }
    _nftIndexInfo[_currentWallet!.walletID!] = result;
    notifyListeners();
  }

  void updateCurrencyType(KCurrencyType kCurrencyType) {
    _currencyType = kCurrencyType;
    SPManager.setAppCurrency(kCurrencyType);
    LogUtil.v("updateCurrencyType $kCurrencyType");
    requestAssets();
  }

  void bannerTap(BuildContext context, String jumpLinks) {
    LogUtil.v("bannerTap  $jumpLinks");
    dappTap(context, DAppRecordsDBModel(url: jumpLinks));
  }

  ///先判断是否授权
  ///没有cointype 弹窗手动选链
  ///有则继续找数据
  Future<void> dappTap(BuildContext context, DAppRecordsDBModel model,
      {KCoinType? coinType}) async {
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
        _queryCoinType(context, model, coinType: coinType);
      });
      return;
    }
    _queryCoinType(context, model, coinType: coinType);
  }

  void _queryCoinType(BuildContext context, DAppRecordsDBModel model,
      {KCoinType? coinType}) {
    if (coinType != null) {
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
    TRWallet? wallet =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet;
    if (wallet == null) {
      HWToast.showText(text: "minepage_pleasecreate".local());
      return;
    }
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

  void assetsHidden(BuildContext context) async {
    LogUtil.v("assetsHidden");
    if (_currentWallet == null) {
      return;
    }
    _currentWallet =
        await TRWallet.queryWalletByWalletID(_currentWallet!.walletID!);
    _currentWallet!.hiddenAssets = (_currentWallet!.hiddenAssets == null ||
            _currentWallet!.hiddenAssets == false)
        ? true
        : false;
    TRWallet.updateWallet(_currentWallet!);
    notifyListeners();
  }

  void tapHelper(BuildContext context, KCoinType? coinType) {
    LogUtil.v("_tapHelper");
    if (_currentWallet == null) {
      return;
    }
    _chooseChainType = coinType;
    queryMyCollectionTokens();
    // showModalBottomSheet(
    //     context: context,
    //     backgroundColor: Colors.transparent,
    //     isScrollControlled: true,
    //     builder: (_) {
    //       return ChainListType(onTap: (KCoinType coinType) async {
    //         _chooseChainType = coinType;
    //         queryMyCollectionTokens();
    //       });
    //     });
  }

  void tapWalletSetting(BuildContext context) {
    LogUtil.v("assetsHidden");
    if (_currentWallet == null) {
      HWToast.showText(text: "minepage_pleasecreate".local());
      return;
    }
    Routers.push(context, WalletsSetting(wallet: _currentWallet!));
  }

  Future<bool> updateChoose(BuildContext context,
      {required TRWallet wallet}) async {
    List<TRWallet> wallets = await TRWallet.queryAllWallets();
    for (var item in wallets) {
      item.isChoose = false;
      if (wallet.walletID == item.walletID) {
        item.isChoose = true;
        _currentWallet = item;
      }
    }
    _chooseChainType = null;
    _tokenIndex = 0;
    TRWallet.updateWallets(wallets);
    initNFTIndex();
    requestAssets();
    notifyListeners();
    return true;
  }

  void updateTokenChoose(BuildContext context, int index,
      {bool pushTransList = true}) async {
    _tokenIndex = index;

    final String walletID = _currentWallet!.walletID!;
    TRWalletInfo infos = (await TRWalletInfo.queryWalletInfo(
            walletID, chooseTokens()!.chainType!))
        .first;
    _walletinfo = infos;
    LogUtil.v("updateTokenChoose infos " + infos.walletAaddress!);
    if (pushTransList == true) {
      Routers.push(context, TransferListPage());
    }

    // LogUtil.v("updateTokenChoose _tokenIndex $_tokenIndex ");
  }

  void walletcellTapReceive(BuildContext context, int index) async {
    updateTokenChoose(context, index, pushTransList: false);
    Routers.push(context, RecervePaymentPage());
  }

  void walletcellTapPayment(BuildContext context, int index) async {
    updateTokenChoose(context, index, pushTransList: false);
    Routers.push(context, TransferPayment());
  }

  void deleteWallet(BuildContext context, {required TRWallet wallet}) {
    wallet.showLockPin(context, exportPrv: false,
        confirmPressed: (value) async {
      bool flag = await TRWallet.deleteWallet(wallet);
      if (flag) {
        TRWallet? wallet = await TRWallet.queryChooseWallet();
        if (wallet == null) {
          List<TRWallet> wallets = await TRWallet.queryAllWallets();
          if (wallets.isNotEmpty) {
            wallet = wallets.first;
            wallet.isChoose = true;
            await updateChoose(context, wallet: wallet);
            HWToast.showText(text: "wallet_delwallet".local());
            Future.delayed(Duration(seconds: 2)).then((value) => {
                  Routers.goBackWithParams(context, {}),
                });
          } else {
            _currentWallet = null;
            notifyListeners();
            HWToast.showText(text: "wallet_delwallet".local());
            Routers.goBack(context);
          }
        }
      }
    }, cancelPress: null, infoCoinType: null);
  }

  void exportPrv(BuildContext context, {required TRWallet wallet}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) {
          return ChainListType(
            onTap: (KCoinType coinType) {
              wallet.showLockPin(context, infoCoinType: coinType,
                  confirmPressed: (value) {
                ShowCustomAlert.showCustomAlertType(context, KAlertType.text,
                    "walletssetting_exportprv".local(), wallet,
                    hideLeftButton: true,
                    bottomActionsPadding:
                        EdgeInsets.fromLTRB(16.width, 0, 16.width, 16.width),
                    rightButtonBGC: ColorUtils.blueColor,
                    rightButtonRadius: 8,
                    rightButtonTitle: "dialog_copy".local(),
                    subtitleText: value, confirmPressed: (result) {
                  String text = result["text"] ?? '';
                  text.copy();
                });
              }, cancelPress: () {});
            },
          );
        });
  }

  void backupWallet(BuildContext context, {required TRWallet wallet}) {
    wallet.showLockPin(context, exportPrv: false, confirmPressed: (value) {
      Routers.push(
          context, BackupTipMemo(memo: value, walletID: wallet.walletID!));
    }, cancelPress: null, infoCoinType: null);
  }

  void modifyPwd(BuildContext context,
      {required TRWallet wallet,
      required String oldPin,
      required String newPin,
      required String againPin,
      required String pinTip}) {
    if (oldPin.length == 0 || newPin.length == 0 || againPin.length == 0) {
      HWToast.showText(text: "input_pwd".local());
      return;
    }
    if (newPin != againPin) {
      HWToast.showText(text: "input_pwd_wrong".local());
      return;
    }
    if (newPin.checkPassword() == false) {
      HWToast.showText(text: "input_pwd_regexp".local());
      return;
    }
    wallet.lockPin(
        text: oldPin,
        ok: (value) {
          //旧的解密
          //新的将私钥助记词加密
          final content = wallet.exportEncContent(pin: oldPin);
          wallet.pin = TREncode.SHA256(newPin);
          wallet.encContent = TREncode.encrypt(content!, newPin);
          wallet.pinTip = pinTip;
          TRWallet.updateWallet(wallet);
          HWToast.showText(text: "dialog_modifyok".local());
          Future.delayed(Duration(seconds: 2)).then((value) => {
                Routers.goBack(context),
              });
        },
        wrong: () {
          HWToast.showText(text: "dialog_wrongpin".local());
        });
  }

  void requestAssets() async {
    queryMyCollectionTokens();
    _requestMyCollectionTokenAssets();
  }

  void queryMyCollectionTokens() async {
    _currentWallet = await TRWallet.queryChooseWallet();
    if (_currentWallet == null) {
      return;
    }
    final String walletID = _currentWallet!.walletID!;
    List<MCollectionTokens> datas = [];
    KNetType netType = SPManager.getNetType();
    if (_chooseChainType == null) {
      datas =
          await MCollectionTokens.findStateTokens(walletID, 1, netType.index);
    } else {
      datas = await MCollectionTokens.findStateChainTokens(
          walletID, 1, netType.index, _chooseChainType!.index);
    }
    _tokens[walletID] = datas;
    notifyListeners();
  }

  void _requestMyCollectionTokenAssets() async {
    _currentWallet = await TRWallet.queryChooseWallet();
    if (_currentWallet == null) {
      return;
    }
    final String walletID = _currentWallet!.walletID!;
    Map<KCoinType, List<Map>> rpcList = {};
    int i = 0;
    List<TRWalletInfo> infos = await _currentWallet!.queryWalletInfos();
    for (i = 0; i < tokens.length; i++) {
      MCollectionTokens map = tokens[i];
      KCoinType coinType = map.chainType!.geCoinType();
      String walletAaddress = "";
      var info =
          infos.where((element) => element.coinType == map.chainType).first;
      walletAaddress = info.walletAaddress!;
      Map params = {};
      if (map.isToken == false) {
        params["jsonrpc"] = "2.0";
        params["method"] = "eth_getBalance";
        params["params"] = [walletAaddress, "latest"];
        params["id"] = map.tokenID;
      } else {
        String owner = walletAaddress;
        String data =
            "0x70a08231000000000000000000000000" + owner.replaceAll("0x", "");
        params["jsonrpc"] = "2.0";
        params["method"] = "eth_call";
        params["params"] = [
          {"to": map.contract, "data": data},
          "latest"
        ];
        params["id"] = map.tokenID;
      }
      List<Map> datas = rpcList[coinType] ?? [];
      datas.add(params);
      rpcList[coinType] = datas;
    }
    if (rpcList.isEmpty) {
      return;
    }
    for (var item in rpcList.keys) {
      List<Map> rpc = rpcList[item] ?? [];
      if (rpc.isEmpty) {
        continue;
      }
      dynamic result =
          await ChainServices.requestDatas(coinType: item, params: rpc);
      if (result != null && result is List) {
        for (var response in result) {
          if (response.keys.contains("result")) {
            String id = response["id"];
            String? bal = response["result"] as String;
            bal = bal.replaceFirst("0x", "");
            bal = bal.length == 0 ? "0" : bal;
            BigInt balBInt = BigInt.parse(bal, radix: 16);
            for (var i = 0; i < tokens.length; i++) {
              MCollectionTokens map = tokens[i];
              if (id == map.tokenID) {
                TokenPrice? price = await TokenPrice.queryTokenPrices(
                    map.token!, currencyType ?? KCurrencyType.CNY);
                map.balance = balBInt.tokenDouble(map.decimals!);
                if (price != null) {
                  map.price = double.tryParse(price.rate ?? "0.0");
                }
                MCollectionTokens.updateTokenData(
                    "price=${map.price},balance =${map.balance} WHERE tokenID = '$id'");
              }
            }
          }
        }
        _calTotalAssets();
      }
    }
  }

  void _configTimerRequest() async {
    if (_timer == null) {
      _timer = TimerUtil(mInterval: 5000);
      _timer!.setOnTimerTickCallback((millisUntilFinished) async {
        if (_currentWallet == null) return;

        Set<String> token = Set();
        token.addAll(tokens.map((e) => e.token!).toList());
        WalletServices.gettokenPrice(token.join(","));
        requestAssets();
      });
    }
    if (_timer!.isActive() == false) {
      _timer!.startTimer();
    }
  }

  ///计算我的总资产
  void _calTotalAssets() {
    final String? walletID = _currentWallet!.walletID;
    Decimal sumAssets = Decimal.zero;
    for (int i = 0; i < tokens.length; i++) {
      MCollectionTokens map = tokens[i];
      sumAssets += Decimal.tryParse(map.assets) ?? Decimal.zero;
    }
    String total = sumAssets == Decimal.zero ? "0.00" : sumAssets.toString();
    _totalAssets[walletID] = total;
    notifyListeners();
  }
}
