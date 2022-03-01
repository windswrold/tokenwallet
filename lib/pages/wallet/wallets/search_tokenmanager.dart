import 'package:cstoken/component/assets_cell.dart';
import 'package:cstoken/component/empty_data.dart';
import 'package:cstoken/model/tokens/collection_tokens.dart';

import '../../../public.dart';

class TokenManager extends StatefulWidget {
  TokenManager({Key? key}) : super(key: key);

  @override
  State<TokenManager> createState() => _TokenManagerState();
}

class _TokenManagerState extends State<TokenManager> {
  TextEditingController searchController = TextEditingController();

  List<MCollectionTokens> _datas = [];

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
      // maxLines: 1,
      onChange: (value) async {
        LogUtil.v("value  $value");
        final walletID =
            Provider.of<CurrentChooseWalletState>(context, listen: false)
                .currentWallet!
                .walletID!;
        final type = SPManager.getNetType().index;
        List<MCollectionTokens> datas = [];
        datas = await MCollectionTokens.findTokensBySQL(
            "(contract like '%$value%' or token like '%$value%') and owner = '$walletID' and kNetType = $type");

        setState(() {
          _datas = datas;
        });
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData();
  }

  void _initData() async {
    final walletID =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet!
            .walletID!;

    List<MCollectionTokens> datas = [];
    KNetType netType = SPManager.getNetType();
    datas = await MCollectionTokens.findTokens(walletID, netType.index);
    setState(() {
      _datas = datas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title:
          CustomPageView.getTitle(title: "tokensetting_tokensmanager".local()),
      child: Column(
        children: [
          _topSearchView(),
          // Container(
          //   height: 44.width,
          //   padding: EdgeInsets.symmetric(horizontal: 16.width),
          //   child: Row(
          //     children: [
          //       Text(
          //         "tokensetting_sortindex".local(),
          //         style: TextStyle(
          //             color: ColorUtils.fromHex("#FF000000"),
          //             fontSize: 14.font,
          //             fontWeight: FontWeightUtils.medium),
          //       ),
          //       11.rowWidget,
          //       Text(
          //         "tokensetting_longpresssort".local(),
          //         style: TextStyle(
          //             color: ColorUtils.fromHex("#66000000"),
          //             fontSize: 14.font,
          //             fontWeight: FontWeightUtils.regular),
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: _datas.length == 0
                ? EmptyDataPage()
                : ListView.builder(
                    itemCount: _datas.length,
                    itemBuilder: (BuildContext context, int index) {
                      MCollectionTokens token = _datas[index];
                      return AssetsCell(
                        key: ValueKey(index),
                        token: token,
                        onTap: () {
                          token.state = token.state == 1 ? 0 : 1;
                          String id = token.tokenID ?? "";
                          MCollectionTokens.updateTokenData(
                              "state=${token.state} WHERE tokenID = '$id'");
                          _initData();
                        },
                      );
                    },
                  ),
          ),
        ],

        // ReorderableListView.builder(
        //   itemBuilder: (BuildContext context, int index) {
        //     MCollectionTokens token = _datas[index];
        //     return AssetsCell(
        //       key: ValueKey(index),
        //       token: token,
        //       onTap: () {
        //         token.state = token.state == 1 ? 0 : 1;
        //         String id = token.tokenID ?? "";
        //         MCollectionTokens.updateTokenData(
        //             "state=${token.state} WHERE tokenID = '$id'");
        //         _initData();
        //       },
        //     );
        //   },
        //   itemCount: _datas.length,
        //   onReorder: (int oldIndex, int newIndex) {
        //     // MCollectionTokens token = _datas[oldIndex];
        //     // String id = token.tokenID ?? "";
        //     // token.moveItem(id, token.owner!, oldIndex, newIndex);
        //   },
      ),
    );
  }
}
