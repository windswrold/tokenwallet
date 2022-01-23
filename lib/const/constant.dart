import 'dart:io';
import 'package:flutter/foundation.dart';
import '../public.dart';

enum KCoinType {
  BSC,
  ETH,
  HECO,
  OKChain,
  Matic,
  AVAX,
  Arbitrum,
}

enum KLeadType {
  Prvkey, //通过私钥
  KeyStore, //通过keystore
  Memo //通过助记词
}

enum KAccountState {
  init, //未备份
  authed, //已备份
  noauthed, //无需备份
}

enum KCurrencyType {
  CNY,
  USD,
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
