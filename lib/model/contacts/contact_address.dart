import 'package:cstoken/db/database.dart';
import 'package:cstoken/db/database_config.dart';
import 'package:floor/floor.dart';
import '../../public.dart';

const String tableName = "contacts_table";

@Entity(tableName: tableName)
class ContactAddress {
  @primaryKey
  String address;
  int coinType;
  String name;
  ContactAddress(this.address, this.coinType, this.name);

  Map<String, dynamic> toJson() {
    return {
      "address": this.address,
      "coinType": this.coinType,
      "name": this.name,
    };
  }

  static ContactAddress fromJson(Map<String, dynamic> json) {
    return ContactAddress(
      json['address'] as String,
      json['coinType'] as int,
      json['name'] as String,
    );
  }

  static Future<List<ContactAddress>> queryAddressType(int coinType) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      List<ContactAddress>? datas =
          await database?.addressDao.queryAddressType(coinType);
      return datas ?? [];
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return [];
    }
  }

  static Future<List<ContactAddress>> queryAllAddress() async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      List<ContactAddress>? datas =
          await database?.addressDao.queryAllAddress();
      return datas ?? [];
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return [];
    }
  }

  static void insertAddress(ContactAddress model) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();
      await database?.addressDao.insertAddress(model);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
      return;
    }
  }

  static void deleteAddress(ContactAddress model) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();

      await database?.addressDao.deleteAddress(model);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
    }
  }

  static void updateAddress(ContactAddress model) async {
    try {
      FlutterDatabase? database = await DataBaseConfig.openDataBase();

      await database?.addressDao.updateAddress(model);
    } catch (e) {
      LogUtil.v("失败" + e.toString());
    }
  }
}

@dao
abstract class ContactAddressDao {
  @Query('SELECT * FROM ' + tableName + ' WHERE coinType = :coinType')
  Future<List<ContactAddress>> queryAddressType(int coinType);

  @Query('SELECT * FROM ' + tableName)
  Future<List<ContactAddress>> queryAllAddress();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAddress(ContactAddress model);

  @delete
  Future<void> deleteAddress(ContactAddress model);

  @update
  Future<void> updateAddress(ContactAddress model);
}
