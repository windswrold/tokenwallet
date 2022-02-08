import '../public.dart';

class AssetsCell extends StatelessWidget {
  const AssetsCell({Key? key}) : super(key: key);

  Widget _loadImgView(String icon) {
    return Container(
      child: LoadAssetsImage(icon,
          width: 40,
          height: 40,
          errorBuilder: (context, error, stackTrace) => LoadAssetsImage(
                "tokens/token_default.png",
                width: 40,
                height: 40,
              )),
    );
  }

  Widget _loadContent() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(bottom: 12.width),
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 0.5,
          color: ColorUtils.lineColor,
        ))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "data1",
                        style: TextStyle(
                          color: ColorUtils.fromHex("#FF000000"),
                          fontSize: 16.font,
                          fontWeight: FontWeightUtils.semiBold,
                        ),
                      ),
                    ),
                    4.columnWidget,
                    Container(
                      child: Text(
                        "data2",
                        style: TextStyle(
                          color: ColorUtils.fromHex("#FF000000"),
                          fontSize: 12.font,
                          fontWeight: FontWeightUtils.regular,
                        ),
                      ),
                    ),
                  ],
                ),
                LoadAssetsImage(
                  "icons/icon_tokenadd.png",
                  width: 20,
                  height: 20,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 4.width),
              child: Text(
                "data3",
                style: TextStyle(
                  color: ColorUtils.fromHex("#FF000000"),
                  fontSize: 12.font,
                  fontWeight: FontWeightUtils.regular,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12.width, left: 16.width, right: 16.width),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _loadImgView("tokens/Arbitrum.png"),
          12.rowWidget,
          _loadContent(),
        ],
      ),
    );
  }
}
