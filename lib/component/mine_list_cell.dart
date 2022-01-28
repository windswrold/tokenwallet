import 'package:flutter/material.dart';

import '../public.dart';

class MineListViewCell extends StatelessWidget {
  const MineListViewCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.width),
      child: Column(
        children: [
          Container(
            height: 55.width,
            color: Colors.white,
            child: Row(
              children: [
                // LoadAssetsImage("name"),
                Text("data"),
                Text("data"),
              ],
            ),
          ),
          Container(
            color: UIConstant.lineColor,
            height: 0.5,
            margin: EdgeInsets.only(left: 48.width),
          ),
        ],
      ),
    );
  }
}
