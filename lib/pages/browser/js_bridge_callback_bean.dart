import 'package:cstoken/utils/log_util.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

extension Web3Result on InAppWebViewController {
  void sendError(String error, int id) {
    final script = "window.ethereum.sendError($id,\"$error\")";
    LogUtil.v("script " + script);
    this.evaluateJavascript(source: script);
  }

  void sendResult(String result, int id) {
    final script = "window.ethereum.sendResponse($id, \"$result\")";
    LogUtil.v("script " + script);
    this.evaluateJavascript(source: script);
  }

  void sendResults(List<String> results, int id) {
    final array = results
        .map((e) => e.toLowerCase())
        .toList()
        .map((e) => "\"$e\"")
        .toList();
    final arrayStr = array.join(",");
    final script = "window.ethereum.sendResponse($id, [$arrayStr])";
    LogUtil.v("script " + script);
    this.evaluateJavascript(source: script);
  }

  void setAddress(String address, int id) async {
    address = address.toLowerCase();
    final script = "window.ethereum.setAddress('$address');";
    LogUtil.v("script " + script);
    await this.evaluateJavascript(source: script);
    sendResults([address], id);
  }
}
