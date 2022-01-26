import 'package:cstoken/component/sortindex_button.dart';
import 'package:cstoken/component/sortindex_view.dart';

import '../../../public.dart';

class VerifyMemo extends StatefulWidget {
  VerifyMemo({Key? key}) : super(key: key);

  @override
  State<VerifyMemo> createState() => _VerifyMemoState();
}

class _VerifyMemoState extends State<VerifyMemo> {
  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      leading: CustomPageView.getCloseLeading(
        () {
          Routers.goBack(context);
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
                      "verifymemo_nextclick".local(),
                      style: TextStyle(
                        fontSize: 14.font,
                        fontWeight: FontWeightUtils.regular,
                        color: ColorUtils.fromHex("#FF000000"),
                      ),
                    ),
                    SortIndexView(
                      memos: List.filled(
                        12,
                        SortViewItem(value: "value", index: 1, isWrong: true),
                      ),
                      offsetWidth: 48.width,
                      bgColor: ColorUtils.fromHex("#FFF6F8FF"),
                      type: SortIndexType.wrongIndex,
                      onTap: (int index) {
                        print("wrongIndex $index");
                      },
                    ),
                    SortIndexView(
                      memos: List.filled(12,
                          SortViewItem(value: "111", index: 12, select: false)),
                      offsetWidth: 48.width,
                      bgColor: Colors.white,
                      type: SortIndexType.actionIndex,
                      onTap: (int index) {
                        print("actionIndex $index");
                      },
                    ),
                  ],
                ),
              ),
            ),
            NextButton(
              onPressed: () {},
              bgc: UIConstant.blueColor,
              enableColor: ColorUtils.fromHex("#667685A2"),
              enabled: false,
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16.font,
                  fontWeight: FontWeightUtils.medium),
              title: "verifymemo_verifystate".local(),
            ),
          ],
        ),
      ),
    );
  }
}
