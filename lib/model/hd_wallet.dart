import '../public.dart';

class HDWallet {
  String? prv; //加密后的
  String? address; //地址
  String? pin; //pin
  String? content;
  KLeadType? leadType;
  KCoinType? coinType;
  HDWallet(
      {this.coinType,
      this.prv,
      this.address,
      this.pin,
      this.content,
      this.leadType});

  @override
  String toString() {
    // TODO: implement toString
    return "prv $prv , address $address pin $pin coinType $coinType";
  }
}

abstract class HDWalletProtocol {
  String privateKeyFromMnemonic(String mnemonic);

  String privateKeyFromJson(String json, String password);

  String getPublicAddress(String privateKey);

  HDWallet? importWallet(
      {required String content,
      required String pin,
      required KLeadType kLeadType});
}
