import 'package:cstoken/component/chain_listtype.dart';
import 'package:cstoken/model/node/node_model.dart';
import 'package:cstoken/model/tokens/collection_tokens.dart';
import 'package:cstoken/net/chain_services.dart';
import 'package:cstoken/utils/custom_toast.dart';

import '../../../public.dart';

class CustomAddTokens extends StatefulWidget {
  CustomAddTokens({Key? key}) : super(key: key);

  @override
  State<CustomAddTokens> createState() => _CustomAddTokensState();
}

class _CustomAddTokensState extends State<CustomAddTokens> {
  final TextEditingController _tokenContractEC = TextEditingController();
  final TextEditingController _tokenSymbolEC = TextEditingController();
  final TextEditingController _tokenDeciimalEC = TextEditingController();

  KCoinType? _chooseType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tokenContractEC.addListener(() {
      _initData();
    });
  }

  @override
  void dispose() {
    _tokenContractEC.removeListener(() {});
    super.dispose();
  }

  void _initData() async {
    if (_chooseType == null) {
      return;
    }
    String _contract = _tokenContractEC.text.trim();
    if (_contract.isEmpty) {
      return;
    }
    if (_contract.checkAddress(KCoinType.ETH) == false) {
      _tokenSymbolEC.clear();
      _tokenDeciimalEC.clear();
      return;
    }
    NodeModel node = NodeModel.queryNodeByChainType(_chooseType!.index);
    Map? result = await ChainServices.requestTokenInfo(
        url: node.content!, contract: _contract);
    if (result == null) {
      _tokenSymbolEC.clear();
      _tokenDeciimalEC.clear();
      return;
    }
    setState(() {
      _tokenSymbolEC.text = result["symbol"];
      _tokenDeciimalEC.text = result["decimal"].toString();
    });
  }

  void _tapNewTokens() async {
    String _contract = _tokenContractEC.text.trim();
    String _symbol = _tokenSymbolEC.text.trim();
    String _decimal = _tokenDeciimalEC.text.trim();
    if (_chooseType == null) {
      HWToast.showText(text: "customtokens_pleasechaintype".local());
      return;
    }
    if (_contract.isEmpty) {
      HWToast.showText(text: "customtokens_pleasetokencontract".local());
      return;
    }
    if (_contract.checkAddress(KCoinType.ETH) == false) {
      HWToast.showText(text: "input_addressinvalid".local());
      return;
    }
    if (_symbol.isEmpty) {
      HWToast.showText(text: "customtokens_pleasetokendsymbol".local());
      return;
    }
    if (_decimal.isEmpty) {
      HWToast.showText(text: "customtokens_decimalempty".local());
      return;
    }

    NodeModel node = NodeModel.queryNodeByChainType(_chooseType!.index);
    TRWallet wallet =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet!;
    MCollectionTokens.newTokens(
        walletID: wallet.walletID!,
        coinType: _chooseType!.index,
        contract: _contract,
        token: _symbol,
        decimal: int.parse(_decimal));
    HWToast.showText(text: "wallet_inputok".local());
    Future.delayed(const Duration(seconds: 2))
        .then((value) => {Routers.goBackWithParams(context, {})});
  }

  void _onTapChain() {
    Provider.of<CurrentChooseWalletState>(context, listen: false)
        .onTapChain(context, (p0) {
      setState(() {
        _chooseType = p0;
      });
      _initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: CustomPageView.getTitle(
        title: "empaty_addtoken".local(),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.width, vertical: 20.width),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _onTapChain,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              width: 0.5,
                              color: ColorUtils.lineColor,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 0),
                              child: Text(
                                "customtokens_chaintype".local(),
                                style: TextStyle(
                                  fontSize: 14.font,
                                  fontWeight: FontWeightUtils.medium,
                                  color: ColorUtils.fromHex("#99000000"),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _chooseType == null
                                      ? Text(
                                          "customtokens_pleasechaintype"
                                              .local(),
                                          style: TextStyle(
                                            fontSize: 14.font,
                                            fontWeight: FontWeightUtils.regular,
                                            color:
                                                ColorUtils.fromHex("#66000000"),
                                          ),
                                        )
                                      : Row(
                                          children: [
                                            LoadAssetsImage(
                                              "tokens/${_chooseType!.coinTypeString()}.png",
                                              width: 24,
                                              height: 24,
                                            ),
                                            8.rowWidget,
                                            Text(
                                              _chooseType!.coinTypeString(),
                                              style: TextStyle(
                                                color: ColorUtils.fromHex(
                                                    "#FF000000"),
                                                fontSize: 14.font,
                                                fontWeight:
                                                    FontWeightUtils.medium,
                                              ),
                                            ),
                                          ],
                                        ),
                                  LoadAssetsImage(
                                    "icons/icon_arrow_right.png",
                                    width: 16,
                                    height: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomTextField.getInputTextField(context,
                        controller: _tokenContractEC,
                        titleText: "customtokens_tokencontract".local(),
                        padding: EdgeInsets.only(top: 20.width),
                        hintText: "customtokens_pleasetokencontract".local()),
                    CustomTextField.getInputTextField(context,
                        controller: _tokenSymbolEC,
                        titleText: "customtokens_tokendsymbol".local(),
                        padding: EdgeInsets.only(top: 20.width),
                        hintText: "customtokens_pleasetokendsymbol".local()),
                    CustomTextField.getInputTextField(
                      context,
                      titleText: "customtokens_tokendecimal".local(),
                      enabled: false,
                      controller: _tokenDeciimalEC,
                      padding: EdgeInsets.only(top: 20.width),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                NextButton(
                    onPressed: () {
                      Routers.goBack(context);
                    },
                    bgc: Colors.transparent,
                    width: 150.width,
                    border: Border.all(
                      color: ColorUtils.lineColor,
                      width: 0.5,
                    ),
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeightUtils.regular,
                      fontSize: 16.font,
                    ),
                    title: "walletssetting_modifycancel".local()),
                20.rowWidget,
                NextButton(
                    onPressed: () {
                      _tapNewTokens();
                    },
                    width: 150.width,
                    textStyle: TextStyle(
                      fontSize: 16.font,
                      fontWeight: FontWeightUtils.medium,
                      color: Colors.white,
                    ),
                    bgc: ColorUtils.blueColor,
                    title: "minepage_save".local())
              ],
            ),
          ],
        ),
      ),
    );
  }
}
