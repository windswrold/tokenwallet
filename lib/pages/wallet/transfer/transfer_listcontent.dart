import 'package:cstoken/component/custom_refresher.dart';
import 'package:cstoken/component/empty_data.dart';
import 'package:cstoken/component/trasnfer_listcell.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../public.dart';

class TransferListContent extends StatefulWidget {
  TransferListContent({Key? key, required this.type}) : super(key: key);
  final int type;

  @override
  State<TransferListContent> createState() => _TransferListContentState();
}

class _TransferListContentState extends State<TransferListContent>
    with AutomaticKeepAliveClientMixin {
  RefreshController refreshController = RefreshController();

  List _dappListData = [{}, ""];

  void initState() {
    // TODO: implement initState
    super.initState();
    LogUtil.v("initState " + widget.type.toString());
    _initData();
  }

  void _initData() async {
    refreshController.loadComplete();
    refreshController.refreshCompleted(resetFooterState: true);
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefresher(
        onRefresh: () {
          _initData();
        },
        child: _dappListData.length == 0
            ? EmptyDataPage()
            : ListView.builder(
                itemCount: _dappListData.length,
                itemBuilder: (BuildContext tx, int index) {
                  return TransferListCell();
                },
              ),
        refreshController: refreshController);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
