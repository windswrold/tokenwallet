import 'dart:async';

import 'package:cstoken/db/database.dart';
import 'package:cstoken/db/database_config.dart';
import 'package:cstoken/model/token_price/tokenprice.dart';
import 'package:cstoken/net/chain_services.dart';
import 'package:cstoken/net/request_method.dart';
import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../public.dart';

const String tableName = "tokens_table";

@JsonSerializable()
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
  int? tokenType;

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
    this.tokenType,
  });

  static MCollectionTokens fromJson(Map<String, dynamic> json) =>
      MCollectionTokens(
        owner: json['owner'] as String?,
        contract: json['contract'] as String?,
        token: json['token'] as String?,
        coinType: json['coinType'] as String?,
        state: json['state'] as int?,
        decimals: json['decimals'] as int?,
        digits: json['digits'] as int?,
        iconPath: json["iconPath"] as String?,
        chainType: json["chainType"] as int?,
        kNetType: json["kNetType"] as int?,
        tokenType: json["tokenType"] as int?,
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'owner': this.owner,
      'contract': this.contract,
      'token': this.token,
      'coinType': this.coinType,
      'state': this.state,
      'decimals': this.decimals,
      'digits': this.digits,
      'iconPath': this.iconPath,
      'chainType': this.chainType,
      'kNetType': this.kNetType,
      'tokenType': this.tokenType
    };
  }

  bool get isToken => tokenType == KTokenType.native.index ? false : true;

  String get assets =>
      StringUtil.dataFormat(((price ??= 0) * (balance ??= 0)), 2);

  String get priceString => StringUtil.dataFormat(price ??= 0, 2);

  String get balanceString =>
      StringUtil.dataFormat(this.balance ?? 0.0, this.digits!);

  String createTokenID(String walletID) {
    String tokenID = (kNetType.toString() +
        "|" +
        chainType.toString() +
        "|" +
        walletID +
        "|" +
        (contract ?? ""));
    return TREncode.SHA256(tokenID);
  }

  Map? generateBalanceParams(String walletAaddress) {
    if (chainType == KCoinType.BTC.index) {
    } else if (chainType == KCoinType.TRX.index) {
      if (isToken == false) {
      } else {
        Map params = {};
        if (tokenType == KTokenType.trc20.index) {
          String contract_address = TREncode.base58HexString(contract!);
          String owner_address = TREncode.base58HexString(walletAaddress);
          params = {
            "contract_address": contract_address,
            "owner_address": owner_address,
            "function_selector": "balanceOf(address)",
            "parameter": owner_address.padLeft(64, "0")
          };
          return params;
        }
      }
    } else {
      Map params = {};
      if (isToken == false) {
        params["jsonrpc"] = "2.0";
        params["method"] = "eth_getBalance";
        params["params"] = [walletAaddress, "latest"];
        params["id"] = tokenID;
      } else if (tokenType == KTokenType.token.index) {
        String owner = walletAaddress;
        String data =
            "0x70a08231000000000000000000000000" + owner.replaceAll("0x", "");
        params["jsonrpc"] = "2.0";
        params["method"] = "eth_call";
        params["params"] = [
          {"to": contract, "data": data},
          "latest"
        ];
        params["id"] = tokenID;
      }
      return params;
    }
  }

  void balanceOf(String walletAaddress, KCurrencyType currencyType) async {
    KCoinType coinType = chainType!.geCoinType();
    double _balance = 0;
    double _price = 0;
    if (coinType == KCoinType.BTC) {
      dynamic result = await ChainServices.requestBTCDatas(
          path: "/addrs/$walletAaddress/balance", method: Method.GET);
      if (result != null && result is Map) {
        final final_balance = result["final_balance"] ?? 0;
        BigInt balBInt = BigInt.from(final_balance);
        _balance = balBInt.tokenDouble(8);
      }
    } else if (coinType == KCoinType.TRX) {
      if (isToken == false) {
        dynamic result = await ChainServices.requestTRXDatas(
            path: "/v1/accounts/$walletAaddress", method: Method.GET);
        if (result != null && result is Map) {
          bool success = result["success"] as bool;
          if (success == true) {
            List data = result["data"] as List;
            if (data.isNotEmpty) {
              BigInt bal = BigInt.from(data.first["balance"] ?? 0);
              _balance = bal.tokenDouble(6);
            }
          }
        }
      } else if (tokenType == KTokenType.trc20.index) {
        Map params = generateBalanceParams(walletAaddress)!;
        dynamic result = await ChainServices.requestTRXDatas(
            path: "/wallet/triggerconstantcontract",
            method: Method.POST,
            data: params);
        if (result != null && result is Map) {
          String constant_result = (result["constant_result"] as List).first;
          if (constant_result.isNotEmpty) {
            constant_result = constant_result.replaceFirst("0x", "");
            BigInt balBInt = BigInt.parse(constant_result, radix: 16);
            _balance = balBInt.tokenDouble(decimals!);
          }
        }
      }
    } else {
      Map params = generateBalanceParams(walletAaddress)!;
      dynamic result =
          await ChainServices.requestDatas(coinType: coinType, params: params);
      if (result != null && result.keys.contains("result")) {
        String id = result["id"];
        String? bal = result["result"] as String;
        bal = bal.replaceFirst("0x", "");
        bal = bal.length == 0 ? "0" : bal;
        BigInt balBInt = BigInt.parse(bal, radix: 16);
        _balance = balBInt.tokenDouble(decimals!);
      }
    }
    TokenPrice? price = await TokenPrice.queryTokenPrices(token!, currencyType);
    if (price != null) {
      _price = double.parse(price.rate ?? "0.0");
    }
    MCollectionTokens.updateTokenData(
        "price=$_price,balance =$_balance WHERE tokenID = '$tokenID'");
  }

  Future<bool> moveItem(
      String tokenid, String walletid, int oldIndex, int newIndex) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      List<MCollectionTokens> datas = [];
      int maxnum = double.maxFinite.toInt();

      // database?.tokensDao
      //     .updateTokenData("'index' = $maxnum where 'tokenID' = '$tokenid'");
      String sql = "";
      if (oldIndex < newIndex) {
        //  (oldIndex  < index <= newIndex)  -1
        sql =
            '"index" > $oldIndex and "index" <= $newIndex and "owner" = \'$walletid\'';

        datas = (await database?.tokensDao.findTokensBySQL(sql)) ?? [];
        datas.forEach((element) {
          element.index = element.index! - 1;
          print("444444444  " +
              element.token! +
              "  index " +
              element.index.toString());
        });
      } else if (oldIndex > newIndex) {
        // newIndex < index <= oldIndex  + 1
        sql =
            '"index" >= $newIndex and "index" < $oldIndex and "owner" = \'$walletid\'';
        datas = (await database?.tokensDao.findTokensBySQL(sql)) ?? [];
        datas.forEach((element) {
          element.index = element.index! + 1;
          print("444444444  " +
              element.token! +
              "  index " +
              element.index.toString());
        });
      }
      if (datas.length > 0) {
        // database?.tokensDao.updateTokenData(
        //     "'index' = $newIndex where 'tokenID' = '$tokenid'");
        datas.forEach((element) {
          print("444444444  " +
              element.token! +
              "  index " +
              element.index.toString());
        });
        // database?.tokensDao.updateTokens(datas);
      }
      return true;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return false;
    }
  }

  static void newTokens(
      {required String walletID,
      required int coinType,
      required String contract,
      required String token,
      required int decimal}) async {
    int netType = SPManager.getNetType().index;
    MCollectionTokens model = MCollectionTokens();
    model.contract = contract;
    model.token = token;
    model.decimals = decimal;
    model.state = 1;
    model.owner = walletID;
    model.kNetType = netType;
    model.chainType = coinType;
    model.coinType = coinType.geCoinType().coinTypeString();
    model.tokenType = KTokenType.token.index;
    model.tokenID = model.createTokenID(walletID);
    model.digits = 4;
    MCollectionTokens.insertTokens([model]);
  }

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

  static Future<List<MCollectionTokens>> findTokensBySQL(String sql) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      return (await database?.tokensDao.findTokensBySQL(sql)) ?? [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<MCollectionTokens>> findWalletsTokens(String owner) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      return (await database?.tokensDao.findAllTokens(owner)) ?? [];
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

  static Future<void> deleteTokens(List<MCollectionTokens> models) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.tokensDao.deleteTokens(models);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> updateTokens(MCollectionTokens model) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.tokensDao.updateTokens([model]);
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

  static Future<int?> findMaxIndex(String owner) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      return database?.tokensDao.findMaxIndex(owner);
    } catch (e) {
      rethrow;
    }
  }
}

@dao
abstract class MCollectionTokenDao {
  @Query('SELECT * FROM ' + tableName + ' WHERE owner = :owner')
  Future<List<MCollectionTokens>> findAllTokens(String owner);

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
  Future<void> deleteTokens(List<MCollectionTokens> models);

  @update
  Future<void> updateTokens(List<MCollectionTokens> models);

  @Query("UPDATE " + tableName + " SET :sql")
  Future<void> updateTokenData(String sql);

  @Query('SELECT * FROM ' + tableName + ' WHERE :sql ' + ' ORDER BY "index"')
  Future<List<MCollectionTokens>> findTokensBySQL(String sql);

  @Query('SELECT MAX(\'index\') FROM ' + tableName + " where owner = :owner ")
  Future<int?> findMaxIndex(String owner);
}
