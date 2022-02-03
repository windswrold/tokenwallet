import 'package:cstoken/pages/wallet/wallets/wallets_modifypwd.dart';

import '../../../public.dart';

class WalletsSetting extends StatefulWidget {
  WalletsSetting({Key? key, required this.wallet}) : super(key: key);
  final TRWallet wallet;

  @override
  State<WalletsSetting> createState() => _WalletsSettingState();
}

class _WalletsSettingState extends State<WalletsSetting> {
  List<Widget> _children = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData();
  }

  void _initData() {
    String? walletName = widget.wallet.walletName;
    String chainType = widget.wallet.getChainType();
    _children.add(_buildCell(
        leftTitle: "walletssetting_name".local(), content: walletName));
    _children.add(_buildCell(
        leftTitle: "walletssetting_chaintype".local(), content: chainType));
    _children.add(8.columnWidget);
    _children.add(_buildCell(
        leftTitle: "walletssetting_modifypwd".local(),
        showArrowIcon: true,
        onTap: () {
          Routers.push(
              context,
              WalletModifyPwd(
                wallet: widget.wallet,
              ));
        }));
    _children.add(_buildCell(
        leftTitle: "walletssetting_exportprv".local(),
        showArrowIcon: true,
        onTap: () {
          Provider.of<CurrentChooseWalletState>(context, listen: false)
              .exportPrv(context, wallet: widget.wallet);
        }));
    if (widget.wallet.leadType != KLeadType.Prvkey.index) {
      _children.add(_buildCell(
          leftTitle: "walletssetting_backupwallet".local(),
          showArrowIcon: true,
          onTap: () {
            Provider.of<CurrentChooseWalletState>(context, listen: false)
                .backupWallet(context, wallet: widget.wallet);
          }));
    }
  }

  void _delWallets() {
    Provider.of<CurrentChooseWalletState>(context, listen: false)
        .deleteWallet(context, wallet: widget.wallet);
  }

  Widget _buildCell(
      {required String leftTitle,
      String? content,
      bool showArrowIcon = false,
      VoidCallback? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 56.width,
        padding: EdgeInsets.symmetric(horizontal: 16.width),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: ColorUtils.lineColor,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              leftTitle,
              style: TextStyle(
                  color: ColorUtils.fromHex("#FF000000"),
                  fontWeight: FontWeightUtils.regular,
                  fontSize: 16.font),
            ),
            Row(
              children: [
                Text(
                  content ?? "",
                  style: TextStyle(
                      color: ColorUtils.fromHex("#66000000"),
                      fontWeight: FontWeightUtils.regular,
                      fontSize: 16.font),
                ),
                Visibility(
                  visible: showArrowIcon,
                  child: LoadAssetsImage("icons/icon_arrow_right.png",
                      width: 16, height: 16),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

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
                child: Column(
              children: _children,
            )),
            NextButton(
                onPressed: () {
                  _delWallets();
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
