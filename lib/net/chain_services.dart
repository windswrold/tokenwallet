import 'package:cstoken/model/node/node_model.dart';
import 'package:cstoken/net/request_method.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class ChainServices {
  // static Future<int?> getGasPrice({required int chainType}) async {
  //   NodeModel node = NodeModel.queryNodeByChainType(chainType);
  //   if (node.content == null) {
  //     return null;
  //   }
  //   Web3Client client = Web3Client(node.content!, Client());
  //   EtherAmount gas = await client.getGasPrice();
  //   return gas.getValueInUnit(EtherUnit.gwei).toInt();
  // }
}
