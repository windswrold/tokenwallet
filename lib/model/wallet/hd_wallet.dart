import 'package:cstoken/model/chain/arb.dart';
import 'package:cstoken/model/chain/avax.dart';
import 'package:cstoken/model/chain/bsc.dart';
import 'package:cstoken/model/chain/eth.dart';
import 'package:cstoken/model/chain/heco.dart';
import 'package:cstoken/model/chain/matic.dart';
import 'package:cstoken/model/chain/okchain.dart';

import '../../public.dart';

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

  static List<HDWallet> getHDWallet(
      {required String content,
      required String pin,
      required KLeadType kLeadType,
      required KChainType chainType}) {
    List<HDWallet> _hdwallets = [];
    if (kLeadType == KLeadType.Memo ||
        kLeadType == KLeadType.Create ||
        kLeadType == KLeadType.Restore ||
        chainType == KChainType.HD ||
        chainType == KChainType.ETH) {
      if (kLeadType == KLeadType.Memo ||
          kLeadType == KLeadType.Create ||
          kLeadType == KLeadType.Restore) {
        kLeadType = KLeadType.Memo;
      }
      _hdwallets.add(ETHChain()
          .importWallet(content: content, pin: pin, kLeadType: kLeadType)!);
      _hdwallets.add(BSCChain()
          .importWallet(content: content, pin: pin, kLeadType: kLeadType)!);
      _hdwallets.add(HecoChain()
          .importWallet(content: content, pin: pin, kLeadType: kLeadType)!);
      _hdwallets.add(ARBChain()
          .importWallet(content: content, pin: pin, kLeadType: kLeadType)!);
      _hdwallets.add(AVAXChain()
          .importWallet(content: content, pin: pin, kLeadType: kLeadType)!);
      _hdwallets.add(MaticChain()
          .importWallet(content: content, pin: pin, kLeadType: kLeadType)!);
      _hdwallets.add(OKChain()
          .importWallet(content: content, pin: pin, kLeadType: kLeadType)!);
    }
    return _hdwallets;
  }
}

abstract class HDWalletProtocol {
  String privateKeyFromMnemonic(String mnemonic);

  String privateKeyFromJson(String json, String password);

  String getPublicAddress(String privateKey);

  // String getPublicKey(String privateKey);

  HDWallet? importWallet(
      {required String content,
      required String pin,
      required KLeadType kLeadType});
}
