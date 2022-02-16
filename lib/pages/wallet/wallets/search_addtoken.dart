import 'package:cstoken/component/assets_cell.dart';
import 'package:cstoken/component/custom_refresher.dart';
import 'package:cstoken/component/empty_data.dart';
import 'package:cstoken/model/tokens/collection_tokens.dart';
import 'package:cstoken/net/url.dart';
import 'package:cstoken/net/wallet_services.dart';
import 'package:cstoken/pages/wallet/wallets/search_tokenmanager.dart';
import 'package:cstoken/utils/custom_toast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../public.dart';

class SearchAddToken extends StatefulWidget {
  SearchAddToken({Key? key}) : super(key: key);

  @override
  State<SearchAddToken> createState() => _SearchAddTokenState();
}

class _SearchAddTokenState extends State<SearchAddToken> {
  TextEditingController searchController = TextEditingController();
  RefreshController _refreshController = RefreshController();

  int _page = 1;
  List<MCollectionTokens> _datas = [];

  @override
  void initState() {
    super.initState();
    _initData(_page);
  }

  void _initData(int page,
      {String? tokenName, String? tokenContractAddress}) async {
    HWToast.showLoading();

    final walletID =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet!
            .walletID!;
    _page = page;
    List indexTokens = [];
    bool popular = false;
    if (tokenName != null || tokenContractAddress != null) {
      indexTokens = await WalletServices.gettokenList(page, 20,
          tokenName: tokenName, tokenContractAddress: tokenContractAddress);
    } else {
      popular = true;
      indexTokens = await WalletServices.getpopularToken();
    }

    List<MCollectionTokens> tokens = [];
    KNetType netType = RequestURLS.host.contains("consensus.zooonews.com")
        ? KNetType.Testnet
        : KNetType.Mainnet;
    for (var item in indexTokens) {
      MCollectionTokens token = MCollectionTokens();
      token.token = item["tokenName"] ?? "";
      token.decimals = item["amountPrecision"] as int;
      token.contract = item["tokenContractAddress"] ?? "";
      token.digits = item["pricePrecision"] ?? 4;
      token.tokenType =
          token.contract == "0x0000000000000000000000000000000000000000"
              ? KTokenType.native.index
              : KTokenType.token.index;

      String tokenIconUrl = item["tokenIconUrl"] ?? "";
      String chainIconUrl = item["chainIconUrl"] ?? "";
      token.iconPath = tokenIconUrl + "," + chainIconUrl;
      token.coinType = item["chainType"] ?? "";
      token.chainType = token.coinType!.chainTypeGetCoinType()?.index;
      token.kNetType = netType.index;
      if (token.chainType == null) {
        assert(token.chainType != null, "有判断失败的数据 ");
        continue;
      }
      token.owner = walletID;
      String contract = token.contract ?? "";
      String tokenID = (token.kNetType.toString() +
          "|" +
          token.chainType.toString() +
          "|" +
          walletID +
          "|" +
          contract);
      token.tokenID = TREncode.SHA256(tokenID);
      tokens.add(token);
    }

    List<MCollectionTokens> statesTokens =
        await MCollectionTokens.findTokens(walletID, netType.index);
    for (var item in tokens) {
      for (var stateTokens in statesTokens) {
        if (item.tokenID == stateTokens.tokenID) {
          item.state = 1;
        }
      }
    }
    if (_page == 1 || popular == true) {
      _datas.clear();
    }
    HWToast.hiddenAllToast();
    _refreshController.loadComplete();
    _refreshController.refreshCompleted();
    setState(() {
      _datas.addAll(tokens);
    });
  }

  Widget _topSearchView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.width),
      height: 44,
      color: Colors.white,
      child: _searchTextField(),
    );
  }

  Widget _searchTextField() {
    return CustomTextField(
      controller: searchController,
      maxLines: 1,
      onChange: (value) {
        if (value.isEmpty) {
          _initData(1);
        } else {
          if (value.checkAddress(KCoinType.ETH) == true) {
            _initData(1, tokenContractAddress: value);
          } else {
            _initData(1, tokenName: value);
          }
        }
      },
      style: TextStyle(
        color: ColorUtils.fromHex("#FF000000"),
        fontSize: 14.font,
        fontWeight: FontWeightUtils.regular,
      ),
      decoration: CustomTextField.getBorderLineDecoration(
          context: context,
          hintText: "tokensetting_searchtip".local(),
          hintStyle: TextStyle(
            color: ColorUtils.fromHex("#807685A2"),
            fontSize: 14.font,
            fontWeight: FontWeightUtils.regular,
          ),
          focusedBorderColor: ColorUtils.blueColor,
          borderRadius: 22,
          prefixIcon: LoadAssetsImage(
            "icons/icon_search.png",
            width: 20,
            height: 20,
          ),
          fillColor: ColorUtils.fromHex("#FFF6F8FF")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
        title: CustomPageView.getTitle(title: "tokensetting_addassets".local()),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 16.width),
              child: CustomPageView.getCustomIcon("icons/icon_tokensetting.png",
                  () {
                Routers.push(context, TokenManager());
              })),
        ],
        child: Column(
          children: [
            _topSearchView(),
            Expanded(
                child: CustomRefresher(
                    onRefresh: () {
                      searchController.clear();
                      _initData(1);
                    },
                    onLoading: () {
                      searchController.clear();
                      _initData(_page + 1);
                    },
                    child: _datas.length == 0
                        ? EmptyDataPage()
                        : ListView.builder(
                            itemCount: _datas.length,
                            itemBuilder: (BuildContext context, int index) {
                              MCollectionTokens item = _datas[index];
                              return AssetsCell(
                                onTap: () {
                                  if (item.state == 1) {
                                    return;
                                  }
                                  item.state = 1;
                                  MCollectionTokens.insertTokens([item]);
                                  searchController.clear();
                                  HWToast.showText(
                                      text: "dialog_modifyok".local());
                                  Future.delayed(Duration(seconds: 1))
                                      .then((value) => {
                                            _initData(1),
                                          });
                                },
                                token: item,
                              );
                            },
                          ),
                    refreshController: _refreshController))
          ],
        ));
  }
}
