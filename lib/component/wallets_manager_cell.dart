import 'package:cstoken/const/constant.dart';
import 'package:cstoken/model/wallet/tr_wallet.dart';
import 'package:cstoken/state/wallet_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';

import '../public.dart';

class WalletsManagetCell extends StatelessWidget {
  const WalletsManagetCell({Key? key, required this.walet}) : super(key: key);
  final TRWallet walet;

  @override
  Widget build(BuildContext context) {
    bool isChoose = walet.isChoose == true ? true : false;
    String address = "";
    String chainType = "";
    if (walet.chainType == KChainType.HD.index) {
      chainType = "wallets_manager_multichain".local();
    } else if (walet.chainType == KChainType.ETH.index) {
      chainType = "importwallet_ethchaintype".local();
      address = walet.walletsInfo?.first.walletAaddress ?? "";
      address = address.contractAddress();
    }
    bool backupState =
        walet.accountState == KAccountState.init.index ? true : false;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .updateChoose(walet);
      },
      child: Container(
        margin:
            EdgeInsets.only(left: 16.width, bottom: 8.width, right: 16.width),
        child: SwipeActionCell(
          key: ObjectKey(walet),
          trailingActions: <SwipeAction>[
            SwipeAction(
                color: Colors.transparent,
                content: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    color: Colors.blue,
                  ),
                  child: Text('wallets_manager_setting'.local(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.font,
                          fontWeight: FontWeightUtils.medium)),
                ),
                onTap: (handler) async {}),
          ],
          child: Container(
            alignment: Alignment.center,
            height: 68.width,
            padding: EdgeInsets.symmetric(horizontal: 12.width),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          walet.walletName ?? "ssss",
                          style: TextStyle(
                            fontSize: 16.width,
                            fontWeight: FontWeightUtils.medium,
                            color: ColorUtils.fromHex("#FF000000"),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.width),
                          padding:
                              EdgeInsets.only(left: 4.width, right: 4.width),
                          height: 20.width,
                          decoration: BoxDecoration(
                              color: ColorUtils.blueBGColor,
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            chainType,
                            style: TextStyle(
                              fontSize: 12.width,
                              fontWeight: FontWeightUtils.medium,
                              color: ColorUtils.blueColor,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: backupState,
                          child: Container(
                            margin: EdgeInsets.only(left: 10.width),
                            padding:
                                EdgeInsets.only(left: 4.width, right: 4.width),
                            height: 20.width,
                            decoration: BoxDecoration(
                                color: ColorUtils.fromHex("#FFFF233E")
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(
                              "wallets_manager_backupstate".local(),
                              style: TextStyle(
                                fontSize: 12.width,
                                fontWeight: FontWeightUtils.medium,
                                color: ColorUtils.fromHex("#FFFF233E"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: address.isNotEmpty,
                      child: Text(
                        address,
                        style: TextStyle(
                          fontSize: 12.width,
                          fontWeight: FontWeightUtils.regular,
                          color:
                              ColorUtils.fromHex("#FF000000").withOpacity(0.4),
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: isChoose,
                  child: LoadAssetsImage(
                    "icons/wallets_choose.png",
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
