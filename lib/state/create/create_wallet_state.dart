import 'package:cstoken/model/mnemonic/mnemonic.dart';
import 'package:cstoken/model/wallet/tr_wallet.dart';
import 'package:cstoken/pages/wallet/create/backup_tip_memo.dart';
import 'package:cstoken/utils/custom_toast.dart';

import '../../public.dart';

class CreateWalletProvider with ChangeNotifier {
  TextEditingController? _contentEC;
  final TextEditingController _walletNameEC =
      TextEditingController(text: TRWallet.randomWalletName());
  final TextEditingController _pwdEC = TextEditingController();
  final TextEditingController _pwdAgainEC = TextEditingController();
  final TextEditingController _pwdTipEC = TextEditingController();
  bool _pwdisClose = true;
  bool _pwdAgainisClose = true;
  KLeadType _leadType = KLeadType.Memo;
  KChainType _chainType = KChainType.HD;

  TextEditingController? get contentEC => _contentEC;
  TextEditingController get walletNameEC => _walletNameEC;
  TextEditingController get pwdEC => _pwdEC;
  TextEditingController get pwdAgainEC => _pwdAgainEC;
  TextEditingController get pwdTipEC => _pwdTipEC;
  bool get pwdisClose => _pwdisClose;
  bool get pwdAgainisClose => _pwdAgainisClose;
  KChainType get chainType => _chainType;

  CreateWalletProvider.init(
      {required KLeadType leadType, required KChainType chainType}) {
    _leadType = leadType;
    _chainType = chainType;
    if (leadType == KLeadType.Prvkey || leadType == KLeadType.Restore) {
      _contentEC = TextEditingController();
    }
  }

  void updateLeadType(KLeadType leadType) {
    _leadType = leadType;
    _contentEC?.clear();
    _walletNameEC.clear();
    _pwdEC.clear();
    _pwdAgainEC.clear();
    _pwdTipEC.clear();
    if (inProduction == false) {
      _contentEC?.text =
          "40730f5ddc6b492688ce3897b9ff54e582f6ad8243a90ece21b060a46db46b44";
      // contentEC.text =
      //     "f335fb8d70f27351a2a20541464f87057112e3245efa8c119fc7a08742622044";

      // contentEC.text =
      //     "0db163591450cd67f3febe856460460e99ef5bb70c6a98cb2a0bcb873d0526be";
    }
  }

  void updateChainType(KChainType chainType) {
    _chainType = chainType;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("CreateWalletProvider dispose");
    _contentEC?.dispose();
    _walletNameEC.dispose();
    _pwdEC.dispose();
    _pwdAgainEC.dispose();
    _pwdTipEC.dispose();
    super.dispose();
  }

  void changePwdisClose() {
    _pwdisClose = !_pwdisClose;
    notifyListeners();
  }

  void changePwdAgainisClose() {
    _pwdAgainisClose = !_pwdAgainisClose;
    notifyListeners();
  }

  void createWallet(BuildContext context) async {
    HWToast.showLoading();
    String memo = "";
    if (_leadType == KLeadType.Memo) {
      memo = Mnemonic.generateMnemonic();
    } else {
      memo = _contentEC!.text;
    }
    bool state = await TRWallet.validImportValue(
        content: memo,
        pin: _pwdEC.text,
        pinAgain: _pwdAgainEC.text,
        pinTip: _pwdTipEC.text,
        walletName: _walletNameEC.text,
        kChainType: _chainType,
        kLeadType: _leadType);
    if (state == false) {
      return;
    }
    TRWallet.importWallet(context,
        content: memo,
        pin: _pwdEC.text,
        pinAgain: _pwdAgainEC.text,
        pinTip: _pwdTipEC.text,
        walletName: _walletNameEC.text,
        kChainType: _chainType,
        kLeadType: _leadType);
  }
}
