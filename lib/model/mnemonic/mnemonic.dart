import 'package:bip39/bip39.dart' as bip39;

class Mnemonic {
  static String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  static bool validateMnemonic(String memo) {
    return bip39.validateMnemonic(memo);
  }
}
