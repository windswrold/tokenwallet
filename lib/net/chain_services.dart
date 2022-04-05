import 'dart:convert';
import 'dart:math';

import 'package:cstoken/model/node/node_model.dart';
import 'package:cstoken/model/tokens/collection_tokens.dart';
import 'package:cstoken/model/transrecord/trans_record.dart';
import 'package:cstoken/net/request_method.dart';
import 'package:cstoken/net/url.dart';
import 'package:cstoken/public.dart';
import 'package:cstoken/utils/date_util.dart';
import 'package:cstoken/utils/json_util.dart';
import 'package:decimal/decimal.dart';
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
    String host =
        NodeModel.queryNodeByChainType(KCoinType.BTC.index).content ?? "";
    String url = RequestURLS.getHost();
    if (method == Method.GET) {
      url += RequestURLS.blockcypherGet;
      queryParameters ??= {};
      queryParameters["url"] = host + path + queryParameters.url();
      queryParameters["time"] = DateUtil.getNowDateMs();
      queryParameters["secret"] = "";
    } else {
      url += RequestURLS.blockcypherPost;
      String content = JsonUtil.encodeObj(data) ?? "";
      queryParameters ??= {};
      queryParameters["url"] =
          host + path + (queryParameters != null ? queryParameters.url() : "");
      queryParameters["time"] = DateUtil.getNowDateMs();
      queryParameters["secret"] = "";
      queryParameters["content"] = content;
    }

    dynamic result = await RequestMethod.manager!
        .requestData(method, url, queryParameters: queryParameters, data: data);
    if (result != null && result is Map) {
      int code = result["code"];
      if (code == 200) {
        String object = result["result"];
        return JsonUtil.getObj(object);
      }
    }
    return result;
  }

  static Future<dynamic> requestTRXDatas(
      {required String path,
      required Method method,
      Map<String, dynamic>? queryParameters,
      dynamic data}) async {
    String host =
        NodeModel.queryNodeByChainType(KCoinType.TRX.index).content ?? "";
    String url = RequestURLS.getHost();
    if (method == Method.GET) {
      url += RequestURLS.trxGet;
      queryParameters ??= {};
      queryParameters["url"] = host + path + queryParameters.url();
      queryParameters["time"] = DateUtil.getNowDateMs();
      queryParameters["secret"] = "";
    } else {
      url += RequestURLS.trxPost;
      String content = JsonUtil.encodeObj(data) ?? "";
      queryParameters ??= {};
      queryParameters["url"] =
          host + path + (queryParameters != null ? queryParameters.url() : "");
      queryParameters["time"] = DateUtil.getNowDateMs();
      queryParameters["secret"] = "";
      queryParameters["content"] = content;
    }
    dynamic result = await RequestMethod.manager!
        .requestData(method, url, queryParameters: queryParameters, data: data);
    if (result != null && result is Map) {
      int code = result["code"];
      if (code == 200) {
        String object = result["result"];
        return JsonUtil.getObj(object);
      }
    }
    return null;
  }

  static Future<dynamic> requestETHDatas(
      {required KCoinType kCoinType,
      required String path,
      Map<String, dynamic>? queryParameters,
      dynamic data}) async {
    String host = NodeModel.getBlockExploreApi(kCoinType);
    queryParameters ??= {};
    String url = host + path;
    String netHost = RequestURLS.getHost() + RequestURLS.ethGet;
    queryParameters["url"] = url + queryParameters.url();
    queryParameters["time"] = DateUtil.getNowDateMs();
    queryParameters["secret"] = "";
    dynamic result = await RequestMethod.manager!.requestData(
        Method.GET, netHost,
        queryParameters: queryParameters, data: data);
    if (result != null && result is Map) {
      int code = result["code"];
      if (code == 200) {
        String object = result["result"];
        return JsonUtil.getObj(object);
      }
    }
    return result;

    // if (kCoinType == KCoinType.BSC) {
    //   queryParameters["apikey"] = "GK3C39199V556I849N46RSPPCJAGYA7RNG";
    // } else if (kCoinType == KCoinType.Arbitrum) {
    //   queryParameters["apikey"] = "WUFC43UEE3FCW1SKT3QYE4REHNTA24S1Y9";
    // } else if (kCoinType == KCoinType.AVAX) {
    //   queryParameters["apikey"] = "S15E9AHU2SG5J3JJXVFZYH4P2I5DA4744Q";
    // } else if (kCoinType == KCoinType.HECO) {
    //   queryParameters["apikey"] = "R9UASFXFRCY24SRGJQ6QM22DH4WX26PNSU";
    // } else if (kCoinType == KCoinType.ETH) {
    //   queryParameters["apikey"] = "TMBXD4DKBMRDWT8IBEZMJGPRHS7ZZN3UGK";
    // }
    // dynamic result = await RequestMethod.manager!.requestData(Method.GET, url,
    //     queryParameters: queryParameters, data: data);
    // return result;
  }

  static Future<List<TransRecordModel>> requestETHTranslist(
      {required MCollectionTokens tokens,
      required KTransDataType kTransDataType,
      required String from,
      required int page}) async {
    List<TransRecordModel> datas = [];
    Map<String, dynamic> params = {};
    KCoinType coinType = tokens.chainType!.geCoinType();
    NodeModel model = NodeModel.queryNodeByChainType(coinType.index);
    int? chainid = model.chainID;
    int? decimal = tokens.decimals;
    String? symbol = tokens.token;
    params["module"] = "account";
    params["address"] = from;
    params["page"] = page;
    params["offset"] = 20;
    params["sort"] = "desc";
    if (tokens.isToken == false) {
      params["action"] = "txlist";
    } else {
      params["action"] = "tokentx";
      params["contractaddress"] = tokens.contract;
    }
    dynamic result = await requestETHDatas(
        kCoinType: coinType, path: "/api", queryParameters: params);
    if (result != null && result is Map) {
      String status = result["status"];
      if (status == "1") {
        List object = result["result"];
        for (var item in object) {
          String blockNumber = item["blockNumber"];
          String timeStamp = item["timeStamp"];
          String hash = item["hash"];
          String fromADD = item["from"];
          String to = item["to"];
          BigInt value = BigInt.parse(item["value"]);
          BigInt gasPrice = BigInt.parse(item["gasPrice"] ?? "0");
          String gasUsed = item["gasUsed"] ?? "0";
          String fee = TRWallet.configFeeValue(
              cointype: coinType.index,
              beanValue: gasUsed,
              offsetValue: gasPrice.tokenString(9));

          TransRecordModel model = TransRecordModel();
          model.txid = hash;
          model.fromAdd = fromADD;
          model.toAdd = to;
          model.fee = fee;
          model.amount =
              decimal == null ? value.toString() : value.tokenString(decimal);
          model.date = DateUtil.formatDateMs(int.parse(timeStamp) * 1000);
          model.coinType = coinType.coinTypeString();
          model.token = symbol;
          model.transStatus = KTransState.success.index;
          model.transType = KTransType.transfer.index;
          model.blockHeight = int.tryParse(blockNumber);
          model.chainid = chainid;
          datas.add(model);
          // if (kTransDataType == KTransDataType.ts_all) {
          //   datas.add(model);
          // } else if (kTransDataType == KTransDataType.ts_out &&
          //     model.isOut(from)) {
          //   datas.add(model);
          // } else if (kTransDataType == KTransDataType.ts_in &&
          //     model.isOut(from) == false) {
          //   datas.add(model);
          // }
        }
        TransRecordModel.insertTrxLists(datas);
      }
    }
    return TransRecordModel.queryTrxList(
        from, symbol ?? "ETH", chainid ?? 0, kTransDataType.index,
        limit: 10, offset: ((page - 1) * 10));
  }

  static Future<List<TransRecordModel>> requestTRXTranslist(
      {required KTransDataType kTransDataType,
      required String from,
      required String? fingerprint,
      required int page,
      required String symbol,
      required String? contract,
      required int decimal,
      required Function(String? fingerprint) onComplation}) async {
    List<TransRecordModel> datas = [];
    String path = "";
    Map<String, dynamic> params = {};
    if (kTransDataType == KTransDataType.ts_other) {
      return [];
    }
    if (kTransDataType == KTransDataType.ts_in) {
      params["only_to"] = true; //转入
    }
    if (kTransDataType == KTransDataType.ts_out) {
      params["only_from"] = true;
    }
    params["search_internal"] = false;
    if (fingerprint != null) {
      params["fingerprint"] = fingerprint;
    }
    if (contract != null && contract.isNotEmpty) {
      path = "/v1/accounts/$from/transactions/trc20";
      params["contract_address"] = contract;
    } else {
      path = "/v1/accounts/$from/transactions";
    }
    dynamic result = await ChainServices.requestTRXDatas(
        path: path, method: Method.GET, queryParameters: params);
    if (result != null && result is Map) {
      List data = result["data"] ?? [];
      bool success = result["success"];
      if (success != true) {
        return [];
      }
      Map meta = result["meta"];
      if (meta.containsKey("fingerprint")) {
        String fp = meta["fingerprint"];
        onComplation(fp);
      } else {
        onComplation(null);
      }
      for (var item in data) {
        String from = "";
        String to = "";
        String value = "0";
        String time = "";
        String transaction_id = "";
        int? blockNumber;
        if (contract != null && contract.isNotEmpty) {
          //trc20
          from = item["from"];
          to = item["to"];
          value = item["value"];
          time = item["block_timestamp"].toString();
          transaction_id = item["transaction_id"];
        } else {
          blockNumber = item["blockNumber"];
          transaction_id = item["txID"];
          Map raw_data = item["raw_data"];
          time = raw_data["timestamp"].toString();
          List contractList = raw_data["contract"];
          String type = contractList.first["type"];
          Map valueParams = contractList.first["parameter"]["value"];
          from = TREncode.base58EncodeString(valueParams["owner_address"]);
          if (type == "TransferContract") {
            value = valueParams["amount"].toString();
            to = TREncode.base58EncodeString(valueParams["to_address"]);
          } else if (type == "TriggerSmartContract") {
            to = TREncode.base58EncodeString(valueParams["contract_address"]);
          } else {
            continue;
          }
        }
        TransRecordModel model = TransRecordModel();
        model.txid = transaction_id;
        model.fromAdd = from;
        model.toAdd = to;
        model.amount = BigInt.parse(value).tokenString(decimal);
        model.date = DateUtil.formatDateMs(int.parse(time));
        model.coinType = KCoinType.TRX.coinTypeString();
        model.token = symbol;
        model.transStatus = KTransState.success.index;
        model.chainid = 0;
        model.transType = KTransType.transfer.index;
        model.blockHeight = blockNumber;
        datas.add(model);
      }
      TransRecordModel.insertTrxLists(datas);
    }

    return TransRecordModel.queryTrxList(from, symbol, 0, kTransDataType.index,
        limit: 10, offset: ((page - 1) * 10));
  }

  static Future<List<TransRecordModel>> requestBTCTranslist(
      {required KTransDataType kTransDataType,
      required String from,
      required int page,
      required int? before}) async {
    List<TransRecordModel> datas = [];
    String path = "/addrs/$from/full";
    Map<String, dynamic> params = {};
    params["txlimit"] = 40;
    if (before != null) {
      params["before"] = before;
    }
    if (kTransDataType == KTransDataType.ts_other) {
      return datas;
    }
    dynamic result = await requestBTCDatas(
        path: path, method: Method.GET, queryParameters: params);
    if (result != null && result is Map) {
      List data = result["txs"] ?? [];
      for (var item in data) {
        String time = "";
        String transaction_id = "";
        transaction_id = item["hash"];
        time = item["received"] ?? "";
        int fees = item["fees"] ?? 0;
        int block_height = item["block_height"];
        List inputs = item["inputs"];
        List outputs = item["outputs"];
        Map state = _checkTransType(from, inputs, outputs);
        String trx_amount = state["a"] as String;
        bool isOut = state["o"] as int == 0 ? false : true;
        TransRecordModel model = TransRecordModel();
        model.txid = transaction_id;
        model.toAdd = isOut == false ? from : state["d"];
        model.fromAdd = isOut == true ? from : state["d"];
        model.date = time;
        model.amount = BigInt.parse(trx_amount).tokenString(8);
        model.fee = BigInt.from(fees).tokenString(8);
        model.transStatus = KTransState.success.index;
        model.coinType = KCoinType.BTC.coinTypeString();
        model.token = "BTC";
        model.blockHeight = block_height;
        model.chainid = 0;
        model.transType = KTransType.transfer.index;
        datas.add(model);
        // if (kTransDataType == KTransDataType.ts_all) {
        //   datas.add(model);
        // } else if (kTransDataType == KTransDataType.ts_out && isOut == true) {
        //   datas.add(model);
        // } else if (kTransDataType == KTransDataType.ts_in && isOut == false) {
        //   datas.add(model);
        // }
      }
      TransRecordModel.insertTrxLists(datas);
    }
    return TransRecordModel.queryTrxList(from, "BTC", 0, kTransDataType.index,
        limit: 10, offset: ((page - 1) * 10));
  }

  static Map _checkTransType(String from, List inputs, List outputs) {
    //根据input里数组有没有自己判断转入转出
    //转入时在input取转入的地址，在out取自己地址对应的金额,
    //转出时在out里去转出的地址，在intput里取转出地址的金额
    Map params = Map();
    int out = 0; //默认转入
    String toAddress = "coinbase";
    BigInt value = BigInt.zero;
    //判断转入转出
    if (inputs.isNotEmpty) {
      for (var input in inputs) {
        List addresses = input["addresses"] as List;
        for (var adds in addresses) {
          if (adds != null && from.toLowerCase() == adds.toLowerCase()) {
            out = 1; //转出
            value = BigInt.from(input["output_value"]);
            break;
          }
        }
      }
    }
    //找出地址金额
    if (out == 0) {
      if (inputs.isNotEmpty) {
        for (var input in inputs) {
          List addresses = input["addresses"] as List;
          for (var adds in addresses) {
            if (adds != null) {
              toAddress = adds;
              break;
            }
          }
        }
      }
      for (var output in outputs) {
        List addresses = output["addresses"];
        for (var add in addresses) {
          if (add == "false") {
            continue;
          }
          if (add.toLowerCase() == from.toLowerCase()) {
            value = BigInt.from(output["value"]);
            break;
          }
        }
      }
    } else {
      for (var output in outputs) {
        List addresses = output["addresses"];
        for (var add in addresses) {
          if (add == "false") {
            continue;
          }
          toAddress = add;
          break;
        }
      }
    }
    params["d"] = toAddress;
    params["a"] = value.toString();
    params["o"] = out;
    return params;
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
