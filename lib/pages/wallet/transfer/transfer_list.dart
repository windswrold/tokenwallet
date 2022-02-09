import 'package:cstoken/component/custom_underline.dart';
import 'package:cstoken/model/tokens/collection_tokens.dart';
import 'package:cstoken/pages/wallet/transfer/transfer_listcontent.dart';
import 'package:cstoken/state/translist_state.dart';
import 'package:cstoken/utils/extension.dart';

import '../../../public.dart';

class TransferListPage extends StatefulWidget {
  TransferListPage({Key? key}) : super(key: key);

  @override
  State<TransferListPage> createState() => _TransferListPageState();
}

class _TransferListPageState extends State<TransferListPage>
    with SingleTickerProviderStateMixin {
  List<Tab> _myTabs = [];
  TabController? _tabController;
  KTransListState _kTransListState = KTransListState();

  @override
  void initState() {
    // TODO: implement initState
    _myTabs = <Tab>[
      Tab(text: 'transferetype_all'.local()),
      Tab(text: 'transferetype_in'.local()),
      Tab(text: 'transferetype_out'.local()),
      Tab(text: 'transferetype_other'.local()),
    ];
    _tabController = TabController(length: _myTabs.length, vsync: this);
    super.initState();
  }

  Widget _headerBuilder() {
    return Container(
        height: 186.width,
        color: ColorUtils.backgroudColor,
        child: Consumer<CurrentChooseWalletState>(
          builder: (context, kwallet, child) {
            String amountType = kwallet.currencySymbolStr;
            MCollectionTokens tokens = kwallet.chooseTokens()!;
            final total = "≈" + amountType;
            String _imageName = "";
            String _balance = tokens.balanceString;
            String _assets = total + tokens.assets;
            String _address = kwallet.walletinfo!.walletAaddress!;
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 12.width),
                  child: ClipOval(
                    child: LoadAssetsImage(_imageName, width: 54, height: 54,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                      return LoadAssetsImage("tokens/token_default.png",
                          width: 54, height: 54);
                    }),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                      top: 8.width, left: 16.width, right: 16.width),
                  child: Text(
                    _balance,
                    style: TextStyle(
                        color: ColorUtils.fromHex("#FF000000"),
                        fontWeight: FontWeightUtils.semiBold,
                        fontSize: 22.font),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                      top: 2.width, left: 16.width, right: 16.width),
                  child: Text(
                    _assets,
                    style: TextStyle(
                        color: ColorUtils.fromHex("#FF7685A2"),
                        fontWeight: FontWeightUtils.regular,
                        fontSize: 14.font),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _address.copy();
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 12.width, left: 16.width, right: 16.width),
                    padding: EdgeInsets.only(
                        left: 12.width,
                        right: 12.width,
                        top: 4.width,
                        bottom: 4.width),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: ColorUtils.fromHex("#12216EFF"),
                    ),
                    child: RichText(
                      text: TextSpan(
                          text: _address.contractAddress(start: 5, end: 5),
                          style: TextStyle(
                              color: ColorUtils.fromHex("#FF000000"),
                              fontWeight: FontWeightUtils.regular,
                              fontSize: 12.font),
                          children: [
                            WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.width),
                                child: LoadAssetsImage(
                                  "icons/icon_copy.png",
                                  width: 16,
                                  height: 16,
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }

  Widget _getBottomWidget() {
    return Container(
      margin: EdgeInsets.only(top: 9.width),
      height: 64.width,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NextButton(
              onPressed: () {
                _kTransListState.paymentClick(context);
              },
              height: 44,
              borderRadius: 12,
              width: 142.width,
              bgc: ColorUtils.fromHex("#FF00C99A"),
              title: '',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadAssetsImage(
                    "icons/icon_white_out.png",
                    width: 20,
                    height: 20,
                  ),
                  8.rowWidget,
                  Text(
                    "transferetype_transfer".local(),
                    style: TextStyle(
                        fontSize: 16.font,
                        fontWeight: FontWeightUtils.medium,
                        color: ColorUtils.fromHex("#FFFFFFFF")),
                  ),
                ],
              ),
            ),
            16.rowWidget,
            NextButton(
              onPressed: () {
                _kTransListState.receiveClick(context);
              },
              height: 44,
              borderRadius: 12,
              width: 142.width,
              bgc: ColorUtils.blueColor,
              title: '',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadAssetsImage(
                    "icons/icon_white_in.png",
                    width: 20,
                    height: 20,
                  ),
                  8.rowWidget,
                  Text(
                    "transferetype_receive".local(),
                    style: TextStyle(
                        fontSize: 16.font,
                        fontWeight: FontWeightUtils.medium,
                        color: ColorUtils.fromHex("#FFFFFFFF")),
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  List<Widget> _getChildren(List<Tab> tabs) {
    List<Widget> datass = [];
    for (var i = 0; i < tabs.length; i++) {
      datass.add(TransferListContent(type: i));
    }
    return datass;
  }

  @override
  Widget build(BuildContext context) {
    MCollectionTokens tokens =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .chooseTokens()!;
    return ChangeNotifierProvider(
      create: (_) => _kTransListState,
      child: DefaultTabController(
        length: _myTabs.length,
        child: CustomPageView(
          title: CustomPageView.getTitle(title: tokens.token ?? ""),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _headerBuilder(),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  color: ColorUtils.backgroudColor,
                  child: Column(
                    children: [
                      Material(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: Theme(
                            data: ThemeData(
                                splashColor: Color.fromRGBO(0, 0, 0, 0),
                                highlightColor: Color.fromRGBO(0, 0, 0, 0)),
                            child: TabBar(
                              tabs: _myTabs,
                              controller: _tabController,
                              indicator: const CustomUnderlineTabIndicator(
                                  gradientColor: [
                                    ColorUtils.blueColor,
                                    ColorUtils.blueColor
                                  ]),
                              indicatorWeight: 4,
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelColor: ColorUtils.fromHex("#FF000000"),
                              labelStyle: TextStyle(
                                fontSize: 14.font,
                                fontWeight: FontWeightUtils.medium,
                              ),
                              unselectedLabelColor:
                                  ColorUtils.fromHex("#99000000"),
                              unselectedLabelStyle: TextStyle(
                                fontSize: 14.font,
                                fontWeight: FontWeightUtils.regular,
                              ),
                              onTap: (page) => {},
                            ),
                          )),
                      Expanded(
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(), //禁止左右滑动
                          children: _getChildren(_myTabs),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _getBottomWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
