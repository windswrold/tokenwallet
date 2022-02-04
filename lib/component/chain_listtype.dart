import 'package:flutter/material.dart';

import '../public.dart';

class ChainListType extends StatelessWidget {
  const ChainListType({Key? key, required this.onTap}) : super(key: key);

  final List<KCoinType> _datas = KCoinType.values;
  final Function(KCoinType coinType) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450.width,
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
                    child: Text(
                      type.coinTypeString(),
                      style: TextStyle(
                        color: ColorUtils.fromHex("#FF000000"),
                        fontSize: 18.font,
                        fontWeight: FontWeightUtils.medium,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          NextButton(
              onPressed: () {
                Routers.goBack(context);
              },
              bgc: ColorUtils.blueColor,
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
