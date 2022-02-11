import 'package:cstoken/component/assets_cell.dart';
import 'package:cstoken/pages/wallet/wallets/search_tokenmanager.dart';

import '../../../public.dart';

class SearchAddToken extends StatefulWidget {
  SearchAddToken({Key? key}) : super(key: key);

  @override
  State<SearchAddToken> createState() => _SearchAddTokenState();
}

class _SearchAddTokenState extends State<SearchAddToken> {
  TextEditingController searchController = TextEditingController();

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
      onChange: (value) {},
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
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: 10,
            //     itemBuilder: (BuildContext context, int index) {
            //       return AssetsCell();
            //     },
            //   ),
            // )
          ],
        ));
  }
}
