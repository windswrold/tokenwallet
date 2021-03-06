import 'package:cstoken/component/wallets_manager_cell.dart';
import 'package:cstoken/model/wallet/tr_wallet.dart';
import 'package:cstoken/pages/wallet/create/create_tip.dart';
import 'package:cstoken/pages/wallet/create/create_wallet_page.dart';
import 'package:cstoken/pages/wallet/import/import_wallets.dart';
import 'package:cstoken/pages/wallet/wallets/wallets_setting.dart';
import 'package:flutter/material.dart';

import '../../../public.dart';

class WalletsManager extends StatefulWidget {
  WalletsManager({Key? key}) : super(key: key);

  @override
  State<WalletsManager> createState() => _WalletsManagerState();
}

class _WalletsManagerState extends State<WalletsManager> {
  List<TRWallet> _datas = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    List<TRWallet> caches = await TRWallet.queryAllWallets();
    if (mounted) {
      setState(() {
        _datas = caches;
      });
    }
  }

  void _create() async {
    List<TRWallet> datas = await TRWallet.queryAllWallets();
    if (datas.isEmpty) {
      Routers.push(context, const CreateTip(type: KCreateType.create));
      return;
    }
    Routers.push(context, CreateWalletPage());
  }

  void _imports() async {
    List<TRWallet> datas = await TRWallet.queryAllWallets();
    if (datas.isEmpty) {
      Routers.push(context, const CreateTip(type: KCreateType.import));
      return;
    }
    Routers.push(context, ImportsWallet());
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      backgroundColor: ColorUtils.backgroudColor,
      title: CustomPageView.getTitle(title: "walletmanager_title".local()),
      child: Container(
        child: Column(
          children: [
            // Container(
            //   height: 64.width,
            //   color: ColorUtils.lineColor,
            // ),
            Expanded(
              child: ListView.builder(
                itemCount: _datas.length,
                itemBuilder: (BuildContext context, int index) {
                  TRWallet walet = _datas[index];
                  return WalletsManagetCell(
                    walet: walet,
                    cellOnTap: (TRWallet walet) async {
                      await Provider.of<CurrentChooseWalletState>(context,
                              listen: false)
                          .updateChoose(context, wallet: walet);
                      _initData();
                    },
                    swipeAction: (TRWallet walet) async {
                      await Provider.of<CurrentChooseWalletState>(context,
                              listen: false)
                          .updateChoose(context, wallet: walet);
                      Routers.push(context, WalletsSetting(wallet: walet))
                          .then((value) => {
                                _initData(),
                              });
                      _initData();
                    },
                  );
                },
              ),
            ),
            Container(
              height: 64.width,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0.0, -5.0),
                      blurRadius: 5.0,
                      spreadRadius: 1.0),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.width),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NextButton(
                      onPressed: _create,
                      height: 44,
                      width: 160,
                      bgc: ColorUtils.blueColor,
                      borderRadius: 12,
                      textStyle: TextStyle(
                        fontSize: 16.font,
                        fontWeight: FontWeightUtils.medium,
                        color: Colors.white,
                      ),
                      title: "wallets_manager_createnew".local()),
                  NextButton(
                      onPressed: _imports,
                      height: 44,
                      width: 160,
                      borderRadius: 12,
                      textStyle: TextStyle(
                        color: ColorUtils.blueColor,
                        fontWeight: FontWeightUtils.medium,
                        fontSize: 16.font,
                      ),
                      bgc: ColorUtils.blueBGColor,
                      title: "wallets_manager_importnew".local()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
