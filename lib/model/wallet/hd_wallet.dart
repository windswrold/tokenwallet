import 'package:cstoken/model/chain/arb.dart';
import 'package:cstoken/model/chain/avax.dart';
import 'package:cstoken/model/chain/bsc.dart';
import 'package:cstoken/model/chain/btc.dart';
import 'package:cstoken/model/chain/eth.dart';
import 'package:cstoken/model/chain/heco.dart';
import 'package:cstoken/model/chain/matic.dart';
import 'package:cstoken/model/chain/okchain.dart';
import 'package:cstoken/model/chain/trx.dart';

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
    if (chainType == KChainType.HD || chainType == KChainType.ETH) {
      HDWallet ethWallet = (await ETHChain()
          .importWallet(content: content, pin: pin, kLeadType: kLeadType))!;
      if (kCoinType == KCoinType.ETH) {
        _hdwallets.add(ethWallet);
      }
      if (kCoinType == KCoinType.BSC) {
        HDWallet hdWallet = HDWallet(
            coinType: KCoinType.BSC,
            prv: ethWallet.prv,
            address: ethWallet.address,
            pin: ethWallet.pin,
            content: ethWallet.content,
            leadType: ethWallet.leadType);
        _hdwallets.add(hdWallet);
      }
      if (kCoinType == KCoinType.HECO) {
        HDWallet hdWallet = HDWallet(
            coinType: KCoinType.HECO,
            prv: ethWallet.prv,
            address: ethWallet.address,
            pin: ethWallet.pin,
            content: ethWallet.content,
            leadType: ethWallet.leadType);
        _hdwallets.add(hdWallet);
      }
      if (kCoinType == KCoinType.Arbitrum) {
        HDWallet hdWallet = HDWallet(
            coinType: KCoinType.Arbitrum,
            prv: ethWallet.prv,
            address: ethWallet.address,
            pin: ethWallet.pin,
            content: ethWallet.content,
            leadType: ethWallet.leadType);
        _hdwallets.add(hdWallet);
      }
      if (kCoinType == KCoinType.AVAX) {
        HDWallet hdWallet = HDWallet(
            coinType: KCoinType.AVAX,
            prv: ethWallet.prv,
            address: ethWallet.address,
            pin: ethWallet.pin,
            content: ethWallet.content,
            leadType: ethWallet.leadType);
        _hdwallets.add(hdWallet);
      }
      if (kCoinType == KCoinType.Matic) {
        HDWallet hdWallet = HDWallet(
            coinType: KCoinType.Matic,
            prv: ethWallet.prv,
            address: ethWallet.address,
            pin: ethWallet.pin,
            content: ethWallet.content,
            leadType: ethWallet.leadType);

        _hdwallets.add(hdWallet);
      }
      if (kCoinType == KCoinType.OKChain) {
        HDWallet hdWallet = HDWallet(
            coinType: KCoinType.OKChain,
            prv: ethWallet.prv,
            address: ethWallet.address,
            pin: ethWallet.pin,
            content: ethWallet.content,
            leadType: ethWallet.leadType);
        _hdwallets.add(hdWallet);
      }
    }

    if (chainType == KChainType.HD ||
        chainType == KChainType.BTC ||
        kCoinType == KCoinType.BTC) {
      HDWallet? hdWallet = await BTCChain()
          .importWallet(content: content, pin: pin, kLeadType: kLeadType);
      _hdwallets.add(hdWallet!);
    }
    if (chainType == KChainType.HD ||
        chainType == KChainType.TRX ||
        kCoinType == KCoinType.TRX) {
      HDWallet? hdWallet = await TRXChain()
          .importWallet(content: content, pin: pin, kLeadType: kLeadType);
      _hdwallets.add(hdWallet!);
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
