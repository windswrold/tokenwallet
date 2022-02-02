import 'dart:io';
import 'package:flutter/foundation.dart';
import '../public.dart';

//链类型
enum KChainType {
  HD,
  ETH,
  BTC,
  TRX,
}

//主币
enum KCoinType {
  ETH,
  BSC,
  HECO,
  OKChain,
  Matic,
  AVAX,
  Arbitrum,
}

extension CoinTypeString on KCoinType {
  String coinTypeString() {
    switch (this) {
      case KCoinType.BSC:
        return "BSC";
      case KCoinType.ETH:
        return "ETH";
      case KCoinType.HECO:
        return "HECO";
      case KCoinType.OKChain:
        return "OKChain";
      case KCoinType.Matic:
        return "Matic";
      case KCoinType.AVAX:
        return "AVAX";
      case KCoinType.Arbitrum:
        return "Arbitrum";
      default:
        throw Error();
    }
  }
}

enum KLeadType {
  Memo, //通过创建助记词
  Prvkey, //通过私钥
  KeyStore,
  Restore,
}

enum KAccountState {
  ///无需备份
  noauthed,

  ///未备份
  init,

  ///已备份
  authed,
}

enum KCurrencyType {
  CNY,
  USD,
}

enum SortIndexType {
  leftIndex,
  actionIndex,
  wrongIndex,
}

enum KChainID { Mainnet, Ropsten, Rinkeby, Localhost }

extension ChainIdNum on KChainID {
  int getChainId() {
    switch (this) {
      case KChainID.Mainnet:
        return 1;
      case KChainID.Ropsten:
        return 3;
      case KChainID.Rinkeby:
        return 4;
      case KChainID.Localhost:
        return 9;
      default:
        return -1;
    }
  }
}

final bool inProduction = kReleaseMode;
final bool isAndroid = Platform.isAndroid;
final bool isIOS = Platform.isIOS;
final String ASSETS_IMG = './assets/images/';
