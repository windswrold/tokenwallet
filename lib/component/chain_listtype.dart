import 'package:flutter/material.dart';

import '../public.dart';

class ChainListType extends StatelessWidget {
  const ChainListType(
      {Key? key, required this.onTap, required, required this.datas})
      : super(key: key);

  final List<KCoinType> datas;
  final Function(KCoinType coinType) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (datas.length * 50.width) + 70.width,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      constraints: BoxConstraints(maxHeight: 420.width),
      margin:
          EdgeInsets.only(left: 16.width, right: 16.width, bottom: 16.width),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16.width, right: 16.width),
              margin: EdgeInsets.only(bottom: 16.width),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: datas.length,
                itemBuilder: (BuildContext context, int index) {
                  KCoinType type = datas[index];
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Routers.goBack(context);
                      onTap(type);
                    },
                    child: Container(
                        height: 50.width,
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
