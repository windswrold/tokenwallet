import 'dart:math';

import 'package:cstoken/const/constant.dart';
import 'package:cstoken/db/database.dart';
import 'package:cstoken/db/database_config.dart';
import 'package:cstoken/utils/encode.dart';
import 'package:floor/floor.dart';
import '../public.dart';
import 'hd_wallet.dart';

const String tableName = "wallet_table";

@Entity(tableName: tableName)
class TRWallet {
  @primaryKey
  String? walletID; //唯一id  coinType|sha(pubKey)
  String? walletAaddress; //钱包地址
  String? pin; //密码
  String? prvKey; //私钥
  int? coinType; //链类型
  int? accountState; // 账号状态
  String? mnemonic; //助记词
  bool? isChoose; //当前选中
  String? pubKey; //公钥
  int? leadType; //导入类型
  String? pinTip; // 密码提示
  String? descName; //默认空字符

  TRWallet(
      {this.walletID,
      this.walletAaddress,
      this.pin,
      this.prvKey,
      this.coinType,
      this.accountState,
      this.mnemonic,
      this.descName,
      this.isChoose,
      this.leadType,
      this.pinTip,
      this.pubKey});

  TRWallet.instance(HDWallet object) {
    walletID = object.coinType!.coinTypeString() +
        "|" +
        TREncode.SHA256(walletAaddress!);
    walletAaddress = object.address;
    pin = TREncode.SHA256(object.pin!);
    prvKey = TREncode.encrypt(object.prv!, object.pin!);
    coinType = object.coinType!.index;
    accountState = object.leadType == KLeadType.Memo
        ? KAccountState.init.index
        : KAccountState.noauthed.index;
    mnemonic = object.leadType == KLeadType.Memo
        ? TREncode.encrypt(object.content!, object.pin!)
        : "";
    leadType = object.leadType!.index;
    TRWallet(
        walletID: walletID,
        walletAaddress: walletAaddress,
        pin: pin,
        pinTip: pinTip,
        prvKey: prvKey,
        coinType: coinType,
        accountState: accountState,
        leadType: leadType);
  }

  static Future<TRWallet?> queryWalletByWalletID(String walletID) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      TRWallet? wallet =
          await database?.walletDao.queryWalletByWalletID(walletID);
      return wallet;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<TRWallet>> queryAllWallets() async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      List<TRWallet>? wallet = await database?.walletDao.queryAllWallets();
      return wallet ??= [];
    } catch (e) {
      rethrow;
    }
  }

  static Future<TRWallet?> queryChooseWallet() async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      TRWallet? wallet = await database?.walletDao.queryChooseWallet();
      return wallet;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> insertWallet(TRWallet wallet) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.walletDao.insertWallet(wallet);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> insertWallets(List<TRWallet> wallets) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.walletDao.insertWallets(wallets);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> updateWallet(TRWallet wallet) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.walletDao.updateWallet(wallet);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> updateWallets(List<TRWallet> wallets) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.walletDao.updateWallets(wallets);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> deleteWallet(TRWallet wallet) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.walletDao.deleteWallet(wallet);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> deleteWallets(List<TRWallet> wallets) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.walletDao.deleteWallets(wallets);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  bool lockPin({
    required String? text,
    required void Function(String? value)? ok,
    required VoidCallback? wrong,
  }) {
    if (this.pin == TREncode.SHA256(text!)) {
      LogUtil.v("pin验证成功");
      if (ok != null) {
        ok(text);
      }
      return true;
    } else {
      LogUtil.v("pin验证失败");
      if (wrong != null) {
        wrong();
      }
      return false;
    }
  }

  //导出私钥
  String? exportPrv({required String pin}) {
    assert(pin != null, "pin为空");
    try {
      String prv = this.prvKey!;
      return TREncode.decrypt(prv, pin);
    } catch (e) {
      rethrow;
    }
  }

  String? exportMemo({required String pin}) {
    assert(pin != null, "pin为空");
    try {
      String memo = this.mnemonic!;
      return memo.length == 0 ? "" : TREncode.decrypt(memo, pin);
    } catch (e) {
      rethrow;
    }
  }

  static String configFeeValue({
    required int? cointype,
    required String? beanValue, // sat price
    required String? offsetValue, //len
  }) {
    double feeValue = 0.0;
    num gasValue = num.tryParse(beanValue!)! * pow(10, 9);
    gasValue = gasValue * num.tryParse(offsetValue!)!;
    feeValue = gasValue / pow(10, 18);
    LogUtil.v("手续费beanValue $beanValue  offsetValue $offsetValue 计算是 " +
        feeValue.toStringAsFixed(6));
    return feeValue.toStringAsFixed(6);
  }

  static importWallet(BuildContext context,
      {required String content,
      required String pin,
      required String walletName,
      required KCoinType kCoinType,
      required KLeadType kLeadType}) async {
    LogUtil.v(
        "importWallet $content pin $pin kCoinType $kCoinType kLeadType $kLeadType");
    try {} catch (e) {
      rethrow;
    }
  }
}

@dao
abstract class WalletDao {
  @Query('SELECT * FROM ' + tableName + ' WHERE walletID = :walletID')
  Future<TRWallet?> queryWalletByWalletID(String walletID);

  @Query('SELECT * FROM ' + tableName)
  Future<List<TRWallet>> queryAllWallets();

  @Query('SELECT * FROM ' + tableName + ' WHERE isChoose = 1')
  Future<TRWallet?> queryChooseWallet();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertWallet(TRWallet wallet);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertWallets(List<TRWallet> wallet);

  @update
  Future<void> updateWallet(TRWallet wallet);

  @update
  Future<void> updateWallets(List<TRWallet> wallet);

  @delete
  Future<void> deleteWallet(TRWallet wallet);

  @delete
  Future<void> deleteWallets(List<TRWallet> wallet);
}
