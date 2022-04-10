import 'package:cstoken/model/news/news_model.dart';
import 'package:cstoken/model/token_price/tokenprice.dart';
import 'package:cstoken/model/tokens/collection_tokens.dart';
import 'package:cstoken/net/request_method.dart';
import 'package:cstoken/net/url.dart';
import 'package:cstoken/public.dart';
import 'package:decimal/decimal.dart';

class WalletServices {
  static Future<List> getdappbannerInfo() async {
    final url = RequestURLS.getHost() + RequestURLS.getdappbannerInfo;
    dynamic result = await RequestMethod.manager!.requestData(Method.GET, url);
    if (result != null && result["code"] == 200) {
      List bannerData = result["result"]["page"] ?? [];
      return bannerData;
    }
    return [];
  }

  static Future<List> getdappType() async {
    final url = RequestURLS.getHost() + RequestURLS.getdappType;
    dynamic result = await RequestMethod.manager!.requestData(Method.GET, url);
    if (result != null && result["code"] == 200) {
      List data = result["result"]["page"] ?? [];
      return data;
    }
    return [];
  }

  static Future<List> getdapptypeList(String dAppType) async {
    final url = RequestURLS.getHost() + RequestURLS.getdapptypeList;
    Map<String, dynamic> params = {"dAppType": dAppType};
    dynamic result = await RequestMethod.manager!
        .requestData(Method.GET, url, queryParameters: params);
    if (result != null && result["code"] == 200) {
      List data = result["result"]["page"] ?? [];
      return data;
    }
    return [];
  }

  static Future<List<NewsModel>> getnftnews(int page, int pagesize) async {
    String url = RequestURLS.getHost() + RequestURLS.getnftnews;

    Map<String, dynamic> params = {
      "pageNum": page.toString(),
      "pageSize": pagesize.toString(),
    };
    dynamic result = await RequestMethod.manager!
        .requestData(Method.GET, url, queryParameters: params);
    if (result != null && result["code"] == 200) {
      List data = result["result"]["page"]["list"] ?? [];
      List<NewsModel> results = [];
      for (var element in data) {
        final content = element["content"];
        final createTime = element["createTime"];
        final createTimestamp = element["createTimestamp"];
        final source = element["source"];
        final timeTips = element["timeTips"];
        final title = element["title"];
        NewsModel nes = NewsModel(
            content: content,
            createTime: createTime,
            createTimestamp: createTimestamp,
            timeTips: timeTips,
            source: source,
            title: title);
        results.add(nes);
      }
      return results;
    }
    return [];
  }

  static Future<List<NewsModel>> getlettersnews(int page, int pagesize) async {
    final url = RequestURLS.getHost() + RequestURLS.getlettersnews;
    Map<String, dynamic> params = {
      "pageNum": page.toString(),
      "pageSize": pagesize.toString(),
    };
    dynamic result = await RequestMethod.manager!
        .requestData(Method.GET, url, queryParameters: params);
    if (result != null && result["code"] == 200) {
      List data = result["result"]["page"]["list"] ?? [];
      List<NewsModel> results = [];
      for (var element in data) {
        final content = element["content"];
        final createTime = element["createTime"];
        final createTimestamp = element["createTimestamp"];
        final source = element["source"];
        final timeTips = element["timeTips"];
        final title = element["title"];
        NewsModel nes = NewsModel(
            content: content,
            createTime: createTime,
            createTimestamp: createTimestamp,
            timeTips: timeTips,
            source: source,
            title: title);
        results.add(nes);
      }
      return results;
    }
    return [];
  }

  static Future ethGasStation({KCoinType? coinType}) async {
    const url = "https://ethgasstation.info/json/ethgasAPI.json";
    dynamic result = await RequestMethod.manager!.requestData(Method.GET, url);
    if (result != null) {
      int _fastest = ((result['fastest'] / 10).toInt());
      int _faster = ((result['fast'] / 10).toInt());
      int _average = ((result['average'] / 10).toInt());
      return {
        "fastestgas": _fastest.toString(),
        "fastgas": _faster.toString(),
        "average": _average.toString(),
      };
    }
  }

  static Future<Map?> getindexnftInfo(String address, String chainType) async {
    final url = RequestURLS.getHost() + RequestURLS.getindexnftInfo;
    Map<String, dynamic> params = {
      "address": address.toString(),
      "chainType": chainType
    };
    dynamic result = await RequestMethod.manager!
        .requestData(Method.GET, url, queryParameters: params);
    if (result != null && result["code"] == 200) {
      Map? data = result["result"];
      return data;
    }
  }

  static Future<List> getindexapplicationInfo() async {
    final url = RequestURLS.getHost() + RequestURLS.getindexapplicationInfo;
    dynamic result = await RequestMethod.manager!.requestData(Method.GET, url);
    if (result != null && result["code"] == 200) {
      List data = result["result"]["page"] ?? [];
      return data;
    }
    return [];
  }

  static Future<List> getbannerInfo() async {
    final url = RequestURLS.getHost() + RequestURLS.getbannerInfo;
    dynamic result = await RequestMethod.manager!.requestData(Method.GET, url);
    if (result != null && result["code"] == 200) {
      List data = result["result"]["page"] ?? [];
      return data;
    }
    return [];
  }

  static Future<List> getindexpopularItem() async {
    final url = RequestURLS.getHost() + RequestURLS.getindexpopularItem;
    dynamic result = await RequestMethod.manager!.requestData(Method.GET, url);
    if (result != null && result["code"] == 200) {
      List data = result["result"]["page"] ?? [];
      return data;
    }
    return [];
  }

  static Future<Map?> getAppversion(String version) async {
    final url = RequestURLS.getHost() + RequestURLS.getAppversion;
    Map<String, dynamic> params = {
      "version": version.replaceAll(".", ""),
    };
    dynamic result = await RequestMethod.manager!
        .requestData(Method.GET, url, queryParameters: params);
    if (result != null && result["code"] == 200) {
      Map data = result["result"] ?? [];
      return data;
    }
    return null;
  }

  static void gettokenPrice(String symbol) async {
    final url = RequestURLS.getHost() + RequestURLS.gettokenPrice;

    Map<String, dynamic> params = {
      "symbol": symbol,
    };
    dynamic result = await RequestMethod.manager!
        .requestData(Method.GET, url, queryParameters: params);
    if (result != null && result["code"] == 200) {
      List<TokenPrice> tokens = [];
      List data = result["result"]["page"] ?? [];
      for (var item in data) {
        final cnyPrice = item["cnyPrice"];
        final usdPrice = item["usdPrice"];
        final tokenName = item["tokenName"];
        final chainType = item["chainType"];

        final tokencny = TokenPrice(
            contract: tokenName,
            source: tokenName,
            target: KCurrencyType.CNY.index.toString(),
            rate: cnyPrice);
        final tokenusd = TokenPrice(
            contract: tokenName,
            source: tokenName,
            target: KCurrencyType.USD.index.toString(),
            rate: usdPrice);
        tokens.add(tokencny);
        tokens.add(tokenusd);
      }
      TokenPrice.insertTokensPrice(tokens);
    }
  }

  static Future<List> gettokenList(int page, int pagesize,
      {String? tokenName,
      String? tokenContractAddress,
      String? chainType,
      bool? defaultFlag}) async {
    final url = RequestURLS.getHost() + RequestURLS.gettokenList;
    Map<String, dynamic> params = {"pageSize": pagesize, "pageNum": page};
    if (tokenName != null) {
      params["tokenName"] = tokenName;
    }
    if (tokenContractAddress != null) {
      params["tokenContractAddress"] = tokenContractAddress;
    }
    if (defaultFlag != null) {
      params["defaultFlag"] = defaultFlag == true ? "1" : "0";
    }
    if (chainType != null) {
      params["chainSeries"] = chainType.toLowerCase();
    }

    dynamic result = await RequestMethod.manager!
        .requestData(Method.GET, url, queryParameters: params);
    if (result != null && result["code"] == 200) {
      List data = result["result"]["page"]["list"] ?? [];
      return data;
    }
    return [];
  }

  static Future<List> getpopularToken({String? chainType}) async {
    final url = RequestURLS.getHost() + RequestURLS.getpopularToken;
    Map<String, dynamic>? params;
    if (chainType != null) {
      params ??= {"chainSeries": chainType.toLowerCase()};
    }
    dynamic result = await RequestMethod.manager!
        .requestData(Method.GET, url, queryParameters: params);
    if (result != null && result["code"] == 200) {
      List data = result["result"]["page"] ?? [];
      return data;
    }
    return [];
  }

  static void getLinkInfo() async {
    final url = RequestURLS.getHost() + RequestURLS.linkInfo;

    dynamic result = await RequestMethod.manager!.requestData(Method.GET, url);
    if (result != null && result["code"] == 200) {
      Map data = result["result"] ?? [];
      final iosUrl = data["iosUrl"] ?? "";
      final androidUrl = data["androidUrl"] ?? "";
      final appDownUrl = data["appDownUrl"] ?? "";
      final userAgreementUrl = data["userAgreementUrl"] ?? "";
      SPManager.setLinkInfo(SPManager.setIosDwownloadUrl, iosUrl);
      SPManager.setLinkInfo(SPManager.setAndroidUrl, androidUrl);
      SPManager.setLinkInfo(SPManager.setappDownUrl, appDownUrl);
      SPManager.setLinkInfo(SPManager.setuserAgreementUrl, userAgreementUrl);
    }
  }

  static Future<Map?> getgasPrice(String chainType) async {
    final url = RequestURLS.getHost() + RequestURLS.getgasPrice;
    if (chainType.toLowerCase() == "tron" || chainType.toLowerCase() == "btc") {
      return null;
    }

    Map<String, dynamic> params = {"chainType": chainType};
    dynamic result = await RequestMethod.manager!
        .requestData(Method.GET, url, queryParameters: params);
    if (result != null && result["code"] == 200) {
      Map data = result["result"] ?? [];
      return data;
    }
  }

  static Future<List> getNftList(
      {int pageNum = 1, bool popularFlag = false}) async {
    final url = RequestURLS.getHost() + RequestURLS.nftList;
    Map<String, dynamic>? params = {};
    params["pageNum"] = pageNum.toString();
    params["pageSize"] = "10";
    params["popularFlag"] = popularFlag == false ? "0" : "1";
    params["defaultFlag"] = "1";
    dynamic result = await RequestMethod.manager!
        .requestData(Method.GET, url, queryParameters: params);
    if (result != null && result["code"] == 200) {
      List data = result["result"]["page"]["list"] ?? [];
      return data;
    }
    return [];
  }

  static Future<List<dynamic>> getUserNftList({required String address}) async {
    final url = RequestURLS.getHost() + RequestURLS.userNftList;
    Map<String, dynamic>? params = {};
    params["address"] = address;
    dynamic result = await RequestMethod.manager!
        .requestData(Method.GET, url, queryParameters: params);
    if (result != null && result["code"] == 200) {
      List data = result["result"]["page"] ?? [];

      // data.addAll([
      //   {
      //     "chainTypeName": "eth",
      //     "contractAddress": "0x064e16771A4864561f767e4Ef4a6989fc4045aE7",
      //     "id": 2,
      //     "nftId": [78932],
      //     "nftTypeName": "721",
      //     "sumCount": 0,
      //   },
      //   {
      //     "chainTypeName": "eth",
      //     "contractAddress": "0xbf3181c23f25cc8ad5d326a3a313f80e9162c8d2",
      //     "id": 2,
      //     "nftId": [100],
      //     "nftTypeName": "721",
      //     "sumCount": 0,
      //   },
      //   {
      //     "chainTypeName": "eth",
      //     "contractAddress": "0x4b2e42c23c7a85ff7874cbdad65b3421e5197c76",
      //     "id": 2,
      //     "nftId": [0],
      //     "nftTypeName": "721",
      //     "sumCount": 0,
      //   },
      //   {
      //     "chainTypeName": "eth",
      //     "contractAddress": "0x064e16771A4864561f767e4Ef4a6989fc4045aE7",
      //     "id": 2,
      //     "nftId": [78932],
      //     "nftTypeName": "721",
      //     "sumCount": 0,
      //   }
      // ]);

      // String chainTypeName = item["chainTypeName"];
      // String contractAddress = item["contractAddress"];
      // String id = item["nftId"].toString();
      // String token = item["contract_name"] ?? "";
      // String url = item["url"];
      // String nftTypeName = item["nftTypeName"];
      // Decimal sumCount =
      //     Decimal.tryParse(item["sumCount"].toString()) ?? Decimal.zero;

      // contractAddress = "0x2c30b60038394755c9ab4285fa59d722153a63e5";
      // id = "446160950877979480142007162702782189984542661413";
      // sumCount = Decimal.fromInt(10);
      // chainTypeName = "ETH";

      // MCollectionTokens model = MCollectionTokens();
      // model.contract = contractAddress;
      // model.digits = 0;
      // model.chainType = chainTypeName.chainTypeGetCoinType()!.index;
      // model.tid = id;
      // model.iconPath = url;
      // model.decimals = 0;
      // model.token = token;
      // model.tokenType = nftTypeName == "721"
      //     ? KTokenType.eip721.index
      //     : KTokenType.eip1155.index;
      // model.balance = sumCount.toDouble();
      // model.coinType = chainTypeName.chainTypeGetCoinType()!.coinTypeString();
      // values.add(model);

      return data;
    }
    return [];
  }
}
