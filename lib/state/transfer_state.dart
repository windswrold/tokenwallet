import 'package:cstoken/model/tokens/collection_tokens.dart';
import 'package:cstoken/model/wallet/tr_wallet_info.dart';
import 'package:cstoken/pages/mine/mine_contacts.dart';
import 'package:cstoken/pages/wallet/transfer/payment_sheet_page.dart';
import 'package:cstoken/pages/wallet/transfer/transfer_fee.dart';
import 'package:cstoken/utils/custom_toast.dart';

import '../public.dart';

class KTransferState with ChangeNotifier {
  TextEditingController _addressEC = TextEditingController();
  TextEditingController _valueEC = TextEditingController();
  TextEditingController _remarkEC = TextEditingController();

  TextEditingController get addressEC => _addressEC;
  TextEditingController get valueEC => _valueEC;
  TextEditingController get remarkEC => _remarkEC;

  void goContract(BuildContext context) async {
    Map result = await Routers.push(context, MineContacts(type: 0));
    if (result != null) {
      final text = result["text"] ?? "";
      _addressEC.text = text;
    }
  }

  void tapBalanceAll(BuildContext context) {
    LogUtil.v("tapBalanceAll");
  }

  void tapFeeView(BuildContext context) {
    LogUtil.v("tapFeeView");
    Routers.push(context, TransfeeView());
  }

  void tapTransfer(BuildContext context,
      {String? gasPrice,
      String? gasLimit,
      String? feeValue,
      bool? isCustomfee}) async {
    LogUtil.v(
        "popupInfo gasPrice $gasPrice gasLimit $gasLimit feeValue $feeValue");
    FocusScope.of(context).requestFocus(FocusNode());
    TRWalletInfo walletInfo =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .walletinfo!;
    TRWallet _wallet =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet!;
    MCollectionTokens tokens =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .chooseTokens()!;
    bool isToken = tokens.isToken;
    int decimals = tokens.decimals ?? 0;
    String from = walletInfo.walletAaddress!;
    String to = _addressEC.text.trim();
    String amount = _valueEC.text.trim();
    String remark = _remarkEC.text.trim();
    bool? isValid = false;
    int coinType = walletInfo.coinType!;
    String feeToken = "ETH";
    isValid = to.checkAddress(coinType.geCoinType());
    if (isValid == false) {
      HWToast.showText(text: "input_addressinvalid".local());
      return;
    }
    if (amount.isEmpty) {
      HWToast.showText(text: "input_paymentvalue".local());
      return;
    }
    if (feeValue == null || feeValue.isEmpty == true) {
      feeValue = TRWallet.configFeeValue(
          cointype: coinType, beanValue: gasLimit, offsetValue: gasPrice);
    } else {
      feeValue = feeValue
          .trim()
          .replaceAll("ETH", "")
          .replaceAll(tokens.token!, "")
          .replaceAll(" ", "");
    }
    if (double.parse(feeValue) == 0) {
      HWToast.showText(text: "payment_highfee".local());
      return;
    }
    BigInt amountBig = amount.tokenInt(decimals);
    BigInt balanceBig = tokens.balanceString.tokenInt(decimals);
    BigInt feeBig = feeValue.tokenInt(decimals);
    if (amountBig > balanceBig) {
      HWToast.showText(text: "payment_valueshouldlessbal".local());
      return;
    }

    if (isToken == true) {
      MCollectionTokens? mainToken;
      // BigInt mainTokenBig = mainToken.balanceString.tokenInt(18);
      // if (feeBig > mainTokenBig) {
      //   HWToast.showText(text: "paymenttip_ethnotenough".local());
      //   return;
      // }
    } else {
      if (balanceBig == amountBig) {
        amountBig = balanceBig - feeBig;
      }
      if (feeBig + amountBig > balanceBig) {
        HWToast.showText(text: "paymenttip_ethnotenough".local());
        return;
      }
    }
    if (amountBig.compareTo(BigInt.zero) <= 0) {
      HWToast.showText(text: "input_paymentvaluezero".local());
      return;
    }
    _showSheetView(
      context,
      _wallet,
      tokens,
      amount: amountBig.tokenString(decimals),
      fee: feeValue,
      remark: remark,
      to: to,
      from: from,
      feeToken: ' ' + feeToken,
      gasPrice: gasPrice,
      gasLimit: gasLimit,
      isCustomfee: true,
    );
  }

  ///重新计算后的转账金额，手续费
  void _showSheetView(
    BuildContext context,
    TRWallet mhWallet,
    MCollectionTokens tokens, {
    required String from,
    required String to,
    required String amount,
    required String remark,
    required String fee,
    required String feeToken,
    String? gasPrice,
    String? gasLimit,
    required bool isCustomfee,
  }) async {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        isDismissible: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        builder: (modalcontext) {
          return PaymentSheet(
            datas: PaymentSheet.getTransStyleList(
                from: from, to: to, remark: remark, fee: fee + feeToken),
            amount: amount + " ${tokens.token!}",
            nextAction: () {
              _unLockWallet(
                  context,
                  mhWallet,
                  (value) => {
                        _startSign(
                          context,
                          tokens,
                          value,
                          from: from,
                          to: to,
                          amount: amount,
                          remark: remark,
                          fee: fee,
                          gasPrice: int.tryParse(gasPrice ?? "") ?? null,
                          gasLimit: int.tryParse(gasLimit ?? "") ?? null,
                          isCustomfee: isCustomfee,
                        )
                      });
            },
          );
        });
  }

  ///解锁
  void _unLockWallet(
    BuildContext context,
    TRWallet mhWallet,
    Function(String value) lockCallBack,
  ) async {
    // ShowCustomAlert.showCustomAlertType(context,
    //     alertType: AlertType.password,
    //     title: "dialog_pwd".local(),
    //     rightButtonColor: ColorUtils.fromHex("#FD5852"),
    //     confirmPressed: (map) async {
    //   String value = map['text']!;
    //   final pin = await mhWallet.exportPrv(pin: value);
    //   if (lockCallBack != null) {
    //     lockCallBack(pin!);
    //   }
    //   //构造参数
    // }, currentWallet: mhWallet);
  }

  ///开始签名
  void _startSign(
    BuildContext context,
    MCollectionTokens? chooseTokens,
    String? pin, {
    required String from,
    required String to,
    required String amount,
    required String remark,
    String? fee,
    int? gasPrice,
    int? gasLimit,
    required bool isCustomfee,
  }) async {
    HWToast.showLoading(clickClose: true);
    String? result;

    if (result?.isNotEmpty == true) {
      HWToast.showText(text: "payment_transsuccess".local());
      Future.delayed(Duration(seconds: 1)).then((value) => {
            Routers.goBackWithParams(context, {}),
          });
    }
  }
}
