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

  void toHDString() {
    // TODO: implement toString
    LogUtil.v(
        "HDWallet prv $prv , address $address pin $pin content $content leadType $leadType coinType $coinType");
  }

  static Future<List<HDWallet>> getHDWallet(
      {required String content,
      required String pin,
      required KLeadType kLeadType,
      KChainType? chainType,
      KCoinType? kCoinType}) async {
    List<HDWallet> _hdwallets = [];
    if (kLeadType == KLeadType.Memo || kLeadType == KLeadType.Restore) {
      kLeadType = KLeadType.Memo;
    }
    HDWallet ethWallet = (await ETHChain()
        .importWallet(content: content, pin: pin, kLeadType: kLeadType))!;
    if (chainType == KChainType.HD ||
        chainType == KChainType.ETH ||
        kCoinType == KCoinType.ETH) {
      _hdwallets.add(ethWallet);
      // _hdwallets.add((await ETHChain()
      //     .importWallet(content: content, pin: pin, kLeadType: kLeadType))!);
    }
    if (chainType == KChainType.HD ||
        chainType == KChainType.ETH ||
        kCoinType == KCoinType.BSC) {
      ethWallet.coinType = KCoinType.BSC;
      _hdwallets.add(ethWallet);
      // _hdwallets.add((await BSCChain()
      //     .importWallet(content: content, pin: pin, kLeadType: kLeadType))!);
    }
    if (chainType == KChainType.HD ||
        chainType == KChainType.ETH ||
        kCoinType == KCoinType.HECO) {
      ethWallet.coinType = KCoinType.HECO;
      _hdwallets.add(ethWallet);
      // _hdwallets.add((await HecoChain()
      //     .importWallet(content: content, pin: pin, kLeadType: kLeadType))!);
    }
    if (chainType == KChainType.HD ||
        chainType == KChainType.ETH ||
        kCoinType == KCoinType.Arbitrum) {
      ethWallet.coinType = KCoinType.Arbitrum;
      _hdwallets.add(ethWallet);
      // _hdwallets.add((await await ARBChain()
      //     .importWallet(content: content, pin: pin, kLeadType: kLeadType))!);
    }
    if (chainType == KChainType.HD ||
        chainType == KChainType.ETH ||
        kCoinType == KCoinType.AVAX) {
      ethWallet.coinType = KCoinType.AVAX;
      _hdwallets.add(ethWallet);
      // _hdwallets.add((await AVAXChain()
      //     .importWallet(content: content, pin: pin, kLeadType: kLeadType))!);
    }
    if (chainType == KChainType.HD ||
        chainType == KChainType.ETH ||
        kCoinType == KCoinType.Matic) {
      ethWallet.coinType = KCoinType.Matic;
      _hdwallets.add(ethWallet);
      // _hdwallets.add((await MaticChain()
      //     .importWallet(content: content, pin: pin, kLeadType: kLeadType))!);
    }
    if (chainType == KChainType.HD ||
        chainType == KChainType.ETH ||
        kCoinType == KCoinType.OKChain) {
      ethWallet.coinType = KCoinType.OKChain;
      _hdwallets.add(ethWallet);
      // _hdwallets.add((await OKChain()
      //     .importWallet(content: content, pin: pin, kLeadType: kLeadType))!);
    }

    // btc
    // trx
    return _hdwallets;
  }
}

abstract class HDWalletProtocol {
  Future<String> privateKeyFromMnemonic(String mnemonic);

  Future<String> privateKeyFromJson(String json, String password);

  Future<String> getPublicAddress(String privateKey);

  // String getPublicKey(String privateKey);

  Future<HDWallet?> importWallet(
      {required String content,
      required String pin,
      required KLeadType kLeadType});
}
