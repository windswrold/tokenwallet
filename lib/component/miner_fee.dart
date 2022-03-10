import 'package:cstoken/state/transfer_state.dart';

import '../public.dart';

class MinerFee extends StatelessWidget {
  const MinerFee({Key? key}) : super(key: key);

  Widget _ethFee(KTransferState provider, {VoidCallback? onTap}) {
    return Container(
      margin: EdgeInsets.only(top: 24.width),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "transferetype_gas".local(),
            style: TextStyle(
              fontSize: 14.font,
              color: ColorUtils.fromHex("#FF000000"),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              margin: EdgeInsets.only(top: 8.width),
              padding: EdgeInsets.only(left: 8.width, right: 8.width),
              height: 48.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    provider.feeValue(),
                    style: TextStyle(
                      fontSize: 14.font,
                      fontWeight: FontWeightUtils.medium,
                      color: ColorUtils.fromHex("#FF000000"),
                    ),
                  ),
                  Row(
                    children: [
                      LoadAssetsImage(
                        "icons/icon_arrow_right.png",
                        width: 16,
                        height: 16,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _btcFee(BuildContext context, KTransferState provider,
      {VoidCallback? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 24.width),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "transferetype_gas".local(),
              style: TextStyle(
                fontSize: 14.font,
                color: ColorUtils.fromHex("#FF000000"),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.width),
              padding: EdgeInsets.only(
                  left: 8.width, right: 8.width, bottom: 8.width),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 45.width,
                    child: Row(
                      children: [
                        Text(
                          "payment_slow".local(),
                          style: TextStyle(
                              color: Color(0xFF161D2D), fontSize: 16.font),
                        ),
                        6.rowWidget,
                        Expanded(
                          child: SliderTheme(
                            //自定义风格
                            data: SliderTheme.of(context).copyWith(
                                activeTrackColor: ColorUtils.blueColor,
                                inactiveTrackColor: Color(0xFFF6F8F9),
                                thumbColor: Color(0xFFFFFFFF),
                                overlayColor: Color(0xFFFFFFFF),
                                overlayShape: RoundSliderOverlayShape(
                                  overlayRadius: 6,
                                ),
                                thumbShape: RoundSliderThumbShape(
                                  disabledThumbRadius: 6,
                                  enabledThumbRadius: 6,
                                ),
                                trackHeight: 6),
                            child: Slider(
                                value: double.parse(provider.feeOffset),
                                onChanged: (v) {
                                  provider.sliderChange(v);
                                },
                                max: provider.sliderMax,
                                min: provider.sliderMin),
                          ),
                        ),
                        Text(
                          "payment_high".local(),
                          style: TextStyle(
                              color: Color(0xFF161D2D), fontSize: 16.font),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    provider.feeOffset + " sat/b",
                    style: TextStyle(
                      fontSize: 14.font,
                      fontWeight: FontWeightUtils.medium,
                      color: ColorUtils.fromHex("#FF000000"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KTransferState>(builder: (_, provider, child) {
      int coinType = provider.walletInfo?.coinType ?? 0;
      return coinType == KCoinType.BTC.index
          ? _btcFee(context, provider)
          : coinType == KCoinType.TRX.index
              ? Container()
              : _ethFee(provider, onTap: () {
                  provider.tapFeeView(context);
                });
    });
  }
}
