import 'dart:async';

import 'package:cstoken/component/custom_refresher.dart';
import 'package:cstoken/component/empty_data.dart';
import 'package:cstoken/component/trasnfer_listcell.dart';
import 'package:cstoken/model/node/node_model.dart';
import 'package:cstoken/model/tokens/collection_tokens.dart';
import 'package:cstoken/model/transrecord/trans_record.dart';
import 'package:cstoken/model/wallet/tr_wallet_info.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../public.dart';

class TransferListContent extends StatefulWidget {
  TransferListContent({Key? key, required this.type}) : super(key: key);
  final int type;

  @override
  State<TransferListContent> createState() => _TransferListContentState();
}

class _TransferListContentState extends State<TransferListContent>
    with AutomaticKeepAliveClientMixin {
  RefreshController refreshController = RefreshController();

  List<TransRecordModel> _dappListData = [];
  MCollectionTokens? tokens;
  TRWalletInfo? trWalletInfo;
  StreamSubscription? _transupTE;
  int? chainid;
  void initState() {
    // TODO: implement initState
    super.initState();

    _transupTE = eventBus.on<MtransListUpdate>().listen((event) {
      _initData();
    });

    tokens = Provider.of<CurrentChooseWalletState>(context, listen: false)
        .chooseTokens();
    trWalletInfo = Provider.of<CurrentChooseWalletState>(context, listen: false)
        .walletinfo;
    chainid = NodeModel.queryNodeByChainType(trWalletInfo!.coinType!).chainID;
    LogUtil.v("initState " + widget.type.toString());
    _initData();
  }

  @override
  void dispose() {
    _transupTE?.cancel();
    super.dispose();
  }

  void _initData() async {
    List<TransRecordModel> datas = await TransRecordModel.queryTrxList(
        trWalletInfo?.walletAaddress ?? "",
        tokens?.token ?? "",
        chainid!,
        widget.type);
    setState(() {
      _dappListData = datas;
    });
    refreshController.loadComplete();
    refreshController.refreshCompleted(resetFooterState: true);
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefresher(
        onRefresh: () {
          _initData();
        },
        enableFooter: false,
        child: _dappListData.length == 0
            ? EmptyDataPage()
            : ListView.builder(
                itemCount: _dappListData.length,
                itemBuilder: (BuildContext tx, int index) {
                  TransRecordModel model = _dappListData[index];
                  return TransferListCell(
                    model: model,
                    from: trWalletInfo?.walletAaddress ?? "",
                  );
                },
              ),
        refreshController: refreshController);
  }

  // @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
