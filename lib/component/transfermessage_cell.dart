import '../public.dart';

class TransferMessageCell extends StatelessWidget {
  const TransferMessageCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imgName = "icons/icon_in.png";
    String address =
        "0xE5298fD436B9874f7FB87a5117fA269B2623Ca34".contractAddress(end: 5);
    String time = "2021-05-04 13:23:34";
    String value = "-123.0134 USDT";
    String state = "确认中";
    return Container(
        height: 71.width,
        padding: EdgeInsets.fromLTRB(16.width, 16.width, 16.width, 0),
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
            width: 0.5,
            color: ColorUtils.lineColor,
          )),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadAssetsImage(
                  imgName,
                  width: 24,
                  height: 24,
                ),
                8.rowWidget,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address,
                      style: TextStyle(
                        color: ColorUtils.fromHex("#FF000000"),
                        fontSize: 14.font,
                        fontWeight: FontWeightUtils.regular,
                      ),
                    ),
                    2.columnWidget,
                    Text(
                      time,
                      style: TextStyle(
                        color: ColorUtils.fromHex("#99000000"),
                        fontSize: 12.font,
                        fontWeight: FontWeightUtils.regular,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: ColorUtils.fromHex("#FF000000"),
                    fontSize: 14.font,
                    fontWeight: FontWeightUtils.semiBold,
                  ),
                ),
                2.columnWidget,
                Text(
                  state,
                  style: TextStyle(
                    color: ColorUtils.fromHex("#99000000"),
                    fontSize: 12.font,
                    fontWeight: FontWeightUtils.regular,
                  ),
                ),
              ],
            ),
          ],
        ));
    ;
  }
}
