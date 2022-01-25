import 'dart:async';
import 'package:cstoken/model/wallet/tr_wallet.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'database.g.dart';

//flutter packages pub run build_runner build
const int dbCurrentVersion = 1;

@Database(version: dbCurrentVersion, entities: [TRWallet])
abstract class FlutterDatabase extends FloorDatabase {
  WalletDao get walletDao;
}
