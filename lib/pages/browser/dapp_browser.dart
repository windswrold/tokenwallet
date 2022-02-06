import 'dart:collection';
import 'dart:convert';
import 'package:cstoken/model/dapps_record/dapps_record.dart';
import 'package:cstoken/pages/browser/js_bridge_bean.dart';
import 'package:cstoken/utils/json_util.dart';
import 'package:flutter/services.dart';
import '../../public.dart';
import './js_bridge_callback_bean.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class DappBrowser extends StatefulWidget {
  DappBrowser({Key? key, this.model}) : super(key: key);
  final DAppRecordsDBModel? model;

  @override
  _DappBrowserState createState() => _DappBrowserState();
}

class _DappBrowserState extends State<DappBrowser> {
  double _lineProgress = 0.0;
  String? js;
  String? addd;
  bool isLoadJs = false;

  final _alertTitle = "messagePayTube";

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
    final rpcurl = "";
    final walletAaddress = "";
    final chainId = "";
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
    // {"id":4,"name":"signMessage","object":{"data":"0xfc6b770d8c80e6324d08282e66604ffb787c444b139e90414e1a54be5fd06b87"}}

    Map<dynamic, dynamic> params = JsonUtil.getObj(message);
    final id = params["id"];
    final name = params["name"];
    if (name == 'signTransaction') {
      Map<String, dynamic> object = params["object"];
      BridgeParams bridge = BridgeParams.fromJson(object);

      // _webViewController!.sendResult(tx, id);

    } else if (name == 'signMessage' || name == 'signPersonalMessage') {
      final object = params["object"];
      final data = object["data"];
    } else if (name == 'requestAccounts' || name == 'eth_requestAccounts') {}
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

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
        title: CustomPageView.getTitle(title: widget.model?.name ?? ""),
        bottom: PreferredSize(
            child: _progressBar(_lineProgress, context),
            preferredSize: const Size.fromHeight(1)),
        leading: CustomPageView.getCloseLeading(() {
          Routers.goBack(context);
        }),
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
                  LogUtil.v("收到js alert ${request.message}");
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
