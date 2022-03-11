import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cstoken/const/constant.dart';
import 'package:cstoken/model/tokens/collection_tokens.dart';
import 'package:cstoken/model/transrecord/trans_record.dart';
import 'package:cstoken/net/chain_services.dart';
import 'package:cstoken/net/request_method.dart';
import 'package:cstoken/utils/custom_toast.dart';
import 'package:cstoken/utils/date_util.dart';
import 'package:cstoken/utils/encode.dart';
import 'package:cstoken/utils/extension.dart';
import 'package:cstoken/utils/json_util.dart';
import 'package:cstoken/utils/log_util.dart';
import 'package:decimal/decimal.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/json_rpc.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:trustdart/trustdart.dart';

class SignTransactionClient {
  final Web3Client client;
  final int? _chainId;

  SignTransactionClient(String url, int chainId)
      : client = Web3Client(url, Client()),
        _chainId = chainId;

  Future<String?> transfer({
    required int coinType,
    required String prv,
    required MCollectionTokens token,
    required String amount,
    required String to,
    required bool isCustomfee,
    required String? data,
    required String? from,
    String? fee,
    int? gasPrice,
    int? maxGas,
    int? nonce,
    String? input,
  }) async {
    try {
      String? result;
      if (coinType == KCoinType.BTC.index) {
        result = await _signBtc(
            prv: prv,
            token: token,
            amount: amount,
            to: to,
            isCustomfee: isCustomfee,
            from: from,
            fee: fee,
            gasPrice: gasPrice,
            maxGas: maxGas,
            nonce: nonce,
            input: input);
      } else if (coinType == KCoinType.TRX.index) {
        result = await _signTRX(
            prv: prv,
            token: token,
            amount: amount,
            to: to,
            isCustomfee: isCustomfee,
            from: from,
            fee: fee,
            gasPrice: gasPrice,
            maxGas: maxGas,
            nonce: nonce,
            input: input);
      } else {
        result = await _signEth(
            prv: prv,
            token: token,
            amount: amount,
            to: to,
            isCustomfee: isCustomfee,
            data: data,
            from: from,
            fee: fee,
            gasPrice: gasPrice,
            maxGas: maxGas,
            nonce: nonce,
            input: input);
      }
      LogUtil.v("Transaction tx $result");
      if (result == null || result.isEmpty) {
        throw "交易失败";
      }
      TransRecordModel model = TransRecordModel();
      model.txid = result;
      model.amount = amount;
      model.fromAdd = from;
      model.date = DateUtil.getNowDateStr();
      model.token = token.token;
      model.coinType = token.coinType;
      model.fee = fee;
      model.gasPrice = gasPrice.toString();
      model.gasLimit = maxGas.toString();
      model.toAdd = to;
      model.transStatus = KTransState.pending.index;
      model.remarks = data;
      model.chainid = _chainId;
      // model.nonce = ts.nonce;
      // model.contractTo = ts.to?.hexEip55;
      // model.input = ts.data != null ? bytesToHex(ts.data!) : null;
      // model.signMessage = signMessage;
      model.repeatPushCount = 0;
      model.transType = KTransType.transfer.index;
      TransRecordModel.insertTrxLists([model]);
      return result;
    } catch (e) {
      LogUtil.v("transfer失败" + e.toString());
      if (e.toString().contains('-32000')) {
        HWToast.showText(text: "gasLow".local());
      } else {
        HWToast.showText(text: e.toString());
      }
    }
  }

  Future<String> _signEth({
    required String prv,
    required MCollectionTokens token,
    required String amount,
    required String to,
    required bool isCustomfee,
    required String? data,
    required String? from,
    required String? fee,
    required int? gasPrice,
    required int? maxGas,
    required int? nonce,
    required String? input,
  }) async {
    final credentials = EthPrivateKey.fromHex(prv);
    Transaction? ts;
    if (token.isToken == false) {
      ts = web3.Transaction(
        to: EthereumAddress.fromHex(to),
        value: EtherAmount.inWei(amount.tokenInt(18)),
        gasPrice: gasPrice == null
            ? null
            : EtherAmount.fromUnitAndValue(EtherUnit.gwei, gasPrice),
        maxGas: isCustomfee == true ? maxGas : null,
        nonce: nonce ??
            await client.getTransactionCount(credentials.address,
                atBlock: const BlockNum.pending()),
        data: input != null
            ? hexToBytes(input)
            : Uint8List.fromList(utf8.encode(data ?? "")),
      );
    } else {
      final contractAddress = EthereumAddress.fromHex(token.contract!);
      final contract = DeployedContract(_erc20Abi, contractAddress);
      final transfer = contract.function('transfer');
      ts = web3.Transaction.callContract(
        contract: contract,
        function: transfer,
        parameters: [
          EthereumAddress.fromHex(to),
          amount.tokenInt(token.decimals!)
        ],
        gasPrice: gasPrice == null
            ? null
            : EtherAmount.fromUnitAndValue(EtherUnit.gwei, gasPrice),
        maxGas: isCustomfee == true ? maxGas : null,
        nonce: nonce ??
            await client.getTransactionCount(credentials.address,
                atBlock: const BlockNum.pending()),
      );
    }
    Uint8List signedTransaction = await client.signTransaction(credentials, ts,
        chainId: _chainId, fetchChainIdFromNetworkId: false);
    final signMessage = bytesToHex(signedTransaction, include0x: true);
    final result = await client.sendRawTransaction(signedTransaction);
    return result;
  }

  Future<String?> _signBtc({
    required String prv,
    required MCollectionTokens token,
    required String amount,
    required String to,
    required bool isCustomfee,
    required String? from,
    required String? fee,
    required int? gasPrice,
    required int? maxGas,
    required int? nonce,
    required String? input,
  }) async {
    String unUrl = "/addrs/$from";
    Map<String, dynamic> params = Map();
    params["unspentOnly"] = true;
    params["includeScript"] = true;
    dynamic result = await ChainServices.requestBTCDatas(
        path: unUrl, method: Method.GET, queryParameters: params);
    if (result == null) {
      return null;
    }
    List txrefs = result["txrefs"];
    List utxos = [];
    for (var item in txrefs) {
      Map params = {};
      params["txid"] = item["tx_hash"];
      params["value"] = item["value"];
      params["script"] = item["script"];
      params["vout"] = item["tx_output_n"];
      utxos.add(params);
    }
    Map btcparams = {
      "utxos": utxos,
      "toAddress": to, //收款人
      "amount": amount.tokenInt(8).toInt(), //金额
      "byteFee": gasPrice, //sat 值
      "changeAddress": from, //找零地址
    };
    String originprv = TREncode.btcWif(prv);
    // originprv = "1ed6e690d72adf846335a4f116471759a2d68041e1bad86e108848ce56d7f340";
    String btcTx = await Trustdart.signTransaction(originprv, 'BTC', btcparams);
    if (btcTx.isEmpty) {
      return "";
    }
    dynamic pushresult = await ChainServices.requestBTCDatas(
        path: "/txs/push", method: Method.POST, data: {"tx": btcTx});
    if (pushresult == null) {
      return "";
    }
    Map pushParams = pushresult as Map;
    if (pushParams.containsKey("error") == true) {
      String error = pushParams["error"];
      throw error;
    } else {
      String hash = pushParams["tx"]["hash"];
      return hash;
    }
  }

  Future<String?> _signTRX({
    required String prv,
    required MCollectionTokens token,
    required String amount,
    required String to,
    required bool isCustomfee,
    required String? from,
    required String? fee,
    required int? gasPrice,
    required int? maxGas,
    required int? nonce,
    required String? input,
  }) async {
    String path = "/wallet/getnowblock";
    dynamic result =
        await ChainServices.requestTRXDatas(path: path, method: Method.GET);
    if (result == null) {
      return null;
    }
    Map raw_data = result["block_header"]["raw_data"];

    String cmd = "";
    String contractAddress = "";
    dynamic assets = amount;
    if (token.tokenType == KTokenType.native.index) {
      cmd = "TRX";
      assets = amount.tokenInt(6).toString();
    } else if (token.tokenType == KTokenType.trc20.index) {
      cmd = "TRC20";
      contractAddress = token.contract ?? '';
      assets = amount
          .tokenInt(token.decimals!)
          .toRadixString(16)
          .padLeft(token.decimals!, "0");
    }

    Map params = {
      "cmd": cmd, // can be TRC20 | TRX | TRC10 | CONTRACT | FREEZE
      "ownerAddress": from, // from address
      "toAddress": to, // to address
      "contractAddress": contractAddress, // in case of Trc20 (Tether USDT)
      "assetName": "", // trc10
      "timestamp": DateTime.now()
          .millisecondsSinceEpoch, // current timestamp (or timestamp as at signing) milliseconds
      "amount":
          assets, // 27 * 1000000, // "004C4B40", // "000F4240" = 1000000 sun hex 2's signed complement
      // (https://www.rapidtables.com/convert/number/hex-to-decimal.html)
      // for asset TRC20 | integer for any other in SUN, 1000000 SUN = 1 TRX
      "feeLimit": 10000000,
      // reference block data to be obtained by querying the blockchain
      "blockTime": raw_data[
          "timestamp"], // timestamp of block to be included milliseconds
      "txTrieRoot": raw_data["txTrieRoot"], // trie root of block
      "witnessAddress":
          raw_data["witness_address"], // address of witness that signed block
      "parentHash": raw_data["parentHash"], // parent hash of block
      "version": raw_data["version"], // block version
      "number": raw_data["number"], // block number
      // freezing
      "frozenDuration": 3, // frozen duration
      "frozenBalance": 10000000, // frozen balance in SUN
      "resource": "ENERGY", // Resource type: BANDWIDTH | ENERGY
    };
    String tx = await Trustdart.signTransaction(prv, 'TRX', params);
    if (tx.isEmpty) {
      return "";
    }

    dynamic pushResult = await ChainServices.requestTRXDatas(
        path: "/wallet/broadcasttransaction",
        method: Method.POST,
        data: JsonUtil.getObj(tx));
    if (pushResult == null) {
      return "";
    }
    Map pushMap = pushResult as Map;
    if (pushMap.containsKey("result") == true) {
      bool sresult = pushMap["result"];
      if (sresult == true) {
        String txid = pushMap["txid"];
        return txid;
      }
    } else {
      String message = pushMap["message"];
      message = TREncode.kHexToUTF8(message);
      throw message;
    }
  }

  Future<String?> signPersonalMessage(String prv, String payload) async {
    final ethSigner = EthPrivateKey.fromHex(prv);
    Uint8List message =
        await ethSigner.signPersonalMessage(hexToBytes(payload));
    return bytesToHex(message, include0x: true);
  }

  Future<String?> transferOrigin({
    required String from,
    required String prv,
    required String to,
    required String data,
    required BigInt amount,
    int? gasLimit,
    String? gasPrice,
    String? fee,
    String? coinType,
  }) async {
    try {
      final credentials = EthPrivateKey.fromHex(prv);
      final signto = EthereumAddress.fromHex(to);
      final input = hexToBytes(data);
      String result = await client.sendTransaction(
          credentials,
          web3.Transaction(
              to: signto,
              value: EtherAmount.inWei(amount),
              gasPrice: null,
              maxGas: gasLimit,
              data: input),
          chainId: _chainId,
          fetchChainIdFromNetworkId: false);

      TransRecordModel model = TransRecordModel();
      model.txid = result;
      model.amount = amount.tokenString(18);
      model.fromAdd = from;
      model.date = DateUtil.getNowDateStr();
      model.token = coinType;
      model.coinType = coinType;
      model.fee = fee;
      model.gasPrice = gasPrice.toString();
      model.gasLimit = gasLimit.toString();
      model.toAdd = to;
      model.transStatus = KTransState.pending.index;
      model.chainid = _chainId;
      // model.nonce = ts.nonce;
      // model.contractTo = ts.to?.hexEip55;
      // model.input = ts.data != null ? bytesToHex(ts.data!) : null;
      // model.signMessage = signMessage;
      model.repeatPushCount = 0;
      model.transType = KTransType.transfer.index;
      TransRecordModel.insertTrxLists([model]);
      return result;
    } catch (e) {
      LogUtil.v("transfer失败" + e.toString());
      if (e.toString().contains('-32000')) {
        HWToast.showText(text: "gasLow".local());
      } else {
        HWToast.showText(text: e.toString());
      }
      return null;
    }
  }

  Future<String?> signTypedMessage(String prv, String jsonData) async {
    String signature = EthSigUtil.signTypedData(
        privateKey: prv, jsonData: jsonData, version: TypedDataVersion.V4);
    return signature;
  }

  Future<int> getGasPrice() async {
    EtherAmount gas = await this.client.getGasPrice();
    int value = gas.getValueInUnit(EtherUnit.gwei).toInt();
    return max(10, value);
  }

  Future<int?> estimateGas({
    String? from,
    String? to,
    String? value,
    EtherAmount? gasPrice,
    EtherAmount? maxPriorityFeePerGas,
    EtherAmount? maxFeePerGas,
    String? data,
  }) async {
    BigInt maxGas = BigInt.zero;
    maxGas = await this.client.estimateGas(
          sender: from != null ? EthereumAddress.fromHex(from) : null,
          to: to != null ? EthereumAddress.fromHex(to) : null,
          data: data != null ? hexToBytes(data) : null,
          value: value != null
              ? EtherAmount.fromUnitAndValue(EtherUnit.ether, value)
              : null,
        );
    return maxGas.toInt();
  }

  Future<TransactionReceipt?> getTransactionReceipt(String hash) {
    return this.client.getTransactionReceipt(hash);
  }

  Future<num> getBalance(String address) async {
    EtherAmount value =
        await this.client.getBalance(EthereumAddress.fromHex(address));
    return value.getValueInUnit(EtherUnit.ether);
  }

  Future<BigInt> getTokenBalance(String address, String contract) {
    final contractAddress = EthereumAddress.fromHex(contract);
    final erc20 = Erc20(address: contractAddress, client: this.client);
    return erc20.balanceOf(EthereumAddress.fromHex(address));
  }

  int? get ChainID => _chainId;
}

final ContractAbi _erc20Abi = ContractAbi('ERC20', [
  const ContractFunction('approve', [
    FunctionParameter('to', AddressType()),
    FunctionParameter('amount', UintType(length: 256)),
  ]),
  const ContractFunction('transfer', [
    FunctionParameter('to', AddressType()),
    FunctionParameter('amount', UintType(length: 256)),
  ]),
  const ContractFunction(
      'allowance',
      [
        FunctionParameter('owner', AddressType()),
        FunctionParameter('spender', AddressType()),
      ],
      outputs: [FunctionParameter('', UintType(length: 256))],
      mutability: StateMutability.view)
], []);
