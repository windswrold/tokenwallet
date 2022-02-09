import 'package:cstoken/net/wallet_services.dart';
import 'package:cstoken/pages/scan/scan.dart';
import 'package:cstoken/state/transfer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../public.dart';

class TransferPayment extends StatefulWidget {
  TransferPayment({Key? key}) : super(key: key);

  @override
  State<TransferPayment> createState() => _TransferPaymentState();
}

class _TransferPaymentState extends State<TransferPayment> {
  KTransferState _kTransferState = KTransferState();
  String _paymentAssets = "--";
  String _tokenprice = "";
  String _gasLimit = '';
  String _gasPrice = '';
  String _feeValue = '';
  bool _isCustomFee = false;

  @override
  void initState() {
    super.initState();

    if (inProduction == false) {
      _kTransferState.addressEC.text =
          "0x4e268c89495254288b4D1Cb4bc4c010f8C009b25";
    }
    _kTransferState.valueEC.addListener(() async {
      final text = _kTransferState.valueEC.text;
    });
    _initData();
  }

  void _initData() async {
    dynamic result = await WalletServices.ethGasStation();
    if (result != null && mounted) {}
  }

  @override
  void dispose() {
    _kTransferState.valueEC.removeListener(() {});
    super.dispose();
  }

  Widget _buildFee() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _kTransferState.tapFeeView(context);
      },
      child: Container(
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
                      LoadAssetsImage(
                        "icons/icon_arrow_right.png",
                        width: 16,
                        height: 16,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String title,
      {bool goContact = false,
      Widget? suffixIcon,
      int maxLine = 1,
      TextInputType keyboardType = TextInputType.text,
      List<TextInputFormatter>? inputFormatters,
      String? titleDetail}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(top: 24.width),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.font,
                  color: ColorUtils.fromHex("#FF000000"),
                ),
              ),
              50.rowWidget,
              Visibility(
                visible: titleDetail == null ? false : true,
                child: Expanded(
                  child: Text(
                    titleDetail ?? "",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 12.font,
                      color: ColorUtils.fromHex("#FF7685A2"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        CustomTextField(
          controller: controller,
          style: TextStyle(
            fontSize: 14.font,
            fontWeight: FontWeightUtils.medium,
            color: ColorUtils.fromHex("#FF000000"),
          ),
          padding: EdgeInsets.only(top: 8.width),
          maxLines: maxLine,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: CustomTextField.getBorderLineDecoration(
              context: context,
              focusedBorderColor: ColorUtils.blueColor,
              fillColor: Colors.white,
              suffixIcon: suffixIcon),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => _kTransferState,
        child: CustomPageView(
          title:
              CustomPageView.getTitle(title: "transferetype_transfer".local()),
          backgroundColor: ColorUtils.backgroudColor,
          actions: [
            CustomPageView.getScan(() async {
              Map? params = await Routers.push(context, ScanCodePage());
              String? result = params?["data"];
              if (result != null) {
                _kTransferState.addressEC.text = result;
              }
            }),
          ],
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.width, 0, 16.width, 24.width),
                  child: Column(
                    children: [
                      _buildTextField(
                          _kTransferState.addressEC, "transferetype_to".local(),
                          suffixIcon: CustomPageView.getCustomIcon(
                              "icons/icon_addcontact.png", () {
                            _kTransferState.goContract(context);
                          })),
                      Consumer<CurrentChooseWalletState>(
                          builder: (_, provider, child) {
                        return _buildTextField(_kTransferState.valueEC,
                            "transferetype_value".local(),
                            titleDetail: "paymentsheep_canuse".local() +
                                provider.chooseTokens()!.balanceString,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              CustomTextField.decimalInputFormatter(18),
                            ],
                            suffixIcon: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                _kTransferState.valueEC.text =
                                    provider.chooseTokens()!.balanceString;
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 30.width,
                                child: Text(
                                  "transferetype_all".local(),
                                  style: TextStyle(
                                    fontSize: 12.font,
                                    fontWeight: FontWeightUtils.medium,
                                    color: ColorUtils.blueColor,
                                  ),
                                ),
                              ),
                            ));
                      }),
                      Container(
                        padding: EdgeInsets.only(top: 4.width),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _paymentAssets,
                          style: TextStyle(
                            fontSize: 12.font,
                            color: ColorUtils.fromHex("#FF7685A2"),
                          ),
                        ),
                      ),
                      _buildFee(),
                      _buildTextField(_kTransferState.remarkEC,
                          "transferetype_remark".local(),
                          maxLine: 5),
                    ],
                  ),
                ),
              ),
              NextButton(
                  onPressed: () {
                    _kTransferState.tapTransfer(context);
                  },
                  bgc: ColorUtils.blueColor,
                  borderRadius: 12,
                  margin: EdgeInsets.fromLTRB(16.width, 0, 16.width, 20.width),
                  textStyle: TextStyle(
                    fontSize: 16.font,
                    fontWeight: FontWeightUtils.medium,
                    color: Colors.white,
                  ),
                  title: "transferetype_goon".local())
            ],
          ),
        ));
  }
}
