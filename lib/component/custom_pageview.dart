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
    this.hiddenScrollView,
    this.bottom,
    this.hiddenAppBar,
    this.hiddenLeading,
    this.bottomNavigationBar,
    this.leadBack,
    this.actions,
    this.leading,
    this.hiddenResizeToAvoidBottomInset = false,
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
  final bool? hiddenScrollView;
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
      {String title = "",
      double fontSize = 17,
      int color = 0xFF333333,
      FontWeight fontWeight = FontWeight.bold}) {
    return Text(
      title,
      style: TextStyle(
          color: Color(color), fontWeight: fontWeight, fontSize: fontSize.sp),
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
                backgroundColor: backgroundColor,
                actions: actions,
                leading: hiddenLeading == true
                    ? (leading != null ? leading : Text(""))
                    : Routers.canGoPop(context) == true
                        ? GestureDetector(
                            onTap: () => {
                              if (leadBack != null)
                                {
                                  leadBack!(),
                                }
                              else
                                {
                                  Routers.goBackWithParams(context, {}),
                                }
                            },
                            child: Center(
                              child: Image.asset(
                                './assets/images/' + "icons/icon_back_dark.png",
                                width: 24,
                                height: 24,
                              ),
                            ),
                          )
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
      child: hiddenScrollView == true
          ? child
          : SingleChildScrollView(
              child: child,
            ),
    );
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
