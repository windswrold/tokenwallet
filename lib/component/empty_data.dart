import '../public.dart';

class EmptyDataPage extends StatelessWidget {
  const EmptyDataPage(
      {Key? key,
      this.emptyTip,
      this.bottomBtnTitle,
      this.onTap,
      this.subBottomBtnTitle,
      this.subOnTap})
      : super(key: key);

  final String? emptyTip;
  final String? bottomBtnTitle;
  final VoidCallback? onTap;
  final String? subBottomBtnTitle;
  final VoidCallback? subOnTap;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 20.width),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emptyTip ?? "empay_datano".local(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorUtils.fromHex("#99000000"),
                fontSize: 14.font,
                fontWeight: FontWeight.w400,
              ),
            ),
            Visibility(
              visible: bottomBtnTitle != null,
              child: NextButton(
                  onPressed: () {
                    if (onTap != null) {
                      onTap!();
                    }
                  },
                  bgc: ColorUtils.blueColor,
                  margin: EdgeInsets.only(top: 20.width),
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.font,
                  ),
                  title: bottomBtnTitle ?? ""),
            ),
            Visibility(
              visible: subBottomBtnTitle != null,
              child: NextButton(
                  onPressed: () {
                    if (subOnTap != null) {
                      subOnTap!();
                    }
                  },
                  bgc: ColorUtils.blueColor,
                  margin: EdgeInsets.only(top: 20.width),
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.font,
                  ),
                  title: subBottomBtnTitle ?? ""),
            ),
          ],
        ));
  }
}
