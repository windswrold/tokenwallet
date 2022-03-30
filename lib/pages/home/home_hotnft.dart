import 'package:cached_network_image/cached_network_image.dart';
import 'package:cstoken/component/custom_refresher.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../public.dart';

class HomeHotNft extends StatefulWidget {
  HomeHotNft({Key? key}) : super(key: key);

  @override
  State<HomeHotNft> createState() => _HomeHotNftState();
}

class _HomeHotNftState extends State<HomeHotNft> {
  RefreshController _controller = RefreshController();

  Widget _buildCell() {
    String logoUrl =
        "https://gimg2.baidu.com/image_search/src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fq_70%2Cc_zoom%2Cw_640%2Fimages%2F20191213%2Ffdd17e15f2e643628bb13cd1c464b61d.gif&refer=http%3A%2F%2F5b0988e595225.cdn.sohucs.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1651244300&t=395b4af52b0109e46869cfd63b299220";
    String title = "ContainerContainerContainerContainer";
    String from = "opensea";
    String desc = "ContainerContainerContainerContainer";

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
            child: CachedNetworkImage(
              imageUrl: logoUrl,
              width: 100.width,
              height: 120.width,
              fit: BoxFit.cover,
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.width),
                margin: EdgeInsets.only(top: 8.width),
                height: 20.width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: ColorUtils.blueBGColor,
                ),
                child: Text(
                  "title",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ColorUtils.blueColor,
                    fontSize: 12.font,
                    fontWeight: FontWeightUtils.medium,
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
          Container(
            height: 50.width,
            padding: EdgeInsets.symmetric(horizontal: 16.width),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: ColorUtils.fromHex("#B2B2B2"),
              width: 0.5,
            ))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    "homepage_latest".local(),
                    style: TextStyle(
                      color: ColorUtils.fromHex("#000000"),
                      fontSize: 16.font,
                      fontWeight: FontWeightUtils.semiBold,
                    ),
                  ),
                ),
                CustomPageView.getCustomIcon("icons/icon_three.png", () {})
              ],
            ),
          ),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.width),
                  child: CustomRefresher(
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildCell();
                        },
                      ),
                      refreshController: _controller)))
        ],
      ),
    );
  }
}
