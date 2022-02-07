// import 'dart:convert';

// import 'package:flutter/services.dart';
// import 'package:flutter_coinid/constant/ui_constant.dart';
// import 'package:flutter_coinid/models/node/node_model.dart';
// import 'package:flutter_coinid/models/transrecord/trans_record.dart';
// import 'package:flutter_coinid/utils/json_util.dart';
// import 'package:flutter_coinid/utils/sharedPrefer.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../public.dart';

// class TransDetailPage extends StatefulWidget {
//   TransDetailPage({Key? key, this.params}) : super(key: key);

//   final Map? params;

//   @override
//   _TransDetailPageState createState() => _TransDetailPageState();
// }

// class _TransDetailPageState extends State<TransDetailPage> {
//   static const String leftKey = "leftKey";
//   static const String rightKey = "rightKey";
//   TransRecordModel? transMdel;
//   // List<Map> cellDatas = [];
//   String amount = "";
//   String assets = "";
//   String price = "";
//   String _feeToken = "";
//   String _typeFrom = "";
//   String _typeTo = "";
//   String _txid = '';
//   @override
//   void initState() {
//     super.initState();
//     if (widget.params != null) {
//       initData();
//     }
//   }

//   void initData() async {
//     String? walletAaddress =
//         Provider.of<CurrentChooseWalletState>(context, listen: false)
//             .currentWallet!
//             .walletAaddress;
//     _txid = widget.params!["txid"];
//     List datas = (await TransRecordModel.queryTrxFromTrxid(_txid));
//     if (datas.length == 0) {
//       final json = widget.params!["json"];
//       transMdel = TransRecordModel.fromJson(JsonUtil.getObj(json));
//     } else {
//       transMdel = datas.first;
//     }
//     if (transMdel == null) {
//       return;
//     }
//     _txid = transMdel!.txid!;
//     if (transMdel!.transType! == MTransListType.L2Deposit.index) {
//       _typeFrom = Constant.layer1Name;
//       _typeTo = Constant.layer2Name;
//     } else if (transMdel!.transType! == MTransListType.L2Transfer.index) {
//       _typeFrom = Constant.layer2Name;
//       _typeTo = Constant.layer2Name;
//     } else if (transMdel!.transType! == MTransListType.L2Withdraw.index) {
//       _typeFrom = Constant.layer2Name;
//       _typeTo = Constant.layer1Name;
//     } else {
//       _typeFrom = Constant.layer1Name;
//       _typeTo = Constant.layer1Name;
//     }
//     _txid = _txid.replaceAll("sync-tx:", "");
//     _feeToken = "ETH";
//     if (transMdel!.transType! == MTransListType.L2Transfer.index ||
//         transMdel!.transType! == MTransListType.L2Withdraw.index) {
//       _feeToken = transMdel!.symbol!;
//     }
//     if (transMdel!.isOut(walletAaddress!) == false) {
//       amount = '+';
//     } else {
//       amount = '-';
//     }
//     setState(() {
//       amount = amount + " " + transMdel!.amount! + " " + transMdel!.symbol!;
//     });
//   }

//   String _urlString() {
//     String url = "";
//     String tx = transMdel!.txid!;
//     tx = tx.replaceAll("sync-tx:", "");
//     if (transMdel!.chainid == 1) {
//       if (transMdel!.transType == MTransListType.L2Withdraw.index ||
//           transMdel!.transType == MTransListType.L2Deposit.index ||
//           transMdel!.transType == MTransListType.L2Transfer.index ||
//           transMdel!.transType == MTransListType.L2ChangepubKey.index ||
//           transMdel!.transType == MTransListType.L2Failed.index) {
//         url = "$mainNetBrowserUrl/transactions/$tx";
//       } else {
//         url = "$mainNetEthScan/tx/" + tx;
//       }
//     } else {
//       if (transMdel!.transType == MTransListType.L2Withdraw.index ||
//           transMdel!.transType == MTransListType.L2Deposit.index ||
//           transMdel!.transType == MTransListType.L2Transfer.index ||
//           transMdel!.transType == MTransListType.L2ChangepubKey.index ||
//           transMdel!.transType == MTransListType.L2Failed.index) {
//         url = "$rinkebyBrowserUrl/transactions/$tx";
//       } else {
//         url = "$rinkebyEthScan/tx/" + tx;
//       }
//     }
//     return url;
//   }

//   _launchURL() {
//     launch(_urlString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomPageView(
//       title: CustomPageView.getDefaultTitle(
//         context: context,
//         titleStr: "transaction_details".local(),
//       ),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: UIConstant.horizontalsPacing),
//         child: transMdel == null
//             ? EmptyDataPage(
//                 emptyTip: "empay_datano",
//               )
//             : Column(
//                 children: [
//                   _contentView(),
//                   50.columnWidget,
//                   GestureDetector(
//                     behavior: HitTestBehavior.opaque,
//                     onTap: () {
//                       _launchURL();
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "go_query_details".local(),
//                           style: TextStyle(
//                               color: ColorUtils.rgba(78, 108, 220, 1),
//                               fontWeight: FontWeight.w600,
//                               fontSize: OffsetWidget.setSp(14)),
//                         ),
//                         OffsetWidget.hGap(8),
//                       ],
//                     ),
//                   ),
//                   50.columnWidget,
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _contentView() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.width, vertical: 20.width),
//       decoration: BoxDecoration(
//         color: ThemeUtils.getFillColor(context.isDark),
//         borderRadius: BorderRadius.circular(12.width),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(child: _transactionStatus()),
//           _amountText(),
//           _contentText(
//             "payment_from".local() + " " + _typeFrom,
//             transMdel!.fromAdd ?? "",
//             true,
//             abbreviation: true,
//           ),
//           6.columnWidget,
//           _contentText(
//             "payment_to".local() + " " + _typeTo,
//             transMdel!.toAdd ??= "",
//             true,
//             abbreviation: true,
//           ),
//           6.columnWidget,
//           _contentText(
//             "hash".local(),
//             _txid,
//             true,
//           ),
//           12.columnWidget,
//           Container(
//             height: 0.5,
//             color: context.isDark
//                 ? Colors.white.withOpacity(0.1)
//                 : Colors.black.withOpacity(0.1),
//           ),
//           20.columnWidget,
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _contentText(
//                     'payment_fee'.local(),
//                     "${transMdel?.fee ?? "0.00"} $_feeToken",
//                     false,
//                   ),
//                   6.columnWidget,
//                   _contentText(
//                     'block_height'.local(),
//                     "${transMdel?.blockHeight ?? ""}",
//                     false,
//                   ),
//                   6.columnWidget,
//                   _contentText(
//                     'timeStamp'.local(),
//                     transMdel!.date ??= "",
//                     false,
//                   ),
//                   6.columnWidget,
//                   _contentText(
//                     'payment_remark'.local(),
//                     transMdel!.remarks ??= "",
//                     false,
//                   ),
//                 ],
//               ),
//               Column(
//                 children: [
//                   QrImage(
//                     data: _urlString(),
//                     padding: EdgeInsets.all(3),
//                     size: OffsetWidget.setSc(88),
//                     backgroundColor:
//                         context.isDark ? Colors.white : Colors.transparent,
//                   ),
//                   6.columnWidget,
//                   Text(
//                     'query_link'.local(),
//                     style:
//                         ThemeUtils.incomeListCellSubtitleStyle(context.isDark),
//                   ),
//                 ],
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget _transactionStatus() {
//     String _statusImage = '';
//     String _statusStr = '';
//     Color? _textColor;
//     if (transMdel!.transStatus == MTransState.MTransState_Success.index) {
//       _statusImage = context.isDark
//           ? Constant.ASSETS_IMG + "icons/transaction_success_dark.png"
//           : Constant.ASSETS_IMG + "icons/transaction_success_light.png";
//       _statusStr = "success".local();
//       _textColor = context.isDark ? Color(0xff24DFBE) : Color(0xff52AA98);
//     } else if (transMdel!.transStatus ==
//         MTransState.MTransState_Failere.index) {
//       _statusImage = context.isDark
//           ? Constant.ASSETS_IMG + "icons/transaction_failed_dark.png"
//           : Constant.ASSETS_IMG + "icons/transaction_failed_light.png";
//       _statusStr = "translist_transFailere".local();
//       _textColor = Color(0xffFF454B);
//     } else {
//       _statusImage = context.isDark
//           ? Constant.ASSETS_IMG + "icons/transaction_pending_dark.png"
//           : Constant.ASSETS_IMG + "icons/transaction_pending_light.png";
//       _statusStr = "transdetail_pending".local();
//       _textColor = context.isDark ? Colors.white : Color(0xff191B1D);
//     }

//     return Column(
//       children: [
//         Container(
//           width: 42.width,
//           height: 42.width,
//           child: Image.asset(
//             _statusImage,
//             fit: BoxFit.cover,
//           ),
//         ),
//         7.columnWidget,
//         Text(
//           _statusStr,
//           style: TextStyle(
//               color: _textColor,
//               fontWeight: FontWeight.w500,
//               fontSize: 14.font),
//         )
//       ],
//     );
//   }

//   Widget _amountText() {
//     return Container(
//       padding: EdgeInsets.only(
//         top: 8.width,
//         bottom: 20.width,
//       ),
//       alignment: Alignment.center,
//       child: Text(
//         amount,
//         style: TextStyle(
//           fontSize: 18.font,
//           color: ThemeUtils.labelColor(context),
//           fontWeight: FontWeight.w500,
//         ),
//         overflow: TextOverflow.ellipsis,
//       ),
//     );
//   }

//   Widget _contentText(String title, String content, bool canCopy,
//       {bool abbreviation = false}) {
//     return Container(
//       padding: EdgeInsets.only(bottom: 10.width),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: ThemeUtils.incomeListCellSubtitleStyle(context.isDark),
//           ),
//           Text.rich(
//             TextSpan(
//               style: ThemeUtils.incomeListCellContentStyle(context.isDark),
//               children: [
//                 TextSpan(
//                   text: abbreviation
//                       ? StringUtil.contractAddress(content, end: 10)
//                       : content,
//                 ),
//                 TextSpan(
//                   text: '  ',
//                 ),
//                 WidgetSpan(
//                   child: canCopy
//                       ? GestureDetector(
//                           onTap: () {
//                             Clipboard.setData(ClipboardData(text: content));
//                             HWToast.showText(text: "copy_success".local());
//                           },
//                           child: Container(
//                             width: 16.width,
//                             height: 16.width,
//                             child: Image.asset(context.isDark
//                                 ? Constant.ASSETS_IMG + "icons/copy_drak.png"
//                                 : Constant.ASSETS_IMG + "icons/copy_light.png"),
//                           ),
//                         )
//                       : Container(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
