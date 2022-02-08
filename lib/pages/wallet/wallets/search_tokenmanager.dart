import 'package:cstoken/component/assets_cell.dart';

import '../../../public.dart';

class TokenManager extends StatefulWidget {
  TokenManager({Key? key}) : super(key: key);

  @override
  State<TokenManager> createState() => _TokenManagerState();
}

class _TokenManagerState extends State<TokenManager> {
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
        title: CustomPageView.getTitle(
            title: "tokensetting_tokensmanager".local()),
        child: Column(
          children: [
            _topSearchView(),
            Container(
              height: 44.width,
              padding: EdgeInsets.symmetric(horizontal: 16.width),
              child: Row(
                children: [
                  Text(
                    "tokensetting_sortindex".local(),
                    style: TextStyle(
                        color: ColorUtils.fromHex("#FF000000"),
                        fontSize: 14.font,
                        fontWeight: FontWeightUtils.medium),
                  ),
                  11.rowWidget,
                  Text(
                    "tokensetting_longpresssort".local(),
                    style: TextStyle(
                        color: ColorUtils.fromHex("#66000000"),
                        fontSize: 14.font,
                        fontWeight: FontWeightUtils.regular),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ReorderableListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return AssetsCell(
                    key: ValueKey(index),
                  );
                },
                itemCount: 10,
                onReorder: (int oldIndex, int newIndex) {
                  // if (oldIndex < newIndex) {
                  //   newIndex -= 1;
                  // }
                  // var child = items.removeAt(oldIndex);
                  // items.insert(newIndex, child);
                  // setState(() {});
                },
              ),
            ),
          ],
        ));
  }
}
