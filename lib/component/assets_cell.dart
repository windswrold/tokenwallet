import 'package:cstoken/model/tokens/collection_tokens.dart';

import '../public.dart';

class AssetsCell extends StatelessWidget {
  const AssetsCell({Key? key, required this.token, required this.onTap}) : super(key: key);
  final MCollectionTokens token;
  final VoidCallback onTap;

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
                        token.token ?? "",
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
                        token.coinType ?? "",
                        style: TextStyle(
                          color: ColorUtils.fromHex("#FF000000"),
                          fontSize: 12.font,
                          fontWeight: FontWeightUtils.regular,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onTap,
                  behavior: HitTestBehavior.opaque,
                  child: LoadAssetsImage(
                    token.state == 1
                        ? "icons/icon_tokened.png"
                        : "icons/icon_tokenadd.png",
                    width: 20,
                    height: 20,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 4.width),
              child: Text(
                token.contract ?? (token.coinType ?? ""),
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
          _loadImgView(token.iconPath ?? ''),
          12.rowWidget,
          _loadContent(),
        ],
      ),
    );
  }
}
