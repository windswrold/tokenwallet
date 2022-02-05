import 'package:cstoken/model/contacts/contact_address.dart';
import 'package:cstoken/pages/mine/mine_newcontacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  void _tapAdds(ContactAddress model) {}

  Widget _buildCell(ContactAddress model) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _tapAdds(model);
      },
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
