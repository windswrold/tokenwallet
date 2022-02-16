import 'package:cstoken/component/custom_refresher.dart';
import 'package:cstoken/component/dapp_records_cell.dart';
import 'package:cstoken/component/empty_data.dart';
import 'package:cstoken/model/dapps_record/dapps_record.dart';
import 'package:cstoken/state/dapp/dapp_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../public.dart';

class AppsContentPage extends StatefulWidget {
  const AppsContentPage({Key? key, required this.dappTap, required this.type})
      : super(key: key);

  final Function(DAppRecordsDBModel model,int type) dappTap;
  final int type;

  @override
  State<AppsContentPage> createState() => _AppsContentPageState();
}

class _AppsContentPageState extends State<AppsContentPage>
    with AutomaticKeepAliveClientMixin {
  RefreshController refreshController = RefreshController();
  List<DAppRecordsDBModel> _dappListData = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LogUtil.v("initState " + widget.type.toString());
    _initData();
  }

  void _initData() async {
    Provider.of<DappDataState>(context, listen: false).getDataOnRefresh();
    List<DAppRecordsDBModel> _datas =
        await Provider.of<DappDataState>(context, listen: false)
            .getdappListData(widget.type);
    setState(() {
      _dappListData = _datas;
    });
    refreshController.loadComplete();
    refreshController.refreshCompleted(resetFooterState: true);
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefresher(
        onRefresh: () {
          _initData();
        },
        enableFooter: false,
        child: _dappListData.length == 0
            ? EmptyDataPage()
            : ListView.builder(
                itemCount: _dappListData.length,
                itemBuilder: (BuildContext tx, int index) {
                  DAppRecordsDBModel model = _dappListData[index];
                  return DAppListCell(
                    model: model,
                    onTap: (DAppRecordsDBModel tapModel) {
                      widget.dappTap(tapModel,widget.type);
                    },
                  );
                },
              ),
        refreshController: refreshController);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
