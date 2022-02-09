import 'dart:async';

import 'package:cstoken/db/database.dart';
import 'package:cstoken/db/database_config.dart';
import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../public.dart';

const String tableName = "tokens_table";

@Entity(tableName: tableName)
class MCollectionTokens {
  @primaryKey
  String? tokenID; //token唯一id
  String? owner; //walletID
  String? contract; //合约地址
  String? token; //符号
  String? coinType; //主币符号
  int? chainType; //哪条链
  int? state; //是否显示
  String? iconPath; //图片地址
  int? decimals;
  double? price;
  double? balance;
  int? digits;
  int? kNetType; //0 是主网 非0是测试网
  int? index; //排序

  MCollectionTokens({
    this.tokenID,
    this.owner,
    this.contract,
    this.token,
    this.coinType,
    this.state,
    this.decimals,
    this.price,
    this.balance,
    this.digits,
    this.iconPath,
    this.chainType,
    this.index,
    this.kNetType,
  });

  static MCollectionTokens fromJson(Map<String, dynamic> json) {
    return MCollectionTokens(
      coinType: json['coinType'] as String?,
      chainType: json['chainType'] as int?,
      token: json['token'] as String?,
      decimals: json['decimals'] as int?,
      contract: json['contract'] as String?,
      digits: json['digits'] as int?,
      kNetType: json['kNetType'] as int?,
    );
  }

  String get assets =>
      StringUtil.dataFormat(((price ??= 0) * (balance ??= 0)), 2);

  String get priceString => StringUtil.dataFormat(price ??= 0, 2);

  String get balanceString =>
      StringUtil.dataFormat(this.balance ?? 0.0, this.digits!);

  // static Future<bool> moveItem(
  //     String walletID, int oldIndex, int newIndex) async {
  //   try {
  //     FlutterDatabase database = await BaseModel.getDataBae();
  //     List<MHWallet> datas = [];
  //     MHWallet wallet = await MHWallet.findWalletByWalletID(walletID);
  //     wallet.index = double.maxFinite.toInt();
  //     database.walletDao.updateWallet(wallet);
  //     String sql = "";
  //     if (oldIndex < newIndex) {
  //       //  (oldIndex  < index <= newIndex)  -1
  //       sql = '"index" > $oldIndex and "index" <= $newIndex ';
  //       datas = await database.walletDao.findWalletsBySQL(sql);
  //       datas.forEach((element) {
  //         element.index -= 1;
  //       });
  //     } else if (oldIndex > newIndex) {
  //       // newIndex < index <= oldIndex  + 1
  //       sql = '"index" >= $newIndex and "index" < $oldIndex ';
  //       datas = await database.walletDao.findWalletsBySQL(sql);
  //       datas.forEach((element) {
  //         element.index += 1;
  //       });
  //     }
  //     if (datas.length > 0) {
  //       wallet.index = newIndex;
  //       datas.add(wallet);
  //       datas.forEach((element) {
  //         print("444444444  " +
  //             element.walletAaddress +
  //             "  index " +
  //             element.index.toString());
  //       });
  //       database.walletDao.updateWallets(datas);
  //     }
  //     return true;
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //     return false;
  //   }
  // }

  ///查询当前钱包下当前节点的所有
  static Future<List<MCollectionTokens>> findTokens(
      String owner, int kNetType) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      return (await database?.tokensDao.findTokens(owner, kNetType)) ?? [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<MCollectionTokens>> findChainTokens(
      String owner, int kNetType, int chainType) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      return (await database?.tokensDao
              .findChainTokens(owner, kNetType, chainType)) ??
          [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<MCollectionTokens>> findStateTokens(
      String owner, int state, int kNetType) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      return (await database?.tokensDao
              .findStateTokens(owner, state, kNetType)) ??
          [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<MCollectionTokens>> findStateChainTokens(
      String owner, int state, int kNetType, int chainType) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      return (await database?.tokensDao
              .findStateChainTokens(owner, state, kNetType, chainType)) ??
          [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> insertTokens(List<MCollectionTokens> models) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.tokensDao.insertTokens(models);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteTokens(MCollectionTokens model) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.tokensDao.deleteTokens(model);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> updateTokens(MCollectionTokens model) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.tokensDao.updateTokens(model);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> updateTokenData(String sql) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.tokensDao.updateTokenData(sql);
    } catch (e) {
      rethrow;
    }
  }

  static Future<int?> findMaxIndex(String owner, int kNetType) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      return database?.tokensDao.findMaxIndex(owner, kNetType);
    } catch (e) {
      rethrow;
    }
  }
}

@dao
abstract class MCollectionTokenDao {
  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE owner = :owner and kNetType=:kNetType ORDER BY "index"')
  Future<List<MCollectionTokens>> findTokens(String owner, int kNetType);

  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE owner = :owner and kNetType=:kNetType and chainType=:chainType ORDER BY "index"')
  Future<List<MCollectionTokens>> findChainTokens(
      String owner, int kNetType, int chainType);

  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE owner = :owner and state = :state and kNetType=:kNetType ORDER BY "index"')
  Future<List<MCollectionTokens>> findStateTokens(
      String owner, int state, int kNetType);

  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE owner = :owner and state = :state and kNetType=:kNetType and chainType =:chainType ORDER BY "index"')
  Future<List<MCollectionTokens>> findStateChainTokens(
      String owner, int state, int kNetType, int chainType);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertToken(MCollectionTokens model);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTokens(List<MCollectionTokens> models);

  @delete
  Future<void> deleteTokens(MCollectionTokens model);

  @update
  Future<void> updateTokens(MCollectionTokens model);

  @Query("UPDATE " + tableName + " SET :sql")
  Future<void> updateTokenData(String sql);

  @Query('SELECT MAX(\'index\') FROM ' +
      tableName +
      " where owner = :owner and kNetType = :kNetType")
  Future<int?> findMaxIndex(String owner, int kNetType);
}
