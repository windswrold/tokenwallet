import '../../../public.dart';

class WalletsSetting extends StatefulWidget {
  WalletsSetting({Key? key, required this.wallet}) : super(key: key);
  final TRWallet wallet;

  @override
  State<WalletsSetting> createState() => _WalletsSettingState();
}

class _WalletsSettingState extends State<WalletsSetting> {
  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: CustomPageView.getTitle(
        title: "wallets_manager_setting".local(),
      ),
      backgroundColor: ColorUtils.backgroudColor,
      child: Container(
        padding: EdgeInsets.only(top: 8.width, bottom: 20.width),
        child: Column(
          children: [
            Expanded(
                child: Container(
              color: Colors.blue,
            )),
            NextButton(
                onPressed: () {
                  Provider.of<CurrentChooseWalletState>(context, listen: false)
                      .deleteWallet(context, wallet: widget.wallet);
                },
                borderRadius: 8,
                margin: EdgeInsets.only(
                  left: 16.width,
                  right: 16.width,
                ),
                bgc: ColorUtils.fromHex("#1AFF233E"),
                textStyle: TextStyle(
                  color: ColorUtils.fromHex("#FFFF233E"),
                  fontSize: 16.font,
                  fontWeight: FontWeightUtils.medium,
                ),
                title: "walletssetting_delwallet".local())
          ],
        ),
      ),
    );
  }
}
