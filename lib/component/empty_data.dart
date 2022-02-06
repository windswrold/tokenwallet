import '../public.dart';

class EmptyDataPage extends StatelessWidget {
  const EmptyDataPage({Key? key, this.emptyTip}) : super(key: key);

  final String? emptyTip;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emptyTip ?? "empay_datano".local(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorUtils.fromHex("#99000000"),
                  fontSize: 14.font,
                  fontWeight: FontWeight.w400,
                )),
          ],
        ));
  }
}
