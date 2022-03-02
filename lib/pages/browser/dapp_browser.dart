import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:cstoken/const/constant.dart';
import 'package:cstoken/model/client/ethclient.dart';
import 'package:cstoken/model/dapps_record/dapps_record.dart';
import 'package:cstoken/model/node/node_model.dart';
import 'package:cstoken/model/wallet/tr_wallet_info.dart';
import 'package:cstoken/pages/browser/js_bridge_bean.dart';
import 'package:cstoken/pages/wallet/transfer/payment_sheet_page.dart';
import 'package:cstoken/utils/custom_toast.dart';
import 'package:cstoken/utils/json_util.dart';
import 'package:cstoken/utils/share_utils.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../public.dart';
import './js_bridge_callback_bean.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class DappBrowser extends StatefulWidget {
  DappBrowser({Key? key, this.model, this.info, this.node}) : super(key: key);
  final DAppRecordsDBModel? model;
  final TRWalletInfo? info;
  final NodeModel? node;

  @override
  _DappBrowserState createState() => _DappBrowserState();
}

class _DappBrowserState extends State<DappBrowser> {
  double _lineProgress = 0.0;
  String? js;
  String? addd;
  bool isLoadJs = false;
  String walletAaddress = "";

  final _alertTitle = "messagePayTube";
  ETHClient? _client;
  CustomPopupMenuController _controller = CustomPopupMenuController();
  int? _type;

  InAppWebViewController? _webViewController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        userAgent:
            "Mozilla/5.0 (Linux; Android 4.4.4; SAMSUNG-SM-N900A Build/tt) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/33.0.0.0 Mobile Safari/537.36",
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
        domStorageEnabled: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  KCoinType? _coinType;
  NodeModel? _node;
  TRWalletInfo? _info;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _type = widget.model!.type;
    _coinType = widget.info?.coinType!.geCoinType();
    walletAaddress = widget.info?.walletAaddress ?? "";
    _node = widget.node;
    _client = ETHClient(widget.node?.content ?? "", widget.node?.chainID ?? 1);
    _loadWeb3();
  }

  void _loadWallet(String walletID, int coinType) async {
    setState(() {
      isLoadJs = false;
    });
    _info = (await TRWalletInfo.queryWalletInfo(walletID, coinType)).first;
    _coinType = widget.info?.coinType!.geCoinType();
    walletAaddress = _info?.walletAaddress ?? "";
    _node = NodeModel.queryNodeByChainType(coinType);
    _client = ETHClient(_node?.content ?? "", _node?.chainID ?? 1);
    // _webViewController?.removeAllUserScripts();
    _loadWeb3();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  _loadWeb3() async {
    var web3 = await rootBundle.loadString('assets/data/trust-min.js');
    String rpcurl = _node?.content ?? "";
    int chainId = _node?.chainID ?? 0;
    var config = """
         (function() {
           var config = {
                chainId: $chainId,
                rpcUrl: "$rpcurl",
                address: "$walletAaddress",
                isDebug: true
            };
            window.ethereum = new trustwallet.Provider(config);
            window.web3 = new trustwallet.Web3(window.ethereum);
            trustwallet.postMessage = (jsonString) => {
               alert("$_alertTitle" + JSON.stringify(jsonString || "{}"))
            };
        })();
        """;
    await Future.delayed(Duration(seconds: 3));
    if (mounted) {
      setState(() {
        js = web3;
        addd = config;
        isLoadJs = true;
      });
    }
  }

  // ///返回结果
  void _jsBridgeCallBack(String message) async {
    TRWallet tr = Provider.of<CurrentChooseWalletState>(context, listen: false)
        .currentWallet!;
    Map<dynamic, dynamic> params = JsonUtil.getObj(message);
    final id = params["id"];
    final name = params["name"];
    if (name == 'requestAccounts' || name == 'eth_requestAccounts') {
      _webViewController!.setAddress(walletAaddress, id);
    } else if (name == 'signTransaction' ||
        name == 'signMessage' ||
        name == 'signPersonalMessage' ||
        name == 'signTypedMessage') {
      String from = walletAaddress;
      String feeToken = _coinType!.feeTokenString();
      if (name == 'signTransaction') {
        Map<String, dynamic> object = params["object"];
        BridgeParams bridge = BridgeParams.fromJson(object);
        HWToast.showLoading();
        String? price = (bridge.gasPrice == null)
            ? (await _client!.getGasPrice()).toString()
            : bridge.gasPrice;
        int? maxGas = bridge.gas ??
            await _client!.estimateGas(
              from: from,
              to: bridge.to,
              data: bridge.data,
            );
        String fee = TRWallet.configFeeValue(
            cointype: 1,
            beanValue: maxGas.toString(),
            offsetValue: price.toString());
        HWToast.hiddenAllToast();
        showModalBottomSheet(
            context: context,
            elevation: 0,
            isDismissible: true,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            builder: (_) {
              return PaymentSheet(
                datas: PaymentSheet.getTransStyleList(
                  from: bridge.from ?? "",
                  to: bridge.to ?? '',
                  remark: '',
                  fee: fee + " $feeToken",
                ),
                amount: (bridge.value ?? BigInt.zero).tokenString(18) +
                    " $feeToken",
                nextAction: () {
                  tr.showLockPin(context, infoCoinType: _coinType,
                      confirmPressed: (prv) async {
                    final result = await _client!.transferOrigin(
                      prv: prv,
                      to: bridge.to ?? "",
                      gasLimit: maxGas,
                      data: bridge.data ?? '',
                      amount: bridge.value ?? BigInt.zero,
                      fee: fee,
                      gasPrice: price,
                      from: from,
                      coinType: _coinType!.feeTokenString(),
                    );

                    _webViewController!.sendResult(result!, id);
                  }, cancelPress: () {
                    _webViewController!.sendError("Canceled", id);
                  });
                },
                cancelAction: () {
                  _webViewController!.sendError("Canceled", id);
                },
              );
            });
      } else if (name == 'signMessage' || name == 'signPersonalMessage') {
        final object = params["object"];
        final data = object["data"];
        ShowCustomAlert.showCustomAlertType(context, KAlertType.text, name, tr,
            subtitleText: utf8.decode(TREncode.kHexToBytes(data)),
            rightButtonStyle: TextStyle(
              color: ColorUtils.blueColor,
              fontSize: 16.font,
            ),
            rightButtonRadius: 8,
            rightButtonTitle: "walletssetting_modifyok".local(),
            cancelPressed: () {
          _webViewController!.sendError("Canceled", id);
        }, confirmPressed: (result) async {
          tr.showLockPin(context, infoCoinType: _coinType,
              confirmPressed: (prv) async {
            String? result = await _client!.signPersonalMessage(prv, data);
            _webViewController!.sendResult(result!, id);
          }, cancelPress: () {
            _webViewController!.sendError("Canceled", id);
          });
        });
      } else {
        final object = params["object"];
        final raw = object["raw"];

        ShowCustomAlert.showCustomAlertType(context, KAlertType.text, name, tr,
            subtitleText: JsonUtil.encodeObj(object),
            rightButtonStyle: TextStyle(
              color: ColorUtils.blueColor,
              fontSize: 16.font,
            ),
            rightButtonRadius: 8,
            rightButtonTitle: "walletssetting_modifyok".local(),
            cancelPressed: () {
          _webViewController!.sendError("Canceled", id);
        }, confirmPressed: (result) {
          tr.showLockPin(context, infoCoinType: _coinType,
              confirmPressed: (prv) async {
            final result = await _client!.signTypedMessage(prv, raw);
            _webViewController!.sendResult(result!, id);
          }, cancelPress: () {
            _webViewController!.sendError("Canceled", id);
          });
        });
      }
    } else if (name == 'addEthereumChain') {
      Map<String, dynamic> object = params["object"];
      String hexchainId = object["chainId"];
      hexchainId = hexchainId.replaceAll("0x", "");
      int chainId = int.parse(hexchainId, radix: 16);
      KCoinType type = chainId.chainGetCoinType();
      String walletid = widget.info!.walletID!;
      _loadWallet(walletid, type.index);
      // HWToast.showText(text: "dapppage_notsupport".local());
    }
  }

  _progressBar(double progress, BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Colors.transparent,
      value: progress,
      minHeight: 2,
      valueColor: progress == 1
          ? const AlwaysStoppedAnimation<Color>(Colors.transparent)
          : const AlwaysStoppedAnimation<Color>(ColorUtils.blueColor),
    );
  }

  Widget _getMenuItem(String itemIcon, String title, VoidCallback callBack) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _controller.hideMenu();
        callBack();
      },
      child: Container(
        height: 48.width,
        padding: EdgeInsets.symmetric(horizontal: 16.width),
        child: Row(
          children: <Widget>[
            LoadAssetsImage(itemIcon, width: 20, height: 20),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 4),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.font,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String url = widget.model?.url ?? '';

    return CustomPageView(
        title: Row(
          children: [
            CustomPageView.getCloseLeading(() {
              Routers.goBack(context);
            }),
            Expanded(
              child: Center(
                  child:
                      CustomPageView.getTitle(title: widget.model?.name ?? "")),
            ),
            const SizedBox(
              width: 24,
            )
          ],
        ),
        leadBack: () async {
          bool? canGo = await _webViewController?.canGoBack();
          if (canGo == true) {
            _webViewController?.goBack();
          } else {
            Routers.goBack(context);
          }
        },
        safeAreaBottom: false,
        bottom: PreferredSize(
            child: _progressBar(_lineProgress, context),
            preferredSize: const Size.fromHeight(1)),
        actions: [
          CustomPopupMenu(
              menuBuilder: () => ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      color: ColorUtils.fromHex("#FF000000").withOpacity(0.7),
                      child: IntrinsicWidth(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _getMenuItem("icons/item_white_share.png",
                                  "dappmenu_share".local(), () {
                                String url = widget.model?.url ?? "";
                                ShareUtils.share(context, url);
                              }),
                              _getMenuItem(
                                  "icons/item_white_collect.png",
                                  (_type == 0 || _type == null)
                                      ? "dappmenu_collect".local()
                                      : "dappmenu_cancollect".local(), () {
                                DAppRecordsDBModel model = widget.model!;
                                if (_type == KDappType.records.index) {
                                  _type = KDappType.recordsandcollect.index;
                                } else if (_type == KDappType.collect.index) {
                                  _type = KDappType.records.index;
                                } else if (_type ==
                                    KDappType.recordsandcollect.index) {
                                  _type = KDappType.records.index;
                                } else {
                                  _type = KDappType.collect.index;
                                }
                                model.type = _type;
                                DAppRecordsDBModel.insertRecords(model);
                                setState(() {});
                              }),
                              _getMenuItem("icons/item_white_copy.png",
                                  "dappmenu_copy".local(), () {
                                String url = widget.model?.url ?? "";
                                url.copy();
                              }),
                              _getMenuItem("icons/item_white_refresh.png",
                                  "dappmenu_refresh".local(), () {
                                _webViewController?.reload();
                              }),
                            ]),
                      ),
                    ),
                  ),
              pressType: PressType.singleClick,
              verticalMargin: -10,
              controller: _controller,
              child: Padding(
                padding: EdgeInsets.only(right: 16.width),
                child: Center(
                  child: Image.asset(
                    ASSETS_IMG + "icons/icon_blue_three.png",
                    width: 24,
                    height: 24,
                  ),
                ),
              )),
        ],
        child: isLoadJs == false
            ? Container()
            : InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(url)),
                initialOptions: options,
                onWebViewCreated: (controller) async {
                  _webViewController = controller;
                },
                initialUserScripts: isLoadJs == true
                    ? UnmodifiableListView([
                        UserScript(
                            source: js ?? "",
                            injectionTime:
                                UserScriptInjectionTime.AT_DOCUMENT_START),
                        UserScript(
                            source: addd ?? "",
                            injectionTime:
                                UserScriptInjectionTime.AT_DOCUMENT_START),
                      ])
                    : null,
                androidOnPermissionRequest:
                    (controller, origin, resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },
                onJsAlert: (controller, request) {
                  print("收到js alert ${request.message}");
                  final message = request.message;
                  bool handledByClient = false;
                  if (message?.contains(_alertTitle) == true) {
                    handledByClient = true;
                    _jsBridgeCallBack(
                        request.message!.replaceFirst(_alertTitle, ""));
                  }
                  return Future.value(JsAlertResponse(
                      message: message ?? "",
                      handledByClient: handledByClient));
                },
                onProgressChanged: (controller, progress) {
                  LogUtil.v("progress $progress");
                  setState(() {
                    _lineProgress = progress / 100;
                  });
                },
                onConsoleMessage: (controller, consoleMessage) {
                  // LogUtil.v("consoleMessage ${consoleMessage.message}");
                },
                onLoadError: (controller, url, code, message) {
                  LogUtil.v("onLoadError $url $message");
                },
                onLoadStop: (controller, url) async {},
                onLoadStart: (controller, url) async {
                  LogUtil.v("onLoadStart $url");
                  if (isAndroid) {
                    _webViewController!
                        .evaluateJavascript(source: js!)
                        .then((value) => {});
                    _webViewController!
                        .evaluateJavascript(source: addd!)
                        .then((value) => {});
                  }
                }));
  }
}
