import 'package:cstoken/model/transrecord/trans_record.dart';
import 'package:cstoken/pages/wallet/transfer/transdetail_page.dart';

import '../public.dart';

class TransferListCell extends StatelessWidget {
  const TransferListCell({Key? key, required this.model, required this.from})
      : super(key: key);
  final TransRecordModel model;
  final String from;

  @override
  Widget build(BuildContext context) {
    String imgName = model.transTypeIcon(from);
    String address = model.toAdd!.contractAddress(end: 5);
    String time = model.date!;
    String value = model.vaueString(from);
    String state = model.transState();
    bool isSpeed = false;
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Routers.push(context, TransDetailPage(model: model));
        },
        child: Container(
          height: 71.width,
          padding: EdgeInsets.fromLTRB(16.width, 16.width, 16.width, 0),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
              width: 0.5,
              color: ColorUtils.lineColor,
            )),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoadAssetsImage(
                    imgName,
                    width: 24,
                    height: 24,
                  ),
                  8.rowWidget,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address,
                        style: TextStyle(
                          color: ColorUtils.fromHex("#FF000000"),
                          fontSize: 14.font,
                          fontWeight: FontWeightUtils.regular,
                        ),
                      ),
                      2.columnWidget,
                      Text(
                        time,
                        style: TextStyle(
                          color: ColorUtils.fromHex("#99000000"),
                          fontSize: 12.font,
                          fontWeight: FontWeightUtils.regular,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 150.width,
                    alignment: Alignment.centerRight,
                    child: Text(
                      value,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ColorUtils.fromHex("#FF000000"),
                        fontSize: 14.font,
                        fontWeight: FontWeightUtils.semiBold,
                      ),
                    ),
                  ),
                  2.columnWidget,
                  Text(
                    state,
                    style: TextStyle(
                      color: model.transStatus == KTransState.failere.index
                          ? ColorUtils.fromHex("#FFFF233E")
                          : ColorUtils.fromHex("#99000000"),
                      fontSize: 12.font,
                      fontWeight: FontWeightUtils.regular,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
    ;
  }
}
