package africa.ejara.trustdart

import androidx.annotation.NonNull
import org.json.JSONObject

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import com.google.protobuf.ByteString
import java.util.Base64

import wallet.core.java.AnySigner

import wallet.core.jni.proto.Bitcoin
import wallet.core.jni.proto.Tron
import wallet.core.jni.proto.Bitcoin.SigningOutput
import wallet.core.jni.proto.Common.SigningError

import africa.ejara.trustdart.Numeric
import wallet.core.jni.*

/** TrustdartPlugin */
class TrustdartPlugin : FlutterPlugin, MethodCallHandler {

    init {
        System.loadLibrary("TrustWalletCore")
    }

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "trustdart")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {


            "generateAddress" -> {
                val path: String? = call.argument("path")
                val coin: String? = call.argument("coin")
                val mnemonic: String? = call.argument("mnemonic")
                val passphrase: String? = call.argument("passphrase")
                if (path != null && coin != null && mnemonic != null) {
//          val wallet: HDWallet = HDWallet(mnemonic, passphrase)
                    val prv : PrivateKey?
                    try  {
                        val bytes = Numeric.hexStringToByteArray(mnemonic)
                        prv = PrivateKey(bytes);
                    } finally {

                    }
                    if (prv != null) {
                        val address: Map<String, String?>? = generateAddress(prv, path, coin)
                        if (address == null) result.error(
                            "address_null",
                            "failed to generate address",
                            null
                        ) else result.success(address)
                    } else {
                        result.error(
                            "no_wallet",
                            "Could not generate wallet, why?", null
                        )
                    }
                } else {
                    result.error(
                        "arguments_null",
                        "[path] and [coin] and [mnemonic] cannot be null",
                        null
                    )
                }
            }
            "validateAddress" -> {
                val address: String? = call.argument("address")
                val coin: String? = call.argument("coin")
                if (address != null && coin != null) {
                    val isValid: Boolean = validateAddress(coin, address)
                    result.success(isValid)
                } else {
                    result.error("arguments_null", "$address and $coin cannot be null", null)
                }
            }
            "signTransaction" -> {
                val coin: String? = call.argument("coin")
                val path: String? = call.argument("path")
                val mnemonic: String? = call.argument("mnemonic")
                val passphrase: String? = call.argument("passphrase")
                val txData: Map<String, Any>? = call.argument("txData")
                if (txData != null && coin != null && path != null && mnemonic != null) {
//                    val wallet: HDWallet = HDWallet(mnemonic, passphrase)
                    val bytes = Numeric.hexStringToByteArray(mnemonic)
                    val prv = PrivateKey(bytes);
                    if (prv != null) {
                        val txHash: String? = signTransaction(prv, coin, path, txData)
                        if (txHash == null) result.error(
                            "txhash_null",
                            "failed to buid and sign transaction",
                            null
                        ) else result.success(txHash)
                    } else {
                        result.error(
                            "no_wallet",
                            "Could not generate wallet, why?", null
                        )
                    }
                } else {
                    result.error(
                        "arguments_null",
                        "[txData], [coin] and [path] and [mnemonic] cannot be null",
                        null
                    )
                }
            }
            "getPrivateKey" -> {
                val path: String? = call.argument("path")
                val coin: String? = call.argument("coin")
                val mnemonic: String? = call.argument("mnemonic")
                val passphrase: String? = call.argument("passphrase")
                if (path != null && coin != null && mnemonic != null) {
                    val wallet: HDWallet = HDWallet(mnemonic, passphrase)

                    if (wallet != null) {
                        val privateKey: String? = getPrivateKey(wallet, coin, path)
                        if (privateKey == null) result.error(
                            "address_null",
                            "failed to generate address",
                            null
                        ) else result.success(privateKey)
                    } else {
                        result.error(
                            "no_wallet",
                            "Could not generate wallet, why?", null
                        )
                    }
                } else {
                    result.error(
                        "arguments_null",
                        "[path] and [coin] and [mnemonic] cannot be null",
                        null
                    )
                }
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun generateAddress(
        privateKey: PrivateKey,
        path: String,
        coin: String
    ): Map<String, String?>? {
        return when (coin) {
            "BTC" -> {

                val publicKey = privateKey.getPublicKeySecp256k1(true)
                val address = BitcoinAddress(publicKey, CoinType.BITCOIN.p2pkhPrefix())
                val shAdd = BitcoinAddress(publicKey, CoinType.BITCOIN.p2shPrefix())
                val test = BitcoinAddress(publicKey, 0x1b) //blockcypher bcy
                mapOf(
                    "legacy" to address.description(),
                    "segwit" to CoinType.BITCOIN.deriveAddress(privateKey),
                    "p2sh" to shAdd.description(),
                    "test" to test.description()
                )
            }

            "TRX" -> {

                mapOf("legacy" to CoinType.TRON.deriveAddress(privateKey))
            }
            "SOL" -> {

                mapOf("legacy" to CoinType.SOLANA.deriveAddress(privateKey))
            }
            else -> null
        }
    }

    private fun validateAddress(coin: String, address: String): Boolean {
        return when (coin) {
            "BTC" -> {
                CoinType.BITCOIN.validate(address)
            }
            "TRX" -> {
                CoinType.TRON.validate(address)
            }
            "SOL" -> {
                CoinType.SOLANA.validate(address)
            }
            else -> false
        }
    }

    private fun getPrivateKey(wallet: HDWallet, coin: String, path: String): String? {
        return when (coin) {
            "BTC" -> {

                val privateKey = wallet.getKey(CoinType.BITCOIN, path)
                Base64.getEncoder().encodeToString(privateKey.data())
            }
            "TRX" -> {
                val privateKey = wallet.getKey(CoinType.TRON, path)
                Base64.getEncoder().encodeToString(privateKey.data())
            }
            "SOL" -> {
                val privateKey = wallet.getKey(CoinType.SOLANA, path)
                Base64.getEncoder().encodeToString(privateKey.data())
            }
            else -> null
        }
    }

    private fun signTransaction(
        privateKey: PrivateKey,
        coin: String,
        path: String,
        txData: Map<String, Any>
    ): String? {
        return when (coin) {

            "BTC" -> {
                signBitcoinTransaction(privateKey, path, txData)
            }
            "TRX" -> {
                signTronTransaction(privateKey, path, txData)
            }
            "SOL" -> {
                signSolanaTransaction(privateKey, path, txData)
            }
            else -> null
        }
    }

    private fun signTronTransaction(
        privateKey: PrivateKey,
        path: String,
        txData: Map<String, Any>
    ): String? {
        val cmd = txData["cmd"] as String
//        val privateKey = wallet.getKey(CoinType.TRON, path)
        val txHash: String?;
        when (cmd) {
            "TRC20" -> {
                val trc20Contract = Tron.TransferTRC20Contract.newBuilder()
                    .setOwnerAddress(txData["ownerAddress"] as String)
                    .setContractAddress(txData["contractAddress"] as String)
                    .setToAddress(txData["toAddress"] as String)
                    .setAmount(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["amount"] as String))))

                val blockHeader = Tron.BlockHeader.newBuilder()
                    .setTimestamp(txData["blockTime"] as Long)
                    .setTxTrieRoot(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["txTrieRoot"] as String))))
                    .setParentHash(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["parentHash"] as String))))
                    .setNumber((txData["number"] as Int).toLong())
                    .setWitnessAddress(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["witnessAddress"] as String))))
                    .setVersion(txData["version"] as Int)
                    .build()

                val transaction = Tron.Transaction.newBuilder()
                    .setTimestamp(txData["timestamp"] as Long)
                    .setTransferTrc20Contract(trc20Contract)
                    .setBlockHeader(blockHeader)
                    .setFeeLimit((txData["feeLimit"] as Int).toLong())
                    .build()

                val signingInput = Tron.SigningInput.newBuilder()
                    .setTransaction(transaction)
                    .setPrivateKey(ByteString.copyFrom(privateKey.data()))

                val output =
                    AnySigner.sign(signingInput.build(), CoinType.TRON, Tron.SigningOutput.parser())
                txHash = output.json
            }
            "TRC10" -> {
                val trc10Contract = Tron.TransferAssetContract.newBuilder()
                    .setOwnerAddress(txData["ownerAddress"] as String)
                    .setAssetName(txData["assetName"] as String)
                    .setToAddress(txData["toAddress"] as String)
                    .setAmount((txData["amount"] as String).toLong())

                val blockHeader = Tron.BlockHeader.newBuilder()
                    .setTimestamp(txData["blockTime"] as Long)
                    .setTxTrieRoot(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["txTrieRoot"] as String))))
                    .setParentHash(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["parentHash"] as String))))
                    .setNumber((txData["number"] as Int).toLong())
                    .setWitnessAddress(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["witnessAddress"] as String))))
                    .setVersion(txData["version"] as Int)
                    .build()

                val transaction = Tron.Transaction.newBuilder()
                    .setTimestamp(txData["timestamp"] as Long)
                    .setTransferAsset(trc10Contract)
                    .setBlockHeader(blockHeader)
                    .build()

                val signingInput = Tron.SigningInput.newBuilder()
                    .setTransaction(transaction)
                    .setPrivateKey(ByteString.copyFrom(privateKey.data()))

                val output =
                    AnySigner.sign(signingInput.build(), CoinType.TRON, Tron.SigningOutput.parser())
                txHash = output.json
            }
            "TRX" -> {
                val transfer = Tron.TransferContract.newBuilder()
                    .setOwnerAddress(txData["ownerAddress"] as String)
                    .setToAddress(txData["toAddress"] as String)
                    .setAmount((txData["amount"] as String).toLong())

                val blockHeader = Tron.BlockHeader.newBuilder()
                    .setTimestamp(txData["blockTime"] as Long)
                    .setTxTrieRoot(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["txTrieRoot"] as String))))
                    .setParentHash(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["parentHash"] as String))))
                    .setNumber((txData["number"] as Int).toLong())
                    .setWitnessAddress(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["witnessAddress"] as String))))
                    .setVersion(txData["version"] as Int)
                    .build()

                val transaction = Tron.Transaction.newBuilder()
                    .setTimestamp(txData["timestamp"] as Long)
                    .setTransfer(transfer)
                    .setBlockHeader(blockHeader)
                    .build()

                val signingInput = Tron.SigningInput.newBuilder()
                    .setTransaction(transaction)
                    .setPrivateKey(ByteString.copyFrom(privateKey.data()))

                val output =
                    AnySigner.sign(signingInput.build(), CoinType.TRON, Tron.SigningOutput.parser())
                txHash = output.json
            }
            "FREEZE" -> {
                val freezeContract = Tron.FreezeBalanceContract.newBuilder()
                    .setOwnerAddress(txData["ownerAddress"] as String)
                    .setResource(txData["resource"] as String)
                    .setFrozenDuration((txData["frozenDuration"] as Int).toLong())
                    .setFrozenBalance((txData["frozenBalance"] as Int).toLong())

                val blockHeader = Tron.BlockHeader.newBuilder()
                    .setTimestamp(txData["blockTime"] as Long)
                    .setTxTrieRoot(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["txTrieRoot"] as String))))
                    .setParentHash(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["parentHash"] as String))))
                    .setNumber((txData["number"] as Int).toLong())
                    .setWitnessAddress(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["witnessAddress"] as String))))
                    .setVersion(txData["version"] as Int)
                    .build()

                val transaction = Tron.Transaction.newBuilder()
                    .setTimestamp(txData["timestamp"] as Long)
                    .setFreezeBalance(freezeContract)
                    .setBlockHeader(blockHeader)
                    .build()

                val signingInput = Tron.SigningInput.newBuilder()
                    .setTransaction(transaction)
                    .setPrivateKey(ByteString.copyFrom(privateKey.data()))

                val output =
                    AnySigner.sign(signingInput.build(), CoinType.TRON, Tron.SigningOutput.parser())
                txHash = output.json
            }
            "CONTRACT" -> {
                txHash = null
            }
            else -> txHash = null;
        }
        return txHash;
    }

    private fun signSolanaTransaction(
        privateKey: PrivateKey,
        path: String,
        txData: Map<String, Any>
    ): String? {
//        val privateKey = wallet.getKey(CoinType.SOLANA, path)
        val opJson = JSONObject(txData).toString();
        val result = AnySigner.signJSON(opJson, privateKey.data(), CoinType.SOLANA.value())
        return result
    }

    private fun signBitcoinTransaction(
        privateKey: PrivateKey,
        path: String,
        txData: Map<String, Any>
    ): String? {
//        val privateKey = wallet.getKey(CoinType.BITCOIN, path)
        val utxos: List<Map<String, Any>> = txData["utxos"] as List<Map<String, Any>>

        val input = Bitcoin.SigningInput.newBuilder()
            .setAmount((txData["amount"] as Int).toLong())
            .setHashType(BitcoinScript.hashTypeForCoin(CoinType.BITCOIN))
            .setToAddress(txData["toAddress"] as String)
            .setChangeAddress(txData["changeAddress"] as String)
            .setByteFee((txData["byteFee"] as Int).toLong())
            .addPrivateKey(ByteString.copyFrom(privateKey.data()))

        for (utx in utxos) {
            val txHash = Numeric.hexStringToByteArray(utx["txid"] as String);
            txHash.reverse();
            val outPoint = Bitcoin.OutPoint.newBuilder()
                .setHash(ByteString.copyFrom(txHash))
                .setIndex(utx["vout"] as Int)
                .setSequence(Long.MAX_VALUE.toInt())
                .build()
            val txScript = Numeric.hexStringToByteArray(utx["script"] as String);
            val utxo = Bitcoin.UnspentTransaction.newBuilder()
                .setAmount((utx["value"] as Int).toLong())
                .setOutPoint(outPoint)
                .setScript(ByteString.copyFrom(txScript))
                .build()
            input.addUtxo(utxo)
        }

        var output = AnySigner.sign(input.build(), CoinType.BITCOIN, Bitcoin.SigningOutput.parser())
        // since we want to set our own fee
        // but such functionality is not obvious in the trustwalletcore library
        // a hack is used for now to calculate the byteFee
//        val size = output.encoded.toByteArray().size;
//        val fees = (txData["fees"] as Int).toLong()
//        val byteFee = fees.div(size) // this gives the fee per byte truncated to Long
//        // now we set new byte size
//        if (byteFee > 1) input.setByteFee(byteFee)
        output = AnySigner.sign(input.build(), CoinType.BITCOIN, Bitcoin.SigningOutput.parser())
        return Numeric.toHexString(output.encoded.toByteArray())
    }
}
