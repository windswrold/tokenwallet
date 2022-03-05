import 'package:cstoken/pages/tabbar/tabbar.dart';
import 'package:cstoken/public.dart';
import 'package:cstoken/state/wallet_state.dart';
import 'package:cstoken/utils/sp_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'component/custom_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:trustdart/trustdart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;

// class MyApp extends StatefulWidget {
//   //launch
//   //tabbar
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final CurrentChooseWalletState _walletState = CurrentChooseWalletState();
//   @override
//   void initState() {
//     super.initState();
//     getSkip();
//     _getLanguage();
//   }

//   void getSkip() async {
//     _walletState.loadWallet();
//   }

//   void _getLanguage() {
//     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
//       if (SPManager.getAppLanguageMode() == KAppLanguage.system) {
//         Locale first = context.deviceLocale;
//         for (var element in context.supportedLocales) {
//           if (element.languageCode.contains(first.languageCode)) {
//             LogUtil.v("element " + element.languageCode);
//             context.setLocale(element);
//             SPManager.setSystemAppLanguage(element.languageCode == "zh"
//                 ? KAppLanguage.zh_cn
//                 : KAppLanguage.en_us);
//           }
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//         designSize: const Size(375, 667),
//         builder: () => MultiProvider(
//                 providers: [
//                   ChangeNotifierProvider.value(value: _walletState),
//                 ],
//                 child: CustomApp(
//                   child: HomeTabbar(),
//                 )));
//     ;
//   }
// }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1)).then((value) => {
      _controller.text = "11111",
    });
  }

//f33e86906e93690567a58af681ceabf10fe64bb9b441fe847fd5629d6f262973

  Map _getBitcoinSendOperation() {
    // https://blockchain.info/unspent?active=35oxCr5Edc2VjoQkX65TPzxUVGXJ7r4Uny
    // https://blockchain.info/unspent?active=bc1qxjth4cj6j2v04s07au935547qk9tzd635hkt3n
    return {
      "utxos": [
        {
          "txid":
              "fce42021fd2d2fa793dc3d5d6520fc853e327e5c2c638c3a0be7529c559d3536",
          "vout": 1,
          "value": 4500,
          "script": "001434977ae25a9298fac1feef0b1a52be058ab13751",
        },
      ],
      "toAddress": "15o5bzVX58t1NRvLchBUGuHscCs1sumr2R",
      "amount": 3000,
      "fees": 1000,
      "changeAddress": "15o5bzVX58t1NRvLchBUGuHscCs1sumr2R",
      "change": 500
    };
  }

  Map _getTronOperation() {
    return {
      "cmd": "TRC20", // can be TRC20 | TRX | TRC10 | CONTRACT | FREEZE
      "ownerAddress": "TYjYrDy7yE9vyJfnF5S3EfPrzfXM3eehri", // from address
      "toAddress": "TJpQNJZSktSZQgEthhBapH3zmvg3RaCbKW", // to address
      "contractAddress":
          "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t", // in case of Trc20 (Tether USDT)
      "timestamp": DateTime.now()
          .millisecondsSinceEpoch, // current timestamp (or timestamp as at signing) milliseconds
      "amount":
          "000F4240", // 27 * 1000000, // "004C4B40", // "000F4240" = 1000000 sun hex 2's signed complement
      // (https://www.rapidtables.com/convert/number/hex-to-decimal.html)
      // for asset TRC20 | integer for any other in SUN, 1000000 SUN = 1 TRX
      "feeLimit": 10000000,
      // reference block data to be obtained by querying the blockchain
      "blockTime":
          1638519600000, // timestamp of block to be included milliseconds
      "txTrieRoot":
          "5807aea383e7de836af95c8b36e22654e4df33e5b92768e55fb936f8a7ae5304", // trie root of block
      "witnessAddress":
          "41e5e572797a3d479030e2596a239bd142a890a305", // address of witness that signed block
      "parentHash":
          "0000000002254183f6d15ba4115b3a5e8a8359adc663f7e6f02fa2bd51c07055", // parent hash of block
      "version": 23, // block version
      "number": 35996036, // block number
      // freezing
      "frozenDuration": 3, // frozen duration
      "frozenBalance": 10000000, // frozen balance in SUN
      "resource": "ENERGY", // Resource type: BANDWIDTH | ENERGY
      "assetName": "ALLOW_SAME_TOKEN_NAME"
    };
  }

  Map _getSolOperation() {
    // return {
    //   "recentBlockhash": "C6oRG8fykBeM7sL5eYyqRSZp9m2QdkGHQqtE8nTszURZ",
    //   "transferTransaction": {"recipient": "CiFADrjcd1acfVqg7hU1jpbNsdNkiUAexY9mRutsQUoR", "value": "250000"}
    // };
    return {
      "recentBlockhash": "EjUjs69fQ7JG1aHwrzMET2YqTe6PMMbtbHvCEtzvDZsJ",
      "tokenTransferTransaction": {
        "tokenMintAddress": "Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB",
        "senderTokenAddress": "7LKVpn2ZP9L7PkyFGApri9xEqUv4N8U8QCRyMHrCZqju",
        "recipientTokenAddress": "88mvV5z4gvbn7ZXcKvnCDJuoUaALis54auijidhjTbJT",
        "amount": "200000",
        "decimals": "6"
      }
    };
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      String dondo =
          "imitate embody law mammal exotic transfer roof hope price swift ordinary uncle";
      // dondo = "a d f d s e w q t y u l";
      bool wallet = await Trustdart.checkMnemonic(dondo);

      // https://github.com/satoshilabs/slips/blob/master/slip-0044.md
      String btcPath = "m/44'/0'/0'/0/0";
      String trxPath = "m/44'/195'/0'/0/0";
      String solPath = "m/44'/501'/0'/0/0";

      String btcPrivKey = await Trustdart.getPrivateKey(
        dondo,
        'BTC',
        btcPath,
      );

      String trxPrivKey = await Trustdart.getPrivateKey(
        dondo,
        'TRX',
        trxPath,
      );
      String solPrivKey = await Trustdart.getPrivateKey(
        dondo,
        'SOL',
        solPath,
      );
      print("btcPrivKey $btcPrivKey");
      print("trxPrivKey $trxPrivKey");
      print("solPrivKey $solPrivKey");

      // var seed = bip39.mnemonicToSeed(dondo);
      // var root = bip32.BIP32.fromSeed(seed,bip32.NetworkType(wif: wif, bip32: bip32));
      // var child = root.derivePath(btcPath);
      // final prv = child.privateKey;
      // final xxxx = TREncode.kBytesToHex(prv!, include0x: false);
      // print("btcPrivKey $xxxx");

      Map btcAddress = await Trustdart.generateAddress(
        dondo,
        'BTC',
        btcPath,
      );

      Map trxAddress = await Trustdart.generateAddress(
        dondo,
        'TRX',
        trxPath,
      );
      Map solAddress = await Trustdart.generateAddress(
        dondo,
        'SOL',
        solPath,
      );
      print("btcAddress $btcAddress");
      print("trxAddress $trxAddress");
      print("solAddress $solAddress");

      bool isBtcLegacyValid = await Trustdart.validateAddress(
        'BTC',
        btcAddress['legacy'],
      );
      bool isBtcSegWitValid = await Trustdart.validateAddress(
        'BTC',
        btcAddress['segwit'],
      );

      bool isTrxValid = await Trustdart.validateAddress(
        'TRX',
        trxAddress['legacy'],
      );
      bool isSolValid = await Trustdart.validateAddress(
        'SOL',
        solAddress['legacy'],
      );

      String btcTx = await Trustdart.signTransaction(
          dondo, 'BTC', btcPath, _getBitcoinSendOperation());
      String trxTx = await Trustdart.signTransaction(
          dondo, 'TRX', trxPath, _getTronOperation());
      String solTx = await Trustdart.signTransaction(
          dondo, 'SOL', solPath, _getSolOperation());
      print("btcTx " + btcTx);
      print("trxTx " + trxTx);
      print("solTx " + solTx);
    } catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        // body: SingleChildScrollView(
        //   child: Column(
        //     children: [
        //       Container(
        //         height: 500,
        //         color: Colors.red,
        //       ),
        //       Container(
        //         height: 500,
        //         color: Colors.blue,
        //       ),
        //       TextField(
        //         controller: _controller,
        //       )
        //     ],
        //   ),
        // ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: Colors.red,
                  primary: Colors.black,
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  initPlatformState();
                },
                child: const Text('Create a new multi-coin wallet'),
              ),
            ),
            Container(
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: Colors.yellow,
                  primary: Colors.black,
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {},
                child: const Text('Generate the default addresses.'),
              ),
            ),
            Container(
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: Colors.green,
                  primary: Colors.black,
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {},
                child: const Text('Sign transactions for sending.'),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
