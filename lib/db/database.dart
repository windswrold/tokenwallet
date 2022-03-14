import 'dart:async';
import 'package:cstoken/model/contacts/contact_address.dart';
import 'package:cstoken/model/dapps_record/dapps_record.dart';
import 'package:cstoken/model/token_price/tokenprice.dart';
import 'package:cstoken/model/tokens/collection_tokens.dart';
import 'package:cstoken/model/transrecord/trans_record.dart';
import 'package:cstoken/model/wallet/tr_wallet.dart';
import 'package:cstoken/model/wallet/tr_wallet_info.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'database.g.dart';

//flutter packages pub run build_runner build
// updateTokenData
const int dbCurrentVersion = 2;

@Database(version: dbCurrentVersion, entities: [
  TRWallet,
  TRWalletInfo,
  ContactAddress,
  DAppRecordsDBModel,
  TokenPrice,
  MCollectionTokens,
  TransRecordModel,
])
abstract class FlutterDatabase extends FloorDatabase {
  WalletDao get walletDao;
  WalletInfoDao get walletInfoDao;
  ContactAddressDao get addressDao;
  DAppRecordsDao get dAppRecordsDao;
  TokenPriceDao get tokenPriceDao;
  MCollectionTokenDao get tokensDao;
  TransRecordModelDao get transListDao;
}
