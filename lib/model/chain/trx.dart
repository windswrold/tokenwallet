import '../../public.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:trustdart/trustdart.dart';

class TRXChain implements HDWalletProtocol {
  @override
  Future<String> getPublicAddress(String privateKey) async {
    Map params = await Trustdart.generateAddress(privateKey, 'TRX', "");
    String address = params['legacy'] ?? "";
    return address;
  }

  @override
  Future<HDWallet?> importWallet(
      {required String content,
      required String pin,
      required KLeadType kLeadType}) async {
    var prv;
    String address;
    if (kLeadType == KLeadType.Memo) {
      prv = await privateKeyFromMnemonic(content);
    } else if (kLeadType == KLeadType.KeyStore) {
      prv = await privateKeyFromJson(content, pin);
    } else if (kLeadType == KLeadType.Prvkey) {
      prv = content;
    }
    address = await getPublicAddress(prv);
    if (address.isEmpty) {
      return null;
    }
    HDWallet wallet = HDWallet(
        coinType: KCoinType.TRX,
        prv: prv,
        address: address,
        pin: pin,
        content: content,
        leadType: kLeadType);
    wallet.toHDString();
    return wallet;
  }

  @override
  Future<String> privateKeyFromJson(String json, String password) {
    // TODO: implement privateKeyFromJson
    throw UnimplementedError();
  }

  @override
  Future<String> privateKeyFromMnemonic(String mnemonic) async {
    var seed = bip39.mnemonicToSeed(mnemonic);
    var root = bip32.BIP32.fromSeed(seed);
    var child = root.derivePath("m/44'/195'/0'/0/0");
    final prv = child.privateKey;
    return TREncode.kBytesToHex(prv!);
  }
}
