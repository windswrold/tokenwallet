import 'dart:math';

import 'package:floor/floor.dart';

import 'hd_wallet.dart';

const String tableName = "wallet_table";

@Entity(tableName: tableName)
class TRWallet {
  @primaryKey
  String? walletID;
  String? walletAaddress; //钱包地址
  String? pin; //密码
  String? prvKey; //私钥
  int? coinType; //链类型
  int? accountState; // 账号状态
  String? mnemonic; //助记词

  TRWallet(this.walletID, this.walletAaddress, this.pin, this.prvKey,
      this.coinType, this.accountState, this.mnemonic);

  TRWallet.instance(HDWallet object) {
    walletAaddress = object.address;
    // pin = TREncode.SHA256(object.pin!);
    // prvKey = TREncode.encrypt(object.prv!, object.pin!);
    // coinType = object.coinType!.index;
    // walletID = coinType.toString() + "|" + TREncode.SHA256(walletAaddress!);
    // mnemonic = object.leadType == KLeadType.Memo
    //     ? TREncode.encrypt(object.content!, object.pin!)
    //     : "";
    // accountState = object.leadType == KLeadType.Memo
    //     ? KAccountState.init.index
    //     : KAccountState.noauthed.index;
    TRWallet(walletID, walletAaddress, pin, prvKey, coinType, accountState,
        mnemonic);
  }

  // static Future<TRWallet?> findWalletByWalletID(String walletID) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     TRWallet? wallet =
  //         await database?.walletDao.findWalletByWalletID(walletID);
  //     return wallet;
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //     return null;
  //   }
  // }

  // static Future<List<TRWallet>> findAllWallets() async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     List<TRWallet>? wallet = await database?.walletDao.findAllWallets();
  //     return wallet ??= [];
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //     return [];
  //   }
  // }

  // static Future<bool> insertWallet(TRWallet wallet) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     database?.walletDao.insertWallet(wallet);
  //     return true;
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //     return false;
  //   }
  // }

  // static Future<bool> insertWallets(List<TRWallet> wallets) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     database?.walletDao.insertWallets(wallets);
  //     return true;
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //     return false;
  //   }
  // }

  // static Future<bool> updateWallet(TRWallet wallet) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     database?.walletDao.updateWallet(wallet);
  //     return true;
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //     return false;
  //   }
  // }

  // static Future<bool> updateWallets(List<TRWallet> wallets) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     database?.walletDao.updateWallets(wallets);
  //     return true;
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //     return false;
  //   }
  // }

  // static Future<bool> deleteWallet(TRWallet wallet) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     database?.walletDao.deleteWallet(wallet);
  //     return true;
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //     return false;
  //   }
  // }

  // static Future<bool> deleteWallets(List<TRWallet> wallets) async {
  //   try {
  //     FlutterDatabase? database = await (BaseModel.getDataBae());
  //     database?.walletDao.deleteWallets(wallets);
  //     return true;
  //   } catch (e) {
  //     LogUtil.v("失败" + e.toString());
  //     return false;
  //   }
  // }

  // bool lockPin({
  //   required String? text,
  //   required void Function(String? value)? ok,
  //   required VoidCallback? wrong,
  // }) {
  //   if (this.pin == TREncode.SHA256(text!)) {
  //     LogUtil.v("pin验证成功");
  //     if (ok != null) {
  //       ok(text);
  //     }
  //     return true;
  //   } else {
  //     LogUtil.v("pin验证失败");
  //     if (wrong != null) {
  //       wrong();
  //     }
  //     return false;
  //   }
  // }

  // //导出私钥
  // String? exportPrv({required String pin}) {
  //   assert(pin != null, "pin为空");
  //   try {
  //     String prv = this.prvKey!;
  //     return TREncode.decrypt(prv, pin);
  //   } catch (e) {
  //     LogUtil.v("exportPrv出错" + e.toString());
  //     return null;
  //   }
  // }

  // String? exportMemo({required String pin}) {
  //   assert(pin != null, "pin为空");
  //   try {
  //     String memo = this.mnemonic!;
  //     return memo.length == 0 ? "" : TREncode.decrypt(memo, pin);
  //   } catch (e) {
  //     LogUtil.v("exportMemo er" + e.toString());
  //     return null;
  //   }
  // }

  // static String configFeeValue({
  //   required int? cointype,
  //   required String? beanValue, // sat price
  //   required String? offsetValue, //len
  // }) {
  //   double feeValue = 0.0;
  //   num gasValue = num.tryParse(beanValue!)! * pow(10, 9);
  //   gasValue = gasValue * num.tryParse(offsetValue!)!;
  //   feeValue = gasValue / pow(10, 18);
  //   LogUtil.v("手续费beanValue $beanValue  offsetValue $offsetValue 计算是 " +
  //       feeValue.toStringAsFixed(6));
  //   return feeValue.toStringAsFixed(6);
  // }

  // static importWallet(BuildContext context,
  //     {required String content,
  //     required String pin,
  //     required String walletName,
  //     required KCoinType kCoinType,
  //     required KLeadType kLeadType}) async {
  //   LogUtil.v(
  //       "importWallet $content pin $pin kCoinType $kCoinType kLeadType $kLeadType");
  //   try {
  //     if (kLeadType == KLeadType.Memo &&
  //         Mnemonic.validateMnemonic(content) == false) {
  //       throw RangeError('Mnemonic wrong');
  //     } else if (kLeadType == KLeadType.Prvkey &&
  //         content.checkPrv(kCoinType) == false) {
  //       throw RangeError('Mnemonic wrong');
  //     }
  //     List<MCollectionTokens> currentTokens = [];
  //     List<TRWallet> datas = [];
  //     if (kCoinType == KCoinType.ETH || kCoinType == KCoinType.All) {
  //       datas.add(TRWallet.instance(ETHChain()
  //           .importWallet(content: content, pin: pin, kLeadType: kLeadType)!));
  //     }
  //     if (kCoinType == KCoinType.BSC || kCoinType == KCoinType.All) {
  //       datas.add(TRWallet.instance(BSCChain()
  //           .importWallet(content: content, pin: pin, kLeadType: kLeadType)!));
  //     }

  //     for (TRWallet walwlet in datas) {
  //       for (var item in currency_List) {
  //         MCollectionTokens tokens = MCollectionTokens.fromJson(item);
  //         if (walwlet.coinType == item["chainType"]) {
  //           tokens.owner = walwlet.walletAaddress;
  //           tokens.contract = tokens.contract?.toLowerCase();
  //           currentTokens.add(tokens);
  //           LogUtil.v("tokens " + tokens.toJson().toString());
  //         }
  //       }
  //     }
  //     TRWallet.insertWallets(datas);
  //     MCollectionTokens.insertTokens(currentTokens);
  //     Routers.push(context, Carousel(), clearStack: true);
  //   } catch (e) {
  //     LogUtil.v("钱包数据插入失败" + e.toString());
  //   }
  // }
}

@dao
abstract class WalletDao {
  @Query('SELECT * FROM ' + tableName + ' WHERE walletID = :walletID')
  Future<TRWallet?> findWalletByWalletID(String walletID);

  @Query('SELECT * FROM ' + tableName)
  Future<List<TRWallet>> findAllWallets();

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
