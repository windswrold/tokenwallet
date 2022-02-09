import 'package:cstoken/net/wallet_services.dart';
import 'package:cstoken/state/transfer_state.dart';

import '../../../public.dart';

class TransfeeView extends StatefulWidget {
  TransfeeView({Key? key}) : super(key: key);

  @override
  State<TransfeeView> createState() => _TransfeeViewState();
}

class _TransfeeViewState extends State<TransfeeView> {
  Map? _feeGas;
  int _seleindex = 1;

  TextEditingController _gasLimitEC = TextEditingController();
  TextEditingController _gasPriceEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    dynamic result = await WalletServices.ethGasStation();
    if (result != null && mounted) {
      setState(() {
        _feeGas = result;
      });
    }
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
        ],
      ),
    );
  }

  Widget _buildGasData() {
    if (_feeGas == null) {
      return Container();
    }
    String fastestgas = _feeGas!["fastestgas"];
    String fastgas = _feeGas!["fastgas"];
    String average = _feeGas!["average"];
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
            setState(() {
              _seleindex = 0;
            });
          }),
          _buildCellItem(fast, fastgas, "＜ 2.0" + minute, 1,
              onTap: (int index) {
            setState(() {
              _seleindex = 1;
            });
          }),
          _buildCellItem(normal, average, "＜ 5.0" + minute, 2,
              onTap: (int index) {
            setState(() {
              _seleindex = 2;
            });
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
                  "0.002234 ETH",
                  style: TextStyle(
                    fontSize: 14.font,
                    fontWeight: FontWeightUtils.medium,
                    color: ColorUtils.fromHex("#FF000000"),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "≈￥10293.29",
                      style: TextStyle(
                        fontSize: 12.font,
                        color: ColorUtils.fromHex("#99000000"),
                      ),
                    ),
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
                        "Gas Price (124.00 GWEI) * Gas Limit (21000)",
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
                onPressed: () {},
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
