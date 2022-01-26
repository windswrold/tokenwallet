import 'package:cstoken/model/mnemonic/mnemonic.dart';
import 'package:cstoken/model/wallet/tr_wallet.dart';
import 'package:cstoken/pages/wallet/create/backup_tip_memo.dart';

import '../../public.dart';

class CreateWalletProvider with ChangeNotifier {
  TextEditingController? _memoEC;
  final TextEditingController _walletNameEC =
      TextEditingController(text: TRWallet.randomWalletName());
  final TextEditingController _pwdEC = TextEditingController();
  final TextEditingController _pwdAgainEC = TextEditingController();
  final TextEditingController _pwdTipEC = TextEditingController();
  bool _pwdisClose = true;
  bool _pwdAgainisClose = true;
  bool _isRestore = false;

  CreateWalletProvider.init({required bool isRestore}) {
    _isRestore = isRestore;
    if (_isRestore == true) {
      _memoEC = TextEditingController();
    }
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
    String memo = Mnemonic.generateMnemonic();
    bool state = TRWallet.validImportValue(
        content: memo,
        pin: _pwdEC.text,
        pinAgain: _pwdAgainEC.text,
        pinTip: _pwdTipEC.text,
        walletName: _walletNameEC.text,
        kChainType: KChainType.HD,
        kLeadType: KLeadType.Memo);
    if (state == false) {
      return;
    }
    //已经生成了存到本地了
    Routers.push(context, BackupTipMemo());
  }

  TextEditingController? get memoEC => _memoEC;
  TextEditingController get walletNameEC => _walletNameEC;
  TextEditingController get pwdEC => _pwdEC;
  TextEditingController get pwdAgainEC => _pwdAgainEC;
  TextEditingController get pwdTipEC => _pwdTipEC;
  bool get pwdisClose => _pwdisClose;
  bool get pwdAgainisClose => _pwdAgainisClose;
}
