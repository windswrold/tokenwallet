import '../../public.dart';
import 'dapp_records_cell.dart';

typedef DeleteAllCallback = void Function();

class DAppRecordList extends StatelessWidget {
  const DAppRecordList(
      {Key? key, required this.recordList, required this.deleteAllCallback})
      : super(key: key);
  final List recordList;
  final DeleteAllCallback deleteAllCallback;

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _topView(),
          Container(
            height: 10.width,
            alignment: Alignment.center,
            color: ColorUtils.backgroudColor,
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: recordList.length,
                itemBuilder: (BuildContext context, int index) {
                  return DAppListCell(model: recordList[index]);
                }),
          ),
        ],
      ),
    );
  }

  Widget _topView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'dApp_popularsearch'.local(),
          textAlign: TextAlign.start,
          style: TextStyle(
            color: ColorUtils.fromHex("#FF000000"),
            fontWeight: FontWeightUtils.medium,
            fontSize: 14.font,
          ),
        ),
        Wrap(),
      ],
    );
  }
}
