import '../../../public.dart';

class PaymentSheetText {
  String? title;
  TextStyle? titleStyle;
  String? content;
  TextStyle? contentStyle;
  PaymentSheetText({
    this.title,
    this.content,
    this.contentStyle,
    this.titleStyle,
  });
}

class PaymentSheet extends StatefulWidget {
  PaymentSheet(
      {Key? key,
      required this.datas,
      required this.nextAction,
      required this.amount,
      required this.cancelAction})
      : super(key: key);

  final List<PaymentSheetText> datas;
  final VoidCallback nextAction;
  final VoidCallback cancelAction;
  final String amount;

  @override
  _PaymentSheetState createState() => _PaymentSheetState();

  static List<PaymentSheetText> getTransStyleList(
      {String from = "",
      String to = "",
      String remark = "",
      String fee = "",
      bool hiddenFee = false}) {
    List<PaymentSheetText> datas = [
      PaymentSheetText(
        title: "transferetype_from".local(),
        content: from,
      ),
      PaymentSheetText(
        title: "transferetype_to".local(),
        content: to,
      ),
    ];

    if (hiddenFee == false) {
      datas.add(
        PaymentSheetText(
          title: "transferetype_fee".local(),
          content: fee,
        ),
      );
    }

    datas.add(PaymentSheetText(
      title: "transferetype_remark".local(),
      content: remark,
    ));
    return datas;
  }
}

class _PaymentSheetState extends State<PaymentSheet> {
  void _next() {
    Navigator.pop(context);
    widget.nextAction();
  }

  void sheetClose() {
    Navigator.pop(context);
    widget.cancelAction();
  }

  Widget _getTitle() {
    return Container(
      height: 55.width,
      padding: EdgeInsets.symmetric(horizontal: 16.width),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        width: 0.5,
        color: ColorUtils.lineColor,
      ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 24,
          ),
          Text(
            "paymentsheep_info".local(),
            style: TextStyle(
                color: ColorUtils.fromHex("#FF000000"),
                fontSize: 16.font,
                fontWeight: FontWeightUtils.semiBold),
          ),
          CustomPageView.getCloseLeading(() {
            sheetClose();
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420.width,
      child: Column(
        children: [
          _getTitle(),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 16.width,
                right: 16.width,
                bottom: 20.width,
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 31.width),
                    alignment: Alignment.center,
                    child: Text(
                      widget.amount,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorUtils.fromHex("#FF000000"),
                        fontSize: 24.font,
                        fontWeight: FontWeightUtils.semiBold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.datas.length,
                      itemBuilder: (BuildContext context, int index) {
                        PaymentSheetText sheet = widget.datas[index];
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 8.width),
                          constraints: BoxConstraints(
                            minHeight: 45.height,
                          ),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            width: 0.5,
                            color: ColorUtils.lineColor,
                          ))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 120.width,
                                child: Text(sheet.title!,
                                    style: TextStyle(
                                      color: ColorUtils.fromHex("#99000000"),
                                      fontSize: 12.font,
                                    )),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(sheet.content!,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: ColorUtils.fromHex("#FF000000"),
                                        fontSize: 12.font,
                                        fontWeight: FontWeightUtils.medium,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  NextButton(
                    onPressed: _next,
                    borderRadius: 12,
                    height: 48,
                    bgc: ColorUtils.blueColor,
                    title: "transferetype_goon".local(),
                    textStyle: TextStyle(
                      fontSize: 16.font,
                      fontWeight: FontWeightUtils.medium,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
