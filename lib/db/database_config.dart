import 'package:cstoken/db/database.dart';
import 'package:cstoken/public.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class DataBaseConfig {
  static FlutterDatabase? fbase;
  static Future<FlutterDatabase?> openDataBase() async {
    if (fbase != null) {
      return fbase;
    } else {
      final migration1to2 = Migration(1, 2, (migdatabase) async {
        await migdatabase
            .execute('ALTER TABLE tokens_table  ADD COLUMN tid TEXT');
      });
      final migration2to3 = Migration(2, 3, (migdatabase) async {
        await migdatabase.execute(
            'CREATE TABLE IF NOT EXISTS `nft_model_table` (`tokenID` TEXT, `owner` TEXT, `chainTypeName` TEXT, `contractAddress` TEXT, `contractName` TEXT, `nftId` TEXT, `nftTypeName` TEXT, `url` TEXT, `usdtValues` TEXT, `state` INTEGER, `kNetType` INTEGER, PRIMARY KEY (`tokenID`))');
      });
      final callback = Callback(
        onOpen: (openDB) async {
          LogUtil.v("数据库打开成功 " + openDB.path);
          LogUtil.v("数据库getVersion ${await openDB.getVersion()}");
        },
        onUpgrade: (database, startVersion, endVersion) {
          LogUtil.v("数据库升级成功 $startVersion -> $endVersion");
        },
        onCreate: (database, version) async {
          LogUtil.v("数据库创建成功 version $version" + database.path);
        },
      );
      fbase = await $FloorFlutterDatabase
          .databaseBuilder('tr_database.db')
          .addMigrations([migration1to2, migration2to3])
          .addCallback(callback)
          .build();

      return fbase;
    }
  }
}
