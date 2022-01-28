import 'package:cstoken/component/custom_refresher.dart';
import 'package:cstoken/pages/apps/top_search_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../public.dart';

class AppsPage extends StatefulWidget {
  AppsPage({Key? key}) : super(key: key);

  @override
  State<AppsPage> createState() => _AppsPageState();
}

class _AppsPageState extends State<AppsPage> {
  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context)!.delegates;
    return CustomPageView(
      hiddenAppBar: true,
      child: Column(
        children: [
          TopSearchView(),
          15.columnWidget,
          // Expanded(child: _bodyListView()),
        ],
      ),
    );
  }

  // Widget _bodyListView() {
  //   return CustomRefresher(
  //     refreshController: _refreshController,
  //     onRefresh: _getDataOnRefresh,
  //     onLoading: () async {
  //       _pageNum += 1;
  //       await _getDApps();
  //       _refreshController.loadComplete();
  //     },
  //     child: _isShowDapp == true
  //         ? ListView.builder(
  //             itemCount: 3,
  //             itemBuilder: (BuildContext context, int index) {
  //               if (index == 0) {
  //                 return _imageList.isNotEmpty
  //                     ? CustomSwipe(imageList: _imageList)
  //                     : Container();
  //               } else if (index == 1) {
  //                 return _hotDAppsList.isNotEmpty
  //                     ? HotDApps(hotDAppsList: _hotDAppsList)
  //                     : Container();
  //               } else {
  //                 return _dAppsWithTypeList.isNotEmpty
  //                     ? DAppsListView(
  //                         dataList: _dAppsWithTypeList,
  //                         changeDAppTypeCallback: (String text) async {
  //                           _dAppsType = text;
  //                           _pageNum = 1;
  //                           _dAppsWithTypeList.clear();
  //                           HWToast.showLoading();
  //                           await _getDApps();
  //                           HWToast.hiddenAllToast();
  //                         },
  //                       )
  //                     : Container();
  //               }
  //             })
  //         : Column(
  //             children: [
  //               _imageList.isNotEmpty
  //                   ? CustomSwipe(imageList: _imageList)
  //                   : Container(),
  //               Expanded(child: EmptyDataPage()),
  //             ],
  //           ),
  //   );
  // }
}
