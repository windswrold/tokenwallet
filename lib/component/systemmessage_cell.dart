import '../public.dart';

class SystemMessageCell extends StatelessWidget {
  const SystemMessageCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 71.width,
        padding: EdgeInsets.symmetric(horizontal: 16.width),
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
            width: 0.5,
            color: ColorUtils.lineColor,
          )),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "KSM主网升级维护通知",
              style: TextStyle(
                color: ColorUtils.fromHex("#FF000000"),
                fontSize: 14.font,
                fontWeight: FontWeightUtils.semiBold,
              ),
            ),
            4.columnWidget,
            Text(
              "18-05-15 10:38:21",
              style: TextStyle(
                color: ColorUtils.fromHex("#99000000"),
                fontSize: 12.font,
                fontWeight: FontWeightUtils.regular,
              ),
            ),
          ],
        ));
  }
}
