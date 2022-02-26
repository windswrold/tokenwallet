import 'package:cstoken/component/dapp_records_list.dart';
import 'package:cstoken/model/dapps_record/dapps_record.dart';
import 'package:cstoken/pages/browser/dapp_browser.dart';
import 'package:cstoken/state/dapp/dapp_state.dart';

import '../../public.dart';

class DAppSearch extends StatefulWidget {
  const DAppSearch({Key? key}) : super(key: key);

  @override
  _DAppSearchState createState() => _DAppSearchState();
}

class _DAppSearchState extends State<DAppSearch> {
  DappDataState _kdataState = DappDataState();

  TextEditingController searchController = TextEditingController();
  int pageSize = 50;
  int pageNum = 1;
  List _searchDAppsList = [];
  List<DAppRecordsDBModel> _recordList = [];
  bool _isRecord = true;

  void _jumpWeb(BuildContext context, String openUrl) {
    searchController.clear();
    DAppRecordsDBModel mdoel = DAppRecordsDBModel(url: openUrl, type: 0);
    DAppRecordsDBModel.insertRecords(mdoel);
    Provider.of<CurrentChooseWalletState>(context, listen: false)
        .dappTap(context, mdoel);
    _getRecords();
  }

  Future<void> _getSearchDApps(String name) async {
    _searchDAppsList.clear();
    // dynamic data = await WalletServices.searchDAppsWithType(
    //     name: name, pageSize: pageSize, pageNum: pageNum);
    // HWToast.hiddenAllToast();
    // if (data != null && data['code'] == 200) {
    //   if (data['msg'] != null && data['msg']['dapps'] != null) {
    //     List _dataList = data['msg']['dapps'];
    //     setState(() {
    //       if (_dataList.isNotEmpty) {
    //         _searchDAppsList = _dataList;
    //       }
    //     });
    //   }
    // } else {
    //   HWToast.showText(text: "request_state_failere".local());
    // }
  }

  void _textFieldOnSubmitted(String value) async {
    if (value.isEmpty) {
      return;
    }
    if (value.isValidUrl() == true) {
      _jumpWeb(context, value);
    } else {
      if (value.contains(".")) {
        List strList = value.split('.');
        if (strList.length == 3) {
          String url = "https://" + value;
          _jumpWeb(context, url);
        } else if (strList.length == 2) {
          if (strList.contains('www')) {
            String url = "https://" + value + '.com';
            _jumpWeb(context, url);
          } else {
            String url = "https://www." + value;
            _jumpWeb(context, url);
          }
        }
      } else {
        String url = "https://www." + value + ".com";
        _jumpWeb(context, url);
      }
    }
  }

  void _deleteAllRecords() async {
    await DAppRecordsDBModel.deleteRecords(_recordList);
    setState(() {
      _recordList.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        _isRecord = searchController.text.isEmpty;
      });
    });
    _getRecords();
  }

  void _getRecords() async {
    _recordList = await DAppRecordsDBModel.finaAllRecords();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _kdataState,
      child: CustomPageView(
        hiddenAppBar: true,
        hiddenResizeToAvoidBottomInset: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topSearchView(),
            Expanded(
                child: DAppRecordList(
              recordList: _recordList,
              deleteAllCallback: _deleteAllRecords,
            )),
          ],
        ),
      ),
    );
  }

  Widget _topSearchView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.width),
      height: 44.width,
      alignment: Alignment.center,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomPageView.getCloseLeading(() {
            Routers.goBack(context);
          }),
          16.rowWidget,
          Expanded(
            child: _searchTextField(),
          ),
          _searchBtn(),
        ],
      ),
    );
  }

  Widget _searchTextField() {
    return CustomTextField(
      controller: searchController,
      maxLines: 1,
      onChange: (value) {
        if (value.isNotEmpty) {
          _getSearchDApps(value);
        }
      },
      style: TextStyle(
        color: ColorUtils.fromHex("#FF000000"),
        fontSize: 14.font,
        fontWeight: FontWeightUtils.regular,
      ),
      onSubmitted: _textFieldOnSubmitted,
      decoration: CustomTextField.getBorderLineDecoration(
          context: context,
          hintText: "dApp_top_search".local(),
          hintStyle: TextStyle(
            color: ColorUtils.fromHex("#807685A2"),
            fontSize: 14.font,
            fontWeight: FontWeightUtils.regular,
          ),
          focusedBorderColor: ColorUtils.blueColor,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.width),
          borderRadius: 22,
          fillColor: ColorUtils.fromHex("#FFF6F8FF")),
    );
  }

  Widget _searchBtn() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => {_textFieldOnSubmitted(searchController.text)},
      child: Container(
          width: 56.width,
          alignment: Alignment.center,
          child: Text(
            "dApp_searchbtn".local(),
            style: TextStyle(
              color: ColorUtils.fromHex("#FF000000"),
              fontSize: 14.font,
              fontWeight: FontWeightUtils.medium,
            ),
          )),
    );
  }
}
