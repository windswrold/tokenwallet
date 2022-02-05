import 'package:cstoken/pages/scan/scan.dart';

import '../../public.dart';

class MineNewContacts extends StatefulWidget {
  MineNewContacts({Key? key}) : super(key: key);

  @override
  State<MineNewContacts> createState() => _MineNewContactsState();
}

class _MineNewContactsState extends State<MineNewContacts> {
  TextEditingController _nameEC = TextEditingController();
  TextEditingController _addsEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      actions: [
        CustomPageView.getScan(() {
          Routers.push(context, ScanCodePage());
        }),
      ],
      backgroundColor: ColorUtils.backgroudColor,
      title: CustomPageView.getTitle(title: "minepage_modifyadds".local()),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 16.width, right: 16.width),
            height: 56.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: ColorUtils.lineColor,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    "TextOverflow",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: ColorUtils.fromHex("#FF000000"),
                        fontSize: 16.font,
                        fontWeight: FontWeightUtils.regular),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "model.",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: ColorUtils.fromHex("#66000000"),
                            fontSize: 12.font,
                            fontWeight: FontWeightUtils.regular),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16.width, right: 16.width),
            height: 56.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: ColorUtils.lineColor,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    "TextOverflow",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: ColorUtils.fromHex("#FF000000"),
                        fontSize: 16.font,
                        fontWeight: FontWeightUtils.regular),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "model.",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: ColorUtils.fromHex("#66000000"),
                            fontSize: 12.font,
                            fontWeight: FontWeightUtils.regular),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16.width, right: 16.width),
            height: 56.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: ColorUtils.lineColor,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100.width,
                  child: Text(
                    "TextOverflow",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: ColorUtils.fromHex("#FF000000"),
                        fontSize: 16.font,
                        fontWeight: FontWeightUtils.regular),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _addsEC,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration.collapsed(hintText: ""),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
