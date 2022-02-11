import 'package:cached_network_image/cached_network_image.dart';
import 'package:cstoken/component/custom_refresher.dart';
import 'package:cstoken/component/empty_data.dart';
import 'package:cstoken/component/home_banner.dart';
import 'package:cstoken/component/wallet_card.dart';
import 'package:cstoken/model/dapps_record/dapps_record.dart';
import 'package:cstoken/model/wallet/tr_wallet_info.dart';
import 'package:cstoken/net/wallet_services.dart';
import 'package:cstoken/pages/browser/dapp_browser.dart';
import 'package:cstoken/pages/mine/mine_message.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../public.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RefreshController _refreshController = RefreshController();
  List _apps = [];
  List _banners = [];
  List _hotDatas = [];
  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _initApp();
    _initBanner();
    _initHotDatas();
    Provider.of<CurrentChooseWalletState>(context, listen: false)
        .initNFTIndex();
    Future.delayed(Duration(seconds: 3)).then((value) => {
          _refreshController.loadComplete(),
          _refreshController.refreshCompleted(),
        });
  }

  _initApp() async {
    List apps = await WalletServices.getindexapplicationInfo();
    setState(() {
      _apps = apps;
    });
  }

  _initBanner() async {
    List apps = await WalletServices.getbannerInfo();
    setState(() {
      _banners = apps;
    });
  }

  _initHotDatas() async {
    List apps = await WalletServices.getindexpopularItem();
    setState(() {
      _hotDatas = apps;
    });
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
            // CustomPageView.getMessage(() {
            //   Routers.push(context, MineMessagePage());
            // }),
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
          Consumer<CurrentChooseWalletState>(builder: (_, kprovider, child) {
            String _nftNum = "--";
            String _jump = "";
            if (kprovider.nftIndexInfo != null) {
              _nftNum = kprovider.nftIndexInfo!["holdNftNum"].toString();
              _jump = kprovider.nftIndexInfo!["saleNftUrl"].toString();
            }
            return Padding(
              padding: EdgeInsets.only(top: 32.width, right: 48.width),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                        text: _nftNum,
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
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Provider.of<CurrentChooseWalletState>(context,
                              listen: false)
                          .bannerTap(context, _jump);
                    },
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: LoadAssetsImage(
                          "icons/icon_arrow_circle_right.png",
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _nftList() {
    return Container(
      height: 123.width,
      alignment: Alignment.center,
      child: _apps.isEmpty
          ? EmptyDataPage()
          : ListView.builder(
              itemCount: _apps.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(top: 22.width),
              itemBuilder: (BuildContext context, int index) {
                Map result = _apps[index];
                String iconUrl = result["iconUrl"];
                String title = result["title"];
                String jumpLinks = result["jumpLinks"];

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Provider.of<CurrentChooseWalletState>(context,
                            listen: false)
                        .bannerTap(context, jumpLinks);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    padding: EdgeInsets.symmetric(horizontal: 10.width),
                    height: 123.width,
                    child: Column(
                      children: [
                        CachedNetworkImage(
                            imageUrl: iconUrl, width: 50, height: 50),
                        9.columnWidget,
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.font,
                            fontWeight: FontWeightUtils.semiBold,
                            color: ColorUtils.fromHex("#FF000000"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _nftHot() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16.width),
      margin: EdgeInsets.only(bottom: 50.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "homepage_hot".local(),
            style: TextStyle(
              fontSize: 16.font,
              fontWeight: FontWeightUtils.semiBold,
              color: ColorUtils.fromHex("#FF000000"),
            ),
          ),
          Container(
            height: 100.w,
            padding: EdgeInsets.only(top: 15.width),
            child: ListView.builder(
              itemCount: _hotDatas.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                Map result = _hotDatas[index];
                String logoUrl = result["logoUrl"] ?? "";
                String title = result["title"] ?? "";
                String introduction = result["introduction"] ?? "";
                String jumpLiks = result["jumpLiks"] ?? "";
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Provider.of<CurrentChooseWalletState>(context,
                            listen: false)
                        .bannerTap(context, jumpLiks);
                  },
                  child: Container(
                    width: 300.width,
                    height: 100.w,
                    padding: EdgeInsets.only(left: 16.width, right: 16.width),
                    margin: EdgeInsets.only(right: 16.width),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: logoUrl,
                            width: 56,
                            height: 56,
                          ),
                        ),
                        10.rowWidget,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 180.width,
                              child: Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18.font,
                                  fontWeight: FontWeightUtils.semiBold,
                                  color: ColorUtils.fromHex("#FF000000"),
                                ),
                              ),
                            ),
                            Container(
                              width: 180.width,
                              child: Text(
                                introduction,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.font,
                                  fontWeight: FontWeightUtils.semiBold,
                                  color: ColorUtils.fromHex("#FF000000"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
                child: Container(
                  color: ColorUtils.backgroudColor,
                  child: Column(
                    children: [
                      _nftNumview(),
                      _nftList(),
                      HomeBanner(
                        datas: _banners,
                      ),
                      _nftHot(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
