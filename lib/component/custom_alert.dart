import 'package:cstoken/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../public.dart';

class ShowCustomAlert {
  static showCustomAlertType(
    BuildContext context,
    KAlertType alertType,
    String? title,
    TRWallet currentWallet, {
    String subtitleText = "",
    String leftButtonTitle = 'aaa',
    String rightButtonTitle = 'bbb',
    bool hideLeftButton = false,
    Color leftButtonColor = const Color(0x99000000),
    Color rightButtonColor = ColorUtils.blueColor,
    VoidCallback? cancelPressed,
    required Function(Map map) confirmPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CustomAlert(
          alertType: alertType,
          titleText: title,
          subtitleText: subtitleText,
          leftButtonTitle: leftButtonTitle,
          rightButtonTitle: rightButtonTitle,
          cancelPressed: cancelPressed,
          confirmPressed: confirmPressed,
          rightButtonColor: rightButtonColor,
          leftButtonColor: leftButtonColor,
          hideLeftButton: hideLeftButton,
          currentWallet: currentWallet,
        );
      },
    );
  }
}

class CustomAlert extends StatefulWidget {
  //弹窗类型
  final KAlertType alertType;
  //标题
  final String? titleText;
  //文本提示内容
  final String subtitleText;
  //左边按钮名称
  final String leftButtonTitle;
  //右边按钮名称
  final String rightButtonTitle;
  //左边按钮颜色
  final Color leftButtonColor;
  //右边按钮颜色
  final Color rightButtonColor;
  //左边按钮点击回调
  final VoidCallback? cancelPressed;
  final TRWallet currentWallet;
  final bool hideLeftButton;
  //右边按钮点击回调
  final Function(Map map) confirmPressed;
  const CustomAlert({
    Key? key,
    required this.alertType,
    required this.titleText,
    required this.subtitleText,
    required this.rightButtonTitle,
    required this.leftButtonTitle,
    this.cancelPressed,
    required this.confirmPressed,
    required this.leftButtonColor,
    required this.rightButtonColor,
    required this.currentWallet,
    this.hideLeftButton = false,
  }) : super(key: key);

  @override
  _CustomAlertState createState() => _CustomAlertState();
}

///alert弹窗的基本样式
class _CustomAlertState extends State<CustomAlert> {
  TextEditingController? _edTextEC;
  Color? _confirmBgc;
  double _confirmRadius = 0;
  Color _colorText = ColorUtils.fromHex("#99000000");
  String? _errText;
  Color? _errColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.alertType == KAlertType.password) {
      _edTextEC = TextEditingController();

      _confirmBgc = ColorUtils.blueColor;
      _confirmRadius = 8;
      _colorText = Colors.white;
      _errColor = ColorUtils.fromHex("#FFFF233E");
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
      padding: EdgeInsets.only(left: 16.width, right: 16.width),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _title(context, widget.titleText),
          _contextView(),
          _bottomActions(),
        ],
      ),
    );
  }

  ///弹窗的title
  Widget _title(BuildContext context, String? text) {
    return Visibility(
      visible: text == null ? false : true,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 16.width),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 24),
            Text(
              text ?? "",
              style: TextStyle(
                color: ColorUtils.fromHex("#FF000000"),
                fontWeight: FontWeightUtils.medium,
                fontSize: 16.font,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
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
        widget.subtitleText,
        style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeightUtils.medium,
            fontSize: 14,
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
            underLineWidth: 0.5,
            underLineColor: ColorUtils.lineColor,
            focusedUnderLineColor: ColorUtils.lineColor,
            errorTextColor: _errColor!),
      );

      // _child = PrivateKeyAlertCenterView(
      //     subTitle: widget.subtitleText,
      //     privateControllerCallBack: (text) {
      //       _privateText = text;
      //     });
    } else if (widget.alertType == KAlertType.edit_name) {
      // _child = PrivateKeyAlertCenterView(
      //     subTitle: widget.subtitleText,
      //     obscureText: false,
      //     hintText: 'enter_name'.local(),
      //     privateControllerCallBack: (text) {
      //       _privateText = text;
      //     });
    } else {
      // _child = NodeUrlAlertCenterView(nodeControllerCallBack1: (String text) {
      //   _nodeText1 = text;
      // }, nodeControllerCallBack2: (String text) {
      //   _nodeText2 = text;
      // });
    }
    return Container(
      padding: EdgeInsets.only(top: 16.width),
      child: _child,
    );
  }

  /// 底部按钮组合
  Widget _bottomActions() {
    return Container(
      padding: EdgeInsets.only(top: 16.width, bottom: 24.width),
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
      title: widget.leftButtonTitle,
      textStyle: TextStyle(
        fontSize: 16.font,
        fontWeight: FontWeightUtils.medium,
        color: ColorUtils.fromHex("#99000000"),
      ),
      borderRadius: 0,
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
      title: widget.rightButtonTitle,
      textStyle: TextStyle(
        fontSize: 16.font,
        fontWeight: FontWeightUtils.medium,
        color: _colorText,
      ),
      bgc: _confirmBgc,
      borderRadius: _confirmRadius,
      onPressed: () {
        _confirmOnPressed();
      },
    );
  }

  void _confirmOnPressed() {
    if (widget.alertType == KAlertType.text) {
      widget.confirmPressed({});
      Navigator.pop(context);
    } else if (widget.alertType == KAlertType.password) {
      String text = _edTextEC!.text;
      //导出私钥  输入密码
      TRWallet mwallet = widget.currentWallet;
      bool isPassword = mwallet.lockPin(text: text, ok: null, wrong: null);
      if (isPassword) {
        widget.confirmPressed({'text': text});
        Navigator.pop(context);
      } else {
        String tip = mwallet.pinTip!;
        setState(() {
          _errText = "createwallet_pwdtip".local() + ":" + tip;
          _errColor = ColorUtils.fromHex("#FFFF6613");
        });
      }
    }
  }
}
