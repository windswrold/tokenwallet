import 'package:cstoken/model/contacts/contact_address.dart';
import 'package:cstoken/pages/mine/mine_newcontacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

import '../../public.dart';

class MineContacts extends StatefulWidget {
  MineContacts({Key? key}) : super(key: key);

  @override
  State<MineContacts> createState() => _MineContactsState();
}

class _MineContactsState extends State<MineContacts> {
  List<ContactAddress> _datas = [];

  @override
  void initState() {
    _initData();
    super.initState();
  }

  void _initData() async {
    _datas = await ContactAddress.queryAllAddress();
    setState(() {});
  }

  void _tapAdds(ContactAddress model) {
    ShowCustomAlert.showCustomBottomSheet(
        context,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Routers.goBack(context);
                model.address.copy();
              },
              child: Container(
                alignment: Alignment.center,
                height: 54.width,
                child: Text(
                  "minepage_copyAdds".local(),
                  style: TextStyle(
                      fontWeight: FontWeightUtils.medium,
                      fontSize: 16.font,
                      color: ColorUtils.fromHex("#FF000000")),
                ),
              ),
            ),
            Container(
              height: 0.5,
              alignment: Alignment.center,
              color: ColorUtils.lineColor,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Routers.goBack(context);
                Routers.push(context, MineNewContacts(model: model))
                    .then((value) => {
                          _initData(),
                        });
              },
              child: Container(
                alignment: Alignment.center,
                height: 54.width,
                child: Text(
                  "minepage_modifyadds".local(),
                  style: TextStyle(
                      fontWeight: FontWeightUtils.medium,
                      fontSize: 16.font,
                      color: ColorUtils.fromHex("#FF000000")),
                ),
              ),
            ),
          ],
        ),
        180.width,
        "walletssetting_modifycancel".local(),
        btnbgc: Colors.white,
        btnSttyle: TextStyle(
            fontWeight: FontWeightUtils.medium,
            fontSize: 16.font,
            color: ColorUtils.blueColor));
  }

  Widget _buildCell(ContactAddress model) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _tapAdds(model);
      },
      child: SwipeActionCell(
        key: ObjectKey(model),
        trailingActions: [
          SwipeAction(
            onTap: (result) {
              ShowCustomAlert.showCustomAlertType(
                  context, KAlertType.text, null, null,
                  leftButtonTitle: "minepage_delAdds".local(),
                  leftButtonStyle: TextStyle(
                    color: ColorUtils.fromHex("#99000000"),
                    fontSize: 16.font,
                    fontWeight: FontWeightUtils.regular,
                  ),
                  rightButtonTitle: "minepage_deladdwait".local(),
                  rightButtonStyle: TextStyle(
                    color: ColorUtils.blueColor,
                    fontSize: 16.font,
                    fontWeight: FontWeightUtils.regular,
                  ),
                  subtitleText: "minepage_delAddstip".local(),
                  subtitleTextStyle: TextStyle(
                      fontWeight: FontWeightUtils.regular,
                      fontSize: 16.font,
                      color: ColorUtils.fromHex("#FF000000")),
                  cancelPressed: () {
                ContactAddress.deleteAddress(model);
                _initData();
              }, confirmPressed: (value) {});
            },
            title: "minepage_delAdds".local(),
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.font,
                fontWeight: FontWeightUtils.medium),
            color: ColorUtils.redColor,
          ),
        ],
        child: Container(
          color: Colors.white,
          height: 72.width,
          child: Container(
            margin: EdgeInsets.only(left: 16.width),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: ColorUtils.lineColor,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LoadAssetsImage(
                  "tokens/${model.coinType.geCoinType().coinTypeString()}.png",
                  width: 32,
                  height: 32,
                ),
                4.rowWidget,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 300.width,
                      child: Text(
                        model.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: ColorUtils.fromHex("#FF000000"),
                            fontSize: 14.font,
                            fontWeight: FontWeightUtils.semiBold),
                      ),
                    ),
                    Container(
                      width: 300.width,
                      child: Text(
                        model.address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: ColorUtils.fromHex("#66000000"),
                            fontSize: 12.font,
                            fontWeight: FontWeightUtils.regular),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: CustomPageView.getTitle(title: "minepage_contactadds".local()),
      actions: [
        CustomPageView.getAdd(() async {
          Routers.push(context, MineNewContacts()).then((value) => {
                _initData(),
              });
        }),
      ],
      backgroundColor: ColorUtils.backgroudColor,
      child: ListView.builder(
        itemCount: _datas.length,
        itemBuilder: (BuildContext context, int index) {
          ContactAddress model = _datas[index];
          return _buildCell(model);
        },
      ),
    );
  }
}
