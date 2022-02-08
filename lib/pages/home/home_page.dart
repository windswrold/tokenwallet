import 'package:cstoken/component/custom_refresher.dart';
import 'package:cstoken/component/wallet_card.dart';
import 'package:cstoken/pages/mine/mine_message.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../public.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
  }

  void _initData() {
    _refreshController.loadComplete();
    _refreshController.refreshCompleted();
  }

  Widget _topView(TRWallet? wallet) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.only(left: 16.width),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            WalletCard(wallet: wallet),
            CustomPageView.getMessage(() {
              Routers.push(context, MineMessagePage());
            }),
          ],
        ),
      ),
    );
  }

  Widget _nftNumview() {
    return Container(
      height: 154.width,
      margin: EdgeInsets.only(top: 12.width),
      padding: EdgeInsets.only(top: 30.width, left: 36.width),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ASSETS_IMG + "bg/nft_bg.png"),
          fit: BoxFit.contain,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "homepage_nft".local(),
                style: TextStyle(
                  fontSize: 14.font,
                  fontWeight: FontWeightUtils.medium,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 32.width, right: 48.width),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                      text: "0",
                      style: TextStyle(
                        fontSize: 36.font,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: EdgeInsets.only(left: 9.width),
                            child: Text(
                              "homepage_number".local(),
                              style: TextStyle(
                                fontSize: 14.font,
                                fontWeight: FontWeightUtils.medium,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
                LoadAssetsImage(
                  "icons/icon_arrow_circle_right.png",
                  width: 24,
                  height: 24,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _nftList() {
    return Container(
      height: 150.width,
      alignment: Alignment.center,
      child: ListView.builder(
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 150.width,
            height: 150.width,
            child: Column(
              children: [
                Text(
                  "homepage_nft".local(),
                  style: TextStyle(
                    fontSize: 14.font,
                    fontWeight: FontWeightUtils.medium,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "homepage_nft".local(),
                  style: TextStyle(
                    fontSize: 14.font,
                    fontWeight: FontWeightUtils.semiBold,
                    color: ColorUtils.fromHex("#FF000000"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _nftSwipe() {
    return Container(
      height: 150.width,
      alignment: Alignment.center,
      child: ListView.builder(
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 150.width,
            height: 150.width,
            child: Column(
              children: [
                Text(
                  "homepage_nft".local(),
                  style: TextStyle(
                    fontSize: 14.font,
                    fontWeight: FontWeightUtils.medium,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "homepage_nft".local(),
                  style: TextStyle(
                    fontSize: 14.font,
                    fontWeight: FontWeightUtils.semiBold,
                    color: ColorUtils.fromHex("#FF000000"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _nftHot() {
    return Container(
      height: 150.width,
      alignment: Alignment.center,
      child: ListView.builder(
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 150.width,
            height: 150.width,
            child: Column(
              children: [
                Text(
                  "homepage_nft".local(),
                  style: TextStyle(
                    fontSize: 14.font,
                    fontWeight: FontWeightUtils.medium,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "homepage_nft".local(),
                  style: TextStyle(
                    fontSize: 14.font,
                    fontWeight: FontWeightUtils.semiBold,
                    color: ColorUtils.fromHex("#FF000000"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context);
    TRWallet? wallet =
        Provider.of<CurrentChooseWalletState>(context).currentWallet;
    return CustomPageView(
      hiddenLeading: true,
      hiddenAppBar: true,
      backgroundColor: ColorUtils.backgroudColor,
      child: Column(
        children: [
          _topView(wallet),
          Expanded(
            child: CustomRefresher(
              refreshController: _refreshController,
              onRefresh: () {
                _initData();
              },
              enableFooter: false,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _nftNumview(),
                    _nftList(),
                    _nftSwipe(),
                    _nftHot(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
