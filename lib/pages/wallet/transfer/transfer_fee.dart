import 'package:cstoken/net/wallet_services.dart';
import 'package:cstoken/state/transfer_state.dart';
import 'package:decimal/decimal.dart';

import '../../../public.dart';

class TransfeeView extends StatefulWidget {
  TransfeeView({
    Key? key,
    required this.feeValue,
    required this.feeToken,
    this.gasPrice,
    this.gasLimit,
    required this.complationBack,
    required this.chaintype,
    required this.seleindex,
  }) : super(key: key);
  final String feeValue;
  final String? gasPrice;
  final String? gasLimit;
  final String? feeToken;
  final String chaintype;
  final int seleindex;
  final Function(String feeValue, String gasPrice, String gasLimit,
      bool isCustom, int seleindex) complationBack;

  @override
  State<TransfeeView> createState() => _TransfeeViewState();
}

class _TransfeeViewState extends State<TransfeeView> {
  Map? _feeGas;
  int _seleindex = 1;
  String? _feeValue;
  String? _gasPrice;
  String? _gasLimit;
  bool _isCustom = false;

  TextEditingController _gasLimitEC = TextEditingController();
  TextEditingController _gasPriceEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _seleindex = widget.seleindex;
    _initData();
  }

  @override
  void dispose() {
    _gasLimitEC.removeListener(() {});
    _gasPriceEC.removeListener(() {});

    super.dispose();
  }

  void _initData() async {
    _feeValue = widget.feeValue;
    _gasPrice = widget.gasPrice;
    _gasLimit = widget.gasLimit;
    _gasLimitEC.text = _gasLimit ?? "";
    _gasPriceEC.text = _gasPrice ?? "";
    dynamic result = await WalletServices.getgasPrice(widget.chaintype);
    if (result != null && mounted) {
      setState(() {
        _feeGas = result;
      });
    }

    _gasLimitEC.addListener(() {
      _tapFee(_gasLimitEC.text, _gasPriceEC.text, _seleindex, modifyEC: false);
    });
    _gasPriceEC.addListener(() {
      _tapFee(_gasLimitEC.text, _gasPriceEC.text, _seleindex, modifyEC: false);
    });
  }

  void _tapNext() {
    widget.complationBack(
        _feeValue!, _gasPrice!, _gasLimit!, _isCustom, _seleindex);
    Routers.goBack(context);
  }

  void _tapFee(String newGaslimit, String newGasPrice, int index,
      {bool modifyEC = true}) {
    String fee = TRWallet.configFeeValue(
        cointype: KCoinType.ETH.index,
        beanValue: newGaslimit,
        offsetValue: newGasPrice);
    if (modifyEC == true) {
      _gasLimitEC.text = newGaslimit;
      _gasPriceEC.text = newGasPrice;
      _isCustom = false;
    } else {
      _isCustom = true;
    }

    setState(() {
      _feeValue = fee;
      _gasPrice = newGasPrice;
      _gasLimit = newGaslimit;
      _seleindex = index;
    });
  }

  Widget _buildTextField(TextEditingController controller, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(top: 10.width),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.font,
              color: ColorUtils.fromHex("#99000000"),
            ),
          ),
        ),
        CustomTextField(
          controller: controller,
          style: TextStyle(
            fontSize: 14.font,
            color: ColorUtils.fromHex("#FF000000"),
          ),
          padding: EdgeInsets.only(top: 8.width),
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          decoration: CustomTextField.getBorderLineDecoration(
            context: context,
            focusedBorderColor: ColorUtils.blueColor,
            fillColor: ColorUtils.fromHex("#0A000000"),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomGasData() {
    return Container(
      margin: EdgeInsets.only(top: 16.width, bottom: 16.width),
      child: Column(
        children: [
          _buildCellItem("transferetype_customfee".local(), null, null, 4,
              onTap: (index) {
            setState(() {
              _seleindex = 4;
            });
          }),
          Visibility(
            visible: _seleindex == 4 ? true : false,
            child: Row(
              children: [
                Expanded(
                  child: _buildTextField(_gasPriceEC, "Gas Price（gwei）"),
                ),
                15.rowWidget,
                Expanded(
                  child: _buildTextField(_gasLimitEC, "Gas Limit（gas）"),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(0, 8.width, 0, 0),
            child: Text(
              "trasnfer_errtip".local(),
              style: TextStyle(
                fontSize: 12.font,
                color: ColorUtils.fromHex("#807685A2"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGasData() {
    if (_feeGas == null) {
      return Container();
    }
    Decimal offset = Decimal.fromInt(10).pow(9);
    String fastestgas = _feeGas!["gasFastPrice"];
    fastestgas = (Decimal.parse(fastestgas) / offset).toDecimal().toString();
    String fastgas = _feeGas!["gasNormalPrice"];
    fastgas = (Decimal.parse(fastgas) / offset).toDecimal().toString();
    String average = _feeGas!["gasSlowPrice"];
    average = (Decimal.parse(average) / offset).toDecimal().toString();
    String fastest = "transferetype_fastest".local();
    String fast = "transferetype_fast".local();
    String normal = "transferetype_normal".local();
    String minute = "transferetype_minute".local();

    return Container(
      margin: EdgeInsets.only(top: 7.width),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          _buildCellItem(fastest, fastestgas, "＜ 0.5" + minute, 0,
              onTap: (int index) {
            _tapFee(widget.gasLimit!, fastestgas, index);
          }),
          _buildCellItem(fast, fastgas, "＜ 2.0" + minute, 1,
              onTap: (int index) {
            _tapFee(widget.gasLimit!, fastgas, index);
          }),
          _buildCellItem(normal, average, "＜ 5.0" + minute, 2,
              onTap: (int index) {
            _tapFee(widget.gasLimit!, average, index);
          }),
        ],
      ),
    );
  }

  Widget _buildCellItem(String title, String? value, String? detail, int index,
      {Function(int index)? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (onTap != null) {
          onTap(index);
        }
      },
      child: Container(
        height: 52.width,
        padding: EdgeInsets.symmetric(horizontal: 9.width),
        decoration: BoxDecoration(
          color: _seleindex == index
              ? ColorUtils.fromHex("#26216EFF")
              : Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: _seleindex == index
                        ? ColorUtils.blueColor
                        : ColorUtils.fromHex("#FF000000"),
                    fontSize: 14.font,
                    fontWeight: FontWeightUtils.regular,
                  ),
                ),
                Visibility(
                  visible: value == null ? false : true,
                  child: Text(
                    (value ?? "") + " Gwei",
                    style: TextStyle(
                      color: _seleindex == index
                          ? ColorUtils.fromHex("#99216EFF")
                          : ColorUtils.fromHex("#99000000"),
                      fontSize: 12.font,
                      fontWeight: FontWeightUtils.regular,
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: detail == null ? false : true,
              child: Text(
                detail ?? "",
                style: TextStyle(
                  color: _seleindex == index
                      ? ColorUtils.blueColor
                      : ColorUtils.fromHex("#FF000000"),
                  fontSize: 14.font,
                  fontWeight: FontWeightUtils.regular,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFee() {
    return Container(
      padding: EdgeInsets.only(top: 24.width),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "transferetype_gas".local(),
            style: TextStyle(
              fontSize: 14.font,
              color: ColorUtils.fromHex("#FF000000"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8.width),
            padding: EdgeInsets.only(left: 8.width, right: 8.width),
            height: 48.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (_feeValue ?? "") + " " + widget.feeToken!,
                  style: TextStyle(
                    fontSize: 14.font,
                    fontWeight: FontWeightUtils.medium,
                    color: ColorUtils.fromHex("#FF000000"),
                  ),
                ),
                Row(
                  children: [
                    // Text(
                    //   "≈￥10293.29",
                    //   style: TextStyle(
                    //     fontSize: 12.font,
                    //     color: ColorUtils.fromHex("#99000000"),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
        title: CustomPageView.getTitle(title: "transferetype_gas".local()),
        backgroundColor: ColorUtils.backgroudColor,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.width, 0, 16.width, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFee(),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 8.width, 0, 0),
                      child: Text(
                        "Gas Price ($_gasPrice GWEI) * Gas Limit ($_gasLimit)",
                        style: TextStyle(
                          fontSize: 12.font,
                          color: ColorUtils.fromHex("#807685A2"),
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 24.width, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "transferetype_gassetting".local(),
                              style: TextStyle(
                                fontSize: 14.font,
                                color: ColorUtils.fromHex("#FF000000"),
                              ),
                            ),
                            Text(
                              "transferetype_gastime".local(),
                              style: TextStyle(
                                fontSize: 12.font,
                                color: ColorUtils.fromHex("#FF7685A2"),
                              ),
                            ),
                          ],
                        )),
                    _buildGasData(),
                    _buildCustomGasData(),
                  ],
                ),
              ),
            ),
            NextButton(
                onPressed: _tapNext,
                bgc: ColorUtils.blueColor,
                borderRadius: 12,
                margin: EdgeInsets.fromLTRB(16.width, 0, 16.width, 20.width),
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.font,
                    fontWeight: FontWeightUtils.medium),
                title: "walletssetting_modifyok".local())
          ],
        ));
  }
}
