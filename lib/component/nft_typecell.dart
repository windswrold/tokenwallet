import 'package:cstoken/model/nft/nft_model.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';

import '../public.dart';

class NFTTypeCell extends StatelessWidget {
  const NFTTypeCell({Key? key, required this.nftInfo}) : super(key: key);

  final NFTModel nftInfo;

  @override
  Widget build(BuildContext context) {
    String imgname = nftInfo.url ?? "";
    List nftId = [];
    if (nftInfo.nftId!.isNotEmpty) {
      nftId = nftInfo.nftId!.split(",");
    }
    int sum = nftId.length;
    String name = nftInfo.contractName ?? "";
    name = name.contractAddress();
    return Container(
      height: 68.width,
      margin: EdgeInsets.only(bottom: 8.width),
      padding: EdgeInsets.symmetric(horizontal: 12.width),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              LoadTokenAssetsImage(imgname, width: 36, height: 36),
              8.rowWidget,
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeightUtils.medium,
                  fontSize: 16.font,
                  color: ColorUtils.fromHex("#FF000000"),
                ),
              ),
            ],
          ),
          Text(
            sum.toString(),
            style: TextStyle(
              fontWeight: FontWeightUtils.bold,
              fontSize: 18.font,
              color: ColorUtils.fromHex("#FF000000"),
            ),
          )
        ],
      ),
    );
  }
}
