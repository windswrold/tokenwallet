import 'package:cstoken/pages/wallet/transfer/transfer_list.dart';

import '../public.dart';

class WalletsTabCell extends StatelessWidget {
  const WalletsTabCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencySymbolStr =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currencySymbolStr;

    String imgname = "tokens/ETH1.png";
    String token = "ETH";
    String tokenPrice = "≈$currencySymbolStr 16432.59";
    String balance = "12.29382726";
    String assets = "$currencySymbolStr 28372819.00";

    return Expanded(
      child: Container(
        color: ColorUtils.backgroudColor,
        padding: EdgeInsets.symmetric(horizontal: 16.width),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Routers.push(context, TransferListPage());
              },
              child: Container(
                height: 68.width,
                margin: EdgeInsets.only(bottom: 8.width),
                padding: EdgeInsets.symmetric(horizontal: 12.width),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        LoadAssetsImage(imgname,
                            width: 36,
                            height: 36,
                            errorBuilder: (context, error, stackTrace) =>
                                LoadAssetsImage(
                                  "tokens/token_default.png",
                                  width: 36,
                                  height: 36,
                                )),
                        8.rowWidget,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              token,
                              style: TextStyle(
                                fontWeight: FontWeightUtils.medium,
                                fontSize: 16.font,
                                color: ColorUtils.fromHex("#FF000000"),
                              ),
                            ),
                            4.columnWidget,
                            Text(
                              tokenPrice,
                              style: TextStyle(
                                fontWeight: FontWeightUtils.regular,
                                fontSize: 11.font,
                                color: ColorUtils.fromHex("#66000000"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          balance,
                          style: TextStyle(
                            fontWeight: FontWeightUtils.bold,
                            fontSize: 18.font,
                            color: ColorUtils.fromHex("#FF000000"),
                          ),
                        ),
                        4.columnWidget,
                        Text(
                          assets,
                          style: TextStyle(
                            fontWeight: FontWeightUtils.regular,
                            fontSize: 11.font,
                            color: ColorUtils.fromHex("#66000000"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
