import 'package:articles_reader/domain/models/articles_result.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' as io;
import 'db_contracts.dart';

abstract class DbHelper {
  Future<int> saveArticle(Article article);

  Future<List> getAllArticles();

  Future<Article?> getArticle(int id);

  Future<int?> getCount();

  Future<int> deleteArticle(int id);

  Future deleteAllArticles();

  Future close();
}

class DbHelperImpl extends DbHelper {
  static final DbHelperImpl instance = DbHelperImpl.internal();

  bool isTesting = false;

  DbHelperImpl.internal();

  factory DbHelperImpl() => instance;
  DbHelperImpl.test({required this.isTesting});

  static Database? _database;

  initDB() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    if (isTesting) {
      var db = await databaseFactory.openDatabase(inMemoryDatabasePath, options: OpenDatabaseOptions(
          version: databaseVersion,
          onCreate: (db, version) => createDB(db, version)
      ));
      return db;
    } else {
      final io.Directory appDocsDirs = await getApplicationDocumentsDirectory();
      String path = join(appDocsDirs.path, 'databases', databaseName);
      var db = await databaseFactory.openDatabase(path, options: OpenDatabaseOptions(
          version: databaseVersion,
          onCreate: (db, version) => createDB(db, version)
      ));
      return db;
    }
  }

  createDB(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $tableName('
        '$columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, '
        '$columnTitle TEXT, '
        '$columnAuthor TEXT, '
        '$columnSource TEXT, '
        '$columnDescription TEXT, '
        '$columnUrl TEXT, '
        '$columnUrlToImage TEXT, '
        '$columnPublished TEXT, '
        '$columnContent TEXT)');
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  @override
  Future<int> saveArticle(Article article) async {
    var dbClient = await database;
    var result = dbClient.insert(tableName, article.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  @override
  Future<List> getAllArticles() async {
    var dbClient = await database;
    var result = await dbClient.query(tableName, columns: [
      columnId,
      columnTitle,
      columnAuthor,
      columnSource,
      columnDescription,
      columnUrl,
      columnUrlToImage,
      columnPublished,
      columnContent
    ]);
    return result.toList();
  }

  @override
  Future<Article?> getArticle(int id) async {
    var dbClient = await database;
    List<Map> result = await dbClient.query(tableName,
        columns: [
          columnId,
          columnTitle,
          columnAuthor,
          columnSource,
          columnDescription,
          columnUrl,
          columnUrlToImage,
          columnPublished,
          columnContent
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (result.isNotEmpty) {
      return Article.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<int?> getCount() async {
    var dbClient = await database;
    var result =
        await dbClient.rawQuery('SELECT COUNT(*) as TOTAL FROM $tableName');
    return result[0]['TOTAL'] as int;
  }

  @override
  Future<int> deleteArticle(int id) async {
    var dbClient = await database;
    return await dbClient
        .delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  @override
  Future deleteAllArticles() async {
    var dbClient = await database;
    await dbClient.delete(tableName);
  }

  @override
  Future close() async {
    var dbClient = await database;
    return dbClient.close();
  }
}
