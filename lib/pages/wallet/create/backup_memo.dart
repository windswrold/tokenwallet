import 'package:cstoken/component/sortindex_button.dart';
import 'package:cstoken/component/sortindex_view.dart';
import 'package:cstoken/pages/tabbar/tabbar.dart';
import 'package:cstoken/pages/wallet/create/verify_memo.dart';
import 'package:cstoken/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../public.dart';

class BackupMemo extends StatefulWidget {
  const BackupMemo({Key? key, required this.memo, required this.walletID})
      : super(key: key);
  final String memo;
  final String walletID;

  @override
  State<BackupMemo> createState() => _BackupMemoState();
}

class _BackupMemoState extends State<BackupMemo> {
  List<SortViewItem> _datas = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    List<String> memos = widget.memo.split(" ");
    setState(() {
      for (var i = 0; i < memos.length; i++) {
        final value = memos[i];
        final item = SortViewItem(value: value, index: i);
        _datas.add(item);
      }
    });
  }

  void _backMemo() {
    Routers.push(
        context, VerifyMemo(memo: widget.memo, walletID: widget.walletID));
  }

  void _copyMemo() {
    if (widget.memo.isEmpty) return;
    Clipboard.setData(ClipboardData(text: widget.memo));
    HWToast.showText(text: "copy_success".local());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: CustomPageView(
          leading: CustomPageView.getCloseLeading(
            () {
              // Routers.goBack(context);
              Routers.push(context, HomeTabbar(), clearStack: true);
            },
          ),
          title: CustomPageView.getTitle(title: "backup_memotitle".local()),
          child: Container(
            padding: EdgeInsets.all(24.width),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "backup_pleasewrite".local(),
                          style: TextStyle(
                            fontSize: 14.font,
                            fontWeight: FontWeightUtils.regular,
                            color: ColorUtils.fromHex("#FF000000"),
                          ),
                        ),
                        SortIndexView(
                          memos: _datas,
                          offsetWidth: 48.width,
                          bgColor: ColorUtils.fromHex("#FFF6F8FF"),
                          type: SortIndexType.leftIndex,
                          onTap: (int index) {},
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 32.width),
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                              text: "backupmemo_warning".local() + "：\n",
                              style: TextStyle(
                                color: ColorUtils.fromHex("#FFFF233E"),
                                fontSize: 14.font,
                                fontWeight: FontWeightUtils.semiBold,
                              ),
                              children: [
                                TextSpan(
                                  text: "backupmemo_warningvalue".local(),
                                  style: TextStyle(
                                    color: ColorUtils.fromHex("#FFFF233E"),
                                    fontSize: 12.font,
                                    fontWeight: FontWeightUtils.regular,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                NextButton(
                  onPressed: _backMemo,
                  bgc: ColorUtils.blueColor,
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.font,
                      fontWeight: FontWeightUtils.medium),
                  title: "backupmemo_next".local(),
                ),
                NextButton(
                  onPressed: _copyMemo,
                  textStyle: TextStyle(
                      color: ColorUtils.blueColor,
                      fontSize: 14.font,
                      fontWeight: FontWeightUtils.regular),
                  title: "backupmemo_copymemo".local(),
                ),
              ],
            ),
          ),
        ));
  }
}
