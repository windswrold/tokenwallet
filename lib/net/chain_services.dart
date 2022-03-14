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
    result = await RequestMethod.manager!
        .requestData(Method.POST, url, data: params);
    return result;
  }

  static Future<dynamic> requestBTCDatas(
      {required String path,
      required Method method,
      dynamic data,
      Map<String, dynamic>? queryParameters}) async {
    String url =
        NodeModel.queryNodeByChainType(KCoinType.BTC.index).content ?? "";
    dynamic result;
    url += path;
    queryParameters ??= {};
    queryParameters["token"] = "51db957650794388ae078d96f331a3e8";
    result = await RequestMethod.manager!
        .requestData(method, url, queryParameters: queryParameters, data: data);
    return result;
  }

  static Future<dynamic> requestTRXDatas(
      {required String path,
      required Method method,
      Map<String, dynamic>? queryParameters,
      dynamic data}) async {
    String url =
        NodeModel.queryNodeByChainType(KCoinType.TRX.index).content ?? "";
    dynamic result;
    url += path;
    Map<String, dynamic> headers = {
      "token": "289637ce-c32c-4b76-9459-06f55cc2a648" //
    };
    result = await RequestMethod.manager!.requestData(method, url,
        queryParameters: queryParameters, header: headers, data: data);
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
      {required KCoinType type,
      required String contract,
      required String walletAaddress}) async {
    NodeModel node = NodeModel.queryNodeByChainType(type.index);
    if (type == KCoinType.TRX) {
      String contract_address = TREncode.base58HexString(contract);
      String owner_address = TREncode.base58HexString(contract);
      Map symbol = {
        "contract_address": contract_address,
        "owner_address": owner_address,
        "function_selector": "symbol()"
      };
      Map decimals = {
        "contract_address": contract_address,
        "owner_address": owner_address,
        "function_selector": "decimals()"
      };
      dynamic symbolResult = await requestTRXDatas(
          path: "/wallet/triggerconstantcontract",
          method: Method.POST,
          data: symbol);
      dynamic decimalResult = await requestTRXDatas(
          path: "/wallet/triggerconstantcontract",
          method: Method.POST,
          data: decimals);
      if (symbolResult == null || decimalResult == null) {
        return null;
      }

      String subsymbolResult = (symbolResult["constant_result"] as List).first;
      String subdecimalResult =
          (decimalResult["constant_result"] as List).first;
      if (subsymbolResult.isNotEmpty && subdecimalResult.isNotEmpty) {
        Map object = {};
        subsymbolResult = subsymbolResult.replaceFirst("0x", "");
        subdecimalResult = subdecimalResult.replaceFirst("0x", "");
        int? decimal = int.tryParse(subdecimalResult, radix: 16);
        int length = int.parse(subsymbolResult.substring(64, 128), radix: 16);
        String result = subsymbolResult.substring(128, 128 + length * 2);
        result = utf8.decoder.convert(hexToBytes(result));
        result = result.replaceAll(" ", "").trim();
        object["symbol"] = result;
        object["decimal"] = decimal;
        return object;
      }
    } else {
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
          .requestData(Method.POST, node.content!, data: [decimals, symbol]);
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
}
