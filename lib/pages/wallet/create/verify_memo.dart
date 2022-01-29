import 'dart:math';

import 'package:cstoken/component/sortindex_button.dart';
import 'package:cstoken/component/sortindex_view.dart';
import 'package:cstoken/model/wallet/tr_wallet.dart';
import 'package:cstoken/pages/tabbar/tabbar.dart';
import 'package:cstoken/utils/custom_toast.dart';
import 'package:cstoken/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../public.dart';

class VerifyMemo extends StatefulWidget {
  const VerifyMemo({Key? key, required this.memo, required this.walletID})
      : super(key: key);
  final String memo;
  final String walletID;

  @override
  State<VerifyMemo> createState() => _VerifyMemoState();
}

class _VerifyMemoState extends State<VerifyMemo> {
  List<SortViewItem> _topList = [];
  List<SortViewItem> _bottomList = [];
  List<String> _originList = [];
  bool _isHWrong = false;
  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    List<String> memos = widget.memo.split(" ");
    setState(() {
      for (var i = 0; i < memos.length; i++) {
        final value = memos[i];
        _originList.add(value);
        final item = SortViewItem(value: "", index: i, isWrong: false);
        _topList.add(item);
      }
      memos.shuffle(Random());
      for (var i = 0; i < memos.length; i++) {
        final value = memos[i];
        final item = SortViewItem(value: value, index: i, select: false);
        _bottomList.add(item);
      }
    });
  }

  void _topListAction(int index) {
    LogUtil.v("_topListAction $index");
    SortViewItem topItem = _topList[index];
    int? bottomIndex = topItem.bottomIndex;
    if (topItem.value.isEmpty || bottomIndex == null) {
      return;
    }
    topItem.value = "";
    topItem.isWrong = false;
    SortViewItem bottomItem = _bottomList[bottomIndex];
    bottomItem.select = false;
    bottomItem.bottomIndex = null;
    setState(() {
      _topList.replaceRange(index, index + 1, [topItem]);
      _bottomList.replaceRange(bottomIndex, bottomIndex + 1, [bottomItem]);
    });
    _chooseCurrentState();
  }

  ///切换选中与未选中
  void _bottomListAction(int index) {
    LogUtil.v("_bottomListAction $index");
    SortViewItem bottomItem = _bottomList[index];
    if (bottomItem.select == true) {
      return;
    }
    int topIndex = _queryTopMinIndex();
    SortViewItem topItem = _topList[topIndex];
    final originValue = _originList[topIndex];
    bottomItem.select = true;
    topItem.value = bottomItem.value;
    topItem.bottomIndex = index;
    if (originValue == bottomItem.value) {
      topItem.isWrong = false;
    } else {
      topItem.isWrong = true;
    }
    setState(() {
      _topList.replaceRange(topIndex, topIndex + 1, [topItem]);
      _bottomList.replaceRange(index, index + 1, [bottomItem]);
    });
    _chooseCurrentState();
  }

  int _queryTopMinIndex() {
    int index = 9999;
    for (var i = 0; i < _topList.length; i++) {
      SortViewItem item = _topList[i];
      if (item.value.isEmpty) {
        index = i;
        break;
      }
    }
    return index;
  }

  void _verifyAction() async {
    bool isHaveWrong = false; //默认没有错
    for (var i = 0; i < _topList.length; i++) {
      final SortViewItem item = _topList[i];
      final String value = _originList[i];
      if (item.value != value) {
        isHaveWrong = true;
        break;
      }
    }
    if (isHaveWrong == true) {
      HWToast.showText(text: "verifymemo_havewrong".local());
      return;
    }
    TRWallet? trWallet = await TRWallet.queryWalletByWalletID(widget.walletID);
    if (trWallet != null) {
      trWallet.accountState = KAccountState.authed.index;
      TRWallet.updateWallet(trWallet);
      HWToast.showText(text: "verifymemo_backupcomplation".local());
      Future.delayed(const Duration(milliseconds: 1500)).then((value) => {
            Routers.push(context, HomeTabbar(), clearStack: true),
          });
    }
  }

  ///当前有没有错误
  ///循环完毕有没有错误
  void _chooseCurrentState() {
    bool isHaveWrong = false; //默认没有错
    for (var i = 0; i < _topList.length; i++) {
      final SortViewItem item = _topList[i];
      final String value = _originList[i];
      if (item.value != value && item.value.isNotEmpty) {
        isHaveWrong = true;
        break;
      }
    }
    setState(() {
      _isHWrong = isHaveWrong;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: CustomPageView.getTitle(title: "backup_memotitle".local()),
      child: Container(
        padding: EdgeInsets.all(24.width),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "verifymemo_nextclick".local(),
                      style: TextStyle(
                        fontSize: 14.font,
                        fontWeight: FontWeightUtils.regular,
                        color: ColorUtils.fromHex("#FF000000"),
                      ),
                    ),
                    SortIndexView(
                      memos: _topList,
                      offsetWidth: 48.width,
                      bgColor: ColorUtils.fromHex("#FFF6F8FF"),
                      type: SortIndexType.wrongIndex,
                      onTap: (int index) {
                        print("wrongIndex $index");
                        _topListAction(index);
                      },
                    ),
                    Opacity(
                      opacity: _isHWrong ? 1 : 0,
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 10.width,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "verifymemo_verifwrong".local(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.font,
                            fontWeight: FontWeightUtils.regular,
                            color: ColorUtils.fromHex("#FFFF233E"),
                          ),
                        ),
                      ),
                    ),
                    SortIndexView(
                      memos: _bottomList,
                      margin: EdgeInsets.only(top: 4.width),
                      offsetWidth: 48.width,
                      bgColor: Colors.white,
                      type: SortIndexType.actionIndex,
                      onTap: (int index) {
                        _bottomListAction(index);
                      },
                    ),
                  ],
                ),
              ),
            ),
            NextButton(
              onPressed: () {
                _verifyAction();
              },
              bgc: UIConstant.blueColor,
              enableColor: ColorUtils.fromHex("#667685A2"),
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16.font,
                  fontWeight: FontWeightUtils.medium),
              title: "verifymemo_verifystate".local(),
            ),
          ],
        ),
      ),
    );
  }
}
