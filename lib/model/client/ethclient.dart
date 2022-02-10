import 'dart:convert';
import 'dart:ffi';
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
    int? gasPrice,
    int? maxGas,
    int? nonce,
    String? input,
    String? from,
    String? fee,
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
      model.fromAdd = from;
      model.date = DateUtil.getNowDateStr();
      model.symbol = token.token;
      model.coinType = token.coinType;
      model.fee = fee;
      model.gasPrice = gasPrice.toString();
      model.gasLimit = maxGas.toString();
      model.toAdd = to;
      model.transStatus = MTransState.MTransState_Pending.index;
      model.remarks = data;
      model.chainid = _chainId;
      model.nonce = ts.nonce;
      model.signTo = to; //收款人的to
      model.input = ts.data != null ? bytesToHex(ts.data!) : null;
      model.signMessage = signMessage;
      model.repeatPushCount = 0;
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

  Future<int> getGasPrice() async {
    EtherAmount gas = await this.client.getGasPrice();
    return gas.getValueInUnit(EtherUnit.gwei).toInt();
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
  ContractFunction('approve', [
    FunctionParameter('to', AddressType()),
    FunctionParameter('amount', UintType(length: 256)),
  ]),
  ContractFunction('transfer', [
    FunctionParameter('to', AddressType()),
    FunctionParameter('amount', UintType(length: 256)),
  ]),
  ContractFunction(
      'allowance',
      [
        FunctionParameter('owner', AddressType()),
        FunctionParameter('spender', AddressType()),
      ],
      outputs: [FunctionParameter('', UintType(length: 256))],
      mutability: StateMutability.view)
], []);
