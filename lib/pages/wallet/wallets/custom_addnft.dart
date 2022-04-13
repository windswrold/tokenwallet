import 'package:cstoken/component/chain_listtype.dart';
import 'package:cstoken/model/node/node_model.dart';
import 'package:cstoken/model/tokens/collection_tokens.dart';
import 'package:cstoken/model/wallet/tr_wallet_info.dart';
import 'package:cstoken/net/chain_services.dart';
import 'package:cstoken/net/wallet_services.dart';
import 'package:cstoken/pages/scan/scan.dart';
import 'package:cstoken/utils/custom_toast.dart';

import '../../../public.dart';

class CustomAddNft extends StatefulWidget {
  CustomAddNft({Key? key}) : super(key: key);

  @override
  State<CustomAddNft> createState() => _CustomAddNftState();
}

class _CustomAddNftState extends State<CustomAddNft> {
  final TextEditingController _tokenContractEC = TextEditingController();
  final TextEditingController _tokenNameEC = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initData() async {}

  void _tapNewTokens() async {
    String _contract = _tokenContractEC.text.trim();
    String _name = _tokenNameEC.text.trim();

    if (_contract.isEmpty) {
      HWToast.showText(text: "tokensetting_addnftconadd".local());
      return;
    }
    if (await _contract.checkAddress(KCoinType.ETH) == false) {
      HWToast.showText(text: "input_addressinvalid".local());
      return;
    }
    if (_name.isEmpty) {
      HWToast.showText(text: "tokensetting_addnftconname".local());
      return;
    }
    TRWallet _wallet =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet!;
    List<TRWalletInfo> infos = await TRWalletInfo.queryWalletInfo(
        _wallet.walletID!, KCoinType.ETH.index);
    if (infos.isEmpty) {
      return;
    }
    HWToast.showLoading();
    bool result = await WalletServices.addUserNft(
        _contract, infos.first.walletAaddress!, _name);
    if (result == true) {
      HWToast.showText(text: "wallet_inputok".local());
      Future.delayed(const Duration(seconds: 2))
          .then((value) => {Routers.goBackWithParams(context, {})});
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: CustomPageView.getTitle(
        title: "empaty_addnft".local(),
      ),
      actions: [
        CustomPageView.getScan(() async {
          Map? params = await Routers.push(context, ScanCodePage());
          String result = params?["data"] ?? '';
          _tokenContractEC.text = result;
        }),
      ],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.width, vertical: 20.width),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField.getInputTextField(context,
                        controller: _tokenContractEC,
                        titleText: "tokensetting_addnftcon".local(),
                        padding: EdgeInsets.only(top: 0.width),
                        maxLines: 5,
                        hintText: "tokensetting_addnftconadd".local(),
                        fillColor: ColorUtils.backgroudColor),
                    CustomTextField.getInputTextField(context,
                        controller: _tokenNameEC,
                        titleText: "tokensetting_addnftconname".local(),
                        padding: EdgeInsets.only(top: 20.width),
                        hintText: "tokensetting_addnftconname".local()),
                  ],
                ),
              ),
            ),
            NextButton(
              onPressed: () {
                _tapNewTokens();
              },
              textStyle: TextStyle(
                fontSize: 16.font,
                fontWeight: FontWeightUtils.medium,
                color: Colors.white,
              ),
              bgc: ColorUtils.blueColor,
              title: "walletssetting_modifyok".local(),
            )
          ],
        ),
      ),
    );
  }
}
