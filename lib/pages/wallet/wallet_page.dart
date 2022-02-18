import 'package:cstoken/component/backup_warningtip.dart';
import 'package:cstoken/component/custom_refresher.dart';
import 'package:cstoken/component/top_search_widget.dart';
import 'package:cstoken/component/wallet_card.dart';
import 'package:cstoken/component/wallet_swipe.dart';
import 'package:cstoken/component/wallets_tab_cell.dart';
import 'package:cstoken/model/wallet/tr_wallet.dart';
import 'package:cstoken/pages/scan/scan.dart';
import 'package:cstoken/pages/wallet/wallets/search_addtoken.dart';
import 'package:cstoken/pages/wallet/wallets/wallets_manager.dart';
import 'package:cstoken/state/wallet_state.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../public.dart';
import 'create/create_tip.dart';
import 'create/create_wallet_page.dart';
import 'restore/restore_wallet_page.dart';

class WalletPage extends StatefulWidget {
  WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  RefreshController _refreshController = RefreshController();
  CustomPopupMenuController _controller = CustomPopupMenuController();
  bool _showBackupWaing = true;

  @override
  void initState() {
    super.initState();
  }

  void _create() async {
    List<TRWallet> datas = await TRWallet.queryAllWallets();
    if (datas.isEmpty) {
      Routers.push(context, const CreateTip(type: KCreateType.create));
      return;
    }
    Routers.push(context, CreateWalletPage());
  }

  void _restore() async {
    List<TRWallet> datas = await TRWallet.queryAllWallets();
    if (datas.isEmpty) {
      Routers.push(context, const CreateTip(type: KCreateType.restore));
      return;
    }
    Routers.push(context, RestoreWalletPage());
  }

  void _tapAssets() {
    Routers.push(context, SearchAddToken());
  }

  Widget _topView(TRWallet wallet) {
    final name = wallet.walletName;
    return Container(
      height: 44,
      alignment: Alignment.center,
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.only(left: 16.width),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            WalletCard(wallet: wallet),
          ],
        ),
      ),
    );
  }

  List<Widget> _getMenuItem() {
    Widget _getItem(KCoinType? e) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _controller.hideMenu();
          Provider.of<CurrentChooseWalletState>(context, listen: false)
              .tapHelper(context, e);
        },
        child: Container(
          height: 45.width,
          padding: EdgeInsets.symmetric(horizontal: 16.width),
          alignment: Alignment.centerLeft,
          child: Text(
            e == null ? "walletmanager_asset_all".local() : e.coinTypeString(),
            style: TextStyle(
                color: Colors.black,
                fontSize: 14.font,
                fontWeight: FontWeightUtils.medium),
          ),
        ),
      );
    }

    List<Widget> datas = KCoinType.values
        .map(
          (e) => _getItem(e),
        )
        .toList();
    datas.insert(0, _getItem(null));
    return datas;
  }

  Widget _helperView() {
    return Container(
      height: 45.width,
      color: ColorUtils.backgroudColor,
      padding: EdgeInsets.only(left: 16.width, right: 16.width),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomPopupMenu(
            menuBuilder: () => ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: Colors.white,
                child: IntrinsicWidth(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _getMenuItem()),
                ),
              ),
            ),
            pressType: PressType.singleClick,
            verticalMargin: -10,
            controller: _controller,
            showArrow: false,
            child: Row(
              children: [
                Consumer<CurrentChooseWalletState>(
                    builder: (_, provider, child) {
                  return Text(
                    provider.chooseChain,
                    style: TextStyle(
                      fontWeight: FontWeightUtils.regular,
                      fontSize: 16.font,
                      color: ColorUtils.fromHex("#FF000000"),
                    ),
                  );
                }),
                4.rowWidget,
                LoadAssetsImage(
                  "icons/icon_arrow_down.png",
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _tapAssets,
            child: Container(
              width: 45,
              height: 45,
              child: Center(
                child: LoadAssetsImage(
                  "icons/icon_asset_add.png",
                  width: 16,
                  height: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context);
    TRWallet? wallet =
        Provider.of<CurrentChooseWalletState>(context).currentWallet;
    return wallet != null
        ? CustomPageView(
            hiddenAppBar: true,
            hiddenLeading: true,
            backgroundColor: ColorUtils.fromHex("#FFFFFCFA"),
            child: Column(
              children: [
                _topView(wallet),
                WalletSwipe(),
                _helperView(),
                Expanded(
                  child: CustomRefresher(
                      onRefresh: () {
                        Provider.of<CurrentChooseWalletState>(context,
                                listen: false)
                            .requestAssets();
                        Future.delayed(Duration(seconds: 3)).then((value) => {
                              _refreshController.loadComplete(),
                              _refreshController.refreshCompleted(),
                            });
                      },
                      enableFooter: false,
                      child: WalletsTabList(),
                      refreshController: _refreshController),
                ),
                Visibility(
                  visible: _showBackupWaing == true
                      ? (wallet.accountState == KAccountState.init.index)
                      : false,
                  child: BackupWarningTip(
                    onTap: () {
                      Provider.of<CurrentChooseWalletState>(context,
                              listen: false)
                          .backupWallet(context, wallet: wallet);
                    },
                    tapClose: () {
                      setState(() {
                        setState(() {
                          _showBackupWaing = false;
                        });
                      });
                    },
                  ),
                ),
              ],
            ))
        : CustomPageView(
            hiddenAppBar: true,
            hiddenLeading: true,
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Positioned(
                  top: 170.width,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Consensus",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 48.font,
                            fontWeight: FontWeightUtils.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16.width),
                        child: Text(
                          SLOGAN,
                          style: TextStyle(
                            fontWeight: FontWeightUtils.medium,
                            fontSize: 18.font,
                            color: const Color(0xFF7685A2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20.width,
                  child: Column(
                    children: [
                      NextButton(
                        margin: EdgeInsets.only(top: 16.width),
                        height: 48.width,
                        width: 240.width,
                        bgc: ColorUtils.blueColor,
                        title: 'choose_createwallet'.local(),
                        textStyle: TextStyle(
                          fontWeight: FontWeightUtils.medium,
                          fontSize: 16.font,
                          color: Colors.white,
                        ),
                        onPressed: _create,
                      ),
                      NextButton(
                        margin: EdgeInsets.only(top: 16.width),
                        height: 48.width,
                        width: 240.width,
                        border: Border.all(color: ColorUtils.blueColor),
                        title: 'choose_restorewallet'.local(),
                        textStyle: TextStyle(
                          fontWeight: FontWeightUtils.medium,
                          fontSize: 16.font,
                          color: ColorUtils.blueColor,
                        ),
                        onPressed: _restore,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40.width),
                        child: Text(
                          'Consensus  Wallet',
                          style: TextStyle(
                            fontWeight: FontWeightUtils.regular,
                            fontSize: 14.font,
                            color: const Color(0x66000000),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }
}
