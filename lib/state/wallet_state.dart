import 'package:cstoken/model/wallet/tr_wallet.dart';
import '../public.dart';

class CurrentChooseWalletState with ChangeNotifier {
  TRWallet? currentWallet;
  void loadWallet() async {
    currentWallet = await TRWallet.queryChooseWallet();
    notifyListeners();
  }

  Future<bool> updateChoose(BuildContext context,
      {required TRWallet wallet}) async {
    List<TRWallet> wallets = await TRWallet.queryAllWallets();
    for (var item in wallets) {
      item.isChoose = false;
      if (wallet.walletID == item.walletID) {
        item.isChoose = true;
      }
    }
    return TRWallet.updateWallets(wallets);
  }

  void deleteWallet(BuildContext context, {required TRWallet wallet}) {
    ShowCustomAlert.showCustomAlertType(
        context, KAlertType.text, "dialog_title".local(), currentWallet!,
        hideLeftButton: true,
        rightButtonTitle: "walletssetting_modifyok".local(),
        subtitleText:
            "33KrFMz32433KrFMz32433KrFMz324jAwMttvi1t33KrFMz324jAwMttvi1jAwMttvi1tjAwMttvi1t33KrFMz32433KrFMz32433KrFMz324jAwMttvi1t33KrFMz324jAwMttvi1jAwMttvi1tjAwMttvi1t",
        confirmPressed: (result) {});
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

  void updateWalletPwd(String oldPin, String newPin) {
    notifyListeners();
  }
}
