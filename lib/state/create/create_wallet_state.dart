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

  void createWallet(BuildContext context) {}

  TextEditingController get walletNameEC => _walletNameEC;
  TextEditingController get pwdEC => _pwdEC;
  TextEditingController get pwdAgainEC => _pwdAgainEC;
  TextEditingController get pwdTipEC => _pwdTipEC;
  bool get pwdisClose => _pwdisClose;
  bool get pwdAgainisClose => _pwdAgainisClose;
}
