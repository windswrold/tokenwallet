import 'package:flutter/material.dart';

import '../public.dart';

class ChainListType extends StatelessWidget {
  const ChainListType({Key? key, required this.onTap}) : super(key: key);

  final List<KCoinType> _datas = KCoinType.values;
  final Function(KCoinType coinType) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16.width),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _datas.length,
              itemBuilder: (BuildContext context, int index) {
                KCoinType type = _datas[index];
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Routers.goBack(context);
                    onTap(type);
                  },
                  child: Container(
                      height: 45.width,
                      alignment: Alignment.centerLeft,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 0.5,
                            color: ColorUtils.lineColor,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          LoadAssetsImage(
                            "tokens/${type.coinTypeString()}.png",
                            width: 24,
                            height: 24,
                          ),
                          8.rowWidget,
                          Text(
                            type.coinTypeString(),
                            style: TextStyle(
                              color: ColorUtils.fromHex("#FF000000"),
                              fontSize: 14.font,
                              fontWeight: FontWeightUtils.medium,
                            ),
                          ),
                        ],
                      )),
                );
              },
            ),
          ),
          NextButton(
              onPressed: () {
                Routers.goBack(context);
              },
              bgc: ColorUtils.blueColor,
              margin: EdgeInsets.only(top: 16.width),
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeightUtils.regular,
                fontSize: 16.font,
              ),
              title: "walletssetting_modifycancel".local())
        ],
      ),
    );
  }
}
