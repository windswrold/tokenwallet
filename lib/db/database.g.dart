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

  TokenPriceDao? _tokenPriceDaoInstance;

  MCollectionTokenDao? _tokensDaoInstance;

  TransRecordModelDao? _transListDaoInstance;

  NFTModelDao? _nftDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
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
            'CREATE TABLE IF NOT EXISTS `wallet_table` (`walletID` TEXT, `walletName` TEXT, `pin` TEXT, `chainType` INTEGER, `accountState` INTEGER, `encContent` TEXT, `isChoose` INTEGER, `leadType` INTEGER, `pinTip` TEXT, `hiddenAssets` INTEGER, PRIMARY KEY (`walletID`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `wallet_info_table` (`key` TEXT NOT NULL, `walletID` TEXT, `walletAaddress` TEXT, `coinType` INTEGER, `pubKey` TEXT, PRIMARY KEY (`key`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `contacts_table` (`address` TEXT NOT NULL, `coinType` INTEGER NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`address`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `dapp_records` (`url` TEXT, `name` TEXT, `imageUrl` TEXT, `description` TEXT, `marketId` TEXT, `date` TEXT, `chainType` TEXT, `type` INTEGER, PRIMARY KEY (`url`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tokenPrice_table` (`contract` TEXT, `source` TEXT, `target` TEXT, `rate` TEXT, PRIMARY KEY (`contract`, `source`, `target`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tokens_table` (`tokenID` TEXT, `owner` TEXT, `contract` TEXT, `token` TEXT, `coinType` TEXT, `chainType` INTEGER, `state` INTEGER, `iconPath` TEXT, `decimals` INTEGER, `price` REAL, `balance` REAL, `digits` INTEGER, `kNetType` INTEGER, `index` INTEGER, `tokenType` INTEGER, `tid` TEXT, PRIMARY KEY (`tokenID`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `translist_table` (`txid` TEXT, `toAdd` TEXT, `fromAdd` TEXT, `date` TEXT, `amount` TEXT, `remarks` TEXT, `fee` TEXT, `gasPrice` TEXT, `gasLimit` TEXT, `transStatus` INTEGER, `token` TEXT, `coinType` TEXT, `chainid` INTEGER, `nonce` INTEGER, `contractTo` TEXT, `input` TEXT, `signMessage` TEXT, `repeatPushCount` INTEGER, `blockHeight` INTEGER, `transType` INTEGER, PRIMARY KEY (`txid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `nft_model_table` (`tokenID` TEXT, `owner` TEXT, `chainTypeName` TEXT, `contractAddress` TEXT, `contractName` TEXT, `nftId` TEXT, `nftTypeName` TEXT, `url` TEXT, `usdtValues` TEXT, `state` INTEGER, `kNetType` INTEGER, PRIMARY KEY (`tokenID`))');

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

  @override
  TokenPriceDao get tokenPriceDao {
    return _tokenPriceDaoInstance ??= _$TokenPriceDao(database, changeListener);
  }

  @override
  MCollectionTokenDao get tokensDao {
    return _tokensDaoInstance ??=
        _$MCollectionTokenDao(database, changeListener);
  }

  @override
  TransRecordModelDao get transListDao {
    return _transListDaoInstance ??=
        _$TransRecordModelDao(database, changeListener);
  }

  @override
  NFTModelDao get nftDao {
    return _nftDaoInstance ??= _$NFTModelDao(database, changeListener);
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
                  'pinTip': item.pinTip,
                  'hiddenAssets': item.hiddenAssets == null
                      ? null
                      : (item.hiddenAssets! ? 1 : 0)
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
                  'pinTip': item.pinTip,
                  'hiddenAssets': item.hiddenAssets == null
                      ? null
                      : (item.hiddenAssets! ? 1 : 0)
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
                  'pinTip': item.pinTip,
                  'hiddenAssets': item.hiddenAssets == null
                      ? null
                      : (item.hiddenAssets! ? 1 : 0)
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
            pinTip: row['pinTip'] as String?,
            hiddenAssets: row['hiddenAssets'] == null
                ? null
                : (row['hiddenAssets'] as int) != 0),
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
            pinTip: row['pinTip'] as String?,
            hiddenAssets: row['hiddenAssets'] == null
                ? null
                : (row['hiddenAssets'] as int) != 0));
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
            pinTip: row['pinTip'] as String?,
            hiddenAssets: row['hiddenAssets'] == null
                ? null
                : (row['hiddenAssets'] as int) != 0));
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
                  'description': item.description,
                  'marketId': item.marketId,
                  'date': item.date,
                  'chainType': item.chainType,
                  'type': item.type
                }),
        _dAppRecordsDBModelDeletionAdapter = DeletionAdapter(
            database,
            'dapp_records',
            ['url'],
            (DAppRecordsDBModel item) => <String, Object?>{
                  'url': item.url,
                  'name': item.name,
                  'imageUrl': item.imageUrl,
                  'description': item.description,
                  'marketId': item.marketId,
                  'date': item.date,
                  'chainType': item.chainType,
                  'type': item.type
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DAppRecordsDBModel>
      _dAppRecordsDBModelInsertionAdapter;

  final DeletionAdapter<DAppRecordsDBModel> _dAppRecordsDBModelDeletionAdapter;

  @override
  Future<List<DAppRecordsDBModel>> finaAllRecords() async {
    return _queryAdapter.queryList(
        'SELECT * FROM dapp_records WHERE (type = 0 or type = 2)',
        mapper: (Map<String, Object?> row) => DAppRecordsDBModel(
            url: row['url'] as String?,
            name: row['name'] as String?,
            imageUrl: row['imageUrl'] as String?,
            description: row['description'] as String?,
            marketId: row['marketId'] as String?,
            date: row['date'] as String?,
            chainType: row['chainType'] as String?,
            type: row['type'] as int?));
  }

  @override
  Future<List<DAppRecordsDBModel>> finaAllCollectRecords() async {
    return _queryAdapter.queryList(
        'SELECT * FROM dapp_records WHERE (type = 1 or type = 2)',
        mapper: (Map<String, Object?> row) => DAppRecordsDBModel(
            url: row['url'] as String?,
            name: row['name'] as String?,
            imageUrl: row['imageUrl'] as String?,
            description: row['description'] as String?,
            marketId: row['marketId'] as String?,
            date: row['date'] as String?,
            chainType: row['chainType'] as String?,
            type: row['type'] as int?));
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

class _$TokenPriceDao extends TokenPriceDao {
  _$TokenPriceDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tokenPriceInsertionAdapter = InsertionAdapter(
            database,
            'tokenPrice_table',
            (TokenPrice item) => <String, Object?>{
                  'contract': item.contract,
                  'source': item.source,
                  'target': item.target,
                  'rate': item.rate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TokenPrice> _tokenPriceInsertionAdapter;

  @override
  Future<List<TokenPrice>> queryTokenPrices(
      String contract, String target) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tokenPrice_table WHERE contract = ?1 and target=?2',
        mapper: (Map<String, Object?> row) => TokenPrice(
            contract: row['contract'] as String?,
            source: row['source'] as String?,
            target: row['target'] as String?,
            rate: row['rate'] as String?),
        arguments: [contract, target]);
  }

  @override
  Future<void> insertTokenPrice(TokenPrice model) async {
    await _tokenPriceInsertionAdapter.insert(model, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertTokensPrice(List<TokenPrice> models) async {
    await _tokenPriceInsertionAdapter.insertList(
        models, OnConflictStrategy.replace);
  }
}

class _$MCollectionTokenDao extends MCollectionTokenDao {
  _$MCollectionTokenDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _mCollectionTokensInsertionAdapter = InsertionAdapter(
            database,
            'tokens_table',
            (MCollectionTokens item) => <String, Object?>{
                  'tokenID': item.tokenID,
                  'owner': item.owner,
                  'contract': item.contract,
                  'token': item.token,
                  'coinType': item.coinType,
                  'chainType': item.chainType,
                  'state': item.state,
                  'iconPath': item.iconPath,
                  'decimals': item.decimals,
                  'price': item.price,
                  'balance': item.balance,
                  'digits': item.digits,
                  'kNetType': item.kNetType,
                  'index': item.index,
                  'tokenType': item.tokenType,
                  'tid': item.tid
                }),
        _mCollectionTokensUpdateAdapter = UpdateAdapter(
            database,
            'tokens_table',
            ['tokenID'],
            (MCollectionTokens item) => <String, Object?>{
                  'tokenID': item.tokenID,
                  'owner': item.owner,
                  'contract': item.contract,
                  'token': item.token,
                  'coinType': item.coinType,
                  'chainType': item.chainType,
                  'state': item.state,
                  'iconPath': item.iconPath,
                  'decimals': item.decimals,
                  'price': item.price,
                  'balance': item.balance,
                  'digits': item.digits,
                  'kNetType': item.kNetType,
                  'index': item.index,
                  'tokenType': item.tokenType,
                  'tid': item.tid
                }),
        _mCollectionTokensDeletionAdapter = DeletionAdapter(
            database,
            'tokens_table',
            ['tokenID'],
            (MCollectionTokens item) => <String, Object?>{
                  'tokenID': item.tokenID,
                  'owner': item.owner,
                  'contract': item.contract,
                  'token': item.token,
                  'coinType': item.coinType,
                  'chainType': item.chainType,
                  'state': item.state,
                  'iconPath': item.iconPath,
                  'decimals': item.decimals,
                  'price': item.price,
                  'balance': item.balance,
                  'digits': item.digits,
                  'kNetType': item.kNetType,
                  'index': item.index,
                  'tokenType': item.tokenType,
                  'tid': item.tid
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MCollectionTokens> _mCollectionTokensInsertionAdapter;

  final UpdateAdapter<MCollectionTokens> _mCollectionTokensUpdateAdapter;

  final DeletionAdapter<MCollectionTokens> _mCollectionTokensDeletionAdapter;

  @override
  Future<List<MCollectionTokens>> findAllTokens(String owner) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tokens_table WHERE owner = ?1',
        mapper: (Map<String, Object?> row) => MCollectionTokens(
            tokenID: row['tokenID'] as String?,
            owner: row['owner'] as String?,
            contract: row['contract'] as String?,
            token: row['token'] as String?,
            coinType: row['coinType'] as String?,
            state: row['state'] as int?,
            decimals: row['decimals'] as int?,
            price: row['price'] as double?,
            balance: row['balance'] as double?,
            digits: row['digits'] as int?,
            iconPath: row['iconPath'] as String?,
            chainType: row['chainType'] as int?,
            index: row['index'] as int?,
            kNetType: row['kNetType'] as int?,
            tokenType: row['tokenType'] as int?,
            tid: row['tid'] as String?),
        arguments: [owner]);
  }

  @override
  Future<List<MCollectionTokens>> findTokens(String owner, int kNetType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tokens_table WHERE owner = ?1 and kNetType=?2 ORDER BY \"index\"',
        mapper: (Map<String, Object?> row) => MCollectionTokens(tokenID: row['tokenID'] as String?, owner: row['owner'] as String?, contract: row['contract'] as String?, token: row['token'] as String?, coinType: row['coinType'] as String?, state: row['state'] as int?, decimals: row['decimals'] as int?, price: row['price'] as double?, balance: row['balance'] as double?, digits: row['digits'] as int?, iconPath: row['iconPath'] as String?, chainType: row['chainType'] as int?, index: row['index'] as int?, kNetType: row['kNetType'] as int?, tokenType: row['tokenType'] as int?, tid: row['tid'] as String?),
        arguments: [owner, kNetType]);
  }

  @override
  Future<List<MCollectionTokens>> findChainTokens(
      String owner, int kNetType, int chainType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tokens_table WHERE owner = ?1 and kNetType=?2 and chainType=?3 ORDER BY \"index\"',
        mapper: (Map<String, Object?> row) => MCollectionTokens(tokenID: row['tokenID'] as String?, owner: row['owner'] as String?, contract: row['contract'] as String?, token: row['token'] as String?, coinType: row['coinType'] as String?, state: row['state'] as int?, decimals: row['decimals'] as int?, price: row['price'] as double?, balance: row['balance'] as double?, digits: row['digits'] as int?, iconPath: row['iconPath'] as String?, chainType: row['chainType'] as int?, index: row['index'] as int?, kNetType: row['kNetType'] as int?, tokenType: row['tokenType'] as int?, tid: row['tid'] as String?),
        arguments: [owner, kNetType, chainType]);
  }

  @override
  Future<List<MCollectionTokens>> findStateTokens(
      String owner, int state, int kNetType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tokens_table WHERE owner = ?1 and state = ?2 and kNetType=?3 ORDER BY \"index\"',
        mapper: (Map<String, Object?> row) => MCollectionTokens(tokenID: row['tokenID'] as String?, owner: row['owner'] as String?, contract: row['contract'] as String?, token: row['token'] as String?, coinType: row['coinType'] as String?, state: row['state'] as int?, decimals: row['decimals'] as int?, price: row['price'] as double?, balance: row['balance'] as double?, digits: row['digits'] as int?, iconPath: row['iconPath'] as String?, chainType: row['chainType'] as int?, index: row['index'] as int?, kNetType: row['kNetType'] as int?, tokenType: row['tokenType'] as int?, tid: row['tid'] as String?),
        arguments: [owner, state, kNetType]);
  }

  @override
  Future<List<MCollectionTokens>> findStateChainTokens(
      String owner, int state, int kNetType, int chainType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tokens_table WHERE owner = ?1 and state = ?2 and kNetType=?3 and chainType =?4 ORDER BY \"index\"',
        mapper: (Map<String, Object?> row) => MCollectionTokens(tokenID: row['tokenID'] as String?, owner: row['owner'] as String?, contract: row['contract'] as String?, token: row['token'] as String?, coinType: row['coinType'] as String?, state: row['state'] as int?, decimals: row['decimals'] as int?, price: row['price'] as double?, balance: row['balance'] as double?, digits: row['digits'] as int?, iconPath: row['iconPath'] as String?, chainType: row['chainType'] as int?, index: row['index'] as int?, kNetType: row['kNetType'] as int?, tokenType: row['tokenType'] as int?, tid: row['tid'] as String?),
        arguments: [owner, state, kNetType, chainType]);
  }

  @override
  Future<void> updateTokenData(String sql) async {
    await _queryAdapter.queryNoReturn('UPDATE tokens_table SET $sql');
  }

  @override
  Future<List<MCollectionTokens>> findTokensBySQL(String sql) async {
    return _queryAdapter.queryList(
      'SELECT * FROM tokens_table WHERE $sql  ORDER BY \"index\"',
      mapper: (Map<String, Object?> row) => MCollectionTokens(
          tokenID: row['tokenID'] as String?,
          owner: row['owner'] as String?,
          contract: row['contract'] as String?,
          token: row['token'] as String?,
          coinType: row['coinType'] as String?,
          state: row['state'] as int?,
          decimals: row['decimals'] as int?,
          price: row['price'] as double?,
          balance: row['balance'] as double?,
          digits: row['digits'] as int?,
          iconPath: row['iconPath'] as String?,
          chainType: row['chainType'] as int?,
          index: row['index'] as int?,
          kNetType: row['kNetType'] as int?,
          tokenType: row['tokenType'] as int?,
          tid: row['tid'] as String?),
    );
  }

  @override
  Future<int?> findMaxIndex(String owner) async {
    await _queryAdapter.queryNoReturn(
        'SELECT MAX(\'index\') FROM tokens_table where owner = ?1',
        arguments: [owner]);
  }

  @override
  Future<void> insertToken(MCollectionTokens model) async {
    await _mCollectionTokensInsertionAdapter.insert(
        model, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertTokens(List<MCollectionTokens> models) async {
    await _mCollectionTokensInsertionAdapter.insertList(
        models, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateTokens(List<MCollectionTokens> models) async {
    await _mCollectionTokensUpdateAdapter.updateList(
        models, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTokens(List<MCollectionTokens> models) async {
    await _mCollectionTokensDeletionAdapter.deleteList(models);
  }
}

class _$TransRecordModelDao extends TransRecordModelDao {
  _$TransRecordModelDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _transRecordModelInsertionAdapter = InsertionAdapter(
            database,
            'translist_table',
            (TransRecordModel item) => <String, Object?>{
                  'txid': item.txid,
                  'toAdd': item.toAdd,
                  'fromAdd': item.fromAdd,
                  'date': item.date,
                  'amount': item.amount,
                  'remarks': item.remarks,
                  'fee': item.fee,
                  'gasPrice': item.gasPrice,
                  'gasLimit': item.gasLimit,
                  'transStatus': item.transStatus,
                  'token': item.token,
                  'coinType': item.coinType,
                  'chainid': item.chainid,
                  'nonce': item.nonce,
                  'contractTo': item.contractTo,
                  'input': item.input,
                  'signMessage': item.signMessage,
                  'repeatPushCount': item.repeatPushCount,
                  'blockHeight': item.blockHeight,
                  'transType': item.transType
                }),
        _transRecordModelUpdateAdapter = UpdateAdapter(
            database,
            'translist_table',
            ['txid'],
            (TransRecordModel item) => <String, Object?>{
                  'txid': item.txid,
                  'toAdd': item.toAdd,
                  'fromAdd': item.fromAdd,
                  'date': item.date,
                  'amount': item.amount,
                  'remarks': item.remarks,
                  'fee': item.fee,
                  'gasPrice': item.gasPrice,
                  'gasLimit': item.gasLimit,
                  'transStatus': item.transStatus,
                  'token': item.token,
                  'coinType': item.coinType,
                  'chainid': item.chainid,
                  'nonce': item.nonce,
                  'contractTo': item.contractTo,
                  'input': item.input,
                  'signMessage': item.signMessage,
                  'repeatPushCount': item.repeatPushCount,
                  'blockHeight': item.blockHeight,
                  'transType': item.transType
                }),
        _transRecordModelDeletionAdapter = DeletionAdapter(
            database,
            'translist_table',
            ['txid'],
            (TransRecordModel item) => <String, Object?>{
                  'txid': item.txid,
                  'toAdd': item.toAdd,
                  'fromAdd': item.fromAdd,
                  'date': item.date,
                  'amount': item.amount,
                  'remarks': item.remarks,
                  'fee': item.fee,
                  'gasPrice': item.gasPrice,
                  'gasLimit': item.gasLimit,
                  'transStatus': item.transStatus,
                  'token': item.token,
                  'coinType': item.coinType,
                  'chainid': item.chainid,
                  'nonce': item.nonce,
                  'contractTo': item.contractTo,
                  'input': item.input,
                  'signMessage': item.signMessage,
                  'repeatPushCount': item.repeatPushCount,
                  'blockHeight': item.blockHeight,
                  'transType': item.transType
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TransRecordModel> _transRecordModelInsertionAdapter;

  final UpdateAdapter<TransRecordModel> _transRecordModelUpdateAdapter;

  final DeletionAdapter<TransRecordModel> _transRecordModelDeletionAdapter;

  @override
  Future<List<TransRecordModel>> queryAllTrxList(
      String fromAdd, String token, int chainid, int limit, int offset) async {
    return _queryAdapter.queryList(
        'SELECT * FROM translist_table WHERE (fromAdd = ?1 COLLATE NOCASE or toAdd =?1 COLLATE NOCASE )  and token = ?2 and chainid = ?3 ORDER BY date DESC limit ?4 offset ?5',
        mapper: (Map<String, Object?> row) => TransRecordModel(txid: row['txid'] as String?, toAdd: row['toAdd'] as String?, fromAdd: row['fromAdd'] as String?, date: row['date'] as String?, amount: row['amount'] as String?, remarks: row['remarks'] as String?, fee: row['fee'] as String?, transStatus: row['transStatus'] as int?, token: row['token'] as String?, coinType: row['coinType'] as String?, gasLimit: row['gasLimit'] as String?, gasPrice: row['gasPrice'] as String?, chainid: row['chainid'] as int?, nonce: row['nonce'] as int?, contractTo: row['contractTo'] as String?, input: row['input'] as String?, signMessage: row['signMessage'] as String?, repeatPushCount: row['repeatPushCount'] as int?, blockHeight: row['blockHeight'] as int?),
        arguments: [fromAdd, token, chainid, limit, offset]);
  }

  @override
  Future<List<TransRecordModel>> queryOutTrxList(
      String fromAdd, String token, int chainid, int limit, int offset) async {
    return _queryAdapter.queryList(
        'SELECT * FROM translist_table WHERE (fromAdd = ?1 COLLATE NOCASE)  and token = ?2 and chainid = ?3 ORDER BY date DESC limit ?4 offset ?5',
        mapper: (Map<String, Object?> row) => TransRecordModel(txid: row['txid'] as String?, toAdd: row['toAdd'] as String?, fromAdd: row['fromAdd'] as String?, date: row['date'] as String?, amount: row['amount'] as String?, remarks: row['remarks'] as String?, fee: row['fee'] as String?, transStatus: row['transStatus'] as int?, token: row['token'] as String?, coinType: row['coinType'] as String?, gasLimit: row['gasLimit'] as String?, gasPrice: row['gasPrice'] as String?, chainid: row['chainid'] as int?, nonce: row['nonce'] as int?, contractTo: row['contractTo'] as String?, input: row['input'] as String?, signMessage: row['signMessage'] as String?, repeatPushCount: row['repeatPushCount'] as int?, blockHeight: row['blockHeight'] as int?),
        arguments: [fromAdd, token, chainid, limit, offset]);
  }

  @override
  Future<List<TransRecordModel>> queryInTrxList(
      String fromAdd, String token, int chainid, int limit, int offset) async {
    return _queryAdapter.queryList(
        'SELECT * FROM translist_table WHERE (toAdd = ?1 COLLATE NOCASE)  and token = ?2 and chainid = ?3 ORDER BY date DESC limit ?4 offset ?5',
        mapper: (Map<String, Object?> row) => TransRecordModel(txid: row['txid'] as String?, toAdd: row['toAdd'] as String?, fromAdd: row['fromAdd'] as String?, date: row['date'] as String?, amount: row['amount'] as String?, remarks: row['remarks'] as String?, fee: row['fee'] as String?, transStatus: row['transStatus'] as int?, token: row['token'] as String?, coinType: row['coinType'] as String?, gasLimit: row['gasLimit'] as String?, gasPrice: row['gasPrice'] as String?, chainid: row['chainid'] as int?, nonce: row['nonce'] as int?, contractTo: row['contractTo'] as String?, input: row['input'] as String?, signMessage: row['signMessage'] as String?, repeatPushCount: row['repeatPushCount'] as int?, blockHeight: row['blockHeight'] as int?),
        arguments: [fromAdd, token, chainid, limit, offset]);
  }

  @override
  Future<List<TransRecordModel>> queryOtherTrxList(
      String fromAdd, String token, int chainid, int limit, int offset) async {
    return _queryAdapter.queryList(
        'SELECT * FROM translist_table WHERE (fromAdd = ?1 COLLATE NOCASE or toAdd =?1  COLLATE NOCASE)  and token = ?2 and chainid = ?3 and transStatus = 0 ORDER BY date DESC limit ?4 offset ?5',
        mapper: (Map<String, Object?> row) => TransRecordModel(txid: row['txid'] as String?, toAdd: row['toAdd'] as String?, fromAdd: row['fromAdd'] as String?, date: row['date'] as String?, amount: row['amount'] as String?, remarks: row['remarks'] as String?, fee: row['fee'] as String?, transStatus: row['transStatus'] as int?, token: row['token'] as String?, coinType: row['coinType'] as String?, gasLimit: row['gasLimit'] as String?, gasPrice: row['gasPrice'] as String?, chainid: row['chainid'] as int?, nonce: row['nonce'] as int?, contractTo: row['contractTo'] as String?, input: row['input'] as String?, signMessage: row['signMessage'] as String?, repeatPushCount: row['repeatPushCount'] as int?, blockHeight: row['blockHeight'] as int?),
        arguments: [fromAdd, token, chainid, limit, offset]);
  }

  @override
  Future<List<TransRecordModel>> queryPendingTrxList() async {
    return _queryAdapter.queryList(
        'SELECT * FROM translist_table WHERE  (transStatus = 2 OR transStatus = 3)  ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => TransRecordModel(
            txid: row['txid'] as String?,
            toAdd: row['toAdd'] as String?,
            fromAdd: row['fromAdd'] as String?,
            date: row['date'] as String?,
            amount: row['amount'] as String?,
            remarks: row['remarks'] as String?,
            fee: row['fee'] as String?,
            transStatus: row['transStatus'] as int?,
            token: row['token'] as String?,
            coinType: row['coinType'] as String?,
            gasLimit: row['gasLimit'] as String?,
            gasPrice: row['gasPrice'] as String?,
            chainid: row['chainid'] as int?,
            nonce: row['nonce'] as int?,
            contractTo: row['contractTo'] as String?,
            input: row['input'] as String?,
            signMessage: row['signMessage'] as String?,
            repeatPushCount: row['repeatPushCount'] as int?,
            blockHeight: row['blockHeight'] as int?));
  }

  @override
  Future<List<TransRecordModel>> queryTrxFromTrxid(String txid) async {
    return _queryAdapter.queryList(
        'SELECT * FROM translist_table WHERE txid = ?1',
        mapper: (Map<String, Object?> row) => TransRecordModel(
            txid: row['txid'] as String?,
            toAdd: row['toAdd'] as String?,
            fromAdd: row['fromAdd'] as String?,
            date: row['date'] as String?,
            amount: row['amount'] as String?,
            remarks: row['remarks'] as String?,
            fee: row['fee'] as String?,
            transStatus: row['transStatus'] as int?,
            token: row['token'] as String?,
            coinType: row['coinType'] as String?,
            gasLimit: row['gasLimit'] as String?,
            gasPrice: row['gasPrice'] as String?,
            chainid: row['chainid'] as int?,
            nonce: row['nonce'] as int?,
            contractTo: row['contractTo'] as String?,
            input: row['input'] as String?,
            signMessage: row['signMessage'] as String?,
            repeatPushCount: row['repeatPushCount'] as int?,
            blockHeight: row['blockHeight'] as int?),
        arguments: [txid]);
  }

  @override
  Future<void> insertTrxLists(List<TransRecordModel> models) async {
    await _transRecordModelInsertionAdapter.insertList(
        models, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateTrxLists(List<TransRecordModel> models) async {
    await _transRecordModelUpdateAdapter.updateList(
        models, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTrxList(TransRecordModel model) async {
    await _transRecordModelDeletionAdapter.delete(model);
  }
}

class _$NFTModelDao extends NFTModelDao {
  _$NFTModelDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _nFTModelInsertionAdapter = InsertionAdapter(
            database,
            'nft_model_table',
            (NFTModel item) => <String, Object?>{
                  'tokenID': item.tokenID,
                  'owner': item.owner,
                  'chainTypeName': item.chainTypeName,
                  'contractAddress': item.contractAddress,
                  'contractName': item.contractName,
                  'nftId': item.nftId,
                  'nftTypeName': item.nftTypeName,
                  'url': item.url,
                  'usdtValues': item.usdtValues,
                  'state': item.state,
                  'kNetType': item.kNetType
                }),
        _nFTModelUpdateAdapter = UpdateAdapter(
            database,
            'nft_model_table',
            ['tokenID'],
            (NFTModel item) => <String, Object?>{
                  'tokenID': item.tokenID,
                  'owner': item.owner,
                  'chainTypeName': item.chainTypeName,
                  'contractAddress': item.contractAddress,
                  'contractName': item.contractName,
                  'nftId': item.nftId,
                  'nftTypeName': item.nftTypeName,
                  'url': item.url,
                  'usdtValues': item.usdtValues,
                  'state': item.state,
                  'kNetType': item.kNetType
                }),
        _nFTModelDeletionAdapter = DeletionAdapter(
            database,
            'nft_model_table',
            ['tokenID'],
            (NFTModel item) => <String, Object?>{
                  'tokenID': item.tokenID,
                  'owner': item.owner,
                  'chainTypeName': item.chainTypeName,
                  'contractAddress': item.contractAddress,
                  'contractName': item.contractName,
                  'nftId': item.nftId,
                  'nftTypeName': item.nftTypeName,
                  'url': item.url,
                  'usdtValues': item.usdtValues,
                  'state': item.state,
                  'kNetType': item.kNetType
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<NFTModel> _nFTModelInsertionAdapter;

  final UpdateAdapter<NFTModel> _nFTModelUpdateAdapter;

  final DeletionAdapter<NFTModel> _nFTModelDeletionAdapter;

  @override
  Future<List<NFTModel>> findAllNFTS(String owner) async {
    return _queryAdapter.queryList(
        'SELECT * FROM nft_model_table WHERE owner = ?1',
        mapper: (Map<String, Object?> row) => NFTModel(
            tokenID: row['tokenID'] as String?,
            owner: row['owner'] as String?,
            chainTypeName: row['chainTypeName'] as String?,
            contractAddress: row['contractAddress'] as String?,
            contractName: row['contractName'] as String?,
            nftId: row['nftId'] as String?,
            nftTypeName: row['nftTypeName'] as String?,
            url: row['url'] as String?,
            state: row['state'] as int?,
            kNetType: row['kNetType'] as int?,
            usdtValues: row['usdtValues'] as String?),
        arguments: [owner]);
  }

  @override
  Future<List<NFTModel>> findNFTS(String owner, int kNetType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM nft_model_table WHERE owner = ?1 and kNetType=?2',
        mapper: (Map<String, Object?> row) => NFTModel(
            tokenID: row['tokenID'] as String?,
            owner: row['owner'] as String?,
            chainTypeName: row['chainTypeName'] as String?,
            contractAddress: row['contractAddress'] as String?,
            contractName: row['contractName'] as String?,
            nftId: row['nftId'] as String?,
            nftTypeName: row['nftTypeName'] as String?,
            url: row['url'] as String?,
            state: row['state'] as int?,
            kNetType: row['kNetType'] as int?,
            usdtValues: row['usdtValues'] as String?),
        arguments: [owner, kNetType]);
  }

  @override
  Future<List<NFTModel>> findChainNFTS(
      String owner, int kNetType, String chainType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM nft_model_table WHERE owner = ?1 and kNetType=?2 and chainTypeName=?3',
        mapper: (Map<String, Object?> row) => NFTModel(tokenID: row['tokenID'] as String?, owner: row['owner'] as String?, chainTypeName: row['chainTypeName'] as String?, contractAddress: row['contractAddress'] as String?, contractName: row['contractName'] as String?, nftId: row['nftId'] as String?, nftTypeName: row['nftTypeName'] as String?, url: row['url'] as String?, state: row['state'] as int?, kNetType: row['kNetType'] as int?, usdtValues: row['usdtValues'] as String?),
        arguments: [owner, kNetType, chainType]);
  }

  @override
  Future<List<NFTModel>> findStateNFTS(
      String owner, int state, int kNetType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM nft_model_table WHERE owner = ?1 and state = ?2 and kNetType=?3',
        mapper: (Map<String, Object?> row) => NFTModel(tokenID: row['tokenID'] as String?, owner: row['owner'] as String?, chainTypeName: row['chainTypeName'] as String?, contractAddress: row['contractAddress'] as String?, contractName: row['contractName'] as String?, nftId: row['nftId'] as String?, nftTypeName: row['nftTypeName'] as String?, url: row['url'] as String?, state: row['state'] as int?, kNetType: row['kNetType'] as int?, usdtValues: row['usdtValues'] as String?),
        arguments: [owner, state, kNetType]);
  }

  @override
  Future<List<NFTModel>> findStateChainNFTS(
      String owner, int state, int kNetType, String chainType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM nft_model_table WHERE owner = ?1 and state = ?2 and kNetType=?3 and chainTypeName =?4',
        mapper: (Map<String, Object?> row) => NFTModel(tokenID: row['tokenID'] as String?, owner: row['owner'] as String?, chainTypeName: row['chainTypeName'] as String?, contractAddress: row['contractAddress'] as String?, contractName: row['contractName'] as String?, nftId: row['nftId'] as String?, nftTypeName: row['nftTypeName'] as String?, url: row['url'] as String?, state: row['state'] as int?, kNetType: row['kNetType'] as int?, usdtValues: row['usdtValues'] as String?),
        arguments: [owner, state, kNetType, chainType]);
  }

  @override
  Future<List<NFTModel>> findNFTBySQL(String sql) async {
    return _queryAdapter.queryList(
      'SELECT * FROM nft_model_table WHERE $sql ',
      mapper: (Map<String, Object?> row) => NFTModel(
          tokenID: row['tokenID'] as String?,
          owner: row['owner'] as String?,
          chainTypeName: row['chainTypeName'] as String?,
          contractAddress: row['contractAddress'] as String?,
          contractName: row['contractName'] as String?,
          nftId: row['nftId'] as String?,
          nftTypeName: row['nftTypeName'] as String?,
          url: row['url'] as String?,
          state: row['state'] as int?,
          kNetType: row['kNetType'] as int?,
          usdtValues: row['usdtValues'] as String?),
    );
  }

  @override
  Future<void> updateNFTSData(String sql) async {
    await _queryAdapter.queryNoReturn('UPDATE nft_model_table SET $sql');
  }

  @override
  Future<void> insertNFTS(List<NFTModel> models) async {
    await _nFTModelInsertionAdapter.insertList(
        models, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateNFTS(List<NFTModel> models) async {
    await _nFTModelUpdateAdapter.updateList(models, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteNFTS(List<NFTModel> models) async {
    await _nFTModelDeletionAdapter.deleteList(models);
  }
}
