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

  TRWalletInfo(this.key); //公钥
}
