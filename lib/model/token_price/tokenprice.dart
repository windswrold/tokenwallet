import 'package:cstoken/db/database.dart';
import 'package:cstoken/db/database_config.dart';
import 'package:cstoken/public.dart';
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
      String contract, KCurrencyType target) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      List<TokenPrice> datas = (await database?.tokenPriceDao
              .queryTokenPrices(contract, target.index.toString())) ??
          [];
      return datas.first;
    } catch (e) {
      return TokenPrice(rate: "0", contract: contract);
    }
    // if (target == KCurrencyType.CNY) {
    //   return TokenPrice(contract: contract, rate: "1000");
    // } else {
    //   return TokenPrice(contract: contract, rate: "500");
    // }
  }

  static Future<void> insertTokensPrice(List<TokenPrice> models) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.tokenPriceDao.insertTokensPrice(models);
    } catch (e) {
      rethrow;
    }
  }
}

@dao
abstract class TokenPriceDao {
  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE contract = :contract and target=:target')
  Future<List<TokenPrice>> queryTokenPrices(String contract, String target);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTokenPrice(TokenPrice model);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTokensPrice(List<TokenPrice> models);
}
