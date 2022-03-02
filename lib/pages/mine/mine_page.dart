import 'package:cstoken/component/mine_list_cell.dart';
import 'package:cstoken/model/contacts/contact_address.dart';
import 'package:cstoken/pages/mine/mine_contacts.dart';
import 'package:cstoken/pages/mine/mine_feeback.dart';
import 'package:cstoken/pages/mine/mine_message.dart';
import 'package:cstoken/pages/mine/mine_version.dart';
import 'package:cstoken/pages/wallet/wallets/wallets_setting.dart';
import 'package:cstoken/utils/custom_toast.dart';
import 'package:cstoken/utils/sp_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:package_info/package_info.dart';

import '../../public.dart';
import 'mine_modifysetting.dart';

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

  void _initData() async {
    _datas.clear();
    String contract = "minepage_contactadds".local(context: context);
    String safe = "minepage_safetysetting".local(context: context);
    String walletsetting = "minepage_walletssetting".local(context: context);
    String currency = "minepage_currency".local(context: context);
    String language = "minepage_language".local(context: context);
    String feedback = "minepage_feedback".local(context: context);
    String version = "minepage_version".local(context: context);

    List<ContactAddress> datas = await ContactAddress.queryAllAddress();
    _datas.add(MinePageData(
        "mine/mine_contact.png", contract, datas.length.toString(), onTap: () {
      Routers.push(context, MineContacts()).then((value) => {
            _initData(),
          });
    }));
    // _datas.add(MinePageData("mine/mine_anquan.png", safe, ""));
    _datas.add(MinePageData("mine/mine_walletset.png", walletsetting, "",
        onTap: () async {
      Provider.of<CurrentChooseWalletState>(context, listen: false)
          .tapWalletSetting(context);
    }));

    String currencyValue = SPManager.getAppCurrencyMode().value;
    _datas.add(MinePageData("mine/mine_currency.png", currency, currencyValue,
        onTap: () {
      Routers.push(context, MineModifySetting(setType: 0)).then((value) => {
            _initData(),
          });
    }));

    String lanValue = SPManager.getAppLanguageMode().value;
    _datas.add(
        MinePageData("mine/mine_language.png", language, lanValue, onTap: () {
      Routers.push(context, MineModifySetting(setType: 1)).then((value) => {
            _initData(),
          });
    }));
    // _datas.add(MinePageData("mine/mine_feedback.png", feedback, "", onTap: () {
    //   Routers.push(context, MineFeedBack());
    // }));
    final PackageInfo appInfo = await PackageInfo.fromPlatform();
    String appversion = appInfo.version;
    _datas.add(
        MinePageData("mine/mine_version.png", version, appversion, onTap: () {
      Routers.push(context, MineVersion());
    }));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context);
    return CustomPageView(
        hiddenLeading: true,
        title: CustomPageView.getTitle(title: "minepage_minetitle".local()),
        backgroundColor: ColorUtils.backgroudColor,
        actions: [
          // CustomPageView.getMessage(() {
          //   Routers.push(context, MineMessagePage());
          // }),
        ],
        child: Column(
          children: [
            Expanded(
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
            ),
            Container(
              child: RichText(
                text: TextSpan(
                    text: "minepage_currentnet".local() + "：",
                    style: TextStyle(
                      color: ColorUtils.fromHex("#FF7685A2"),
                      fontSize: 14.font,
                    ),
                    children: [
                      TextSpan(
                        text: SPManager.getNetType().value,
                        style: TextStyle(
                            color: ColorUtils.fromHex("#FF7685A2"),
                            fontSize: 14.font,
                            fontWeight: FontWeightUtils.semiBold),
                      )
                    ]),
              ),
            ),
            NextButton(
              onPressed: () {
                KNetType net = SPManager.getNetType() == KNetType.Mainnet
                    ? KNetType.Testnet
                    : KNetType.Mainnet;

                if (net == KNetType.Testnet) {
                  ShowCustomAlert.showCustomAlertType(
                      context, KAlertType.text, null, null,
                      subtitleText: "minepage_modifytestnet".local(),
                      leftButtonTitle: "minepage_staymain".local(),
                      rightButtonTitle: "minepage_modifytest".local(),
                      leftButtonStyle: TextStyle(
                        color: ColorUtils.blueColor,
                        fontSize: 16.font,
                      ),
                      rightButtonStyle: TextStyle(
                        color: ColorUtils.blueColor,
                        fontSize: 16.font,
                      ), confirmPressed: (result) {
                    SPManager.setNetType(net);
                    setState(() {});
                  });
                  return;
                }
                SPManager.setNetType(net);
                setState(() {});
              },
              bgc: ColorUtils.blueBGColor,
              margin: EdgeInsets.only(top: 8.width, bottom: 40.width),
              height: 30,
              borderRadius: 4,
              width: 120.width,
              textStyle: TextStyle(
                color: ColorUtils.blueColor,
                fontSize: 12.font,
              ),
              title: "minepage_modify".local() +
                  (SPManager.getNetType() == KNetType.Mainnet
                      ? KNetType.Testnet.value
                      : KNetType.Mainnet.value),
            ),
          ],
        ));
  }
}
