import 'package:cached_network_image/cached_network_image.dart';
import 'package:cstoken/component/custom_refresher.dart';
import 'package:cstoken/net/wallet_services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../public.dart';

class HomeHotNft extends StatefulWidget {
  HomeHotNft({Key? key}) : super(key: key);

  @override
  State<HomeHotNft> createState() => _HomeHotNftState();
}

class _HomeHotNftState extends State<HomeHotNft> {
  RefreshController _controller = RefreshController();

  List _hotNFTS = [];
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _initHotNFTS(_currentPage);
  }

  void _initHotNFTS(int page) async {
    _currentPage = page;
    List apps = await WalletServices.getHotNftList(pageNum: _currentPage);
    setState(() {
      if (page == 1) {
        _hotNFTS.clear();
      }
      _hotNFTS.addAll(apps);
    });
    _controller.refreshCompleted();
    _controller.loadComplete();
  }

  Widget _buildCell(Map model) {
    String logoUrl = model["url"] ?? "";
    String title = model["contractName"] ?? "";
    String from = model["contractLabel"] ?? "";
    String desc = model["nft_desc"] ?? "";

    return Container(
      height: 152.width,
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: ColorUtils.lineColor,
        width: 0.5,
      ))),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: LoadTokenAssetsImage(
              logoUrl,
              width: 100.width,
              height: 120.width,
              fit: BoxFit.cover,
              isNft: true,
            ),
          ),
          13.rowWidget,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: 200.width,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ColorUtils.fromHex("#000000"),
                    fontSize: 16.font,
                    fontWeight: FontWeightUtils.semiBold,
                  ),
                ),
              ),
              Visibility(
                visible: from.isNotEmpty,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.width),
                  margin: EdgeInsets.only(top: 8.width),
                  height: 20.width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: ColorUtils.blueBGColor,
                  ),
                  child: Text(
                    from,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: ColorUtils.blueColor,
                      fontSize: 12.font,
                      fontWeight: FontWeightUtils.medium,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: 200.width,
                padding: EdgeInsets.only(top: 8.width),
                child: Text(
                  desc,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ColorUtils.fromHex("#000000").withOpacity(0.6),
                    fontSize: 12.font,
                    fontWeight: FontWeightUtils.regular,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: CustomPageView.getTitle(title: "homepage_nfthot".local()),
      child: Column(
        children: [
          // Container(
          //   height: 50.width,
          //   padding: EdgeInsets.symmetric(horizontal: 16.width),
          //   decoration: BoxDecoration(
          //       border: Border(
          //           bottom: BorderSide(
          //     color: ColorUtils.fromHex("#B2B2B2"),
          //     width: 0.5,
          //   ))),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Container(
          //         child: Text(
          //           "homepage_latest".local(),
          //           style: TextStyle(
          //             color: ColorUtils.fromHex("#000000"),
          //             fontSize: 16.font,
          //             fontWeight: FontWeightUtils.semiBold,
          //           ),
          //         ),
          //       ),
          //       CustomPageView.getCustomIcon("icons/icon_three.png", () {})
          //     ],
          //   ),
          // ),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.width),
                  child: CustomRefresher(
                      onRefresh: () {
                        _initHotNFTS(1);
                      },
                      onLoading: () {
                        _initHotNFTS(_currentPage + 1);
                      },
                      child: ListView.builder(
                        itemCount: _hotNFTS.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map value = _hotNFTS[index];
                          return _buildCell(value);
                        },
                      ),
                      refreshController: _controller)))
        ],
      ),
    );
  }
}
