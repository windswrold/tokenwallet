import 'package:cstoken/model/news/news_model.dart';
import 'package:cstoken/model/token_price/tokenprice.dart';
import 'package:cstoken/net/request_method.dart';
import 'package:cstoken/net/url.dart';
import 'package:cstoken/public.dart';

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
      params["chainType"] = chainType.toLowerCase();
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
      params ??= {"chainType": chainType.toLowerCase()};
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
}
