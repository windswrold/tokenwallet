import 'dart:math';

import 'package:cstoken/const/constant.dart';
import 'package:cstoken/db/database.dart';
import 'package:cstoken/db/database_config.dart';
import 'package:cstoken/model/chain/bsc.dart';
import 'package:cstoken/model/chain/eth.dart';
import 'package:cstoken/model/chain/heco.dart';
import 'package:cstoken/utils/custom_toast.dart';
import 'package:cstoken/utils/encode.dart';
import 'package:floor/floor.dart';
import '../../public.dart';
import 'hd_wallet.dart';

const String tableName = "wallet_table";

@Entity(tableName: tableName)
class TRWallet {
  @primaryKey
  String? walletID; //唯一id  助记词hash 或者私钥hash keystore
  String? walletName; //钱包名称
  String? pin; //密码hash
  int? chainType; //链类型
  int? accountState; // 账号状态
  String? encContent; //密文 助记词 或者私钥
  bool? isChoose; //当前选中
  int? leadType; //导入类型 Prvkey 助记词 keystore
  String? pinTip; // 密码提示

  TRWallet({
    this.walletID,
    this.walletName,
    this.pin,
    this.chainType,
    this.accountState,
    this.encContent,
    this.isChoose,
    this.leadType,
    this.pinTip,
  });

  // TRWallet.instance(HDWallet object) {
  //   walletID = TREncode.SHA256(object.content!.replaceAll(" ", "") + "CSTOKEM");
  //   pin = TREncode.SHA256(object.pin!);
  //   accountState = object.leadType == KLeadType.Memo
  //       ? KAccountState.init.index
  //       : KAccountState.noauthed.index;
  //   encContent = TREncode.encrypt(object.content!, object.pin!);
  //   leadType = object.leadType!.index;
  //   TRWallet(
  //       walletID: walletID,
  //       pin: pin,
  //       pinTip: pinTip,
  //       accountState: accountState,
  //       encContent: encContent,
  //       leadType: leadType);
  // }

  static bool validImportValue(
      {required String content,
      required String pin,
      required String pinAgain,
      required String pinTip,
      required String walletName,
      required KChainType kChainType,
      required KLeadType kLeadType}) {
    LogUtil.v(
        "importWallet $content pin $pin kChainType $kChainType kLeadType $kLeadType");
    content = content.trim();
    walletName = walletName.trim();
    pin = pin.trim();
    pinTip = pinTip.trim();
    pinAgain = pinAgain.trim();
    if (kLeadType == KLeadType.Prvkey) {
      content = content.replaceFirst("0x", "");
    }
    if (content.isEmpty) {
      if (KLeadType.KeyStore == kLeadType) {
      } else if (KLeadType.Prvkey == kLeadType) {
        HWToast.showText(text: "input_prvkey".local());
      } else {
        HWToast.showText(text: "input_memos".local());
      }
      return false;
    }
    if (walletName.isEmpty) {
      HWToast.showText(text: "input_name".local());
      return false;
    }
    if (pin.isEmpty) {
      HWToast.showText(text: "input_pwd".local());
      return false;
    }
    if (pinAgain.isEmpty) {
      HWToast.showText(text: "input_pwd".local());
      return false;
    }
    if (pin != pinAgain) {
      HWToast.showText(text: "input_pwd_wrong".local());
      return false;
    }
    if (pin.checkPassword() == false) {
      HWToast.showText(text: "input_pwd_regexp".local());
      return false;
    }
    if (kLeadType == KLeadType.Prvkey &&
        content.checkPrv(kChainType) == false) {
      HWToast.showText(text: "import_prvwrong".local());
      return false;
    }
    if (kLeadType == KLeadType.Memo && content.checkMemo() == false) {
      HWToast.showText(text: "input_memo_wrong".local());
      return false;
    }
    return true;
  }

  static importWallet(BuildContext context,
      {required String content,
      required String pin,
      required String pinAgain,
      required String pinTip,
      required String walletName,
      required KChainType kChainType,
      required KLeadType kLeadType}) async {
    try {
      if (validImportValue(
              content: content,
              pin: pin,
              pinAgain: pinAgain,
              pinTip: pinTip,
              walletName: walletName,
              kChainType: kChainType,
              kLeadType: kLeadType) ==
          false) {
        return;
      }
      List<TRWallet> datas = [];
      List<HDWallet> _hdwallets = [];
      if (kLeadType == KLeadType.Memo) {
        _hdwallets.add(await ETHChain()
            .importWallet(content: content, pin: pin, kLeadType: kLeadType)!);
        _hdwallets.add(await BSCChain()
            .importWallet(content: content, pin: pin, kLeadType: kLeadType)!);
        _hdwallets.add(await HecoChain()
            .importWallet(content: content, pin: pin, kLeadType: kLeadType)!);
        _hdwallets.add(await ETHChain()
            .importWallet(content: content, pin: pin, kLeadType: kLeadType)!);
        _hdwallets.add(await ETHChain()
            .importWallet(content: content, pin: pin, kLeadType: kLeadType)!);
      }
      if (kLeadType == KLeadType.Prvkey && kChainType == KChainType.ETH) {}
    } catch (e) {
      rethrow;
    }
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
      // String prv = this.prvKey!;
      // return TREncode.decrypt(prv, pin);
    } catch (e) {
      rethrow;
    }
  }

  String? exportMemo({required String pin}) {
    assert(pin != null, "pin为空");
    try {
      // String memo = this.mnemonic!;
      // return memo.length == 0 ? "" : TREncode.decrypt(memo, pin);
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
