import 'package:cstoken/component/custom_refresher.dart';
import 'package:cstoken/model/nft/nft_model.dart';
import 'package:cstoken/model/tokens/collection_tokens.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../public.dart';
import 'nft_info.dart';

class NFTListData extends StatefulWidget {
  NFTListData({Key? key, required this.model}) : super(key: key);
  final NFTModel model;

  @override
  State<NFTListData> createState() => _NFTListDataState();
}

class _NFTListDataState extends State<NFTListData> {
  RefreshController _refreshController = RefreshController();

  Widget _buildHeader() {
    String nftTypeName = widget.model.nftTypeName ?? "";
    String contract = widget.model.contractAddress ?? "";
    String name = widget.model.contractName ?? "";
    name = name.contractAddress();
    String imgname = widget.model.url ?? "";
    return Container(
      color: Colors.white,
      height: 90.width,
      padding: EdgeInsets.only(left: 20.width, right: 20.width),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LoadTokenAssetsImage(imgname, width: 50, height: 50),
          10.rowWidget,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeightUtils.semiBold,
                  fontSize: 16.font,
                  color: ColorUtils.fromHex("#FF000000"),
                ),
              ),
              5.columnWidget,
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.width),
                    alignment: Alignment.center,
                    height: 25.width,
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Color.fromARGB(255, 210, 210, 210),
                    )),
                    child: Text(
                      "ERC" + nftTypeName,
                      style: TextStyle(
                        fontSize: 14.font,
                        color: Color.fromARGB(255, 183, 183, 183),
                      ),
                    ),
                  ),
                  10.rowWidget,
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      contract.copy();
                    },
                    child: RichText(
                      maxLines: 3,
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: contract.contractAddress(),
                        style: TextStyle(
                          color: Color.fromARGB(255, 183, 183, 183),
                          fontSize: 14.font,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          WidgetSpan(
                            child: Padding(
                              padding: EdgeInsets.only(left: 9.width),
                              child: LoadAssetsImage(
                                "icons/icon_copy.png",
                                width: 16,
                                height: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCell(
      MCollectionTokens infos, int index, CurrentChooseWalletState provider) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        provider.updateTokenChoose(context, index, pushTransList: false);
        Routers.push(context,
            NFTInfo(nftModel: widget.model, tokenid: infos.toString()));
      },
      child: Container(
        height: 75.width,
        margin: EdgeInsets.only(left: 20.width, right: 20.width),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: ColorUtils.lineColor,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LoadTokenAssetsImage(
                  "name",
                  width: 50,
                  height: 50,
                ),
                10.rowWidget,
                Container(
                  child: Text(
                    infos.tid.toString(),
                    style: TextStyle(
                      fontSize: 14.font,
                      color: Color.fromARGB(255, 183, 183, 183),
                    ),
                  ),
                ),
              ],
            ),
            LoadAssetsImage(
              "icons/icon_arrow_right.png",
              width: 16,
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: CustomPageView.getTitle(title: "homepage_nftinfo".local()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Container(
            height: 20.width,
            color: ColorUtils.backgroudColor,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.width),
            height: 50.width,
            alignment: Alignment.centerLeft,
            child: Text(
              "walletpage_assets".local(),
              style: TextStyle(
                fontSize: 16.font,
                fontWeight: FontWeightUtils.semiBold,
              ),
            ),
          ),
          Expanded(
            child: Consumer<CurrentChooseWalletState>(
              builder: (_, value, child) {
                return ListView.builder(
                  itemCount: value.nftInfos.length,
                  itemBuilder: (BuildContext context, int index) {
                    MCollectionTokens infos = value.nftInfos[index];
                    return _buildCell(infos, index, value);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
