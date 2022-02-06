// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorFlutterDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder databaseBuilder(String name) =>
      _$FlutterDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$FlutterDatabaseBuilder(null);
}

class _$FlutterDatabaseBuilder {
  _$FlutterDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$FlutterDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$FlutterDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<FlutterDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$FlutterDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$FlutterDatabase extends FlutterDatabase {
  _$FlutterDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  WalletDao? _walletDaoInstance;

  WalletInfoDao? _walletInfoDaoInstance;

  ContactAddressDao? _addressDaoInstance;

  DAppRecordsDao? _dAppRecordsDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `wallet_table` (`walletID` TEXT, `walletName` TEXT, `pin` TEXT, `chainType` INTEGER, `accountState` INTEGER, `encContent` TEXT, `isChoose` INTEGER, `leadType` INTEGER, `pinTip` TEXT, PRIMARY KEY (`walletID`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `wallet_info_table` (`key` TEXT NOT NULL, `walletID` TEXT, `walletAaddress` TEXT, `coinType` INTEGER, `pubKey` TEXT, PRIMARY KEY (`key`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `contacts_table` (`address` TEXT NOT NULL, `coinType` INTEGER NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`address`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `dapp_records` (`url` TEXT, `name` TEXT, `imageUrl` TEXT, `description` TEXT, PRIMARY KEY (`url`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  WalletDao get walletDao {
    return _walletDaoInstance ??= _$WalletDao(database, changeListener);
  }

  @override
  WalletInfoDao get walletInfoDao {
    return _walletInfoDaoInstance ??= _$WalletInfoDao(database, changeListener);
  }

  @override
  ContactAddressDao get addressDao {
    return _addressDaoInstance ??=
        _$ContactAddressDao(database, changeListener);
  }

  @override
  DAppRecordsDao get dAppRecordsDao {
    return _dAppRecordsDaoInstance ??=
        _$DAppRecordsDao(database, changeListener);
  }
}

class _$WalletDao extends WalletDao {
  _$WalletDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tRWalletInsertionAdapter = InsertionAdapter(
            database,
            'wallet_table',
            (TRWallet item) => <String, Object?>{
                  'walletID': item.walletID,
                  'walletName': item.walletName,
                  'pin': item.pin,
                  'chainType': item.chainType,
                  'accountState': item.accountState,
                  'encContent': item.encContent,
                  'isChoose':
                      item.isChoose == null ? null : (item.isChoose! ? 1 : 0),
                  'leadType': item.leadType,
                  'pinTip': item.pinTip
                }),
        _tRWalletUpdateAdapter = UpdateAdapter(
            database,
            'wallet_table',
            ['walletID'],
            (TRWallet item) => <String, Object?>{
                  'walletID': item.walletID,
                  'walletName': item.walletName,
                  'pin': item.pin,
                  'chainType': item.chainType,
                  'accountState': item.accountState,
                  'encContent': item.encContent,
                  'isChoose':
                      item.isChoose == null ? null : (item.isChoose! ? 1 : 0),
                  'leadType': item.leadType,
                  'pinTip': item.pinTip
                }),
        _tRWalletDeletionAdapter = DeletionAdapter(
            database,
            'wallet_table',
            ['walletID'],
            (TRWallet item) => <String, Object?>{
                  'walletID': item.walletID,
                  'walletName': item.walletName,
                  'pin': item.pin,
                  'chainType': item.chainType,
                  'accountState': item.accountState,
                  'encContent': item.encContent,
                  'isChoose':
                      item.isChoose == null ? null : (item.isChoose! ? 1 : 0),
                  'leadType': item.leadType,
                  'pinTip': item.pinTip
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TRWallet> _tRWalletInsertionAdapter;

  final UpdateAdapter<TRWallet> _tRWalletUpdateAdapter;

  final DeletionAdapter<TRWallet> _tRWalletDeletionAdapter;

  @override
  Future<TRWallet?> queryWalletByWalletID(String walletID) async {
    return _queryAdapter.query('SELECT * FROM wallet_table WHERE walletID = ?1',
        mapper: (Map<String, Object?> row) => TRWallet(
            walletID: row['walletID'] as String?,
            walletName: row['walletName'] as String?,
            pin: row['pin'] as String?,
            chainType: row['chainType'] as int?,
            accountState: row['accountState'] as int?,
            encContent: row['encContent'] as String?,
            isChoose:
                row['isChoose'] == null ? null : (row['isChoose'] as int) != 0,
            leadType: row['leadType'] as int?,
            pinTip: row['pinTip'] as String?),
        arguments: [walletID]);
  }

  @override
  Future<List<TRWallet>> queryAllWallets() async {
    return _queryAdapter.queryList('SELECT * FROM wallet_table',
        mapper: (Map<String, Object?> row) => TRWallet(
            walletID: row['walletID'] as String?,
            walletName: row['walletName'] as String?,
            pin: row['pin'] as String?,
            chainType: row['chainType'] as int?,
            accountState: row['accountState'] as int?,
            encContent: row['encContent'] as String?,
            isChoose:
                row['isChoose'] == null ? null : (row['isChoose'] as int) != 0,
            leadType: row['leadType'] as int?,
            pinTip: row['pinTip'] as String?));
  }

  @override
  Future<TRWallet?> queryChooseWallet() async {
    return _queryAdapter.query('SELECT * FROM wallet_table WHERE isChoose = 1',
        mapper: (Map<String, Object?> row) => TRWallet(
            walletID: row['walletID'] as String?,
            walletName: row['walletName'] as String?,
            pin: row['pin'] as String?,
            chainType: row['chainType'] as int?,
            accountState: row['accountState'] as int?,
            encContent: row['encContent'] as String?,
            isChoose:
                row['isChoose'] == null ? null : (row['isChoose'] as int) != 0,
            leadType: row['leadType'] as int?,
            pinTip: row['pinTip'] as String?));
  }

  @override
  Future<void> insertWallet(TRWallet wallet) async {
    await _tRWalletInsertionAdapter.insert(wallet, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertWallets(List<TRWallet> wallet) async {
    await _tRWalletInsertionAdapter.insertList(
        wallet, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateWallet(TRWallet wallet) async {
    await _tRWalletUpdateAdapter.update(wallet, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateWallets(List<TRWallet> wallet) async {
    await _tRWalletUpdateAdapter.updateList(wallet, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteWallet(TRWallet wallet) async {
    await _tRWalletDeletionAdapter.delete(wallet);
  }

  @override
  Future<void> deleteWallets(List<TRWallet> wallet) async {
    await _tRWalletDeletionAdapter.deleteList(wallet);
  }
}

class _$WalletInfoDao extends WalletInfoDao {
  _$WalletInfoDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tRWalletInfoInsertionAdapter = InsertionAdapter(
            database,
            'wallet_info_table',
            (TRWalletInfo item) => <String, Object?>{
                  'key': item.key,
                  'walletID': item.walletID,
                  'walletAaddress': item.walletAaddress,
                  'coinType': item.coinType,
                  'pubKey': item.pubKey
                }),
        _tRWalletInfoUpdateAdapter = UpdateAdapter(
            database,
            'wallet_info_table',
            ['key'],
            (TRWalletInfo item) => <String, Object?>{
                  'key': item.key,
                  'walletID': item.walletID,
                  'walletAaddress': item.walletAaddress,
                  'coinType': item.coinType,
                  'pubKey': item.pubKey
                }),
        _tRWalletInfoDeletionAdapter = DeletionAdapter(
            database,
            'wallet_info_table',
            ['key'],
            (TRWalletInfo item) => <String, Object?>{
                  'key': item.key,
                  'walletID': item.walletID,
                  'walletAaddress': item.walletAaddress,
                  'coinType': item.coinType,
                  'pubKey': item.pubKey
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TRWalletInfo> _tRWalletInfoInsertionAdapter;

  final UpdateAdapter<TRWalletInfo> _tRWalletInfoUpdateAdapter;

  final DeletionAdapter<TRWalletInfo> _tRWalletInfoDeletionAdapter;

  @override
  Future<List<TRWalletInfo>?> queryWalletInfosByWalletID(
      String walletID) async {
    return _queryAdapter.queryList(
        'SELECT * FROM wallet_info_table WHERE walletID = ?1',
        mapper: (Map<String, Object?> row) => TRWalletInfo(
            key: row['key'] as String,
            walletID: row['walletID'] as String?,
            coinType: row['coinType'] as int?,
            walletAaddress: row['walletAaddress'] as String?,
            pubKey: row['pubKey'] as String?),
        arguments: [walletID]);
  }

  @override
  Future<List<TRWalletInfo>?> queryWalletInfo(
      String walletID, int coinType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM wallet_info_table WHERE walletID = ?1 and coinType = ?2',
        mapper: (Map<String, Object?> row) => TRWalletInfo(
            key: row['key'] as String,
            walletID: row['walletID'] as String?,
            coinType: row['coinType'] as int?,
            walletAaddress: row['walletAaddress'] as String?,
            pubKey: row['pubKey'] as String?),
        arguments: [walletID, coinType]);
  }

  @override
  Future<void> insertWallet(TRWalletInfo wallet) async {
    await _tRWalletInfoInsertionAdapter.insert(
        wallet, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertWallets(List<TRWalletInfo> wallet) async {
    await _tRWalletInfoInsertionAdapter.insertList(
        wallet, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateWallet(TRWalletInfo wallet) async {
    await _tRWalletInfoUpdateAdapter.update(wallet, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateWallets(List<TRWalletInfo> wallet) async {
    await _tRWalletInfoUpdateAdapter.updateList(
        wallet, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteWallet(TRWalletInfo wallet) async {
    await _tRWalletInfoDeletionAdapter.delete(wallet);
  }

  @override
  Future<void> deleteWallets(List<TRWalletInfo> wallet) async {
    await _tRWalletInfoDeletionAdapter.deleteList(wallet);
  }
}

class _$ContactAddressDao extends ContactAddressDao {
  _$ContactAddressDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _contactAddressInsertionAdapter = InsertionAdapter(
            database,
            'contacts_table',
            (ContactAddress item) => <String, Object?>{
                  'address': item.address,
                  'coinType': item.coinType,
                  'name': item.name
                }),
        _contactAddressUpdateAdapter = UpdateAdapter(
            database,
            'contacts_table',
            ['address'],
            (ContactAddress item) => <String, Object?>{
                  'address': item.address,
                  'coinType': item.coinType,
                  'name': item.name
                }),
        _contactAddressDeletionAdapter = DeletionAdapter(
            database,
            'contacts_table',
            ['address'],
            (ContactAddress item) => <String, Object?>{
                  'address': item.address,
                  'coinType': item.coinType,
                  'name': item.name
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ContactAddress> _contactAddressInsertionAdapter;

  final UpdateAdapter<ContactAddress> _contactAddressUpdateAdapter;

  final DeletionAdapter<ContactAddress> _contactAddressDeletionAdapter;

  @override
  Future<List<ContactAddress>> queryAddressType(int coinType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM contacts_table WHERE coinType = ?1',
        mapper: (Map<String, Object?> row) => ContactAddress(
            row['address'] as String,
            row['coinType'] as int,
            row['name'] as String),
        arguments: [coinType]);
  }

  @override
  Future<List<ContactAddress>> queryAllAddress() async {
    return _queryAdapter.queryList('SELECT * FROM contacts_table',
        mapper: (Map<String, Object?> row) => ContactAddress(
            row['address'] as String,
            row['coinType'] as int,
            row['name'] as String));
  }

  @override
  Future<void> insertAddress(ContactAddress model) async {
    await _contactAddressInsertionAdapter.insert(
        model, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateAddress(ContactAddress model) async {
    await _contactAddressUpdateAdapter.update(model, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteAddress(ContactAddress model) async {
    await _contactAddressDeletionAdapter.delete(model);
  }
}

class _$DAppRecordsDao extends DAppRecordsDao {
  _$DAppRecordsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _dAppRecordsDBModelInsertionAdapter = InsertionAdapter(
            database,
            'dapp_records',
            (DAppRecordsDBModel item) => <String, Object?>{
                  'url': item.url,
                  'name': item.name,
                  'imageUrl': item.imageUrl,
                  'description': item.description
                }),
        _dAppRecordsDBModelDeletionAdapter = DeletionAdapter(
            database,
            'dapp_records',
            ['url'],
            (DAppRecordsDBModel item) => <String, Object?>{
                  'url': item.url,
                  'name': item.name,
                  'imageUrl': item.imageUrl,
                  'description': item.description
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DAppRecordsDBModel>
      _dAppRecordsDBModelInsertionAdapter;

  final DeletionAdapter<DAppRecordsDBModel> _dAppRecordsDBModelDeletionAdapter;

  @override
  Future<List<DAppRecordsDBModel>> finaAllRecords() async {
    return _queryAdapter.queryList('SELECT * FROM dapp_records',
        mapper: (Map<String, Object?> row) => DAppRecordsDBModel(
            url: row['url'] as String?,
            name: row['name'] as String?,
            imageUrl: row['imageUrl'] as String?,
            description: row['description'] as String?));
  }

  @override
  Future<void> insertRecords(DAppRecordsDBModel model) async {
    await _dAppRecordsDBModelInsertionAdapter.insert(
        model, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteRecord(DAppRecordsDBModel model) async {
    await _dAppRecordsDBModelDeletionAdapter.delete(model);
  }

  @override
  Future<void> deleteRecords(List<DAppRecordsDBModel> model) async {
    await _dAppRecordsDBModelDeletionAdapter.deleteList(model);
  }
}
