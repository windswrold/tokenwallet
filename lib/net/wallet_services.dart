import 'package:cstoken/net/request_method.dart';
import 'package:cstoken/net/url.dart';

class WalletServices {
  static getNFTNEWS(int page, int pagesize) {
    final url = RequestURLS.getnftnews;
    Map<String, String> params = {
      "pageNum": page.toString(),
      "pageSize": pagesize.toString(),
    };
  }

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
}
