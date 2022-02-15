import 'dart:collection';
import 'dart:convert';
import 'package:cstoken/model/client/ethclient.dart';
import 'package:cstoken/model/dapps_record/dapps_record.dart';
import 'package:cstoken/model/node/node_model.dart';
import 'package:cstoken/model/wallet/tr_wallet_info.dart';
import 'package:cstoken/pages/browser/js_bridge_bean.dart';
import 'package:cstoken/pages/wallet/transfer/payment_sheet_page.dart';
import 'package:cstoken/utils/custom_toast.dart';
import 'package:cstoken/utils/json_util.dart';
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
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    walletAaddress = widget.info?.walletAaddress ?? "";
    _client = ETHClient(widget.node?.content ?? "", widget.node?.chainID ?? 1);
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
    var web3 = await rootBundle.loadString('assets/data/Paytube-min.js');
    final rpcurl = widget.node?.content ?? "";
    final chainId = widget.node?.chainID ?? '';
    if (mounted) {
      setState(() {
        isLoadJs =
            widget.model?.url?.contains("coinwind") == true ? false : true;
        js = web3;
        addd = """
         (function() {
            var config = {
                chainId: '$chainId',
                rpcUrl: '$rpcurl',
                isDebug: true
            };
            window.ethereum = new PayTube.Provider(config);
            window.web3 = new PayTube.Web3(window.ethereum);
            PayTube.postMessage = (jsonString) => {
              alert("$_alertTitle" + JSON.stringify(jsonString || "{}"))
            };
        })();
        """;
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
      String feeToken = widget.info!.coinType!.geCoinType().coinTypeString();
      if (name == 'signTransaction') {
        Map<String, dynamic> object = params["object"];
        BridgeParams bridge = BridgeParams.fromJson(object);
        HWToast.showLoading();
        int price = await _client!.getGasPrice();
        String fee = TRWallet.configFeeValue(
            cointype: 1,
            beanValue: bridge.gas.toString(),
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
                  tr.showLockPin(context,
                      infoCoinType: widget.info!.coinType!.geCoinType(),
                      confirmPressed: (prv) async {
                    final result = await _client!.transferOrigin(
                        prv,
                        bridge.to ?? "",
                        bridge.gas,
                        bridge.data ?? '',
                        bridge.value ?? BigInt.zero);

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
          tr.showLockPin(context,
              infoCoinType: widget.info!.coinType!.geCoinType(),
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
          tr.showLockPin(context,
              infoCoinType: widget.info!.coinType!.geCoinType(),
              confirmPressed: (prv) async {
            final result = await _client!.signTypedMessage(prv, raw);
            _webViewController!.sendResult(result!, id);
          }, cancelPress: () {
            _webViewController!.sendError("Canceled", id);
          });
        });
      }
    } else if (name == 'addEthereumChain') {
      HWToast.showText(text: "dapppage_notsupport".local());
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
    return CustomPageView(
        title: CustomPageView.getTitle(title: widget.model?.name ?? ""),
        safeAreaBottom: false,
        bottom: PreferredSize(
            child: _progressBar(_lineProgress, context),
            preferredSize: const Size.fromHeight(1)),
        leading: CustomPageView.getCloseLeading(() {
          Routers.goBack(context);
        }),
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
                                Share.share(url);
                              }),
                              _getMenuItem("icons/item_white_collect.png",
                                  "dappmenu_collect".local(), () {
                                DAppRecordsDBModel model = widget.model!;
                                model.type = 2;
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
        child: js == null || addd == null
            ? Container(
                color: Colors.white,
              )
            : InAppWebView(
                initialUrlRequest:
                    URLRequest(url: Uri.parse(widget.model?.url ?? '')),
                // initialUrlRequest:
                //     URLRequest(url: Uri.parse("http://js-eth-sign.surge.sh/")),
                // initialUrlRequest:
                //     URLRequest(url: Uri.parse("http://192.168.0.100:3000")),
                // initialUrlRequest: URLRequest(
                //     url: Uri.parse("https://example.walletconnect.org/")),
                initialOptions: options,
                onWebViewCreated: (controller) {
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
                onLoadError: (controller, url, code, message) {
                  LogUtil.v("onLoadError $url $message");
                },
                onLoadStart: (controller, url) {
                  LogUtil.v("onLoadStart $url");
                }));
  }
}
