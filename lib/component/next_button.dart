import '../../public.dart';

typedef NextButtonCallback = void Function();

class NextButton extends StatelessWidget {
  const NextButton(
      {Key? key,
      required this.onPressed,
      this.bgc,
      required this.title,
      this.enabled = true,
      this.height = 48.0,
      this.borderRadius = 8,
      this.margin,
      this.padding,
      this.border,
      this.textStyle,
      this.enableColor = Colors.black,
      this.bgImg,
      this.width})
      : super(key: key);

  final NextButtonCallback onPressed;
  final Color? bgc;
  final String title;
  final bool enabled;

  ///原始值
  final double height;

  ///原始值
  final double? width;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxBorder? border;
  final TextStyle? textStyle;
  final Color? enableColor;

  ///Constant.ASSETS_IMG + "icons/buttongradient.png",
  final String? bgImg;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _buttonOnPressed(context),
      child: Container(
        alignment: Alignment.center,
        height: height.width,
        margin: margin,
        padding: padding,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
          border: border,
          color: bgc,
          image: bgImg == null
              ? null
              : DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage(bgImg!),
                ),
          // gradient: bgc == null
          //     ? LinearGradient(
          //         begin: Alignment.centerLeft,
          //         end: Alignment.centerRight,
          //         colors: enabled
          //             ? UIConstant.gradientColors
          //             : UIConstant.enabledGradientColors,
          //       )
          //     : null,
        ),
        child: Text(
          title,
          style: textStyle,
        ),
      ),
    );
  }

  void _buttonOnPressed(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (enabled) {
      onPressed();
    }
  }
}
