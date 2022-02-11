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

enum KAppLanguage {
  system,
  zh_cn,
  en_us,
}

enum SortIndexType {
  leftIndex,
  actionIndex,
  wrongIndex,
}

enum KAlertType {
  password, //输入密码
  text, //文本提示
  node,
  edit_name, //nodeUrl
}

enum KTransState {
  failere,
  success,
  pending, //l1转账打包中 l2 loading 然后l2
}

enum KTokenType { native, token }

enum KNetType { Mainnet, Testnet }

enum KTransType {
  transfer,
}

enum KTransDataType {
  ts_all,
  ts_in,
  ts_out,
  ts_other,
}

final bool inProduction = kReleaseMode;
final bool isAndroid = Platform.isAndroid;
final bool isIOS = Platform.isIOS;
final String ASSETS_IMG = './assets/images/';

final String CSTOKEN_QR = "https://www.baidu.com";
final String SLOGAN = "Aggregation of NFT";

const int transferETHGasLimit = 25000;
const int transferERC20GasLimit = 65000;
