import '../public.dart';

class BackupWarningTip extends StatelessWidget {
  const BackupWarningTip(
      {Key? key, required this.onTap, required this.tapClose})
      : super(key: key);
  final VoidCallback onTap;
  final VoidCallback tapClose;

  @override
  Widget build(BuildContext context) {
    String warning = "homepage_backuptip".local();
    double maxWidth = 225.width;
    Size maxsize = calculateTextSize(
        warning, 10.font, FontWeightUtils.regular, maxWidth, null, context);

    return Container(
      height: 70.width + maxsize.height,
      color: ColorUtils.fromHex("#FFFFFCFA"),
      margin:
          EdgeInsets.only(left: 16.width, right: 16.width, bottom: 16.width),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 8, right: 8),
            padding: EdgeInsets.all(12.width),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    LoadAssetsImage(
                      "icons/icon_red_warningtip.png",
                      width: 20,
                      height: 20,
                    ),
                    4.rowWidget,
                    Text(
                      "homepage_warningtip".local(),
                      style: TextStyle(
                        fontSize: 14.font,
                        color: ColorUtils.redColor,
                      ),
                    ),
                  ],
                ),
                8.columnWidget,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        warning,
                        style: TextStyle(
                          fontSize: 10.font,
                          color: ColorUtils.fromHex("#FF000000"),
                        ),
                      ),
                    ),
                    NextButton(
                        onPressed: onTap,
                        bgc: ColorUtils.blueColor,
                        padding: EdgeInsets.symmetric(horizontal: 12.width),
                        margin: EdgeInsets.only(left: 15.width),
                        height: 25,
                        textStyle: TextStyle(
                          fontSize: 12.font,
                          fontWeight: FontWeightUtils.medium,
                          color: Colors.white,
                        ),
                        title: "homepage_backup".local()),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: tapClose,
                child: SizedBox(
                  width: 30.width,
                  height: 30.width,
                  child: Center(
                    child: LoadAssetsImage(
                      "icons/icon_circle_close.png",
                      width: 16,
                      height: 16,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
