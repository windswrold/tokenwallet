import 'dart:convert';

import 'package:cstoken/model/node/node_model.dart';
import 'package:cstoken/net/request_method.dart';
import 'package:cstoken/public.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class ChainServices {
  static Future<dynamic> requestDatas(
      {required KCoinType? coinType, dynamic params}) async {
    String url = NodeModel.queryNodeByChainType(coinType!.index).content ?? "";
    dynamic result;
    if (coinType == KCoinType.BTC) {
      url += (params as List).first;
      url += "token=51db957650794388ae078d96f331a3e8";
      result = await RequestMethod.manager!.requestData(Method.GET, url);
    } else {
      result = await RequestMethod.manager!
          .requestData(Method.POST, url, data: params);
    }

    return result;
  }

  static Future requestTransactionReceipt(String tx, String url) async {
    String method = "eth_getTransactionReceipt";
    Map params = {
      "jsonrpc": "2.0",
      "method": method,
      "params": [tx],
      "id": tx,
    };
    return RequestMethod.manager!.requestData(Method.POST, url, data: params);
  }

  static Future<Map?> requestTokenInfo(
      {required String url, required String contract}) async {
    Map decimals = {
      "jsonrpc": "2.0",
      "id": "n",
      "method": "eth_call",
      "params": [
        {"to": contract, "data": "0x313ce567"},
        "latest"
      ]
    };
    Map symbol = {
      "jsonrpc": "2.0",
      "id": "n",
      "method": "eth_call",
      "params": [
        {"to": contract, "data": "0x95d89b41"},
        "latest"
      ]
    };
    dynamic result = await RequestMethod.manager!
        .requestData(Method.POST, url, data: [decimals, symbol]);
    if (result == null) {
      return null;
    }
    List response = result as List;
    Map? object;
    for (var i = 0; i < response.length; i++) {
      Map params = response[i];
      if (params.keys.contains("result") && params["result"].length > 2) {
        String result = params["result"] as String;
        result = result.replaceAll("0x", "");
        object ??= {};
        if (i == 0) {
          int? decimal = int.tryParse(result, radix: 16);
          LogUtil.v("decimal $decimal");
          object["decimal"] = decimal;
        } else if (i == 1 && result.length == 192) {
          int length = int.parse(result.substring(64, 128), radix: 16);
          result = result.substring(128, 128 + length * 2);
          result = utf8.decoder.convert(hexToBytes(result));
          result = result.replaceAll(" ", "").trim();
          LogUtil.v("symbol  $result");
          object["symbol"] = result;
        }
      }
    }
    return object;
  }
}
