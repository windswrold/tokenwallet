import Flutter
import UIKit
import WalletCore

public class SwiftTrustdartPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "trustdart", binaryMessenger: registrar.messenger())
        let instance = SwiftTrustdartPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        switch call.method {
            
        case "generateAddress":
            let args = call.arguments as! [String: String]
            let path: String? = args["path"]
            let coin: String? = args["coin"]
            let mnemonic: String? = args["mnemonic"]
            let _: String? = args["passphrase"]
            if path != nil && coin != nil && mnemonic != nil {
                
                let prv : PrivateKey?
                do {
                    let data = try Data(hexString: mnemonic!)
                    prv = data == nil ? nil :PrivateKey(data: data!)
                } catch  _{
                    
                }
                if prv != nil {
                    let address: [String: String]? = generateAddress(privateKey: prv!, path: path!, coin: coin!)
                    if address == nil {
                        result(FlutterError(code: "address_null",
                                            message: "Failed to generate address",
                                            details: nil))
                    } else {
                        result(address)
                    }
                } else {
                    result(FlutterError(code: "no_wallet",
                                        message: "Could not generate wallet, why?",
                                        details: nil))
                }
            } else {
                result(FlutterError(code: "arguments_null",
                                    message: "[path] and [coin] and [mnemonic] cannot be null",
                                    details: nil))
            }
        case "validateAddress":
            let args = call.arguments as! [String: String]
            let address: String? = args["address"]
            let coin: String? = args["coin"]
            if address != nil && coin != nil {
                let isValid: Bool = validateAddress(address: address!, coin: coin!)
                result(isValid)
            } else {
                result(FlutterError(code: "arguments_null",
                                    message: "[address] and [coin] cannot be null",
                                    details: nil))
            }
        case "signTransaction":
            let args = call.arguments as! [String: Any]
            let coin: String? = args["coin"] as? String
            let path: String? = args["path"] as? String
            let txData: [String: Any]? = args["txData"] as? [String: Any]
            let mnemonic: String? = args["mnemonic"] as? String
            let passphrase: String? = args["passphrase"] as? String
            if coin != nil && path != nil && txData != nil && mnemonic != nil {
                //                    let wallet = HDWallet(mnemonic: mnemonic!, passphrase: passphrase!)
                let data = Data(hexString: mnemonic!)
                let prv = PrivateKey(data: data!)
                
                if prv != nil {
                    let txHash: String? = signTransaction(privateKey: prv!, coin: coin!, path: path!, txData: txData!)
                    if txHash == nil {
                        result(FlutterError(code: "txhash_null",
                                            message: "Failed to buid and sign transaction",
                                            details: nil))
                    } else {
                        result(txHash)
                    }
                } else {
                    result(FlutterError(code: "no_wallet",
                                        message: "Could not generate wallet, why?",
                                        details: nil))
                }
            } else {
                result(FlutterError(code: "arguments_null",
                                    message: "[coin], [path] and [txData] cannot be null",
                                    details: nil))
            }
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func generateAddress(privateKey: PrivateKey, path: String, coin: String) -> [String: String]? {
        var addressMap: [String: String]?
        switch coin {
        case "BTC":
            
            let publicKey = privateKey.getPublicKeySecp256k1(compressed: true)
            let legacyAddress = BitcoinAddress(publicKey: publicKey, prefix: 0)
            let scriptHashAddress = BitcoinAddress(publicKey: publicKey, prefix: 5)
            let test = BitcoinAddress(publicKey: publicKey, prefix: 111)
            addressMap = ["legacy": legacyAddress!.description,
                          "segwit": CoinType.bitcoin.deriveAddress(privateKey: privateKey),
                          "p2sh": scriptHashAddress!.description,
                          "test":test!.description
            ]
            
        case "TRX":
            
            addressMap = ["legacy": CoinType.tron.deriveAddress(privateKey: privateKey)]
        case "SOL":
            
            addressMap = ["legacy": CoinType.solana.deriveAddress(privateKey: privateKey)]
        default:
            addressMap = nil
        }
        return addressMap
        
    }
    
    func validateAddress(address: String, coin: String) -> Bool {
        var isValid: Bool
        switch coin {
        case "BTC":
            isValid = CoinType.bitcoin.validate(address: address)
        case "TRX":
            isValid = CoinType.tron.validate(address: address)
        case "SOL":
            isValid = CoinType.solana.validate(address: address)
        default:
            isValid = false
        }
        return isValid
        
    }
    
    
    
    func getPrivateKey(wallet: HDWallet, path: String, coin: String) -> String? {
        var privateKey: String?
        switch coin {
        case "BTC":
            privateKey = wallet.getKey(coin: CoinType.bitcoin, derivationPath: path).data.base64EncodedString()
            
        case "TRX":
            privateKey = wallet.getKey(coin: CoinType.tron, derivationPath: path).data.base64EncodedString()
        case "SOL":
            privateKey = wallet.getKey(coin: CoinType.solana, derivationPath: path).data.base64EncodedString()
        default:
            privateKey = nil
        }
        return privateKey;
    }
    
    func signTransaction(privateKey: PrivateKey, coin: String, path: String, txData: [String: Any]) -> String? {
        var txHash: String?
        switch coin {
        case "BTC":
            txHash = signBitcoinTransaction(privateKey: privateKey, path: path, txData: txData)
        case "TRX":
            txHash = signTronTransaction(privateKey: privateKey, path: path, txData: txData)
        case "SOL":
            txHash = signSolanaTransaction(privateKey: privateKey, path: path, txData: txData)
        default:
            txHash = nil
        }
        return txHash
        
    }
    
    private func objToJson(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    
    
    
    func signSolanaTransaction(privateKey: PrivateKey, path: String, txData:  [String: Any]) -> String? {
        //        let privateKey = wallet.getKey(coin: CoinType.solana, derivationPath: path)
        let opJson =  objToJson(from:txData)
        let result = AnySigner.signJSON(opJson!, key: privateKey.data, coin: CoinType.solana)
        return result
    }
    
    func signTronTransaction(privateKey: PrivateKey, path: String, txData:  [String: Any]) -> String? {
        let cmd = txData["cmd"] as! String
        var txHash: String?
        //        let privateKey = wallet.getKey(coin: CoinType.tron, derivationPath: path)
        switch cmd {
        case "TRC20":
            let contract = TronTransferTRC20Contract.with {
                $0.ownerAddress = txData["ownerAddress"] as! String
                $0.toAddress = txData["toAddress"] as! String
                $0.contractAddress = txData["contractAddress"] as! String
                $0.amount = Data(hexString: txData["amount"] as! String)!
            }
            
            let input = TronSigningInput.with {
                $0.transaction = TronTransaction.with {
                    $0.feeLimit = txData["feeLimit"] as! Int64
                    $0.transferTrc20Contract = contract
                    $0.timestamp = txData["timestamp"] as! Int64
                    $0.blockHeader = TronBlockHeader.with {
                        $0.timestamp = txData["blockTime"] as! Int64
                        $0.number = txData["number"] as! Int64
                        $0.version = txData["version"] as! Int32
                        $0.txTrieRoot = Data(hexString: txData["txTrieRoot"] as! String)!
                        $0.parentHash = Data(hexString: txData["parentHash"] as! String)!
                        $0.witnessAddress = Data(hexString: txData["witnessAddress"] as! String)!
                    }
                }
                $0.privateKey = privateKey.data
            }
            let output: TronSigningOutput = AnySigner.sign(input: input, coin: CoinType.tron)
            txHash = output.json
        case "TRC10":
            let transferAsset = TronTransferAssetContract.with {
                $0.ownerAddress = txData["ownerAddress"] as! String
                $0.toAddress = txData["toAddress"] as! String
                $0.amount = Int64(txData["amount"] as! String) ?? 0
                $0.assetName = txData["assetName"] as! String
            }
            let input = TronSigningInput.with {
                $0.transaction = TronTransaction.with {
                    $0.transferAsset = transferAsset
                    $0.timestamp = txData["timestamp"] as! Int64
                    $0.blockHeader = TronBlockHeader.with {
                        $0.timestamp = txData["blockTime"] as! Int64
                        $0.number = txData["number"] as! Int64
                        $0.version = txData["version"] as! Int32
                        $0.txTrieRoot = Data(hexString: txData["txTrieRoot"] as! String)!
                        $0.parentHash = Data(hexString: txData["parentHash"] as! String)!
                        $0.witnessAddress = Data(hexString: txData["witnessAddress"] as! String)!
                    }
                }
                $0.privateKey = privateKey.data
            }
            let output: TronSigningOutput = AnySigner.sign(input: input, coin: CoinType.tron)
            txHash = output.json
        case "TRX":
            let transfer = TronTransferContract.with {
                $0.ownerAddress = txData["ownerAddress"] as! String
                $0.toAddress = txData["toAddress"] as! String
                $0.amount = Int64(txData["amount"] as! String) ?? 0
            }
            let input = TronSigningInput.with {
                $0.transaction = TronTransaction.with {
                    $0.transfer = transfer
                    $0.timestamp = txData["timestamp"] as! Int64
                    $0.blockHeader = TronBlockHeader.with {
                        $0.timestamp = txData["blockTime"] as! Int64
                        $0.number = txData["number"] as! Int64
                        $0.version = txData["version"] as! Int32
                        $0.txTrieRoot = Data(hexString: txData["txTrieRoot"] as! String)!
                        $0.parentHash = Data(hexString: txData["parentHash"] as! String)!
                        $0.witnessAddress = Data(hexString: txData["witnessAddress"] as! String)!
                    }
                }
                $0.privateKey = privateKey.data
            }
            let output: TronSigningOutput = AnySigner.sign(input: input, coin: CoinType.tron)
            txHash = output.json
        case "CONTRACT":
            txHash = ""
        case "FREEZE":
            let contract = TronFreezeBalanceContract.with {
                $0.frozenBalance = txData["frozenBalance"] as! Int64
                $0.frozenDuration = txData["frozenDuration"] as! Int64
                $0.ownerAddress = txData["ownerAddress"] as! String
                $0.resource = txData["resource"] as! String
            }
            let input = TronSigningInput.with {
                $0.transaction = TronTransaction.with {
                    $0.freezeBalance = contract
                    $0.timestamp = txData["timestamp"] as! Int64
                    $0.blockHeader = TronBlockHeader.with {
                        $0.timestamp = txData["blockTime"] as! Int64
                        $0.number = txData["number"] as! Int64
                        $0.version = txData["version"] as! Int32
                        $0.txTrieRoot = Data(hexString: txData["txTrieRoot"] as! String)!
                        $0.parentHash = Data(hexString: txData["parentHash"] as! String)!
                        $0.witnessAddress = Data(hexString: txData["witnessAddress"] as! String)!
                    }
                }
                $0.privateKey = privateKey.data
            }
            let output: TronSigningOutput = AnySigner.sign(input: input, coin: CoinType.tron)
            txHash = output.json
        default:
            txHash = nil
        }
        return txHash
    }
    
    func signBitcoinTransaction(privateKey: PrivateKey, path: String, txData:  [String: Any]) -> String? {
        //        let privateKey = wallet.getKey(coin: CoinType.bitcoin, derivationPath: path)
        let utxos: [[String: Any]] = txData["utxos"] as! [[String: Any]]
        var unspent: [BitcoinUnspentTransaction] = []
        
        for utx in utxos {
            unspent.append(BitcoinUnspentTransaction.with {
                $0.outPoint.hash = Data.reverse(hexString: utx["txid"] as! String)
                $0.outPoint.index = utx["vout"] as! UInt32
                $0.outPoint.sequence = UINT32_MAX
                $0.amount = utx["value"] as! Int64
                $0.script = Data(hexString: utx["script"] as! String)!
            })
        }
        let input: BitcoinSigningInput = BitcoinSigningInput.with {
            $0.hashType = BitcoinScript.hashTypeForCoin(coinType: .bitcoin)
            $0.amount = txData["amount"] as! Int64
            $0.toAddress = txData["toAddress"] as! String
            $0.changeAddress = txData["changeAddress"] as! String // can be same sender address
            $0.privateKey = [privateKey.data]
            $0.utxo = unspent
            $0.byteFee = txData["byteFee"] as! Int64
        }
        
        let output: BitcoinSigningOutput = AnySigner.sign(input: input, coin: .bitcoin)
        print(output.encoded.count)
        print(output.error)
        return output.encoded.hexString
    }
}
