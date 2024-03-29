import 'package:cstoken/model/tokens/collection_tokens.dart';
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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _kTransferState.init(context);
      if (inProduction == false) {
        _kTransferState.addressEC.text =
            "0x4e268c89495254288b4D1Cb4bc4c010f8C009b25";
      }
    });
  }

  Widget _buildFee() {
    return Container(
      margin: EdgeInsets.only(top: 24.width),
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
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _kTransferState.tapFeeView(context);
            },
            child: Container(
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
                  Consumer<KTransferState>(builder: (_, prover, child) {
                    return Text(
                      prover.feeValue(),
                      style: TextStyle(
                        fontSize: 14.font,
                        fontWeight: FontWeightUtils.medium,
                        color: ColorUtils.fromHex("#FF000000"),
                      ),
                    );
                  }),
                  Row(
                    children: [
                      // Text(
                      //   "≈￥10293.29",
                      //   style: TextStyle(
                      //     fontSize: 12.font,
                      //     color: ColorUtils.fromHex("#99000000"),
                      //   ),
                      // ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String title,
      {bool goContact = false,
      Widget? suffixIcon,
      int maxLine = 1,
      String? hintText,
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
              hintText: hintText,
              fillColor: Colors.white,
              suffixIcon: suffixIcon),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String token = Provider.of<CurrentChooseWalletState>(context, listen: false)
            .chooseTokens()!
            .token ??
        "";
    return ChangeNotifierProvider(
        create: (_) => _kTransferState,
        child: CustomPageView(
          title: CustomPageView.getTitle(
              title: token + " " + "transferetype_transfer".local()),
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
                          hintText: "payments_address".local(),
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
                            hintText: "payments_value".local(),
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
                        child: Consumer<KTransferState>(
                          builder: (context, provider, child) {
                            return Text(
                              provider.paymentAssets,
                              style: TextStyle(
                                fontSize: 12.font,
                                color: ColorUtils.fromHex("#FF7685A2"),
                              ),
                            );
                          },
                        ),
                      ),
                      _buildFee(),
                      _buildTextField(_kTransferState.remarkEC,
                          "transferetype_remark".local(),
                          hintText: "payments_remark".local(), maxLine: 5),
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
