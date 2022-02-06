import 'package:cstoken/component/dapp_records_cell.dart';
import 'package:cstoken/component/empty_data.dart';
import 'package:cstoken/model/dapps_record/dapps_record.dart';

import '../../public.dart';

class AppsContentPage extends StatefulWidget {
  const AppsContentPage({Key? key, required this.datas, required this.dappTap})
      : super(key: key);

  final List<DAppRecordsDBModel> datas;
  final Function(DAppRecordsDBModel model) dappTap;

  @override
  State<AppsContentPage> createState() => _AppsContentPageState();
}

class _AppsContentPageState extends State<AppsContentPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return widget.datas.length == 0
        ? EmptyDataPage()
        : ListView.builder(
            itemCount: widget.datas.length,
            itemBuilder: (BuildContext tx, int index) {
              DAppRecordsDBModel model = widget.datas[index];
              return DAppListCell(
                model: model,
                onTap: (DAppRecordsDBModel tapModel) {
                  widget.dappTap(tapModel);
                  // _kdataState.dappTap(context, tapModel);
                },
              );
            },
          );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
