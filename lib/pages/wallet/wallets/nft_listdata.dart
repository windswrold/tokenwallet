import 'package:cstoken/component/custom_refresher.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../public.dart';
import 'nft_info.dart';

class NFTListData extends StatefulWidget {
  NFTListData({Key? key}) : super(key: key);

  @override
  State<NFTListData> createState() => _NFTListDataState();
}

class _NFTListDataState extends State<NFTListData> {
  RefreshController _refreshController = RefreshController();

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      height: 90.width,
      padding: EdgeInsets.only(left: 20.width, right: 20.width),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LoadTokenAssetsImage("name", width: 50, height: 50),
          10.rowWidget,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "datadata",
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
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Color.fromARGB(255, 210, 210, 210),
                    )),
                    child: Text(
                      "data",
                      style: TextStyle(
                        fontSize: 14.font,
                        color: Color.fromARGB(255, 183, 183, 183),
                      ),
                    ),
                  ),
                  10.rowWidget,
                  Text(
                    "data",
                    style: TextStyle(
                      fontSize: 14.font,
                      color: Color.fromARGB(255, 183, 183, 183),
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

  Widget _buildCell() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Routers.push(context, NFTInfo());
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
                LoadTokenAssetsImage("name", width: 50, height: 50),
                10.rowWidget,
                Container(
                  child: Text(
                    "data",
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
              child: CustomRefresher(
                  enableFooter: false,
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildCell();
                    },
                  ),
                  refreshController: _refreshController)),
        ],
      ),
    );
  }
}
