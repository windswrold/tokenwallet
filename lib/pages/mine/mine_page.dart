import 'package:cstoken/component/mine_list_cell.dart';
import 'package:cstoken/pages/mine/mine_contacts.dart';

import '../../public.dart';

class MinePageData {
  final String imgName;
  final String leftContent;
  final String content;
  final VoidCallback? onTap;

  MinePageData(this.imgName, this.leftContent, this.content, {this.onTap});
}

class MinePage extends StatefulWidget {
  MinePage({Key? key}) : super(key: key);

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  List<MinePageData> _datas = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData();
  }

  void _initData() {
    String contract = "minepage_contactadds".local();
    String safe = "minepage_safetysetting".local();
    String walletsetting = "minepage_walletssetting".local();
    String currency = "minepage_currency".local();
    String language = "minepage_language".local();
    String feedback = "minepage_feedback".local();
    String version = "minepage_version".local();

    _datas.add(MinePageData("mine/mine_contact.png", contract, "", onTap: () {
      Routers.push(context, MineContacts());
    }));
    _datas.add(MinePageData("mine/mine_anquan.png", safe, ""));
    _datas.add(MinePageData("mine/mine_walletset.png", walletsetting, ""));
    _datas.add(MinePageData("mine/mine_currency.png", currency, ""));
    _datas.add(MinePageData("mine/mine_language.png", language, ""));
    _datas.add(MinePageData("mine/mine_feedback.png", feedback, ""));
    _datas.add(MinePageData("mine/mine_version.png", version, ""));
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      hiddenLeading: true,
      title: CustomPageView.getTitle(title: "minepage_minetitle".local()),
      backgroundColor: ColorUtils.backgroudColor,
      actions: [
        CustomPageView.getMessage(() {}),
      ],
      child: ListView.builder(
        padding: EdgeInsets.only(top: 8.width),
        itemCount: _datas.length,
        itemBuilder: (BuildContext context, int index) {
          MinePageData _mine = _datas[index];
          return MineListViewCell(
            iconName: _mine.imgName,
            leftTitle: _mine.leftContent,
            content: _mine.content,
            onTap: _mine.onTap,
          );
        },
      ),
    );
  }
}
