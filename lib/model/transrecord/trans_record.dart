import 'package:cstoken/db/database.dart';
import 'package:cstoken/db/database_config.dart';
import 'package:cstoken/public.dart';
import 'package:cstoken/utils/log_util.dart';
import 'package:floor/floor.dart';

const String tableName = "translist_table";

@Entity(tableName: tableName)
class TransRecordModel {
  @primaryKey
  String? txid; //交易ID
  String? toAdd; //to
  String? fromAdd; //from
  String? date; //时间
  String? amount; //金额
  String? remarks; //备注
  String? fee; //手续费
  String? gasPrice;
  String? gasLimit;
  int? transStatus; //0失败 1成功
  String? token; //转账符号
  String? coinType;
  //自定义字段
  int? chainid; //哪条链
  int? nonce; //用来加速交易或者取消交易
  String? contractTo; //发上交易后的to 可能是代币的合约地址 也有可能是某个中间合约的地址
  String? input;
  String? signMessage; //签过名的数据用来重发交易
  int? repeatPushCount; //重发的次数
  int? blockHeight; //区块高度
  int? transType; //转账类型

  TransRecordModel({
    this.txid,
    this.toAdd,
    this.fromAdd,
    this.date,
    this.amount,
    this.remarks,
    this.fee,
    this.transStatus,
    this.token,
    this.coinType,
    this.gasLimit,
    this.gasPrice,
    this.chainid,
    this.nonce,
    this.contractTo,
    this.input,
    this.signMessage,
    this.repeatPushCount,
    this.blockHeight,
  });

  bool isOut(String from) {
    if (this.toAdd?.toLowerCase() == from.toLowerCase()) {
      //转入
      return false;
    } else {
      return true;
    }
  }

  String vaueString(String from) {
    String result = "";
    if (isOut(from) == true) {
      result = "-";
    } else {
      result = "+";
    }
    result += amount ?? "0";
    result += token ?? "";
    return result;
  }

  String transTypeIcon(String from) {
    String result = "";
    if (isOut(from) == true) {
      result = "icons/icon_out.png";
    } else {
      result = "icons/icon_in.png";
    }
    return result;
  }

  String transState() {
    String result = "";
    if (transStatus == KTransState.failere.index) {
      result = "translist_statefailere".local();
    } else if (transStatus == KTransState.pending.index) {
      result = "translist_pending".local();
    }else if (transStatus == KTransState.success.index) {
      result = "translist_success".local();
    }
    return result;
  }

    String transStateicon() {
    String result = "";
    if (transStatus == KTransState.failere.index) {
      result = "icons/trans_failere.png";
    } else if (transStatus == KTransState.pending.index) {
      result = "icons/trans_pending.png";
    }else if (transStatus == KTransState.success.index) {
      result = "icons/trans_success.png";
    }
    return result;
  }

  // Future<bool?> updateTransState(BuildContext context) async {
  //   String tx = this.txid!;
  //   if (this.transType! < MTransListType.L2All.index ||
  //       this.transType == MTransListType.L2Authorize.index ||
  //       this.transType == MTransListType.L2Deposit.index ||
  //       (this.transType! <= MTransListType.whitelistWithdraw.index &&
  //           this.transType! >= MTransListType.stackAuthorize.index)) {
  //     //l1查询回执
  //     dynamic result = await ChainServices.requestTransactionReceipt(tx);
  //     if (result != null &&
  //         result is Map &&
  //         result.keys.contains("result") &&
  //         result["result"] != null) {
  //       String status = result["result"]["status"];
  //       String? gasPrice = this.gasPrice;
  //       String gasUsed = result["result"]["gasUsed"];
  //       String block = result["result"]["blockNumber"];
  //       int blockNumber =
  //           int.tryParse(block.replaceAll("0x", ""), radix: 16) ?? 0;
  //       BigInt? gas = BigInt.tryParse(gasUsed.replaceAll("0x", ""), radix: 16);
  //       if (gasPrice != null && gasUsed != null) {
  //         String fee = MHWallet.configFeeValue(
  //             cointype: MCoinType.MCoinType_ETH.index,
  //             beanValue: gas.toString(),
  //             offsetValue: gasPrice);
  //         this.fee = fee;
  //       }
  //       this.blockHeight = blockNumber;
  //       if (status == "0x1") {
  //         if (this.transType == MTransListType.L2Deposit.index) {
  //           //deposit 查询l2状态
  //           // this.transStatus = MTransState.MTransState_PendingL2.index;
  //           // bool? state = await ChainServices.requestVerState(tx);
  //           // if (state == true) {
  //           //1层成功直接成功
  //           this.transStatus = MTransState.MTransState_Success.index;
  //           // }
  //           TransRecordModel.updateTrxList(this);
  //           return true;
  //         } else {
  //           //其他置为success
  //           this.transStatus = MTransState.MTransState_Success.index;
  //           TransRecordModel.updateTrxList(this);
  //           return true;
  //         }
  //       } else {
  //         //1层失败则置为失败
  //         this.transStatus = MTransState.MTransState_Failere.index;
  //         TransRecordModel.updateTrxList(this);
  //         return true;
  //       }
  //     } else {
  //       //10s没有查出结果时触发重新push 主网交易
  //       //还在pending中的数据 already known
  //       int repeatPushCount = this.repeatPushCount ?? 0;
  //       DateTime? trxTime = DateUtil.getDateTime(this.date ?? '');
  //       int nowTime = DateTime.now().millisecondsSinceEpoch;
  //       if (trxTime != null &&
  //           nowTime > (trxTime.millisecondsSinceEpoch + 15000) &&
  //           repeatPushCount < 5 &&
  //           this.chainid == 1) {
  //         if (this.signMessage != null) {
  //           final Map<String, dynamic> params = {
  //             "id": "1",
  //             "jsonrpc": "2.0",
  //             "method": "eth_sendRawTransaction",
  //             "params": [this.signMessage]
  //           };
  //           var urls = [
  //             'https://jsonrpc.maiziqianbao.net',
  //             'https://mainnet.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161', //metamask
  //             'https://mainnet.infura.io/v3/5214b556252f4858b486bcb825f578e6' //zktube
  //           ];
  //           dynamic result = await ChainServices.requestETHRpc(
  //               url: urls[repeatPushCount ~/ 2], paramas: params);
  //           LogUtil.v('重新push $result');
  //           if (result != null) {
  //             final pushResult = result.toString();
  //             if (pushResult.contains('already known') == true) {
  //               this.repeatPushCount = 99;
  //             } else {
  //               this.repeatPushCount = repeatPushCount + 1;
  //             }
  //             TransRecordModel.updateTrxList(this);
  //           }
  //         }
  //       }
  //     }
  //   } else {
  //     if (this.transType == MTransListType.L2ChangepubKey.index ||
  //         this.transType == MTransListType.L2Transfer.index) {
  //       bool? txState =
  //           await Provider.of<CurrentChooseWalletState>(context, listen: false)
  //               .getTransactionStatus(tx);
  //       if (txState == true) {
  //         this.transStatus = MTransState.MTransState_PendingL2.index;
  //         bool? state = await ChainServices.requestVerState(tx);
  //         if (state == true) {
  //           this.transStatus = MTransState.MTransState_Success.index;
  //         }
  //         TransRecordModel.updateTrxList(this);
  //         return true;
  //       } else if (txState == false) {
  //         this.transStatus = MTransState.MTransState_Failere.index;
  //         TransRecordModel.updateTrxList(this);
  //         return true;
  //       } else if (txState == null) {
  //         // this.transStatus = MTransState.MTransState_Failere.index;
  //         // return TransRecordModel.updateTrxList(this);
  //       }
  //     } else if (this.transType == MTransListType.L2Withdraw.index) {
  //       bool? txState =
  //           await Provider.of<CurrentChooseWalletState>(context, listen: false)
  //               .getTransactionStatus(tx);
  //       if (txState == true) {
  //         this.transStatus = MTransState.MTransState_PendingL2.index;
  //         String? ethsync = (await Provider.of<CurrentChooseWalletState>(
  //                 context,
  //                 listen: false)
  //             .getEthTransactionForWithdrawal(tx));
  //         if (ethsync != null) {
  //           final ethresult =
  //               await ChainServices.requestTransactionReceipt(ethsync);
  //           if (ethresult != null &&
  //               ethresult is Map &&
  //               ethresult.keys.contains("result") &&
  //               ethresult["result"] != null) {
  //             final result = ethresult["result"];
  //             if (result != null) {
  //               String status = result["status"];
  //               if (status == "0x1") {
  //                 this.transStatus = MTransState.MTransState_Success.index;
  //               } else {
  //                 this.transStatus = MTransState.MTransState_Failere.index;
  //               }
  //               TransRecordModel.updateTrxList(this);
  //               return true;
  //             }
  //           }
  //         }
  //         TransRecordModel.updateTrxList(this);
  //         return true;
  //       } else if (txState == false) {
  //         this.transStatus = MTransState.MTransState_Failere.index;
  //         TransRecordModel.updateTrxList(this);
  //         return true;
  //       }
  //     }
  //   }
  // }

  static Future<List<TransRecordModel>> queryTrxList(
      String from, String symbol, int chainid, int kTransDataType) async {
    try {
      LogUtil.v(
          "queryTrxList from $from symbol $symbol chainid $chainid kTransDataType $kTransDataType");

      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      List<TransRecordModel> dbs = [];
      if (KTransDataType.ts_all.index == kTransDataType) {
        dbs = await database?.transListDao
                .queryAllTrxList(from, symbol, chainid) ??
            [];
      } else if (KTransDataType.ts_out.index == kTransDataType) {
        dbs = await database?.transListDao
                .queryOutTrxList(from, symbol, chainid) ??
            [];
      } else if (KTransDataType.ts_in.index == kTransDataType) {
        dbs = await database?.transListDao
                .queryInTrxList(from, symbol, chainid) ??
            [];
      } else if (KTransDataType.ts_other.index == kTransDataType) {
        dbs = await database?.transListDao
                .queryOtherTrxList(from, symbol, chainid) ??
            [];
      }
      return dbs;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return [];
    }
  }

  static Future<List<TransRecordModel>> queryPendingTrxList(
      String from, String symbol, int chainid) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      List<TransRecordModel>? datas = await database?.transListDao
          .queryPendingTrxList(from, symbol, chainid);
      return datas ?? [];
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return [];
    }
  }

  static Future<List<TransRecordModel>> queryTrxFromTrxid(String txid) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      List<TransRecordModel>? datas =
          await database?.transListDao.queryTrxFromTrxid(txid);
      return datas ?? [];
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return [];
    }
  }

  static void insertTrxLists(List<TransRecordModel> models) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.transListDao.insertTrxLists(models);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
    }
  }

  static void deleteTrxList(TransRecordModel model) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.transListDao.deleteTrxList(model);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
    }
  }

  static void updateTrxLists(List<TransRecordModel> models) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.transListDao.updateTrxLists(models);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
    }
  }
}

@dao
abstract class TransRecordModelDao {
  //or toAdd =:fromAdd
  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE (fromAdd = :fromAdd or toAdd =:fromAdd )  and token = :token and chainid = :chainid ORDER BY date DESC')
  Future<List<TransRecordModel>> queryAllTrxList(
      String fromAdd, String token, int chainid);

  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE (fromAdd = :fromAdd )  and token = :token and chainid = :chainid ORDER BY date DESC')
  Future<List<TransRecordModel>> queryOutTrxList(
      String fromAdd, String token, int chainid);

  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE (toAdd = :fromAdd )  and token = :token and chainid = :chainid ORDER BY date DESC')
  Future<List<TransRecordModel>> queryInTrxList(
      String fromAdd, String token, int chainid);

  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE (fromAdd = :fromAdd or toAdd =:fromAdd  )  and token = :token and chainid = :chainid and transStatus = 0  ORDER BY date DESC')
  Future<List<TransRecordModel>> queryOtherTrxList(
      String fromAdd, String token, int chainid);

  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE (fromAdd = :fromAdd )  and token = :token and chainid = :chainid and transType =:transType ORDER BY date DESC')
  Future<List<TransRecordModel>> queryTrxListWithType(
      String fromAdd, String token, int chainid, int transType);

  @Query('SELECT * FROM ' +
      tableName +
      ' WHERE (fromAdd = :fromAdd)  and token = :token and chainid = :chainid and (transStatus = 2 OR transStatus = 3)  ORDER BY date DESC')
  Future<List<TransRecordModel>> queryPendingTrxList(
      String fromAdd, String token, int chainid);

  @Query('SELECT * FROM ' + tableName + ' WHERE txid = :txid')
  Future<List<TransRecordModel>> queryTrxFromTrxid(String txid);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTrxLists(List<TransRecordModel> models);

  @delete
  Future<void> deleteTrxList(TransRecordModel model);

  @update
  Future<void> updateTrxList(TransRecordModel model);

  @update
  Future<void> updateTrxLists(List<TransRecordModel> models);
}
