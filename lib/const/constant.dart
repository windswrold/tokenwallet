import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import '../public.dart';
import 'dart:ui' as ui;

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
  BTC,
  TRX,
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

enum KTokenType { native, token, trc20, eip721, eip1155 }

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

enum KCreateType {
  create,
  restore,
  import,
}

enum KDappType {
  records,
  collect,
  recordsandcollect,
}

extension ChainTypeString on KChainType {
  String getChainType() {
    if (this == KChainType.HD) {
      return "wallets_manager_multichain".local();
    } else if (this == KChainType.ETH) {
      return "importwallet_ethchaintype".local();
    } else if (this == KChainType.BTC) {
      return "importwallet_btcchaintype".local();
    } else if (this == KChainType.TRX) {
      return "importwallet_trxchaintype".local();
    }
    return "";
  }

  String getTokenType() {
    if (this == KChainType.HD) {
      return "wallets_manager_multichain".local();
    } else if (this == KChainType.ETH) {
      return "ETH,BSC,Heco,OK,Polygon,AVAX,Arbitrum";
    } else if (this == KChainType.BTC) {
      return "BTC";
    } else if (this == KChainType.TRX) {
      return "TRON";
    }
    return "";
  }

  String? getNetTokenType() {
    if (this == KChainType.HD) {
    } else if (this == KChainType.ETH) {
      return "ETH";
    } else if (this == KChainType.BTC) {
      return "BTC";
    } else if (this == KChainType.TRX) {
      return "TRON";
    }
    return null;
  }

  List<KCoinType> getSuppertCoinTypes() {
    if (this == KChainType.HD) {
      return KCoinType.values;
    } else if (this == KChainType.ETH) {
      return [
        KCoinType.ETH,
        KCoinType.BSC,
        KCoinType.HECO,
        KCoinType.OKChain,
        KCoinType.Matic,
        KCoinType.AVAX,
        KCoinType.Arbitrum
      ];
    } else if (this == KChainType.BTC) {
      return [KCoinType.BTC];
    } else if (this == KChainType.TRX) {
      return [KCoinType.TRX];
    }
    return [];
  }

  List<KCoinType> getTokensSuppertCoinTypes() {
    if (this == KChainType.HD) {
      List<KCoinType> tokens = KChainType.ETH.getSuppertCoinTypes();
      tokens.add(KCoinType.TRX);
      return tokens;
    } else if (this == KChainType.ETH) {
      return KChainType.ETH.getSuppertCoinTypes();
    } else if (this == KChainType.TRX) {
      return [KCoinType.TRX];
    }
    return [];
  }
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
        return "Polygon";
      case KCoinType.AVAX:
        return "AVAX";
      case KCoinType.Arbitrum:
        return "Arbitrum";
      case KCoinType.BTC:
        return "BTC";
      case KCoinType.TRX:
        return "TRON";
      default:
        throw Error();
    }
  }

  String feeTokenString() {
    switch (this) {
      case KCoinType.BSC:
        return "BNB";
      case KCoinType.ETH:
        return "ETH";
      case KCoinType.HECO:
        return "HT";
      case KCoinType.OKChain:
        return "OKT";
      case KCoinType.Matic:
        return "MATIC";
      case KCoinType.AVAX:
        return "AVAX";
      case KCoinType.Arbitrum:
        return "ETH-ARBI";
      case KCoinType.BTC:
        return "BTC";
      case KCoinType.TRX:
        return "TRX";
      default:
        throw Error();
    }
  }
}

extension KCurrencyTypeString on KCurrencyType {
  String get value => <String>['CNY', 'USD'][index];
}

extension KAppLanguageString on KAppLanguage {
  String get value => <String>[
        'minepage_followsystem'.local(),
        'minepage_zh_hans'.local(),
        'English'
      ][index];
}

extension KNetTypeString on KNetType {
  String get value => <String>['MainNet', 'TestNet'][index];
}

final bool inProduction = kReleaseMode;
final bool isAndroid = Platform.isAndroid;
final bool isIOS = Platform.isIOS;
final String ASSETS_IMG = './assets/images/';

final String SLOGAN = "Aggregation of NFT";

const int transferETHGasLimit = 25000;
const int transferERC20GasLimit = 65000;

EventBus eventBus = EventBus();

class MtransListUpdate {}

Size calculateTextSize(
  String value,
  double fontSize,
  FontWeight fontWeight,
  double maxWidth,
  int? maxLines,
  BuildContext context,
) {
  TextPainter painter = TextPainter(
    locale: Localizations.localeOf(context),
    maxLines: maxLines,
    textDirection: TextDirection.ltr,
    text: TextSpan(
      text: value,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    ),
  );
  painter.layout(maxWidth: maxWidth);
  LogUtil.v("calculateTextSize ${Size(painter.width, painter.height)}");
  return Size(painter.width, painter.height);
}

Future<File> shareImage(GlobalKey repkey) async {
  late ui.Image _convertedImage;
  final _boundary =
      repkey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  _convertedImage = await _boundary.toImage(pixelRatio: 3);
  final byteData =
      await _convertedImage.toByteData(format: ui.ImageByteFormat.png);
  final image = byteData?.buffer.asUint8List();
  final directory = (await getTemporaryDirectory()).path;
  await Directory('$directory/sample').create(recursive: true);
  final fullPath =
      '$directory/sample/${DateTime.now().millisecondsSinceEpoch}.png';
  final imgFile = File('$fullPath');
  return imgFile.writeAsBytes(image!);
}

String bsc_apiKey = 'GK3C39199V556I849N46RSPPCJAGYA7RNG';
String arb_apikey = 'WUFC43UEE3FCW1SKT3QYE4REHNTA24S1Y9';
String avax_apikey = 'X8IINYPZ7MV6B5H3TC5226E7P3FFWW7AXW';
String heco_apikey = 'ZR64U734RYXTM57SWM78DIHD9G4X16IKAK';
String mati_apikey = '';

String alltoken_MainContract = "0x6F0b8B05799332Cb6883f6E4e84d259f6cd6b255";
String alltoken_TestContract = "0x3eD836A6bC50F6c8edC55ab21D4d0Df7ceADA03f";
