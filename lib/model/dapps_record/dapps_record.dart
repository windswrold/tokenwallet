import 'package:cstoken/db/database.dart';
import 'package:cstoken/db/database_config.dart';
import 'package:cstoken/utils/log_util.dart';
import 'package:floor/floor.dart';

const String tableName = "dapp_records";

@Entity(tableName: tableName)
class DAppRecordsDBModel {
  @primaryKey
  final String? url;
  final String? name;
  final String? imageUrl;
  final String? description;

  DAppRecordsDBModel({
    this.url,
    this.name,
    this.imageUrl,
    this.description,
  });

  static Future<List<DAppRecordsDBModel>> finaAllRecords() async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      List<DAppRecordsDBModel>? datas =
          await (database?.dAppRecordsDao.finaAllRecords());
      return datas ?? [];
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return [];
    }
  }

  static Future<bool> insertRecords(DAppRecordsDBModel model) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.dAppRecordsDao.insertRecords(model);
      return true;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return false;
    }
  }

  static Future<bool> deleteRecord(DAppRecordsDBModel url) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.dAppRecordsDao.deleteRecord(url);
      return true;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return false;
    }
  }

  static Future<bool> deleteRecords(List<DAppRecordsDBModel> models) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      database?.dAppRecordsDao.deleteRecords(models);
      return true;
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return false;
    }
  }
}

@dao
abstract class DAppRecordsDao {
  @Query('SELECT * FROM ' + tableName)
  Future<List<DAppRecordsDBModel>> finaAllRecords();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertRecords(DAppRecordsDBModel model);

  @delete
  Future<void> deleteRecord(DAppRecordsDBModel model);

  @delete
  Future<void> deleteRecords(List<DAppRecordsDBModel> model);
}
