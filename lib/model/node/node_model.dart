// import 'dart:html';
import 'package:cstoken/utils/sp_manager.dart';
import 'package:floor/floor.dart';
import '../../public.dart';

const String tableName = "nodes_table";

@Entity(tableName: tableName, primaryKeys: ["content", "chainType"])
class NodeModel {
  String? content;
  int? chainType;
  bool? isChoose;
  int? netType; //类型
  int? chainID;

  NodeModel(
      {this.content,
      this.chainType,
      this.isChoose,
      this.netType,
      this.chainID}); //ID

  static void configNodeData() async {}

  // static Future<bool> insertNodeDatas(List<NodeModel> list) async {
  //   try {
  //     FlutterDatabase? database = await BaseModel.getDataBae();
  //     database?.nodeDao.insertNodeDatas(list);
  //     return true;
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //   }
  //   return false;
  // }

  // static Future<bool> insertNodeData(NodeModel model) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     database?.nodeDao.insertNodeData(model);
  //     return true;
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //   }
  //   return false;
  // }

  static NodeModel queryNodeByChainType(int chainType) {
    KNetType netType = SPManager.getNetType();
    NodeModel node = NodeModel();
    node.netType = netType.index;
    node.chainType = chainType;
    if (chainType == KCoinType.ETH.index) {
      if (KNetType.Mainnet == netType) {
        node.chainID = 1;
        node.content =
            "https://mainnet.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161";
      } else {
        node.chainID = 4;
        node.content =
            "https://rinkeby.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161";
      }
    }
    if (chainType == KCoinType.BSC.index) {
      if (KNetType.Mainnet == netType) {
        node.chainID = 56;
        node.content = "https://bsc-dataseed.binance.org/";
      } else {
        node.chainID = 97;
        // node.content = "https://data-seed-prebsc-1-s1.binance.org:8545";
        node.content = "https://data-seed-prebsc-2-s3.binance.org:8545";
      }
    }
    if (chainType == KCoinType.HECO.index) {
      if (KNetType.Mainnet == netType) {
        node.chainID = 128;
        node.content = "https://http-mainnet.hecochain.com";
      } else {
        node.chainID = 256;
        node.content = "https://http-testnet.hecochain.com";
      }
    }
    if (chainType == KCoinType.OKChain.index) {
      if (KNetType.Mainnet == netType) {
        node.chainID = 66;
        node.content = "https://exchainrpc.okex.org";
      } else {
        node.chainID = 65;
        node.content = "https://exchaintestrpc.okex.org";
      }
    }
    if (chainType == KCoinType.Arbitrum.index) {
      if (KNetType.Mainnet == netType) {
        node.chainID = 42161;
        node.content = "https://arb1.arbitrum.io/rpc";
      } else {
        node.chainID = 421611;
        node.content = "https://rinkeby.arbitrum.io/rpc";
      }
    }
    if (chainType == KCoinType.Matic.index) {
      if (KNetType.Mainnet == netType) {
        node.chainID = 137;
        node.content = "https://polygon-rpc.com/";
      } else {
        node.chainID = 80001;
        node.content = "https://matic-mumbai.chainstacklabs.com";
      }
    }
    if (chainType == KCoinType.AVAX.index) {
      if (KNetType.Mainnet == netType) {
        node.chainID = 43114;
        node.content = "https://api.avax.network/ext/bc/C/rpc";
      } else {
        node.chainID = 43113;
        node.content = "https://api.avax-test.network/ext/bc/C/rpc";
      }
    }
    assert(node.content != null,
        "nodechainType " + chainType.geCoinType().coinTypeString() + "没有节点信息");
    return node;
  }

  // static Future<List<NodeModel>?> queryNodeByIsChoose(bool isChoose) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     return database?.nodeDao.queryNodeByIsChoose(isChoose);
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //     return null;
  //   }
  // }

  // static Future<List<NodeModel>?> queryNodeByContent(String content) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     return database?.nodeDao.queryNodeByContent(content);
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //     return null;
  //   }
  // }

  // static Future<List<NodeModel>?> queryNodeByIsDefaultAndChainType(
  //     bool isDefault, int chainType) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     return database?.nodeDao
  //         .queryNodeByIsDefaultAndChainType(isDefault, chainType);
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //     return null;
  //   }
  // }

  // static Future<List<NodeModel>?> queryNodeByContentAndChainType(
  //     String content, int chainType) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     return database?.nodeDao
  //         .queryNodeByContentAndChainType(content, chainType);
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //     return null;
  //   }
  // }

  // static Future<bool> updateNode(NodeModel model) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     database?.nodeDao.updateNode(model);
  //     return true;
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //     return false;
  //   }
  // }

  // static Future<bool> updateNodes(List<NodeModel> models) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     database?.nodeDao.updateNodes(models);
  //     return true;
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //     return false;
  //   }
  // }
}

@dao
abstract class NodeDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertNodeDatas(List<NodeModel> list);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertNodeData(NodeModel model);

  @Query('SELECT * FROM $tableName WHERE  isChoose = :isChoose')
  Future<List<NodeModel>> queryChooseNode(bool isChoose);

  @Query(
      'SELECT * FROM $tableName WHERE chainType = :chainType and isChoose = :isChoose')
  Future<List<NodeModel>> queryNodeByChainType(int chainType, bool isChoose);

  @update
  Future<void> updateNode(NodeModel model);

  @update
  Future<void> updateNodes(List<NodeModel> models);
}
