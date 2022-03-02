import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cstoken/const/constant.dart';
import 'package:cstoken/model/tokens/collection_tokens.dart';
import 'package:cstoken/model/transrecord/trans_record.dart';
import 'package:cstoken/utils/custom_toast.dart';
import 'package:cstoken/utils/date_util.dart';
import 'package:cstoken/utils/extension.dart';
import 'package:cstoken/utils/log_util.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:eth_sig_util/eth_sig_util.dart';

class ETHClient {
  final Web3Client client;
  Credentials? credentials;
  final int? _chainId;

  ETHClient(String url, int chainId)
      : client = Web3Client(url, Client()),
        _chainId = chainId;

  Future<String?> transfer({
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
      Uint8List signedTransaction = await client.signTransaction(
          credentials, ts,
          chainId: _chainId, fetchChainIdFromNetworkId: false);
      final signMessage = bytesToHex(signedTransaction, include0x: true);
      final result = await client.sendRawTransaction(signedTransaction);
      LogUtil.v("Transaction tx $result");
      TransRecordModel model = TransRecordModel();
      model.txid = result;
      model.amount = amount;
      model.fromAdd = from ?? credentials.address.hexEip55;
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
      model.nonce = ts.nonce;
      model.contractTo = ts.to?.hexEip55;
      model.input = ts.data != null ? bytesToHex(ts.data!) : null;
      model.signMessage = signMessage;
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
    try {
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
    } catch (e) {
      HWToast.showText(text: e.toString());
    }
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
