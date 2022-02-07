import 'package:cstoken/db/database.dart';
import 'package:cstoken/db/database_config.dart';
import 'package:cstoken/utils/log_util.dart';
import 'package:floor/floor.dart';

const String tableName = "tokenPrice_table";

@Entity(tableName: tableName, primaryKeys: ["contract", "target", "source"])
class TokenPrice {
  String? contract; // 合约地址
  String? source; //币名
  String? target; //usd cny
  String? rate; //价格

  TokenPrice({required this.contract, this.source, this.target, this.rate});

  static Future<TokenPrice?> queryTokenPrices(
      String source, String target) async {
    // target = target.replaceAll("USD", "USDT");
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      List<TokenPrice>? datas =
          await (database?.tokenPriceDao.queryTokenPrices(source, target));
      return datas?.first;
    } catch (e) {
      LogUtil.v("queryTokenPrices $source $target" + e.toString());
      return null;
    }
  }

  static updateTokenPrice(String rate, String contract) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      await (database?.tokenPriceDao.updateTokenPrice(rate, contract));
    } catch (e) {
      LogUtil.v("updateTokenPrice" + e.toString());
    }
  }

  static insertTokenPrice(TokenPrice model) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      await (database?.tokenPriceDao.insertTokenPrice(model));
    } catch (e) {
      LogUtil.v("insertTokenPrice失败" + e.toString());
    }
  }

  static insertTokensPrice(List<TokenPrice> models) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      await (database?.tokenPriceDao.insertTokensPrice(models));
    } catch (e) {
      LogUtil.v("insertTokensPrice失败" + e.toString());
    }
  }
}

@dao
abstract class TokenPriceDao {
  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE contract = :contract and target=:target')
  Future<List<TokenPrice>> queryTokenPrices(String contract, String target);

  @Query("UPDATE " +
      tableName +
      " SET rate=:rate WHERE token_rate_supported_id = :tokenid")
  Future<void> updateTokenPrice(String rate, int tokenid);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTokenPrice(TokenPrice model);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTokensPrice(List<TokenPrice> models);
}
