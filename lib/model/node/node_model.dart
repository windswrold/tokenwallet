// import 'dart:html';
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

  static void configNodeData() async {
    // List<NodeModel>? nodes = await NodeModel.;
    // if (nodes == null || nodes.length == 0) {
    //   nodes = [];
    //   NodeModel _nodeModel = NodeModel(
    //       mainNet, MCoinType.MCoinType_ETH.index, true, true, true, 1);
    //   ChainServices.currentNode = _nodeModel;
    //   nodes.add(_nodeModel);
    //   nodes.add(NodeModel(
    //       rinkebyNet, MCoinType.MCoinType_ETH.index, false, true, false, 4));
    //   NodeModel.insertNodeDatas(nodes);
    //   return _nodeModel;
    // } else {
    //   NodeModel _nodeModel = nodes.first;
    //   ChainServices.currentNode = _nodeModel;
    //   return _nodeModel;
    // }
  }

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

  // static Future<List<NodeModel>?> queryNodeByChainType(int chainType) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     return database?.nodeDao.queryNodeByChainType(chainType);
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //     return null;
  //   }
  // }

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
