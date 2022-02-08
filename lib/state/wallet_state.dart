import 'package:cstoken/component/chain_listtype.dart';
import 'package:cstoken/model/dapps_record/dapps_record.dart';
import 'package:cstoken/model/wallet/tr_wallet.dart';
import 'package:cstoken/model/wallet/tr_wallet_info.dart';
import 'package:cstoken/net/wallet_services.dart';
import 'package:cstoken/pages/browser/dapp_browser.dart';
import 'package:cstoken/pages/wallet/create/backup_tip_memo.dart';
import 'package:cstoken/pages/wallet/create/create_wallet_page.dart';
import 'package:cstoken/pages/wallet/wallets/wallets_setting.dart';
import 'package:cstoken/utils/custom_toast.dart';
import 'package:cstoken/utils/sp_manager.dart';
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
  String? get totalAssets => _currentWallet == null
      ? "0.00"
      : _totalAssets[_currentWallet?.walletID] ?? "0.00";

  Future<TRWallet?> loadWallet() async {
    _currentWallet = await TRWallet.queryChooseWallet();
    _currencyType = SPManager.getAppCurrencyMode();
    initNFTIndex();
    notifyListeners();
    return _currentWallet;
  }

  void initNFTIndex() async {
    if (_currentWallet == null) {
      return;
    }
    String? ethAdress;
    List<TRWalletInfo> infos =
        await _currentWallet!.queryWalletInfos(coinType: KCoinType.ETH);
    if (infos.isEmpty) {
      return;
    }
    ethAdress = infos.first.walletAaddress;
    if (ethAdress == null) {
      return;
    }
    Map? result = await WalletServices.getindexnftInfo(ethAdress);
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
    if (jumpLinks.isEmpty) {
      return;
    }
    Routers.push(
        context, DappBrowser(model: DAppRecordsDBModel(url: jumpLinks)));
  }

  void assetsHidden(BuildContext context) {
    LogUtil.v("assetsHidden");
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
    initNFTIndex();
    notifyListeners();

    return TRWallet.updateWallets(wallets);
  }

  void deleteWallet(BuildContext context, {required TRWallet wallet}) {
    ShowCustomAlert.showCustomAlertType(context, KAlertType.password,
        "dialog_walletpin".local(), currentWallet!,
        hideLeftButton: true,
        rightButtonBGC: ColorUtils.blueColor,
        rightButtonRadius: 8,
        rightButtonTitle: "walletssetting_modifyok".local(),
        subtitleText:
            "33KrFMz32433KrFMz32433KrFMz324jAwMttvi1t33KrFMz324jAwMttvi1jAwMttvi1tjAwMttvi1t33KrFMz32433KrFMz32433KrFMz324jAwMttvi1t33KrFMz324jAwMttvi1jAwMttvi1tjAwMttvi1t",
        confirmPressed: (result) async {
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
    });
  }

  void exportPrv(BuildContext context, {required TRWallet wallet}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) {
          return ChainListType(
            onTap: (KCoinType coinType) {
              ShowCustomAlert.showCustomAlertType(context, KAlertType.password,
                  "dialog_walletpin".local(), wallet,
                  hideLeftButton: true,
                  rightButtonBGC: ColorUtils.blueColor,
                  rightButtonRadius: 8,
                  rightButtonTitle: "walletssetting_modifyok".local(),
                  confirmPressed: (result) {
                String? memo = wallet.exportEncContent(pin: result["text"]);
                List<HDWallet> hdWallets = HDWallet.getHDWallet(
                    content: memo!,
                    pin: "",
                    kLeadType: wallet.leadType!.getLeadType(),
                    kCoinType: coinType);
                if (hdWallets.isNotEmpty) {
                  String prv = hdWallets.first.prv ?? "";
                  ShowCustomAlert.showCustomAlertType(context, KAlertType.text,
                      "walletssetting_exportprv".local(), wallet,
                      hideLeftButton: true,
                      rightButtonBGC: ColorUtils.blueColor,
                      rightButtonRadius: 8,
                      rightButtonTitle: "dialog_copy".local(),
                      subtitleText: prv, confirmPressed: (result) {
                    String text = result["text"] ?? '';
                    text.copy();
                  });
                }
              });
            },
          );
        });
  }

  void backupWallet(BuildContext context, {required TRWallet wallet}) {
    ShowCustomAlert.showCustomAlertType(context, KAlertType.password,
        "dialog_walletpin".local(), currentWallet!,
        hideLeftButton: true,
        rightButtonBGC: ColorUtils.blueColor,
        rightButtonRadius: 8,
        rightButtonTitle: "walletssetting_modifyok".local(),
        subtitleText:
            "33KrFMz32433KrFMz32433KrFMz324jAwMttvi1t33KrFMz324jAwMttvi1jAwMttvi1tjAwMttvi1t33KrFMz32433KrFMz32433KrFMz324jAwMttvi1t33KrFMz324jAwMttvi1jAwMttvi1tjAwMttvi1t",
        confirmPressed: (result) {
      String? memo = wallet.exportEncContent(pin: result["text"]);
      Routers.push(
          context, BackupTipMemo(memo: memo!, walletID: wallet.walletID!));
    });
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void requestAssets() async {
    _requestMyCollectionTokenAssets();
  }

  void queryMyCollectionTokens() async {
    notifyListeners();
  }

  void _requestMyCollectionTokenAssets() async {
    notifyListeners();
    _calTotalAssets();
  }

  void _configTimerRequest() async {}

  ///计算我的总资产
  void _calTotalAssets() {}
}
