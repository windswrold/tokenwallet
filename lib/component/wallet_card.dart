import 'package:cstoken/pages/wallet/wallets/wallets_manager.dart';

import '../public.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({Key? key, required this.wallet}) : super(key: key);

  final TRWallet? wallet;

  @override
  Widget build(BuildContext context) {
    String name = "CSTOKEN";
    if (wallet != null) {
      name = wallet?.walletName ?? "";
      name = name.breakWord();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        Routers.push(context, WalletsManager());
      },
      child: Container(
        width: 120.width,
        height: 32.width,
        padding: EdgeInsets.only(left: 8.width, right: 8.width),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: ColorUtils.blueColor,
        ),
        child: Row(children: [
          LoadAssetsImage(
            "icons/icon_white_wallet.png",
            width: 24,
            height: 24,
          ),
          2.rowWidget,
          Expanded(
              child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              color: ColorUtils.fromHex("#FFFFFFFF"),
              fontSize: 14.font,
              fontWeight: FontWeightUtils.semiBold,
            ),
          ))
        ]),
      ),
    );
  }
}
