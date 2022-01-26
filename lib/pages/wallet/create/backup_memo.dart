import 'package:cstoken/pages/wallet/create/verify_memo.dart';
import 'package:flutter/material.dart';

import '../../../public.dart';

class BackupMemo extends StatefulWidget {
  BackupMemo({Key? key}) : super(key: key);

  @override
  State<BackupMemo> createState() => _BackupMemoState();
}

class _BackupMemoState extends State<BackupMemo> {
  void _backMemo() {
    Routers.push(context, VerifyMemo());
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      leading: CustomPageView.getCloseLeading(() {
        Routers.goBack(context);
      }),
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
              bgc: UIConstant.blueColor,
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16.font,
                  fontWeight: FontWeightUtils.medium),
              title: "backupmemo_next".local(),
            ),
            NextButton(
              onPressed: () {},
              textStyle: TextStyle(
                  color: UIConstant.blueColor,
                  fontSize: 14.font,
                  fontWeight: FontWeightUtils.regular),
              title: "backupmemo_copymemo".local(),
            ),
          ],
        ),
      ),
    );
  }
}
