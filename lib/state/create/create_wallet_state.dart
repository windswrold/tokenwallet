import 'package:cstoken/model/mnemonic/mnemonic.dart';
import 'package:cstoken/model/wallet/tr_wallet.dart';

import '../../public.dart';

class CreateWalletProvider with ChangeNotifier {
  TextEditingController _walletNameEC = TextEditingController();
  TextEditingController _pwdEC = TextEditingController();
  TextEditingController _pwdAgainEC = TextEditingController();
  TextEditingController _pwdTipEC = TextEditingController();
  bool _pwdisClose = true;
  bool _pwdAgainisClose = true;

  void changePwdisClose() {
    _pwdisClose = !_pwdisClose;
    notifyListeners();
  }

  void changePwdAgainisClose() {
    _pwdAgainisClose = !_pwdAgainisClose;
    notifyListeners();
  }

  void createWallet(BuildContext context) {
    String memo = Mnemonic.generateMnemonic();
    TRWallet.validImportValue(
        content: memo,
        pin: _pwdEC.text,
        pinAgain: _pwdAgainEC.text,
        pinTip: _pwdTipEC.text,
        walletName: _walletNameEC.text,
        kChainType: KChainType.HD,
        kLeadType: KLeadType.Memo);
  }

  TextEditingController get walletNameEC => _walletNameEC;
  TextEditingController get pwdEC => _pwdEC;
  TextEditingController get pwdAgainEC => _pwdAgainEC;
  TextEditingController get pwdTipEC => _pwdTipEC;
  bool get pwdisClose => _pwdisClose;
  bool get pwdAgainisClose => _pwdAgainisClose;
}
