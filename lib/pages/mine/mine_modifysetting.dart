import 'package:cstoken/utils/sp_manager.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../public.dart';

class MineModifySetting extends StatefulWidget {
  MineModifySetting({Key? key, required this.setType}) : super(key: key);
  final int setType;

  @override
  State<MineModifySetting> createState() => _MineModifySettingState();
}

class _MineModifySettingState extends State<MineModifySetting> {
  static String _kName = "kName";
  static String _kState = "kState";

  List<Map> _datas = [];

  @override
  void initState() {
    super.initState();
    _getDatas();
  }

  void _getDatas() async {
    int setType = widget.setType;
    List<Map> data = [];
    if (setType == 0) {
      KCurrencyType type = SPManager.getAppCurrencyMode();
      data = KCurrencyType.values
          .map((e) => {
                _kName: e.value,
                _kState: e == type ? true : false,
              })
          .toList();
    } else {
      KAppLanguage type = SPManager.getAppLanguageMode();
      data = KAppLanguage.values
          .map((e) => {
                _kName: e.value,
                _kState: e == type ? true : false,
              })
          .toList();
    }
    setState(() {
      _datas = data;
    });
  }

  void _cellTap(int index) {
    setState(() {
      for (var element in _datas) {
        element[_kState] = false;
        if (_datas[index] == element) {
          element[_kState] = true;
        }
      }
    });
    if (widget.setType == 0) {
      Provider.of<CurrentChooseWalletState>(context, listen: false)
          .updateCurrencyType(index.getCurrencyType());
    } else {
      SPManager.setAppLanguage(index.getAppLanguageType());
      if (index == 0) {
        context.deleteSaveLocale();
      } else if (index == 1) {
        context.setLocale(Locale('zh', 'CN'));
      } else {
        context.setLocale(Locale('en', 'US'));
      }
    }
    Navigator.pop(context);
  }

  Widget _buildCell(int index) {
    Map result = _datas[index];
    final content = result[_kName];
    final isChoose = result[_kState];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _cellTap(index);
      },
      child: Container(
        height: 56.width,
        color: Colors.white,
        padding: EdgeInsets.only(left: 16.width, right: 16.width),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              content,
              style: TextStyle(
                color: ColorUtils.fromHex("#FF000000"),
                fontWeight: FontWeightUtils.regular,
                fontSize: 16.font,
              ),
            ),
            Visibility(
                visible: isChoose,
                child: LoadAssetsImage(
                  "icons/icon_setchoose.png",
                  width: 20,
                  height: 20,
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context);
    return CustomPageView(
        title: CustomPageView.getTitle(
            title: widget.setType == 0
                ? "minepage_currency".local()
                : "minepage_language".local()),
        backgroundColor: ColorUtils.fromHex("#FFF6F8FF"),
        child: Container(
          margin: EdgeInsets.only(top: 8.width),
          child: ListView.builder(
            itemCount: _datas.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildCell(index);
            },
          ),
        ));
  }
}
