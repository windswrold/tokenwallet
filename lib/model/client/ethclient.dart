import 'dart:ffi';
import 'dart:typed_data';
import 'package:web3dart/contracts/erc20.dart';
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
