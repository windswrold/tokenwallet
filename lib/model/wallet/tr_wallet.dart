import 'dart:math';

import 'package:cstoken/const/constant.dart';
import 'package:cstoken/db/database.dart';
import 'package:cstoken/db/database_config.dart';
import 'package:cstoken/model/assets/currency_list.dart';
import 'package:cstoken/model/chain/bsc.dart';
import 'package:cstoken/model/chain/eth.dart';
import 'package:cstoken/model/chain/heco.dart';
import 'package:cstoken/model/tokens/collection_tokens.dart';
import 'package:cstoken/model/wallet/tr_wallet_info.dart';
import 'package:cstoken/pages/tabbar/tabbar.dart';
import 'package:cstoken/pages/wallet/create/backup_tip_memo.dart';
import 'package:cstoken/state/wallet_state.dart';
import 'package:cstoken/utils/custom_toast.dart';
import 'package:cstoken/utils/encode.dart';
import 'package:decimal/decimal.dart';
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
  bool? hiddenAssets; //是否隐藏资产

  @ignore
  List<TRWalletInfo>? walletsInfo;

  TRWallet(
      {this.walletID,
      this.walletName,
      this.pin,
      this.chainType,
      this.accountState,
      this.encContent,
      this.isChoose,
      this.leadType,
      this.pinTip,
      this.hiddenAssets});

  String getChainType() {
    if (chainType == KChainType.HD.index) {
      return "wallets_manager_multichain".local();
    } else if (chainType == KChainType.ETH.index) {
      return "importwallet_ethchaintype".local();
    }
    return "";
  }

  static String randomWalletName() {
    int random = Random().nextInt(9999);
    return "钱包#" + random.toString();
  }

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
    if ((kLeadType == KLeadType.Memo || kLeadType == KLeadType.Restore) &&
        content.checkMemo() == false) {
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
    HWToast.showLoading();
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

      final walletID = TREncode.SHA256(content.replaceAll(" ", "") + "CSTOKEM");
      TRWallet? oldWallets = await TRWallet.queryWalletByWalletID(walletID);
      if (oldWallets != null) {
        LogUtil.v("查找到有已经导入的钱包");
        HWToast.showText(text: "create_wallet_exist".local());
        return;
      }
      TRWallet trWallet = TRWallet();
      trWallet.walletID = walletID;
      trWallet.walletName = walletName;
      trWallet.pinTip = pinTip;
      trWallet.chainType = kChainType.index;
      trWallet.leadType = kLeadType.index;
      //通过创建时需要提示备份
      trWallet.accountState = kLeadType == KLeadType.Memo
          ? KAccountState.init.index
          : KAccountState.noauthed.index;
      trWallet.encContent = TREncode.encrypt(content, pin);
      trWallet.pin = TREncode.SHA256(pin);
      TRWallet? chooseTR = await TRWallet.queryChooseWallet();
      if (chooseTR == null) {
        trWallet.isChoose = true;
      }
      //开始生成地址信息
      List<HDWallet> _hdwallets = HDWallet.getHDWallet(
          content: content,
          pin: pin,
          kLeadType: kLeadType,
          chainType: kChainType);
      TRWallet.insertWallet(trWallet);
      for (var object in _hdwallets) {
        String address = object.address!;
        String key = walletID + address + object.coinType!.coinTypeString();
        TRWalletInfo infos = TRWalletInfo(key: key);
        infos.walletID = walletID;
        infos.walletAaddress = address;
        infos.coinType = object.coinType!.index;
        TRWalletInfo.insertWallets([infos]);
      }
      int index = (await MCollectionTokens.findMaxIndex(
              walletID, KNetType.Mainnet.index)) ??
          0;
      List<MCollectionTokens> tokens = [];
      for (var item in currency_List) {
        MCollectionTokens token = MCollectionTokens.fromJson(item);
        token.owner = walletID;
        token.state = 1;
        token.tokenID = token.kNetType.toString() +
            "|" +
            token.chainType.toString() +
            "|" +
            token.contract!;
        token.index = index++;
        tokens.add(token);
      }
      MCollectionTokens.insertTokens(tokens);
      HWToast.hiddenAllToast();
      Provider.of<CurrentChooseWalletState>(context, listen: false)
          .loadWallet();
      //如果是创建则去跳转备份
      //如果其他则去tabbar
      //关闭备份则去tababr
      if (kLeadType == KLeadType.Memo) {
        Routers.push(context, BackupTipMemo(memo: content, walletID: walletID));
      } else {
        Routers.push(context, HomeTabbar(), clearStack: true);
      }
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

  Future<List<TRWalletInfo>> queryWalletInfos({KCoinType? coinType}) async {
    try {
      List<TRWalletInfo> wallet = [];
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      if (coinType == null) {
        wallet = (await database?.walletInfoDao
                .queryWalletInfosByWalletID(walletID!)) ??
            [];
      } else {
        wallet = (await database?.walletInfoDao
                .queryWalletInfo(walletID!, coinType.index)) ??
            [];
      }
      return wallet;
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
  String? exportEncContent({required String pin}) {
    assert(pin != null, "pin为空");
    try {
      return TREncode.decrypt(encContent!, pin);
    } catch (e) {
      rethrow;
    }
  }

  static String configFeeValue({
    required int? cointype,
    required String? beanValue, // sat price
    required String? offsetValue, //len
  }) {
    Decimal gasValue =
        Decimal.parse(beanValue ?? "0") * Decimal.fromInt(10).pow(9);
    gasValue = gasValue * Decimal.parse(offsetValue ?? "0");
    var feeValue = (gasValue / Decimal.fromInt(10).pow(18)).toDecimal();
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
