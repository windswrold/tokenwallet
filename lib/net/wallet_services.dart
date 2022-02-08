import 'package:cstoken/model/news/news_model.dart';
import 'package:cstoken/net/request_method.dart';
import 'package:cstoken/net/url.dart';
import 'package:cstoken/public.dart';

class WalletServices {
  static Future<List> getdappbannerInfo() async {
    final url = RequestURLS.getdappbannerInfo;
    dynamic result = await RequestMethod.manager!.requestData(Method.GET, url);
    if (result != null && result["code"] == 200) {
      List bannerData = result["result"]["page"] ?? [];
      return bannerData;
    }
    return [];
  }

  static Future<List> getdappType() async {
    final url = RequestURLS.getdappType;
    dynamic result = await RequestMethod.manager!.requestData(Method.GET, url);
    if (result != null && result["code"] == 200) {
      List data = result["result"]["page"] ?? [];
      return data;
    }
    return [];
  }

  static Future<List> getdapptypeList(String dAppType) async {
    final url = RequestURLS.getdapptypeList;
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
    final url = RequestURLS.getnftnews;

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
    final url = RequestURLS.getlettersnews;
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
    final url = "https://ethgasstation.info/json/ethgasAPI.json";
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
}
