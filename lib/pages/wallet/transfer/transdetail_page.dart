import 'package:cstoken/model/transrecord/trans_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../public.dart';

class TransDetailPage extends StatefulWidget {
  TransDetailPage({Key? key, this.model}) : super(key: key);

  final TransRecordModel? model;

  @override
  _TransDetailPageState createState() => _TransDetailPageState();
}

class _TransDetailPageState extends State<TransDetailPage> {
  String from = "";
  @override
  void initState() {
    super.initState();

    from = Provider.of<CurrentChooseWalletState>(context, listen: false)
        .walletinfo!
        .walletAaddress!;
  }

  Widget _buildStateIcon() {
    return Container(
      child: LoadAssetsImage(
        widget.model!.transStateicon(),
        width: 56,
        height: 56,
      ),
    );
  }

  Widget _buildStateTip() {
    return Container(
        padding: EdgeInsets.only(top: 8.width),
        child: Text(
          widget.model!.transState(),
          style: TextStyle(
            color: ColorUtils.fromHex("#FF000000"),
            fontSize: 14.font,
          ),
        ));
  }

  Widget _buildTransAmount() {
    return Container(
        padding: EdgeInsets.only(top: 8.width),
        child: Text(
          widget.model!.vaueString(from),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorUtils.fromHex("#FF000000"),
            fontSize: 24.font,
            fontWeight: FontWeightUtils.semiBold,
          ),
        ));
  }

  Widget _buildTransTime() {
    return Container(
        child: Text(
      widget.model!.date ?? "",
      style: TextStyle(
        color: ColorUtils.fromHex("#FF000000"),
        fontSize: 11.font,
        fontWeight: FontWeightUtils.regular,
      ),
    ));
  }

  Widget _buildCell(String leftString, String rightContent,
      {String? details, bool canCopy = false, bool addContacts = false}) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 36.width,
      ),
      padding: EdgeInsets.symmetric(vertical: 8.width),
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(
          width: 0.5,
          color: ColorUtils.lineColor,
        )),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 110.width,
            child: Text(
              leftString,
              style: TextStyle(
                color: ColorUtils.fromHex("#99000000"),
                fontSize: 12.font,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (canCopy == true) {
                  rightContent.copy();
                }
              },
              child: RichText(
                textAlign: TextAlign.end,
                text: TextSpan(
                  text: rightContent,
                  style: TextStyle(
                    color: ColorUtils.fromHex("#FF000000"),
                    fontSize: 12.font,
                    fontWeight: FontWeightUtils.medium,
                  ),
                  children: [
                    WidgetSpan(
                      child: Visibility(
                        visible: canCopy,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.width),
                          child: LoadAssetsImage(
                            "icons/icon_black_copy.png",
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ),
                    ),
                    WidgetSpan(
                      child: Visibility(
                        visible: addContacts,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.width),
                            child: Text(
                              "transferetype_addcontaca".local(),
                              style: TextStyle(
                                  color: ColorUtils.blueColor,
                                  fontSize: 11.font,
                                  fontWeight: FontWeightUtils.regular),
                            )),
                      ),
                    ),
                    WidgetSpan(
                      child: Visibility(
                        visible: details == null ? false : true,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.width),
                            child: Text(
                              details ?? "",
                              style: TextStyle(
                                  color: ColorUtils.fromHex("#FF000000")
                                      .withOpacity(0.4),
                                  fontSize: 11.font,
                                  fontWeight: FontWeightUtils.regular),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _speedUPView() {
    return Visibility(
      visible: false,
      child: Container(
        height: 64.width,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NextButton(
                bgc: ColorUtils.blueColor,
                height: 44,
                borderRadius: 12,
                width: 142.width,
                onPressed: () {},
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16.font,
                  fontWeight: FontWeightUtils.medium,
                ),
                title: "transferetype_speedup".local()),
            16.rowWidget,
            NextButton(
                onPressed: () {},
                height: 44,
                borderRadius: 12,
                width: 142,
                bgc: ColorUtils.blueBGColor,
                textStyle: TextStyle(
                  color: ColorUtils.blueColor,
                  fontSize: 16.font,
                  fontWeight: FontWeightUtils.medium,
                ),
                title: "transferetype_cancel".local()),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: CustomPageView.getTitle(
        title: "transferetype_transdetail".local(),
      ),
      // actions: [
      //   Padding(
      //     padding: EdgeInsets.only(right: 16.width),
      //     child:
      //         CustomPageView.getCustomIcon("icons/icon_blue_share.png", () {}),
      //   ),
      // ],
      backgroundColor: ColorUtils.backgroudColor,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.width),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.width),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        _buildStateIcon(),
                        _buildStateTip(),
                        _buildTransAmount(),
                        _buildTransTime(),
                      ],
                    ),
                  ),
                  8.columnWidget,
                  Container(
                    padding:
                        EdgeInsets.fromLTRB(16.width, 16.width, 16.width, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        _buildCell("transferetype_chain".local(),
                            widget.model!.coinType ?? ""),
                        _buildCell(
                            "transferetype_bl".local(),
                            widget.model!.blockHeight == null
                                ? "-"
                                : widget.model!.blockHeight.toString()),
                        _buildCell("transferetype_trx".local(),
                            widget.model!.txid ?? "",
                            canCopy: true),
                        _buildCell(
                          "transferetype_from".local(),
                          widget.model!.fromAdd ?? "",
                          canCopy: true,
                        ),
                        _buildCell(
                          "transferetype_to".local(),
                          widget.model!.toAdd ?? "",
                          canCopy: true,
                        ),
                        _buildCell("transferetype_fee".local(),
                            widget.model!.fee ?? ""),
                        _buildCell("transferetype_remark".local(),
                            widget.model!.remarks ?? ""),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _speedUPView(),
        ],
      ),
    );
  }
}

  // Widget _contentView() {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 16.width, vertical: 20.width),
  //     decoration: BoxDecoration(
  //       color: ThemeUtils.getFillColor(context.isDark),
  //       borderRadius: BorderRadius.circular(12.width),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Center(child: _transactionStatus()),
  //         _amountText(),
  //         _contentText(
  //           "payment_from".local() + " " + _typeFrom,
  //           transMdel!.fromAdd ?? "",
  //           true,
  //           abbreviation: true,
  //         ),
  //         6.columnWidget,
  //         _contentText(
  //           "payment_to".local() + " " + _typeTo,
  //           transMdel!.toAdd ??= "",
  //           true,
  //           abbreviation: true,
  //         ),
  //         6.columnWidget,
  //         _contentText(
  //           "hash".local(),
  //           _txid,
  //           true,
  //         ),
  //         12.columnWidget,
  //         Container(
  //           height: 0.5,
  //           color: context.isDark
  //               ? Colors.white.withOpacity(0.1)
  //               : Colors.black.withOpacity(0.1),
  //         ),
  //         20.columnWidget,
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 _contentText(
  //                   'payment_fee'.local(),
  //                   "${transMdel?.fee ?? "0.00"} $_feeToken",
  //                   false,
  //                 ),
  //                 6.columnWidget,
  //                 _contentText(
  //                   'block_height'.local(),
  //                   "${transMdel?.blockHeight ?? ""}",
  //                   false,
  //                 ),
  //                 6.columnWidget,
  //                 _contentText(
  //                   'timeStamp'.local(),
  //                   transMdel!.date ??= "",
  //                   false,
  //                 ),
  //                 6.columnWidget,
  //                 _contentText(
  //                   'payment_remark'.local(),
  //                   transMdel!.remarks ??= "",
  //                   false,
  //                 ),
  //               ],
  //             ),
  //             Column(
  //               children: [
  //                 QrImage(
  //                   data: _urlString(),
  //                   padding: EdgeInsets.all(3),
  //                   size: OffsetWidget.setSc(88),
  //                   backgroundColor:
  //                       context.isDark ? Colors.white : Colors.transparent,
  //                 ),
  //                 6.columnWidget,
  //                 Text(
  //                   'query_link'.local(),
  //                   style:
  //                       ThemeUtils.incomeListCellSubtitleStyle(context.isDark),
  //                 ),
  //               ],
  //             )
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Widget _transactionStatus() {
  //   String _statusImage = '';
  //   String _statusStr = '';
  //   Color? _textColor;
  //   if (transMdel!.transStatus == MTransState.MTransState_Success.index) {
  //     _statusImage = context.isDark
  //         ? Constant.ASSETS_IMG + "icons/transaction_success_dark.png"
  //         : Constant.ASSETS_IMG + "icons/transaction_success_light.png";
  //     _statusStr = "success".local();
  //     _textColor = context.isDark ? Color(0xff24DFBE) : Color(0xff52AA98);
  //   } else if (transMdel!.transStatus ==
  //       MTransState.MTransState_Failere.index) {
  //     _statusImage = context.isDark
  //         ? Constant.ASSETS_IMG + "icons/transaction_failed_dark.png"
  //         : Constant.ASSETS_IMG + "icons/transaction_failed_light.png";
  //     _statusStr = "translist_transFailere".local();
  //     _textColor = Color(0xffFF454B);
  //   } else {
  //     _statusImage = context.isDark
  //         ? Constant.ASSETS_IMG + "icons/transaction_pending_dark.png"
  //         : Constant.ASSETS_IMG + "icons/transaction_pending_light.png";
  //     _statusStr = "transdetail_pending".local();
  //     _textColor = context.isDark ? Colors.white : Color(0xff191B1D);
  //   }

  //   return Column(
  //     children: [
  //       Container(
  //         width: 42.width,
  //         height: 42.width,
  //         child: Image.asset(
  //           _statusImage,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //       7.columnWidget,
  //       Text(
  //         _statusStr,
  //         style: TextStyle(
  //             color: _textColor,
  //             fontWeight: FontWeight.w500,
  //             fontSize: 14.font),
  //       )
  //     ],
  //   );
  // }

  // Widget _amountText() {
  //   return Container(
  //     padding: EdgeInsets.only(
  //       top: 8.width,
  //       bottom: 20.width,
  //     ),
  //     alignment: Alignment.center,
  //     child: Text(
  //       amount,
  //       style: TextStyle(
  //         fontSize: 18.font,
  //         color: ThemeUtils.labelColor(context),
  //         fontWeight: FontWeight.w500,
  //       ),
  //       overflow: TextOverflow.ellipsis,
  //     ),
  //   );
  // }

  // Widget _contentText(String title, String content, bool canCopy,
  //     {bool abbreviation = false}) {
  //   return Container(
  //     padding: EdgeInsets.only(bottom: 10.width),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           title,
  //           style: ThemeUtils.incomeListCellSubtitleStyle(context.isDark),
  //         ),
  //         Text.rich(
  //           TextSpan(
  //             style: ThemeUtils.incomeListCellContentStyle(context.isDark),
  //             children: [
  //               TextSpan(
  //                 text: abbreviation
  //                     ? StringUtil.contractAddress(content, end: 10)
  //                     : content,
  //               ),
  //               TextSpan(
  //                 text: '  ',
  //               ),
  //               WidgetSpan(
  //                 child: canCopy
  //                     ? GestureDetector(
  //                         onTap: () {
  //                           Clipboard.setData(ClipboardData(text: content));
  //                           HWToast.showText(text: "copy_success".local());
  //                         },
  //                         child: Container(
  //                           width: 16.width,
  //                           height: 16.width,
  //                           child: Image.asset(context.isDark
  //                               ? Constant.ASSETS_IMG + "icons/copy_drak.png"
  //                               : Constant.ASSETS_IMG + "icons/copy_light.png"),
  //                         ),
  //                       )
  //                     : Container(),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
// }
