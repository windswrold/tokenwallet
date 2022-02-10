import 'package:cstoken/model/client/ethclient.dart';
import 'package:cstoken/model/node/node_model.dart';
import 'package:cstoken/model/tokens/collection_tokens.dart';
import 'package:cstoken/model/wallet/tr_wallet_info.dart';
import 'package:cstoken/net/wallet_services.dart';
import 'package:cstoken/pages/mine/mine_contacts.dart';
import 'package:cstoken/pages/wallet/transfer/payment_sheet_page.dart';
import 'package:cstoken/pages/wallet/transfer/transfer_fee.dart';
import 'package:cstoken/utils/custom_toast.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

import '../public.dart';

class KTransferState with ChangeNotifier {
  TextEditingController _addressEC = TextEditingController();
  TextEditingController _valueEC = TextEditingController();
  TextEditingController _remarkEC = TextEditingController();

  TextEditingController get addressEC => _addressEC;
  TextEditingController get valueEC => _valueEC;
  TextEditingController get remarkEC => _remarkEC;

  TRWalletInfo? _walletInfo;
  TRWallet? _wallet;
  ETHClient? _client;
  MCollectionTokens? _tokens;

  String _gasLimit = '';
  String _gasPrice = '';
  String _feeValue = '0.0';
  bool _isCustomFee = false;

  String feeValue() {
    if (_tokens == null) {
      return _feeValue + "";
    }
    return _feeValue + " " + _tokens!.coinType!;
  }

  void init(BuildContext context) {
    _walletInfo = Provider.of<CurrentChooseWalletState>(context, listen: false)
        .walletinfo!;
    _wallet = Provider.of<CurrentChooseWalletState>(context, listen: false)
        .currentWallet!;
    _tokens = Provider.of<CurrentChooseWalletState>(context, listen: false)
        .chooseTokens()!;
    NodeModel node = NodeModel.queryNodeByChainType(_walletInfo!.coinType!);
    if (node.content == null) {
      return;
    }

    _client = ETHClient(node.content!, node.chainID!);
    initGasData();
  }

  void initGasData() async {
    int gasPrice = await _client!.getGasPrice();
    String fee = "";
    if (_tokens!.tokenType == KTokenType.native.index) {
      _gasLimit = transferETHGasLimit.toString();
    } else {
      _gasLimit = transferERC20GasLimit.toString();
    }
    fee = TRWallet.configFeeValue(
        cointype: _walletInfo!.coinType!,
        beanValue: _gasLimit,
        offsetValue: gasPrice.toString());
    _gasPrice = gasPrice.toString();
    _feeValue = fee;
    notifyListeners();
  }

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
    Routers.push(
        context,
        TransfeeView(
          feeValue: _feeValue,
          gasLimit: _gasLimit,
          gasPrice: _gasPrice,
          complationBack: (feeValue, gasPrice, gasLimit, isCustom) {
            LogUtil.v("feeValue $feeValue $gasPrice $gasLimit $isCustom");
            _feeValue = feeValue;
            _gasPrice = gasPrice;
            _gasLimit = gasLimit;
            _isCustomFee = _isCustomFee;
            notifyListeners();
          },
          feeToken: _tokens!.coinType!,
        ));
  }

  void tapTransfer(BuildContext context) async {
    LogUtil.v(
        "popupInfo gasPrice $_gasPrice gasLimit $_gasLimit feeValue $_feeValue iscustom $_isCustomFee");
    FocusScope.of(context).requestFocus(FocusNode());
    HWToast.showLoading();
    bool isToken = _tokens!.isToken;
    int decimals = _tokens!.decimals ?? 0;
    String from = _walletInfo!.walletAaddress!;
    String to = _addressEC.text.trim();
    String amount = _valueEC.text.trim();
    String remark = _remarkEC.text.trim();
    bool? isValid = false;
    int coinType = _walletInfo!.coinType!;
    String feeToken = _tokens!.coinType!;
    isValid = to.checkAddress(coinType.geCoinType());
    if (isValid == false) {
      HWToast.showText(text: "input_addressinvalid".local());
      return;
    }
    if (amount.isEmpty) {
      HWToast.showText(text: "input_paymentvalue".local());
      return;
    }
    if (_feeValue == null || _feeValue.isEmpty == true) {
      _feeValue = TRWallet.configFeeValue(
          cointype: coinType, beanValue: _gasLimit, offsetValue: _gasPrice);
    } else {
      _feeValue = _feeValue
          .trim()
          .replaceAll("ETH", "")
          .replaceAll(_tokens!.token!, "")
          .replaceAll(" ", "");
    }
    if (double.parse(_feeValue) == 0) {
      HWToast.showText(text: "payment_highfee".local());
      return;
    }
    BigInt amountBig = amount.tokenInt(decimals);
    BigInt balanceBig = _tokens!.balanceString.tokenInt(decimals);
    if (amountBig > balanceBig) {
      HWToast.showText(text: "payment_valueshouldlessbal".local());
      return;
    }
    BigInt feeBig = _feeValue.tokenInt(18);
    if (isToken == true) {
      num mainBalance = await _client!.getBalance(from);
      BigInt mainTokenBig = mainBalance.toString().tokenInt(18);
      if (feeBig > mainTokenBig) {
        HWToast.showText(text: "paymenttip_ethnotenough".local());
        return;
      }
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
    // _showSheetView(
    //   context,
    //   _wallet!,
    //   _tokens!,
    //   amount: amountBig.tokenString(decimals),
    //   fee: "zzz",
    //   remark: remark,
    //   to: to,
    //   from: from,
    //   feeToken: ' ' + feeToken,
    //   gasPrice: _gasPrice,
    //   gasLimit: _gasLimit,
    //   isCustomfee: true,
    //   kCoinType: coinType.geCoinType(),
    // );
  }

  ///重新计算后的转账金额，手续费
  void _showSheetView(
    BuildContext context, {
    required String from,
    required String to,
    required String amount,
    required String remark,
    required String feeToken,
  }) async {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        isDismissible: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        builder: (_) {
          return PaymentSheet(
            datas: PaymentSheet.getTransStyleList(
                from: from, to: to, remark: remark, fee: _feeValue + feeToken),
            amount: amount + " ${_tokens!.token!}",
            nextAction: () {
              ShowCustomAlert.showCustomAlertType(context, KAlertType.password,
                  "dialog_walletpin".local(), _wallet,
                  hideLeftButton: true,
                  rightButtonBGC: ColorUtils.blueColor,
                  rightButtonRadius: 8,
                  rightButtonTitle: "walletssetting_modifyok".local(),
                  confirmPressed: (result) {
                String? memo = _wallet!.exportEncContent(pin: result["text"]);
                List<HDWallet> hdWallets = HDWallet.getHDWallet(
                    content: memo!,
                    pin: "",
                    kLeadType: _wallet!.leadType!.getLeadType(),
                    kCoinType: _walletInfo!.coinType!.geCoinType());
                if (hdWallets.isNotEmpty) {
                  String prv = hdWallets.first.prv ?? "";
                  _startSign(
                    context,
                    amount,
                    from: from,
                    to: to,
                    amount: amount,
                    remark: remark,
                  );
                }
              });
            },
          );
        });
  }

  ///开始签名
  void _startSign(
    BuildContext context,
    String? pin, {
    required String from,
    required String to,
    required String amount,
    required String remark,
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
