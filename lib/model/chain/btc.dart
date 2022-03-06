import '../../public.dart';

class BTCChain implements HDWalletProtocol {
  @override
  Future<String> getPublicAddress(String privateKey) {
    // TODO: implement getPublicAddress
    throw UnimplementedError();
  }

  @override
  Future<HDWallet?> importWallet(
      {required String content,
      required String pin,
      required KLeadType kLeadType}) {
    // TODO: implement importWallet
    throw UnimplementedError();
  }

  @override
  Future<String> privateKeyFromJson(String json, String password) {
    // TODO: implement privateKeyFromJson
    throw UnimplementedError();
  }

  @override
  Future<String> privateKeyFromMnemonic(String mnemonic) {
    // TODO: implement privateKeyFromMnemonic
    throw UnimplementedError();
  }
}
