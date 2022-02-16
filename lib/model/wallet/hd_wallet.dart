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
      HDWallet hdWallet = HDWallet(
          coinType: KCoinType.BSC,
          prv: ethWallet.prv,
          address: ethWallet.address,
          pin: ethWallet.pin,
          content: ethWallet.content,
          leadType: ethWallet.leadType);
      _hdwallets.add(hdWallet);
      // _hdwallets.add((await BSCChain()
      //     .importWallet(content: content, pin: pin, kLeadType: kLeadType))!);
    }
    if (chainType == KChainType.HD ||
        chainType == KChainType.ETH ||
        kCoinType == KCoinType.HECO) {
      HDWallet hdWallet = HDWallet(
          coinType: KCoinType.HECO,
          prv: ethWallet.prv,
          address: ethWallet.address,
          pin: ethWallet.pin,
          content: ethWallet.content,
          leadType: ethWallet.leadType);
      _hdwallets.add(hdWallet);
      // _hdwallets.add((await HecoChain()
      //     .importWallet(content: content, pin: pin, kLeadType: kLeadType))!);
    }
    if (chainType == KChainType.HD ||
        chainType == KChainType.ETH ||
        kCoinType == KCoinType.Arbitrum) {
      HDWallet hdWallet = HDWallet(
          coinType: KCoinType.Arbitrum,
          prv: ethWallet.prv,
          address: ethWallet.address,
          pin: ethWallet.pin,
          content: ethWallet.content,
          leadType: ethWallet.leadType);
      _hdwallets.add(hdWallet);
      // _hdwallets.add((await await ARBChain()
      //     .importWallet(content: content, pin: pin, kLeadType: kLeadType))!);
    }
    if (chainType == KChainType.HD ||
        chainType == KChainType.ETH ||
        kCoinType == KCoinType.AVAX) {
      HDWallet hdWallet = HDWallet(
          coinType: KCoinType.AVAX,
          prv: ethWallet.prv,
          address: ethWallet.address,
          pin: ethWallet.pin,
          content: ethWallet.content,
          leadType: ethWallet.leadType);
      _hdwallets.add(hdWallet);
      // _hdwallets.add((await AVAXChain()
      //     .importWallet(content: content, pin: pin, kLeadType: kLeadType))!);
    }
    if (chainType == KChainType.HD ||
        chainType == KChainType.ETH ||
        kCoinType == KCoinType.Matic) {
      HDWallet hdWallet = HDWallet(
          coinType: KCoinType.Matic,
          prv: ethWallet.prv,
          address: ethWallet.address,
          pin: ethWallet.pin,
          content: ethWallet.content,
          leadType: ethWallet.leadType);

      _hdwallets.add(hdWallet);
      // _hdwallets.add((await MaticChain()
      //     .importWallet(content: content, pin: pin, kLeadType: kLeadType))!);
    }
    if (chainType == KChainType.HD ||
        chainType == KChainType.ETH ||
        kCoinType == KCoinType.OKChain) {
      HDWallet hdWallet = HDWallet(
          coinType: KCoinType.OKChain,
          prv: ethWallet.prv,
          address: ethWallet.address,
          pin: ethWallet.pin,
          content: ethWallet.content,
          leadType: ethWallet.leadType);
      _hdwallets.add(hdWallet);
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
