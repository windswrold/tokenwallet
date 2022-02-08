import 'dart:async';

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
  int? chainid; //用来区分测试网主网
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
    this.chainid,
    this.iconPath,
    this.chainType,
    this.index,
  });

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

  // static Future<List<MCollectionTokens>> findTokens(
  //     String owner, int chainID) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     List<MCollectionTokens>? datas =
  //         await database?.tokensDao.findTokens(owner, chainID);
  //     return datas ?? [];
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //     return [];
  //   }
  // }

  // static Future<void> updateTokenPrice(double price, String token) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     database?.tokensDao.updateTokenPrice(price, token);
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //     return;
  //   }
  // }

  // static Future<List<MCollectionTokens>> findStateTokens(
  //     String s, int i, int chainID) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     List<MCollectionTokens>? datas =
  //         await database?.tokensDao.findStateTokens(s, i, chainID);
  //     datas ??= [];
  //     for (var item in datas) {
  //       if (item.token == "ETH") {
  //         datas.remove(item);
  //         datas.insert(0, item);
  //       }
  //       if (item.token == "ZKTR") {
  //         datas.remove(item);
  //         datas.insert(1, item);
  //       }
  //     }
  //     return datas;
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //     return [];
  //   }
  // }

  // static void insertToken(MCollectionTokens model) async {
  //   try {
  //     model.contract = model.contract?.toLowerCase();
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     await database?.tokensDao.insertToken(model);
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //   }
  // }

  // static void insertTokens(List<MCollectionTokens> models) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     await database?.tokensDao.insertTokens(models);
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //   }
  // }

  // static void deleteTokens(MCollectionTokens model) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());

  //     await database?.tokensDao.deleteTokens(model);
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //   }
  // }

  // static void updateTokens(MCollectionTokens model) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     await database?.tokensDao.updateTokens(model);
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //   }
  // }

  // static void updateTokenData(String sql) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     await database?.tokensDao.updateTokenData(sql);
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //   }
  // }

  String get assets =>
      StringUtil.dataFormat(((price ??= 0) * (balance ??= 0)), 2);

  bool get isToken =>
      coinType?.toLowerCase() == token?.toLowerCase() ? false : true;

  String get balanceString =>
      StringUtil.dataFormat(this.balance ?? 0.0, this.digits!);
}

@dao
abstract class MCollectionTokenDao {
  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE owner = :owner and chainid=:chainid ORDER BY "index"')
  Future<List<MCollectionTokens>> findTokens(String owner, int chainid);

  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE owner = :owner and chainid=:chainid and chainType=:chainType ORDER BY "index"')
  Future<List<MCollectionTokens>> findChainTokens(
      String owner, int chainid, int chainType);

  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE owner = :owner and state = :state and chainid=:chainid ORDER BY "index"')
  Future<List<MCollectionTokens>> findStateTokens(
      String owner, int state, int chainid);

  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE owner = :owner and state = :state and chainid=:chainid and chainType =:chainType ORDER BY "index"')
  Future<List<MCollectionTokens>> findStateChainTokens(
      String owner, int state, int chainid, int chainType);

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
}
