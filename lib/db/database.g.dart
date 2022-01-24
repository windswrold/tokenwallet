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
            'CREATE TABLE IF NOT EXISTS `wallet_table` (`walletID` TEXT, `walletAaddress` TEXT, `pin` TEXT, `prvKey` TEXT, `coinType` INTEGER, `accountState` INTEGER, `mnemonic` TEXT, `isChoose` INTEGER, `pubKey` TEXT, `leadType` INTEGER, `pinTip` TEXT, `descName` TEXT, PRIMARY KEY (`walletID`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  WalletDao get walletDao {
    return _walletDaoInstance ??= _$WalletDao(database, changeListener);
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
                  'walletAaddress': item.walletAaddress,
                  'pin': item.pin,
                  'prvKey': item.prvKey,
                  'coinType': item.coinType,
                  'accountState': item.accountState,
                  'mnemonic': item.mnemonic,
                  'isChoose':
                      item.isChoose == null ? null : (item.isChoose! ? 1 : 0),
                  'pubKey': item.pubKey,
                  'leadType': item.leadType,
                  'pinTip': item.pinTip,
                  'descName': item.descName
                }),
        _tRWalletUpdateAdapter = UpdateAdapter(
            database,
            'wallet_table',
            ['walletID'],
            (TRWallet item) => <String, Object?>{
                  'walletID': item.walletID,
                  'walletAaddress': item.walletAaddress,
                  'pin': item.pin,
                  'prvKey': item.prvKey,
                  'coinType': item.coinType,
                  'accountState': item.accountState,
                  'mnemonic': item.mnemonic,
                  'isChoose':
                      item.isChoose == null ? null : (item.isChoose! ? 1 : 0),
                  'pubKey': item.pubKey,
                  'leadType': item.leadType,
                  'pinTip': item.pinTip,
                  'descName': item.descName
                }),
        _tRWalletDeletionAdapter = DeletionAdapter(
            database,
            'wallet_table',
            ['walletID'],
            (TRWallet item) => <String, Object?>{
                  'walletID': item.walletID,
                  'walletAaddress': item.walletAaddress,
                  'pin': item.pin,
                  'prvKey': item.prvKey,
                  'coinType': item.coinType,
                  'accountState': item.accountState,
                  'mnemonic': item.mnemonic,
                  'isChoose':
                      item.isChoose == null ? null : (item.isChoose! ? 1 : 0),
                  'pubKey': item.pubKey,
                  'leadType': item.leadType,
                  'pinTip': item.pinTip,
                  'descName': item.descName
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
            walletAaddress: row['walletAaddress'] as String?,
            pin: row['pin'] as String?,
            prvKey: row['prvKey'] as String?,
            coinType: row['coinType'] as int?,
            accountState: row['accountState'] as int?,
            mnemonic: row['mnemonic'] as String?,
            descName: row['descName'] as String?,
            isChoose:
                row['isChoose'] == null ? null : (row['isChoose'] as int) != 0,
            leadType: row['leadType'] as int?,
            pinTip: row['pinTip'] as String?,
            pubKey: row['pubKey'] as String?),
        arguments: [walletID]);
  }

  @override
  Future<List<TRWallet>> queryAllWallets() async {
    return _queryAdapter.queryList('SELECT * FROM wallet_table',
        mapper: (Map<String, Object?> row) => TRWallet(
            walletID: row['walletID'] as String?,
            walletAaddress: row['walletAaddress'] as String?,
            pin: row['pin'] as String?,
            prvKey: row['prvKey'] as String?,
            coinType: row['coinType'] as int?,
            accountState: row['accountState'] as int?,
            mnemonic: row['mnemonic'] as String?,
            descName: row['descName'] as String?,
            isChoose:
                row['isChoose'] == null ? null : (row['isChoose'] as int) != 0,
            leadType: row['leadType'] as int?,
            pinTip: row['pinTip'] as String?,
            pubKey: row['pubKey'] as String?));
  }

  @override
  Future<TRWallet?> queryChooseWallet() async {
    return _queryAdapter.query('SELECT * FROM wallet_table WHERE isChoose = 1',
        mapper: (Map<String, Object?> row) => TRWallet(
            walletID: row['walletID'] as String?,
            walletAaddress: row['walletAaddress'] as String?,
            pin: row['pin'] as String?,
            prvKey: row['prvKey'] as String?,
            coinType: row['coinType'] as int?,
            accountState: row['accountState'] as int?,
            mnemonic: row['mnemonic'] as String?,
            descName: row['descName'] as String?,
            isChoose:
                row['isChoose'] == null ? null : (row['isChoose'] as int) != 0,
            leadType: row['leadType'] as int?,
            pinTip: row['pinTip'] as String?,
            pubKey: row['pubKey'] as String?));
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
