import 'package:cstoken/db/database.dart';
import 'package:cstoken/db/database_config.dart';
import 'package:cstoken/utils/encode.dart';
import 'package:floor/floor.dart';

const String tableName = "nft_model_table";

@Entity(tableName: tableName)
class NFTModel {
  @primaryKey
  String? tokenID; //token唯一id
  String? owner; //walletID
  final String? chainTypeName;
  final String? contractAddress;
  final String? contractName;
  final String? nftId;
  final String? nftTypeName;
  final String? url;
  int? state; //是否显示
  int? kNetType; //0 是主网 非0是测试网

  NFTModel(
      {this.tokenID,
      this.owner,
      this.chainTypeName,
      this.contractAddress,
      this.contractName,
      this.nftId,
      this.nftTypeName,
      this.url,
      this.state,
      this.kNetType});

  static NFTModel fromJson(Map<String, dynamic> json) {
    return NFTModel(
      chainTypeName: json["chainTypeName"] ?? '',
      contractAddress: json["contractAddress"] ?? '',
      contractName: json["contractName"] ?? '',
      nftId: (json["nftId"] as List).join(','),
      nftTypeName: json["nftTypeName"] ?? '',
      url: json["url"] ?? '',
    );
  }

  String createTokenID(String walletID) {
    String tokenID = (kNetType.toString() +
        "|" +
        chainTypeName.toString() +
        "|" +
        walletID +
        "|" +
        (contractAddress ?? ""));
    return TREncode.SHA256(tokenID);
  }

  ///查询当前钱包下当前节点的所有
  static Future<List<NFTModel>> findTokens(String owner, int kNetType) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      return (await database?.nftDao.findNFTS(owner, kNetType)) ?? [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<NFTModel>> findWalletsTokens(String owner) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      return (await database?.nftDao.findAllNFTS(owner)) ?? [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<NFTModel>> findChainTokens(
      String owner, int kNetType, String chainType) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      return (await database?.nftDao
              .findChainNFTS(owner, kNetType, chainType)) ??
          [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<NFTModel>> findStateTokens(
      String owner, int state, int kNetType) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      return (await database?.nftDao.findStateNFTS(owner, state, kNetType)) ??
          [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<NFTModel>> findStateChainTokens(
      String owner, int state, int kNetType, String chainType) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      return (await database?.nftDao
              .findStateChainNFTS(owner, state, kNetType, chainType)) ??
          [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> insertTokens(List<NFTModel> models) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.nftDao.insertNFTS(models);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteTokens(List<NFTModel> models) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.nftDao.deleteNFTS(models);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> updateTokens(NFTModel model) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.nftDao.updateNFTS([model]);
    } catch (e) {
      rethrow;
    }
  }
}

@dao
abstract class NFTModelDao {
  @Query('SELECT * FROM ' + tableName + ' WHERE owner = :owner')
  Future<List<NFTModel>> findAllNFTS(String owner);

  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE owner = :owner and kNetType=:kNetType ')
  Future<List<NFTModel>> findNFTS(String owner, int kNetType);

  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE owner = :owner and kNetType=:kNetType and chainTypeName=:chainType ')
  Future<List<NFTModel>> findChainNFTS(
      String owner, int kNetType, String chainType);

  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE owner = :owner and state = :state and kNetType=:kNetType ')
  Future<List<NFTModel>> findStateNFTS(String owner, int state, int kNetType);

  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE owner = :owner and state = :state and kNetType=:kNetType and chainTypeName =:chainType ')
  Future<List<NFTModel>> findStateChainNFTS(
      String owner, int state, int kNetType, String chainType);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertNFTS(List<NFTModel> models);

  @delete
  Future<void> deleteNFTS(List<NFTModel> models);

  @update
  Future<void> updateNFTS(List<NFTModel> models);

  @Query("UPDATE " + tableName + " SET :sql")
  Future<void> updateNFTSData(String sql);
}
