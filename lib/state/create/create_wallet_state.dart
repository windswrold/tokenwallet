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

  CreateWalletProvider.init({required KLeadType leadType}) {
    _leadType = leadType;
    if (leadType == KLeadType.Prvkey || leadType == KLeadType.Restore) {
      _contentEC = TextEditingController();
    }
  }

  void updateLeadType(KLeadType leadType) {
    _leadType = leadType;
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

  void createWallet(BuildContext context) {
    String memo = "";
    if (_leadType == KLeadType.Memo) {
      memo = Mnemonic.generateMnemonic();
    } else {
      memo = _contentEC!.text;
    }
    bool state = TRWallet.validImportValue(
        content: memo,
        pin: _pwdEC.text,
        pinAgain: _pwdAgainEC.text,
        pinTip: _pwdTipEC.text,
        walletName: _walletNameEC.text,
        kChainType: KChainType.HD,
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
        kChainType: KChainType.HD,
        kLeadType: _leadType);
  }

  TextEditingController? get contentEC => _contentEC;
  TextEditingController get walletNameEC => _walletNameEC;
  TextEditingController get pwdEC => _pwdEC;
  TextEditingController get pwdAgainEC => _pwdAgainEC;
  TextEditingController get pwdTipEC => _pwdTipEC;
  bool get pwdisClose => _pwdisClose;
  bool get pwdAgainisClose => _pwdAgainisClose;
}
