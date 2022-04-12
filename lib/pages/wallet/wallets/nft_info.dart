import 'package:cstoken/component/empty_data.dart';
import 'package:cstoken/model/client/sign_client.dart';
import 'package:cstoken/net/chain_services.dart';
import 'package:cstoken/net/wallet_services.dart';
import 'package:cstoken/pages/wallet/transfer/transfer_payment.dart';
import 'package:cstoken/utils/custom_toast.dart';

import '../../../public.dart';

class NFTInfo extends StatefulWidget {
  NFTInfo({Key? key, required this.nftModel, required this.tokenid})
      : super(key: key);
  final Map nftModel;
  final String tokenid;

  @override
  State<NFTInfo> createState() => _NFTInfoState();
}

class _NFTInfoState extends State<NFTInfo> {
  Map? _infos;
  @override
  void initState() {
    super.initState();
    _getNftInfo();
  }

  void _getNftInfo() async {
    HWToast.showLoading();
    String contractAddress = widget.nftModel["contractAddress"];
    String chainTypeName = widget.nftModel["chainTypeName"];
    KCoinType coinType = chainTypeName.chainTypeGetCoinType()!;
    Map params =
        SignTransactionClient.get721TokenURI(contractAddress, widget.tokenid);
    dynamic result =
        await ChainServices.requestNFTInfo(coinType: coinType, qparams: params);

    HWToast.hiddenAllToast();
    if (result == null || result is! Map) {
      return;
    }
    setState(() {
      _infos = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: CustomPageView.getTitle(title: "homepage_nftinfo".local()),
      child: Column(
        children: [
          _infos == null
              ? Expanded(child: EmptyDataPage())
              : Expanded(
                  child: Column(
                  children: [
                    Expanded(
                      child: LoadTokenAssetsImage(
                        WalletServices.getIpfsImageUrl(
                          _infos!["image"] ?? '',
                        ),
                        isNft: true,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(
                            left: 16.width, right: 16.width, top: 16.width),
                        child: Text(
                          _infos!["description"] ?? '',
                          style: TextStyle(
                            fontSize: 14.font,
                            color: Color.fromARGB(255, 183, 183, 183),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          NextButton(
            bgc: ColorUtils.blueColor,
            textStyle: TextStyle(
              fontSize: 16.font,
              fontWeight: FontWeightUtils.medium,
              color: Colors.white,
            ),
            margin: EdgeInsets.only(
                left: 16.width, right: 16.width, bottom: 16.width),
            onPressed: () {
              Routers.push(context, TransferPayment());
            },
            title: "homepage_send".local(),
          ),
        ],
      ),
    );
  }
}
