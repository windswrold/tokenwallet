import 'package:cstoken/model/tr_wallet.dart';
import 'package:cstoken/state/wallet_state.dart';
import 'package:flutter/material.dart';

import '../../public.dart';

class WalletPage extends StatefulWidget {
  WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  void _create() {}

  void _restore() {}

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
            hiddenScrollView: true,
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
                        bgc: const Color(0xFF0060FF),
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
                        border: Border.all(color: const Color(0xFF0060FF)),
                        title: 'choose_restorewallet'.local(),
                        textStyle: TextStyle(
                          fontWeight: FontWeightUtils.medium,
                          fontSize: 16.font,
                          color: const Color(0xFF0060FF),
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
