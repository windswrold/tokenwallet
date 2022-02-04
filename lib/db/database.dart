import 'dart:async';
import 'package:cstoken/model/contacts/contact_address.dart';
import 'package:cstoken/model/wallet/tr_wallet.dart';
import 'package:cstoken/model/wallet/tr_wallet_info.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'database.g.dart';

//flutter packages pub run build_runner build
const int dbCurrentVersion = 1;

@Database(
    version: dbCurrentVersion,
    entities: [TRWallet, TRWalletInfo, ContactAddress])
abstract class FlutterDatabase extends FloorDatabase {
  WalletDao get walletDao;
  WalletInfoDao get walletInfoDao;
  ContactAddressDao get addressDao;
}
