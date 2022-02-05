import 'package:cstoken/component/no_screenshots.dart';
import 'package:cstoken/pages/tabbar/tabbar.dart';
import 'package:flutter/material.dart';

import '../../../public.dart';
import 'backup_memo.dart';

class BackupTipMemo extends StatefulWidget {
  const BackupTipMemo({Key? key, required this.memo, required this.walletID})
      : super(key: key);
  final String memo;
  final String walletID;

  @override
  State<BackupTipMemo> createState() => _BackupTipMemoState();
}

class _BackupTipMemoState extends State<BackupTipMemo> {
  void _startBackup() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) {
          return NoScreentshots(
            onTap: () {
              Routers.push(context,
                  BackupMemo(memo: widget.memo, walletID: widget.walletID));
            },
          );
        });
  }

  ///暂不备份
  void _waitBackUp() {
    Routers.push(context, HomeTabbar(), clearStack: true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: CustomPageView(
          title: CustomPageView.getTitle(
            title: "backup_memotitle".local(),
          ),
          leading: CustomPageView.getCloseLeading(() {
            _waitBackUp();
          }),
          child: Container(
            padding: EdgeInsets.only(left: 16.width, right: 16.width),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 120.width),
                  child: Text(
                    "backup_know".local(),
                    style: TextStyle(
                      color: ColorUtils.fromHex("#FF000000"),
                      fontSize: 24.font,
                      fontWeight: FontWeightUtils.semiBold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 16.width),
                  child: Text(
                    "backup_memoowner".local(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorUtils.fromHex("#FFFF6613"),
                      fontSize: 16.font,
                      fontWeight: FontWeightUtils.medium,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 4.width),
                  child: Text(
                    "backup_memotype".local(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorUtils.fromHex("#CC000000"),
                      fontSize: 14.font,
                      fontWeight: FontWeightUtils.regular,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 120.width),
                  child: NextButton(
                    onPressed: _startBackup,
                    bgc: ColorUtils.blueColor,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.font,
                      fontWeight: FontWeightUtils.medium,
                    ),
                    title: "backup_nextbackup".local(),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: NextButton(
                    onPressed: _waitBackUp,
                    textStyle: TextStyle(
                      color: ColorUtils.fromHex("#99000000"),
                      fontSize: 14.font,
                      fontWeight: FontWeightUtils.medium,
                    ),
                    title: "backup_nobackup".local(),
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }
}
