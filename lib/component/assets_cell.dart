import 'package:cstoken/model/nft/nft_model.dart';
import 'package:cstoken/model/tokens/collection_tokens.dart';

import '../public.dart';

class AssetsCell extends StatelessWidget {
  const AssetsCell({Key? key, required this.token, required this.onTap})
      : super(key: key);
  final dynamic token;
  final VoidCallback onTap;

  Widget _loadImgView(String icon) {
    return Container(
      child: LoadTokenAssetsImage(
        icon,
        width: 40,
        height: 40,
      ),
    );
  }

  Widget _loadContent(
      String token, String coinType, int state, String contract) {
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
                      width: 200.width,
                      child: Text(
                        token,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                        coinType,
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
                    state == 1
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
                (contract.replaceAll(
                    "0x0000000000000000000000000000000000000000", "")),
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
    String icon = "";
    String tokenContent = "";
    String coinType = "";
    int state = 0;
    String contract = "";
    if (token is MCollectionTokens) {
      MCollectionTokens model = token as MCollectionTokens;
      icon = model.iconPath ?? "";
      tokenContent = model.token ?? '';
      coinType = model.coinType ?? "";
      state = model.state ?? 0;
      contract = model.contract ?? "";
    } else {
      NFTModel model = token as NFTModel;
      icon = model.url ?? "";
      state = model.state ?? 0;
      tokenContent = (model.contractName ?? '');
      contract = model.contractAddress ?? '';
      coinType = model.chainTypeName ?? "";
    }

    return Container(
      padding: EdgeInsets.only(top: 12.width, left: 16.width, right: 16.width),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _loadImgView(icon),
          12.rowWidget,
          _loadContent(tokenContent, coinType, state, contract),
        ],
      ),
    );
  }
}
