import 'package:floor/floor.dart';

const String tableName = "wallet_info_table";

@Entity(tableName: tableName)
class TRWalletInfo {
  @primaryKey
  final String key;
  String? walletID;
  String? walletAaddress; //钱包地址
  int? coinType;
  String? pubKey;

  TRWalletInfo(
      {required this.key,
      this.walletID,
      this.coinType,
      this.walletAaddress,
      this.pubKey}); //公钥
}

@dao
abstract class WalletInfoDao {
  @Query('SELECT * FROM ' + tableName + ' WHERE walletID = :walletID')
  Future<List<TRWalletInfo?>> queryWalletInfosByWalletID(String walletID);

  @Query('SELECT * FROM ' + tableName + ' WHERE walletID = :walletID and coinType = :coinType')
  Future<List<TRWalletInfo?>> queryWalletInfo(String walletID, int coinType);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertWallet(TRWalletInfo wallet);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertWallets(List<TRWalletInfo> wallet);

  @update
  Future<void> updateWallet(TRWalletInfo wallet);

  @update
  Future<void> updateWallets(List<TRWalletInfo> wallet);

  @delete
  Future<void> deleteWallet(TRWalletInfo wallet);

  @delete
  Future<void> deleteWallets(List<TRWalletInfo> wallet);
}
