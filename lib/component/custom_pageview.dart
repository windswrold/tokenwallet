import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../public.dart';

//封装视图view

class CustomPageView extends StatelessWidget {
  CustomPageView({
    Key? key,
    required this.child,
    this.title,
    this.bottom,
    this.hiddenAppBar,
    this.hiddenLeading,
    this.bottomNavigationBar,
    this.leadBack,
    this.actions,
    this.leading,
    this.hiddenResizeToAvoidBottomInset = true,
    this.elevation = 0,
    this.backgroundColor = Colors.white,
    this.safeAreaTop = true,
    this.safeAreaLeft = true,
    this.safeAreaBottom = true,
    this.safeAreaRight = true,
  }) : super(key: key);

  Widget child;
  Widget? title;
  final PreferredSizeWidget? bottom;
  final bool? hiddenAppBar;
  final bool? hiddenLeading;
  final bool hiddenResizeToAvoidBottomInset; //是否弹出软键盘压缩界面
  final Widget? bottomNavigationBar;
  final VoidCallback? leadBack;
  final List<Widget>? actions;
  final Widget? leading;
  final double elevation;
  final Color backgroundColor;
  final bool safeAreaTop;
  final bool safeAreaLeft;
  final bool safeAreaBottom;
  final bool safeAreaRight;

  static Widget getTitle(
      {required String title,
      double fontSize = 18,
      int color = 0xFF000000,
      FontWeight fontWeight = FontWeightUtils.semiBold}) {
    return Text(
      title,
      style: TextStyle(
          color: Color(color), fontWeight: fontWeight, fontSize: fontSize.sp),
    );
  }

  static Widget getCloseLeading(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Image.asset(
          ASSETS_IMG + "icons/icon_lightclose.png",
          width: 24.w,
          height: 24.w,
        ),
      ),
    );
  }

  static Widget getAdd(VoidCallback onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(right: 16.width),
        child: Image.asset(
          ASSETS_IMG + "icons/icon_add.png",
          width: 24.width,
          height: 24.w,
        ),
      ),
    );
  }

  static Widget getScan(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(right: 16.width),
        child: Image.asset(
          ASSETS_IMG + "icons/icon_scan.png",
          width: 24.w,
          height: 24.w,
        ),
      ),
    );
  }

  static Widget getMessage(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(right: 16.width),
        child: Image.asset(
          ASSETS_IMG + "mine/mine_messages.png",
          width: 24.w,
          height: 24.w,
        ),
      ),
    );
  }

  static Widget getBack(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Image.asset(
          ASSETS_IMG + "icons/icon_back_dark.png",
          width: 24.w,
          height: 24.w,
        ),
      ),
    );
  }

  static Widget getCustomIcon(String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        ASSETS_IMG + iconName,
        width: 24.w,
        height: 24.w,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //全局拦截键盘处理
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: hiddenAppBar == true
          ? _annotatedRegion()
          : Scaffold(
              resizeToAvoidBottomInset: hiddenResizeToAvoidBottomInset,
              appBar: AppBar(
                title: title,
                centerTitle: true,
                elevation: elevation,
                bottom: bottom,
                backgroundColor: Colors.white,
                actions: actions,
                leading: hiddenLeading == true
                    ? Text("")
                    : Routers.canGoPop(context) == true
                        ? leading ??
                            getBack(() {
                              if (leadBack != null) {
                                leadBack!();
                              } else {
                                Routers.goBackWithParams(context, {});
                              }
                            })
                        : Text(""),
              ),
              backgroundColor: backgroundColor,
              bottomNavigationBar: this.bottomNavigationBar,
              body: _body(),
            ),
    );
  }

  Widget _body() {
    return SafeArea(
        top: safeAreaTop,
        left: safeAreaLeft,
        bottom: safeAreaBottom,
        right: safeAreaRight,
        child: child);
  }

  Widget _annotatedRegion() {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: backgroundColor,
          bottomNavigationBar: this.bottomNavigationBar,
          resizeToAvoidBottomInset: hiddenResizeToAvoidBottomInset,
          body: _body(),
        ));
  }
}
