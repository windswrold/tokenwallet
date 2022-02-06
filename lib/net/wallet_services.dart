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

  static getdappbannerInfo() {
    final url = RequestURLS.getdappbannerInfo;

    RequestMethod.manager!.requestData(Method.GET, url);
  }
}
