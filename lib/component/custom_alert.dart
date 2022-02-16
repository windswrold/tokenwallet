import 'package:cstoken/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../public.dart';

class ShowCustomAlert {
  static showCustomAlertType(
    BuildContext context,
    KAlertType alertType,
    String? titleText,
    TRWallet? currentWallet, {
    bool hideLeftButton = false,
    String? subtitleText,
    TextStyle? subtitleTextStyle,
    String? leftButtonTitle,
    String? rightButtonTitle,
    TextStyle? leftButtonStyle,
    TextStyle? rightButtonStyle,
    Color? leftButtonBGC,
    Color? rightButtonBGC,
    double leftButtonRadius = 8,
    double rightButtonRadius = 8,
    double contextViewMinHeight = 80,
    VoidCallback? cancelPressed,
    EdgeInsetsGeometry? bottomActionsPadding,
    required Function(Map map) confirmPressed,
    bool tapConfirmAutoClose = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CustomAlert(
          alertType: alertType,
          titleText: titleText,
          subtitleText: subtitleText,
          rightButtonTitle: rightButtonTitle,
          leftButtonTitle: leftButtonTitle,
          cancelPressed: cancelPressed,
          confirmPressed: confirmPressed,
          currentWallet: currentWallet,
          hideLeftButton: hideLeftButton,
          subtitleTextStyle: subtitleTextStyle,
          leftButtonStyle: leftButtonStyle,
          rightButtonStyle: rightButtonStyle,
          leftButtonBGC: leftButtonBGC,
          rightButtonBGC: rightButtonBGC,
          leftButtonRadius: leftButtonRadius,
          rightButtonRadius: rightButtonRadius,
          contextViewMinHeight: contextViewMinHeight,
          bottomActionsPadding: bottomActionsPadding,
          tapConfirmAutoClose: tapConfirmAutoClose,
        );
      },
    );
  }

  static void showCustomBottomSheet(
    BuildContext context,
    Widget child,
    double height,
    String btnTitle, {
    VoidCallback? onTap,
    Color? btnbgc,
    TextStyle? btnSttyle,
  }) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) {
          return Container(
            height: height,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            margin: EdgeInsets.only(
                left: 16.width, right: 16.width, bottom: 16.width),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(bottom: 16.width),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: child),
                ),
                NextButton(
                    onPressed: () {
                      Routers.goBack(context);
                      if (onTap != null) {
                        onTap();
                      }
                    },
                    bgc: btnbgc ?? ColorUtils.blueColor,
                    textStyle: btnSttyle ??
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeightUtils.regular,
                          fontSize: 16.font,
                        ),
                    title: btnTitle)
              ],
            ),
          );
        });
  }

  static void versionAlert(
      BuildContext context, int update, String descTxt, String url) {
    ShowCustomAlert.showCustomAlertType(context, KAlertType.text, null, null,
        bottomActionsPadding: EdgeInsets.zero,
        hideLeftButton: update == 2 ? true : false,
        rightButtonStyle: TextStyle(
          color: ColorUtils.blueColor,
          fontSize: 16.font,
        ),
        rightButtonRadius: 8,
        rightButtonTitle: "homepage_update".local(),
        subtitleText: "newspage_versiontip".local() + "\n" + descTxt,
        tapConfirmAutoClose: update == 2 ? false : true,
        confirmPressed: (result) {
      launch(url);
    });
  }
}

class CustomAlert extends StatefulWidget {
  //弹窗类型
  final KAlertType alertType;
  //标题
  final String? titleText;
  final TRWallet? currentWallet;
  final bool hideLeftButton;
  //左边按钮点击回调
  final VoidCallback? cancelPressed;
  final String? subtitleText;
  final TextStyle? subtitleTextStyle;
  final String? leftButtonTitle;
  final String? rightButtonTitle;
  final TextStyle? leftButtonStyle;
  final TextStyle? rightButtonStyle;
  final Color? leftButtonBGC;
  final Color? rightButtonBGC;
  final double? leftButtonRadius;
  final double? rightButtonRadius;
  final double? contextViewMinHeight;
  final EdgeInsetsGeometry? bottomActionsPadding;
  //右边按钮点击回调
  final Function(Map map) confirmPressed;
  final bool tapConfirmAutoClose;
  const CustomAlert({
    Key? key,
    required this.alertType,
    required this.titleText,
    required this.subtitleText,
    required this.rightButtonTitle,
    required this.leftButtonTitle,
    required this.cancelPressed,
    required this.confirmPressed,
    required this.currentWallet,
    required this.hideLeftButton,
    required this.subtitleTextStyle,
    required this.leftButtonStyle,
    required this.rightButtonStyle,
    required this.leftButtonBGC,
    required this.rightButtonBGC,
    required this.leftButtonRadius,
    required this.rightButtonRadius,
    required this.contextViewMinHeight,
    required this.bottomActionsPadding,
    required this.tapConfirmAutoClose,
  }) : super(key: key);

  @override
  _CustomAlertState createState() => _CustomAlertState();
}

///alert弹窗的基本样式
class _CustomAlertState extends State<CustomAlert> {
  TextEditingController? _edTextEC;
  Color _colorText = ColorUtils.fromHex("#99000000");
  String? _errText;
  Color? _errColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.alertType == KAlertType.password) {
      _edTextEC = TextEditingController();
      _colorText = Colors.white;
      _errColor = ColorUtils.fromHex("#FFFF233E");
    }
    if (widget.alertType == KAlertType.text) {
      _colorText = Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: _alertBgView(context),
      ),
    );
  }

  ///alertView bgView
  Widget _alertBgView(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 158.width, maxHeight: 812.width),
      margin: EdgeInsets.only(left: 40.width, right: 40.width),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _title(context, widget.titleText),
            _contextView(),
            _bottomActions(),
          ],
        ),
      ),
    );
  }

  ///弹窗的title
  Widget _title(BuildContext context, String? text) {
    return Visibility(
      visible: text == null ? false : true,
      child: Container(
        alignment: Alignment.center,
        padding:
            EdgeInsets.only(top: 16.width, left: 16.width, right: 16.width),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 24),
            Expanded(
              child: Text(
                text ?? "",
                style: TextStyle(
                  color: ColorUtils.fromHex("#FF000000"),
                  fontWeight: FontWeightUtils.medium,
                  fontSize: 16.font,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                if (widget.cancelPressed != null) {
                  widget.cancelPressed!();
                }
              },
              child: Center(
                child: Image.asset(
                  ASSETS_IMG + "icons/icon_lightclose.png",
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///弹窗中间的widget
  Widget _contextView() {
    Widget? _child;
    if (widget.alertType == KAlertType.text) {
      _child = Text(
        widget.subtitleText ?? "",
        style: widget.subtitleTextStyle ??
            TextStyle(
                color: ColorUtils.fromHex("#99000000"),
                fontWeight: FontWeightUtils.regular,
                fontSize: 14.font,
                decoration: TextDecoration.none),
        textAlign: TextAlign.center,
      );
    } else if (widget.alertType == KAlertType.password) {
      _child = CustomTextField(
        controller: _edTextEC,
        obscureText: true,
        style: TextStyle(
          color: ColorUtils.fromHex("#FF000000"),
          fontSize: 14.font,
          fontWeight: FontWeightUtils.regular,
        ),
        onChange: (value) {
          setState(() {
            _errText = null;
            // _errColor = ColorUtils.fromHex("#FFFF233E");
          });
        },
        decoration: CustomTextField.getUnderLineDecoration(
            errorText: _errText,
            hintText: "input_pwd".local(),
            hintStyle: TextStyle(
              fontSize: 14.font,
              fontWeight: FontWeightUtils.regular,
              color: ColorUtils.fromHex("#66000000"),
            ),
            underLineWidth: 0.5,
            underLineColor: ColorUtils.lineColor,
            focusedUnderLineColor: ColorUtils.lineColor,
            errorTextColor: _errColor!),
      );
    } else if (widget.alertType == KAlertType.edit_name) {
    } else {}
    return Container(
      padding: EdgeInsets.only(top: 16.width, left: 16.width, right: 16.width),
      alignment: Alignment.center,
      constraints:
          BoxConstraints(minHeight: widget.contextViewMinHeight ?? 80.width),
      child: _child,
    );
  }

  /// 底部按钮组合
  Widget _bottomActions() {
    return Container(
      margin: EdgeInsets.only(top: 16.width),
      padding: widget.bottomActionsPadding ?? EdgeInsets.only(bottom: 12.width),
      decoration: widget.hideLeftButton == false
          ? const BoxDecoration(
              border: Border(
                  top: BorderSide(
              color: ColorUtils.lineColor,
              width: 0.5,
            )))
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.hideLeftButton
              ? Container()
              : Expanded(child: _cancelButton()),
          Expanded(child: _confirmButton()),
        ],
      ),
    );
  }

  Widget _cancelButton() {
    return NextButton(
      title: widget.leftButtonTitle ?? "walletssetting_modifycancel".local(),
      textStyle: widget.leftButtonStyle ??
          TextStyle(
            fontSize: 16.font,
            fontWeight: FontWeightUtils.medium,
            color: ColorUtils.fromHex("#99000000"),
          ),
      borderRadius: widget.leftButtonRadius ?? 0,
      bgc: widget.leftButtonBGC,
      onPressed: () {
        Navigator.pop(context);
        if (widget.cancelPressed != null) {
          widget.cancelPressed!();
        }
      },
    );
  }

  Widget _confirmButton() {
    return NextButton(
      title: widget.rightButtonTitle ?? "walletssetting_modifyok".local(),
      textStyle: widget.rightButtonStyle ??
          TextStyle(
            fontSize: 16.font,
            fontWeight: FontWeightUtils.medium,
            color: _colorText,
          ),
      bgc: widget.rightButtonBGC,
      borderRadius: widget.rightButtonRadius,
      onPressed: () {
        _confirmOnPressed();
      },
    );
  }

  void _confirmOnPressed() async {
    if (widget.alertType == KAlertType.text) {
      if (widget.tapConfirmAutoClose == true) {
        Navigator.pop(context);
      }

      widget.confirmPressed({"text": widget.subtitleText});
    } else if (widget.alertType == KAlertType.password) {
      String text = _edTextEC!.text;
      //导出私钥  输入密码
      TRWallet mwallet = widget.currentWallet!;
      mwallet = (await TRWallet.queryWalletByWalletID(mwallet.walletID!))!;
      bool isPassword = mwallet.lockPin(text: text, ok: null, wrong: null);
      if (isPassword) {
        if (widget.tapConfirmAutoClose == true) {
          Navigator.pop(context);
        }
        widget.confirmPressed({'text': text});
      } else {
        String tip = mwallet.pinTip ?? "";
        setState(() {
          _errText = "dialog_wrongpin".local() +
              "," +
              "createwallet_pwdtip".local() +
              "：" +
              tip;
          // _errColor = ColorUtils.fromHex("#FFFF6613");
        });
      }
    }
  }
}
