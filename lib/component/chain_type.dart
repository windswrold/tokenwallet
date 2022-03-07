import 'package:cstoken/state/create/create_wallet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../public.dart';

class ChooseChainType extends StatelessWidget {
  const ChooseChainType({Key? key, this.padding}) : super(key: key);

  final EdgeInsetsGeometry? padding;

  Widget _childItem(BuildContext context, String text, VoidCallback itemTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Routers.goBack(context);
        itemTap();
      },
      child: Container(
        alignment: Alignment.center,
        height: 54.width,
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: ColorUtils.lineColor, width: 0.5))),
        padding: EdgeInsets.symmetric(horizontal: 16.width),
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeightUtils.medium,
              fontSize: 16.font,
              color: ColorUtils.fromHex("#FF000000")),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String ethchain = KChainType.ETH.getTokenType();
    String btcchain = KChainType.BTC.getTokenType();
    String trxchain = KChainType.TRX.getTokenType();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ShowCustomAlert.showCustomBottomSheet(
            context,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _childItem(context, ethchain, () {
                  Provider.of<CreateWalletProvider>(context, listen: false)
                      .updateChainType(KChainType.ETH);
                }),
                _childItem(context, btcchain, () {
                  Provider.of<CreateWalletProvider>(context, listen: false)
                      .updateChainType(KChainType.BTC);
                }),
                _childItem(context, trxchain, () {
                  Provider.of<CreateWalletProvider>(context, listen: false)
                      .updateChainType(KChainType.TRX);
                }),
              ],
            ),
            230.width,
            "walletssetting_modifycancel".local(),
            btnbgc: Colors.white,
            btnSttyle: TextStyle(
                fontWeight: FontWeightUtils.medium,
                fontSize: 16.font,
                color: ColorUtils.blueColor));
      },
      child: Container(
        padding: padding,
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 0),
              child: Text(
                "importwallet_chaintype".local(),
                style: TextStyle(
                  fontSize: 14.font,
                  fontWeight: FontWeightUtils.medium,
                  color: ColorUtils.fromHex("#99000000"),
                ),
              ),
            ),
            Container(
              height: 44.width,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Expanded(
                    child: Consumer<CreateWalletProvider>(
                      builder: (context, value, child) {
                        return Text(
                          value.chainType.getTokenType(),
                          style: TextStyle(
                            fontSize: 14.font,
                            fontWeight: FontWeightUtils.medium,
                            color: ColorUtils.fromHex("#FF000000"),
                          ),
                        );
                      },
                    ),
                  ),
                  8.rowWidget,
                  LoadAssetsImage(
                    "icons/icon_arrow_right.png",
                    width: 16,
                    height: 16,
                  ),
                ],
              ),
            ),
            Container(
              height: 0.5,
              color: ColorUtils.lineColor,
            ),
          ],
        ),
      ),
    );
  }
}
