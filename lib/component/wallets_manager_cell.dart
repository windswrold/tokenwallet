import 'package:cstoken/model/wallet/tr_wallet.dart';

import '../public.dart';

class WalletsManagetCell extends StatelessWidget {
  const WalletsManagetCell({Key? key, required this.walet}) : super(key: key);
  final TRWallet walet;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68.width,
      color: Colors.white,
      child: Row(
        children: [
          Text(walet.walletName ?? "ssss"),
          5.rowWidget,
          Text(walet.chainType.toString()),
          5.rowWidget,
          Text(walet.accountState.toString()),
        ],
      ),
    );
    ;
  }
}
