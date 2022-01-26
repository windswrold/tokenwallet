import 'package:cstoken/model/wallet/tr_wallet.dart';
import 'package:cstoken/state/wallet_state.dart';
import 'package:flutter/material.dart';

import '../../public.dart';
import 'create/create_tip.dart';
import 'create/create_wallet_page.dart';

class WalletPage extends StatefulWidget {
  WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  void _create() async {
    List<TRWallet> datas = await TRWallet.queryAllWallets();
    if (datas.isEmpty) {
      Routers.push(context, const CreateTip());
      return;
    }
    Routers.push(context, CreateWalletPage());
  }

  void _restore() async {
    List<TRWallet> datas = await TRWallet.queryAllWallets();
    if (datas.isEmpty) {
      Routers.push(context, const CreateTip());
      return;
    }
    // Routers.push(context, CreateWalletPage());
  }

  @override
  Widget build(BuildContext context) {
    TRWallet? wallet =
        Provider.of<CurrentChooseWalletState>(context).currentWallet;
    return wallet != null
        ? CustomPageView(
            title: CustomPageView.getTitle(title: "ssss"),
            child: Container(
              alignment: Alignment.center,
              height: 50,
              color: Colors.red,
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
                      LoadAssetsImage(
                        "bg/biglogo.png",
                        fit: BoxFit.cover,
                        height: 40.width,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16.width),
                        child: Text(
                          'Aggregation of NFT',
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
                        bgc: UIConstant.blueColor,
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
                        border: Border.all(color: UIConstant.blueColor),
                        title: 'choose_restorewallet'.local(),
                        textStyle: TextStyle(
                          fontWeight: FontWeightUtils.medium,
                          fontSize: 16.font,
                          color: UIConstant.blueColor,
                        ),
                        onPressed: _restore,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40.width),
                        child: Text(
                          'Digicenter Wallet',
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
