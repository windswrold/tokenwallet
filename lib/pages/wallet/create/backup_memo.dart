import 'package:flutter/material.dart';

import '../../../public.dart';

class BackupMemo extends StatefulWidget {
  BackupMemo({Key? key}) : super(key: key);

  @override
  State<BackupMemo> createState() => _BackupMemoState();
}

class _BackupMemoState extends State<BackupMemo> {
  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: CustomPageView.getTitle(
        title: "backup_memotitle".local(),
      ),
      leading: CustomPageView.getCloseLeading(() {
        Routers.goBack(context);
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
                style: TextStyle(
                  color: ColorUtils.fromHex("#FF000000"),
                  fontSize: 24.font,
                  fontWeight: FontWeightUtils.semiBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
