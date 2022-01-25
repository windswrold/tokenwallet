import 'package:cstoken/const/constant.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import '../../public.dart';

class MaticChain implements HDWalletProtocol {
  @override
  String getPublicAddress(String privateKey) {
    final private = EthPrivateKey.fromHex(privateKey);
    return private.address.hexEip55;
  }

  @override
  HDWallet? importWallet(
      {required String content,
      required String pin,
      required KLeadType kLeadType}) {
    var prv;
    var address;
    if (kLeadType == KLeadType.Memo) {
      prv = privateKeyFromMnemonic(content);
    } else if (kLeadType == KLeadType.KeyStore) {
      prv = privateKeyFromJson(content, pin);
    } else if (kLeadType == KLeadType.Prvkey) {
      prv = content;
    }
    address = getPublicAddress(prv);
    HDWallet wallet = HDWallet(
        coinType: KCoinType.Matic,
        prv: prv,
        address: address,
        pin: pin,
        content: content,
        leadType: kLeadType);
    return wallet;
  }

  @override
  String privateKeyFromJson(String json, String password) {
    Wallet wallet = Wallet.fromJson(json, password);
    return TREncode.kBytesToHex(wallet.privateKey.privateKey, include0x: true);
  }

  @override
  String privateKeyFromMnemonic(String mnemonic) {
    var seed = bip39.mnemonicToSeed(mnemonic);
    var root = bip32.BIP32.fromSeed(seed);
    var child = root.derivePath("m/44'/966'/0'/0/0");
    final prv = child.privateKey;
    return TREncode.kBytesToHex(prv!, include0x: true);
  }
}
