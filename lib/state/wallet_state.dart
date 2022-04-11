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
import 'package:cstoken/pages/wallet/wallets/nft_listdata.dart';
import 'package:cstoken/pages/wallet/wallets/wallets_setting.dart';
import 'package:cstoken/utils/custom_toast.dart';
import 'package:cstoken/utils/sp_manager.dart';
import 'package:cstoken/utils/timer_util.dart';
import 'package:decimal/decimal.dart';
import 'package:easy_localization/src/public_ext.dart';
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
  Map<String?, String> _totalTokenAssets = {}; //总资产数额
  Map<String?, String> _totalNFTAssets = {}; //总资产数额

  Map<String?, List<MCollectionTokens>> _tokens = {};
  List<MCollectionTokens> get tokens => _homeTokenType == 0
      ? _currentWallet == null
          ? []
          : (_tokens[_currentWallet?.walletID] ?? [])
      : nftInfos;

  KCoinType? _chooseChainType;
  String get chooseChain => _chooseChainType == null
      ? "walletmanager_asset_all".local()
      : _chooseChainType!.coinTypeString();

  TimerUtil? _timer;
  TimerUtil? _priceTimer;
  int _tokenIndex = 0;
  TRWalletInfo? _walletinfo;
  TRWalletInfo? get walletinfo => _walletinfo;
  int _homeTokenType = 0;
  int get homeTokenType => _homeTokenType;
  Map<String?, List> _nftContracts = {};
  List get nftContracts => _currentWallet == null
      ? []
      : _nftContracts[_currentWallet?.walletID] ?? [];

  Map<String?, List<MCollectionTokens>> _nftInfos = {};
  List<MCollectionTokens> get nftInfos =>
      _currentWallet == null ? [] : _nftInfos[_currentWallet?.walletID] ?? [];

  MCollectionTokens? chooseTokens() {
    if (tokens.length > _tokenIndex) {
      return tokens[_tokenIndex];
    } else {
      LogUtil.v("chooseTokens越界");
      assert(false, "chooseTokens越界");
      return null;
    }
  }

  String? totalTokenAssets() {
    if (_currentWallet == null) {
      return "0.00";
    }
    if (_currentWallet!.hiddenAssets == true) {
      return "****";
    }
    return _totalTokenAssets[_currentWallet?.walletID] ?? "0.00";
  }

  String? totalNFTAssets() {
    if (_currentWallet == null) {
      return "0.00";
    }
    if (_currentWallet!.hiddenAssets == true) {
      return "****";
    }
    return _totalNFTAssets[_currentWallet?.walletID] ?? "0.00";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _priceTimer?.cancel();
    _priceTimer = null;
    super.dispose();
  }

  Future<TRWallet?> loadWallet() async {
    _chooseChainType = null;
    _tokenIndex = 0;
    _homeTokenType = 0;
    _currentWallet = await TRWallet.queryChooseWallet();
    _currencyType = SPManager.getAppCurrencyMode();
    initNFTIndex();
    initNFTTokens();
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

  void initNFTTokens() async {
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
    List result = await WalletServices.getUserNftList(address: ethAdress);
    _nftContracts[_currentWallet!.walletID!] = result;
    notifyListeners();
  }

  void updateCurrencyType(KCurrencyType kCurrencyType) {
    _currencyType = kCurrencyType;
    SPManager.setAppCurrency(kCurrencyType);
    LogUtil.v("updateCurrencyType $kCurrencyType");
    requestAssets();
  }

  ///选择链类型
  void onTapChain(
      BuildContext context, List<KCoinType> coins, Function(KCoinType) onTap) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) {
          return ChainListType(
            onTap: onTap,
            datas: coins,
          );
        });
  }

  void setDeviceLocale(BuildContext context) {
    Locale first = context.deviceLocale;
    for (var element in context.supportedLocales) {
      if (element.languageCode.contains(first.languageCode)) {
        LogUtil.v("element " + element.languageCode);
        context.setLocale(element);
        SPManager.setSystemAppLanguage(element.languageCode == "zh"
            ? KAppLanguage.zh_cn
            : KAppLanguage.en_us);
      }
    }
  }

  void bannerTap(BuildContext context, DAppRecordsDBModel model) {
    if (model.url == null || model.url!.isEmpty) {
      return;
    }
    KCoinType? coinType;
    if (model.chainType != null) {
      coinType = model.chainType!.chainTypeGetCoinType();
    }
    dappTap(context, model, coinType: coinType);
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
      ///目前是eth系
      onTapChain(
          context,
          KChainType.ETH.getSuppertCoinTypes(),
          (p0) => {
                _queryWalletInfo(context, model, p0),
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
        "dapp address ${infos.first.walletAaddress} chain ${node.content} id ${node.chainID}");
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
  }

  void tapWalletSetting(BuildContext context) {
    LogUtil.v("assetsHidden");
    if (_currentWallet == null) {
      HWToast.showText(text: "minepage_pleasecreate".local());
      return;
    }
    Routers.push(context, WalletsSetting(wallet: _currentWallet!));
  }

  void tapNFTInfo(BuildContext context, Map nftInfo) {
    List datas = nftInfo["nftId"];
    String chainTypeName = nftInfo["chainTypeName"];
    String contractAddress = nftInfo["contractAddress"];
    final String walletID = _currentWallet!.walletID!;
    List<MCollectionTokens> _datas = [];
    for (var item in datas) {
      KCoinType coinType = chainTypeName.chainTypeGetCoinType()!;
      String url = nftInfo["url"] ?? '';
      MCollectionTokens model = MCollectionTokens();
      model.contract = contractAddress;
      model.digits = 0;
      model.chainType = coinType.index;
      model.tid = item.toString();
      model.iconPath = url;
      model.decimals = 0;
      model.token = "";
      model.tokenType = KTokenType.eip721.index;
      model.balance = 0.0;
      model.coinType = chainTypeName.chainTypeGetCoinType()!.coinTypeString();
      model.tokenID = model.createTokenID(walletID);
      _datas.add(model);
    }
    _nftInfos[walletID] = _datas;
    Routers.push(context, NFTListData(model: nftInfo));
  }

  void onIndexChanged(BuildContext context, int index) {
    _homeTokenType = index;
    if (index == 1) {
      initNFTTokens();
    }
    notifyListeners();
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
    initNFTTokens();
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
  }

  void walletcellTapReceive(BuildContext context, int index,
      {bool tapNFT = false}) async {
    if (tapNFT == false) {
      updateTokenChoose(context, index, pushTransList: false);
    } else {
      final String walletID = _currentWallet!.walletID!;
      String chainType = nftContracts[index]["chainTypeName"] ?? '';
      TRWalletInfo infos = (await TRWalletInfo.queryWalletInfo(
              walletID, chainType.chainTypeGetCoinType()!.index))
          .first;
      _walletinfo = infos;
    }

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
            datas: wallet.chainType!.getChainType().getSuppertCoinTypes(),
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
    _calTotalAssets();
  }

  void _requestMyCollectionTokenAssets() async {
    _currentWallet = await TRWallet.queryChooseWallet();
    if (_currentWallet == null) {
      return;
    }
    List<TRWalletInfo> infos = await _currentWallet!.queryWalletInfos();
    for (int i = 0; i < tokens.length; i++) {
      MCollectionTokens map = tokens[i];
      String walletAaddress = "";
      TRWalletInfo? info;
      if (infos.isNotEmpty) {
        info =
            infos.where((element) => element.coinType == map.chainType).first;
      }
      if (info == null) {
        LogUtil.v("element.coinType ${map.token}");
        continue;
      }
      walletAaddress = info.walletAaddress!;
      map.balanceOf(walletAaddress, currencyType ?? KCurrencyType.CNY);
    }
  }

  void _configTimerRequest() async {
    if (_timer == null) {
      _timer = TimerUtil(mInterval: 5000);
      _timer!.setOnTimerTickCallback((millisUntilFinished) async {
        if (_currentWallet == null) return;
        requestAssets();
      });
    }
    if (_timer!.isActive() == false) {
      _timer!.startTimer();
    }
    if (_priceTimer == null) {
      _priceTimer = TimerUtil(mInterval: 30000);
      _priceTimer!.setOnTimerTickCallback((millisUntilFinished) async {
        if (_currentWallet == null) return;
        Set<String> token = Set();
        token.addAll(tokens.map((e) => e.token!).toList());
        if (token.isEmpty) {
          return;
        }
        WalletServices.gettokenPrice(token.join(","));
      });
    }
    if (_priceTimer!.isActive() == false) {
      _priceTimer!.startTimer();
    }
  }

  ///计算我的总资产
  void _calTotalAssets() {
    final String? walletID = _currentWallet!.walletID;
    Decimal sumAssets = Decimal.zero;
    List<MCollectionTokens> userTokens = _tokens[walletID] ?? [];
    for (int i = 0; i < userTokens.length; i++) {
      MCollectionTokens map = userTokens[i];
      sumAssets += Decimal.tryParse(map.assets) ?? Decimal.zero;
    }
    String total = sumAssets == Decimal.zero ? "0.00" : sumAssets.toString();
    _totalTokenAssets[walletID] = total;

    Decimal sumnftAssets = Decimal.zero;
    List<MCollectionTokens> userNFTTokens = _nftInfos[walletID] ?? [];
    for (int i = 0; i < userNFTTokens.length; i++) {
      MCollectionTokens map = userNFTTokens[i];
      sumnftAssets += Decimal.tryParse(map.assets) ?? Decimal.zero;
    }
    String totalnft =
        sumnftAssets == Decimal.zero ? "0.00" : sumnftAssets.toString();
    _totalNFTAssets[walletID] = totalnft;
    notifyListeners();
  }
}
