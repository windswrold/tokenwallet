import 'package:cstoken/model/wallet/tr_wallet.dart';
import '../public.dart';

class CurrentChooseWalletState with ChangeNotifier {
  TRWallet? currentWallet;
  void loadWallet() async {
    currentWallet = await TRWallet.queryChooseWallet();
    notifyListeners();
  }

  void delWallets() async {}

  void updateChoose(TRWallet wallet) async {
    TRWallet? chooseWallet = await TRWallet.queryChooseWallet();
    if (chooseWallet == null) {
      return;
    }
    chooseWallet.isChoose = false;
    wallet.isChoose = true;
    TRWallet.updateWallets([wallet, chooseWallet]);
    loadWallet();
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
