import 'package:cached_network_image/cached_network_image.dart';
import 'package:cstoken/component/custom_refresher.dart';
import 'package:cstoken/component/empty_data.dart';
import 'package:cstoken/component/home_banner.dart';
import 'package:cstoken/component/wallet_card.dart';
import 'package:cstoken/model/dapps_record/dapps_record.dart';
import 'package:cstoken/model/wallet/tr_wallet_info.dart';
import 'package:cstoken/net/wallet_services.dart';
import 'package:cstoken/pages/browser/dapp_browser.dart';
import 'package:cstoken/pages/home/home_hotnft.dart';
import 'package:cstoken/pages/mine/mine_message.dart';
import 'package:cstoken/utils/date_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

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
  List _hotNFTS = [];
  @override
  void initState() {
    super.initState();
    _initData();
    WalletServices.getLinkInfo();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _initVersion();
    });
  }

  void _initVersion() async {
    final PackageInfo appInfo = await PackageInfo.fromPlatform();
    String appversion = appInfo.version;
    Map? result = await WalletServices.getAppversion(appversion);
    if (result == null) {
      return;
    }
    String descTxt = result["descTxt"] ?? "";
    int update = result["update"] ?? 0;
    String version = result["version"] ?? "";
    int frequency = result["frequency"] ?? 0;
    String url = result["url"] ?? "";
    if (url.isEmpty || version.isEmpty) {
      return;
    }
    if (frequency == 0) {
      ShowCustomAlert.versionAlert(context, update, descTxt, url);
    } else {
      String? versionTip = SPManager.getVersionFrequency();
      if (versionTip == null) {
        //第一次
        ShowCustomAlert.versionAlert(context, update, descTxt, url);
        SPManager.setVersionFrequency(frequency);
      } else {
        List<String> versions = versionTip.split(",");
        int oldversion = int.parse(versions.first);
        int lasttime = int.parse(versions.last);
        int currentTime = DateUtil.getNowDateMs();
        LogUtil.v(
            "${currentTime - lasttime}  ${oldversion * (3600 * 24 * 1000)}");
        if (currentTime - lasttime >= oldversion * (3600 * 24 * 1000)) {
          ShowCustomAlert.versionAlert(context, update, descTxt, url);
          SPManager.setVersionFrequency(frequency);
        }
      }
    }
  }

  void _initData() async {
    _initApp();
    _initBanner();
    _initHotDatas();
    _initHotNFTS();
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

  _initHotNFTS() async {
    List apps = await WalletServices.getNftList(popularFlag: true);
    setState(() {
      _hotNFTS = apps;
    });
  }

  Widget _topView(TRWallet? wallet) {
    return Container(
      height: 44.width,
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
            String _chainType = "";
            if (kprovider.nftIndexInfo != null) {
              _nftNum = kprovider.nftIndexInfo!["holdNftNum"].toString();
              _jump = kprovider.nftIndexInfo!["saleNftUrl"].toString();
              _chainType = kprovider.nftIndexInfo!["chainType"].toString();
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
                      DAppRecordsDBModel model = DAppRecordsDBModel();
                      model.url = _jump;
                      model.chainType = _chainType;

                      Provider.of<CurrentChooseWalletState>(context,
                              listen: false)
                          .bannerTap(context, model);
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
                String chainType = result["chainType"] ?? "";

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    DAppRecordsDBModel model = DAppRecordsDBModel();
                    model.url = jumpLinks;
                    model.chainType = chainType;
                    model.imageUrl = iconUrl;
                    model.name = title;
                    Provider.of<CurrentChooseWalletState>(context,
                            listen: false)
                        .bannerTap(context, model);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    padding: EdgeInsets.symmetric(horizontal: 10.width),
                    height: 123.width,
                    child: Column(
                      children: [
                        CachedNetworkImage(
                            imageUrl: iconUrl,
                            width: 50.width,
                            height: 50.width),
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

  Widget _dappHot() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16.width),
      margin: EdgeInsets.only(bottom: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "homepage_hot".local(),
            style: TextStyle(
              fontSize: 15.font,
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
                String chainType = result["chainType"] ?? "";
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    DAppRecordsDBModel model = DAppRecordsDBModel();
                    model.url = jumpLiks;
                    model.chainType = chainType;
                    model.imageUrl = logoUrl;
                    model.name = title;
                    model.description = introduction;
                    Provider.of<CurrentChooseWalletState>(context,
                            listen: false)
                        .bannerTap(context, model);
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
                            width: 56.width,
                            height: 56.width,
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

  Widget _nftHot() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16.width),
      margin: EdgeInsets.only(bottom: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "homepage_nfthot".local(),
                style: TextStyle(
                  fontSize: 15.font,
                  fontWeight: FontWeightUtils.semiBold,
                  color: ColorUtils.fromHex("#363636"),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Routers.push(context, HomeHotNft());
                },
                child: Text(
                  "homepage_more".local(),
                  style: TextStyle(
                    fontSize: 12.font,
                    fontWeight: FontWeightUtils.regular,
                    color: ColorUtils.fromHex("#000000").withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 225.w,
            margin: EdgeInsets.only(top: 12.width),
            child: ListView.builder(
              itemCount: _hotNFTS.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                Map result = _hotNFTS[index];
                String logoUrl = result["icon_url"] ?? "";
                String title = result["contract_name"] ?? "";
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: Container(
                    width: 155.width,
                    height: 225.w,
                    margin: EdgeInsets.only(right: 20.width),
                    child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 40.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: CachedNetworkImage(
                                  imageUrl: logoUrl,
                                  width: 125.width,
                                  height: 125.width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8.w),
                                width: 130.width,
                                alignment: Alignment.center,
                                child: Text(
                                  title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.font,
                                    fontWeight: FontWeightUtils.semiBold,
                                    color: ColorUtils.fromHex("#FF000000"),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8.w),
                                width: 130.width,
                                alignment: Alignment.center,
                                child: Text(
                                  "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11.font,
                                    fontWeight: FontWeightUtils.regular,
                                    color: ColorUtils.fromHex("#FF000000")
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                    HomeBanner(
                      datas: _banners,
                    ),
                    _dappHot(),
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
