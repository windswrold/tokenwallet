import 'package:cstoken/component/chain_listtype.dart';
import 'package:cstoken/model/contacts/contact_address.dart';
import 'package:cstoken/pages/scan/scan.dart';
import 'package:cstoken/utils/custom_toast.dart';

import '../../public.dart';

class MineNewContacts extends StatefulWidget {
  MineNewContacts({Key? key, this.model}) : super(key: key);
  final ContactAddress? model;

  @override
  State<MineNewContacts> createState() => _MineNewContactsState();
}

class _MineNewContactsState extends State<MineNewContacts> {
  final TextEditingController _nameEC = TextEditingController();
  final TextEditingController _addsEC = TextEditingController();
  KCoinType? _chooseType;

  @override
  void initState() {
    super.initState();

    if (widget.model != null) {
      _nameEC.text = widget.model!.name;
      _addsEC.text = widget.model!.address;
      _chooseType = widget.model!.coinType.geCoinType();
    }
  }

  void _tapNewAdds() async {
    String _name = _nameEC.text.trim();
    String _add = _addsEC.text.trim();
    if (_name.isEmpty) {
      HWToast.showText(text: "minepage_inputname".local());
      return;
    }
    if (_add.isEmpty) {
      HWToast.showText(text: "minepage_inputadds".local());
      return;
    }
    if (_chooseType == null) {
      return;
    }

    bool isValid = _add.checkAddress(_chooseType!);
    if (isValid == false) {
      HWToast.showText(text: "input_addressinvalid".local());
      return;
    }

    ContactAddress model = ContactAddress(_add, _chooseType!.index, _name);
    ContactAddress.insertAddress(model);
    HWToast.showText(text: "wallet_inputok".local());
    Future.delayed(const Duration(seconds: 2))
        .then((value) => {Routers.goBackWithParams(context, {})});
  }

  void _onTapChain() {
    Provider.of<CurrentChooseWalletState>(context, listen: false)
        .onTapChain(context, KChainType.HD.getSuppertCoinTypes(), (p0) {
      setState(() {
        _chooseType = p0;
      });
    });
  }

  Widget _buildText(String text) {
    return Container(
      width: 120.width,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: ColorUtils.fromHex("#FF000000"),
            fontSize: 16.font,
            fontWeight: FontWeightUtils.regular),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return Expanded(
      child: CustomTextField(
        controller: controller,
        textAlign: TextAlign.end,
        style: TextStyle(
          fontSize: 14.font,
          fontWeight: FontWeightUtils.medium,
          color: ColorUtils.fromHex("#FF000000"),
        ),
        decoration: CustomTextField.getUnderLineDecoration(
          underLineColor: Colors.transparent,
          underLineWidth: 0,
          focusedUnderLineColor: Colors.transparent,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14.font,
            fontWeight: FontWeightUtils.regular,
            color: ColorUtils.fromHex("#66000000"),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      actions: [
        CustomPageView.getScan(() async {
          Map? params = await Routers.push(context, ScanCodePage());
          String? result = params?["data"];
          if (result != null) {
            result = result.replaceAll("ethereum:", "");
            setState(() {
              _addsEC.text = result ?? "";
            });
          }
        }),
      ],
      backgroundColor: ColorUtils.backgroudColor,
      title: CustomPageView.getTitle(title: "minepage_modifyadds".local()),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _onTapChain,
            child: Container(
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
                  _buildText("minepage_chain".local()),
                  Container(
                    child: Row(
                      children: [
                        _chooseType == null
                            ? Text(
                                "minepage_choosecoin".local(),
                                style: TextStyle(
                                  fontSize: 14.font,
                                  fontWeight: FontWeightUtils.regular,
                                  color: ColorUtils.fromHex("#66000000"),
                                ),
                              )
                            : Row(
                                children: [
                                  LoadAssetsImage(
                                    "tokens/${_chooseType!.coinTypeString()}.png",
                                    width: 24,
                                    height: 24,
                                  ),
                                  8.rowWidget,
                                  Text(
                                    _chooseType!.coinTypeString(),
                                    style: TextStyle(
                                      color: ColorUtils.fromHex("#FF000000"),
                                      fontSize: 14.font,
                                      fontWeight: FontWeightUtils.medium,
                                    ),
                                  ),
                                ],
                              ),
                        LoadAssetsImage(
                          "icons/icon_arrow_right.png",
                          width: 16,
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                _buildText("minepage_addname".local()),
                _buildTextField(_nameEC, "minepage_inputname".local()),
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
                _buildText("minepage_adds".local()),
                _buildTextField(_addsEC, "minepage_inputadds".local()),
              ],
            ),
          ),
          Expanded(child: Container()),
          NextButton(
              onPressed: _tapNewAdds,
              textStyle: TextStyle(
                fontSize: 16.font,
                fontWeight: FontWeightUtils.medium,
                color: Colors.white,
              ),
              margin: EdgeInsets.only(
                  left: 16.width, right: 16.width, bottom: 16.width),
              bgc: ColorUtils.blueColor,
              title: "minepage_save".local())
        ],
      ),
    );
  }
}
