import 'package:flutter/services.dart';

import '../public.dart';

class RegExInputFormatter implements TextInputFormatter {
  final RegExp _regExp;

  RegExInputFormatter._(this._regExp);

  factory RegExInputFormatter.withRegex(String regexString) {
    try {
      final regex = RegExp(regexString);
      return RegExInputFormatter._(regex);
    } catch (e) {
      assert(false, e.toString());
      return RegExInputFormatter._(RegExp(""));
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final oldValueValid = _isValid(oldValue.text);
    final newValueValid = _isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }

  bool _isValid(String value) {
    try {
      final matches = _regExp.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}

class CustomTextField extends StatefulWidget {
  CustomTextField({
    Key? key,
    this.padding,
    this.maxLines = 1,
    this.obscureText = false,
    this.onSubmitted,
    required this.controller,
    this.decoration,
    this.style,
    this.maxLength,
    this.onChange,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  final EdgeInsetsGeometry? padding;
  final TextEditingController? controller;
  int maxLines;
  final bool obscureText;
  final ValueChanged<String>? onSubmitted;
  InputDecoration? decoration;
  final TextStyle? style;
  final int? maxLength;
  final ValueChanged<String>? onChange;
  final bool enabled;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final TextAlign textAlign;

  static TextInputFormatter decimalInputFormatter(int? decimals) {
    String amount = '^[0-9]{0,}(\\.[0-9]{0,$decimals})?\$';
    return RegExInputFormatter.withRegex(amount);
  }

  static InputDecoration getUnderLineDecoration({
    String? hintText,
    TextStyle? hintStyle,
    String? helperText,
    TextStyle? helperStyle,
    Widget? prefixIcon,
    Widget? suffixIcon,
    BoxConstraints suffixIconConstraints =
        const BoxConstraints(maxWidth: 100, maxHeight: double.infinity),
    BoxConstraints prefixIconConstraints =
        const BoxConstraints(minWidth: 80, maxHeight: double.infinity),
    Color underLineColor = Colors.white,
    Color focusedUnderLineColor = Colors.white,
    double underLineWidth = 1,
    Color fillColor = Colors.white,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.fromLTRB(10, 20, 10, 20),
    String? errorText,
    Color errorTextColor = const Color(0xFFFF233E),
  }) {
    return InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      suffixIconConstraints: suffixIconConstraints,
      prefixIconConstraints: prefixIconConstraints,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: underLineWidth, color: underLineColor),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: underLineWidth, color: underLineColor),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide:
            BorderSide(width: underLineWidth, color: focusedUnderLineColor),
      ),
      counterText: "",
      hintText: hintText,
      hintStyle: hintStyle,
      helperText: helperText,
      helperStyle: helperStyle,
      helperMaxLines: 5,
      fillColor: fillColor,
      errorText: errorText,
      errorStyle: TextStyle(
        fontSize: 12.font,
        fontWeight: FontWeightUtils.regular,
        color: errorTextColor,
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide:
            BorderSide(width: underLineWidth, color: focusedUnderLineColor),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide:
            BorderSide(width: underLineWidth, color: focusedUnderLineColor),
      ),
      filled: true,
      contentPadding: contentPadding,
    );
  }

  static InputDecoration getBorderLineDecoration({
    required BuildContext context,
    Color borderColor = Colors.transparent,
    Color focusedBorderColor = Colors.transparent,
    String? hintText,
    String? helperText,
    TextStyle? helperStyle,
    TextStyle? hintStyle,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.fromLTRB(10, 20, 10, 20),
    double borderRadius = 4,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? counterText,
    TextStyle? counterStyle,
    BoxConstraints suffixIconConstraints =
        const BoxConstraints(maxWidth: 50, maxHeight: double.infinity),
    BoxConstraints prefixIconConstraints =
        const BoxConstraints(minWidth: 50, maxHeight: double.infinity),
    Color? fillColor,
  }) {
    return InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      suffixIconConstraints: suffixIconConstraints,
      prefixIconConstraints: prefixIconConstraints,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: focusedBorderColor),
      ),
      hintText: hintText,
      hintStyle: hintStyle,
      helperText: helperText,
      helperStyle: helperStyle,
      helperMaxLines: 5,
      fillColor: fillColor,
      filled: true,
      contentPadding: contentPadding,
      counterText: counterText,
      counterStyle: counterStyle,
    );
  }

  static Widget getInputTextField(
    BuildContext context, {
    TextEditingController? controller,
    String? hintText,
    String? titleText,
    String? helpText,
    bool obscureText = false, //控制秘方
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    int? maxLength,
    int maxLines = 1,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.fromLTRB(10, 15, 10, 15),
    bool isPasswordText = false,
    bool isScanText = false,
    VoidCallback? onPressBack,
    bool enabled = true,
    Color fillColor = Colors.white,
  }) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Text(
              titleText ??= "",
              style: TextStyle(
                fontSize: 14.font,
                fontWeight: FontWeightUtils.medium,
                color: ColorUtils.fromHex("#99000000"),
              ),
            ),
          ),
          Stack(children: [
            CustomTextField(
              controller: controller,
              obscureText: obscureText,
              maxLength: maxLength,
              maxLines: maxLines,
              style: TextStyle(
                fontSize: 14.font,
                fontWeight: FontWeightUtils.medium,
                color: ColorUtils.fromHex("#FF000000"),
              ),
              enabled: enabled,
              decoration: CustomTextField.getUnderLineDecoration(
                  underLineColor: ColorUtils.lineColor,
                  focusedUnderLineColor: ColorUtils.blueColor,
                  underLineWidth: 0.5,
                  hintText: hintText,
                  fillColor: fillColor,
                  hintStyle: TextStyle(
                    fontSize: 14.font,
                    fontWeight: FontWeightUtils.regular,
                    color: ColorUtils.fromHex("#66000000"),
                  ),
                  contentPadding: contentPadding),
            ),
            isPasswordText
                ? Positioned(
                    right: 0,
                    child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Image.asset(
                          obscureText
                              ? ASSETS_IMG + "icons/icon_closeeye.png"
                              : ASSETS_IMG + "icons/icon_openeye.png",
                          width: 16.width,
                          height: 16.width,
                        ),
                        onPressed: onPressBack),
                  )
                : Container(),
          ]),
        ],
      ),
    );
  }

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry? padding = widget.padding;
    final TextEditingController? controller = widget.controller;
    int maxLines = widget.maxLines;
    final obscureText = widget.obscureText;
    final onSubmitted = widget.onSubmitted;
    return Container(
      padding: padding,
      child: TextField(
        autofocus: widget.autofocus,
        controller: controller,
        maxLines: maxLines,
        obscureText: obscureText,
        onSubmitted: onSubmitted,
        style: widget.style,
        maxLength: widget.maxLength,
        onChanged: widget.onChange,
        enabled: widget.enabled,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        textAlign: widget.textAlign,
        decoration: widget.decoration != null ? widget.decoration : null,
      ),
    );
  }
}
