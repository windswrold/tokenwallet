import 'package:cstoken/model/node/node_model.dart';
import 'package:cstoken/net/request_method.dart';
import 'package:cstoken/public.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class ChainServices {
  static Future<dynamic>? requestDatas(
      {required KCoinType? coinType, dynamic params}) async {
    String? url = NodeModel.queryNodeByChainType(coinType!.index).content;
    dynamic result = await RequestMethod.manager!
        .requestData(Method.POST, url!, data: params);
    return result;
  }
}
