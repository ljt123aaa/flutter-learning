import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:english_words/english_words.dart';

class DatabaseHelper {
  // 单例模式：确保整个应用只打开一个数据库连接
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  // 获取数据库连接
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('favorites.db');
    return _database!;
  }

  // 初始化数据库
  Future<Database> _initDB(String filePath) async {
    // 获取设备上存放数据库的默认路径
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // 打开数据库，如果不存在就创建它，并执行 onCreate 里的建表语句
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // 创建表（SQL语句）
  Future _createDB(Database db, int version) async {
    // 我们建一个叫 'favorites' 的表
    // id 是自增主键，first 和 second 分别存单词的两部分
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first TEXT NOT NULL,
        second TEXT NOT NULL
      )
      ''',
    );
  }

  // ================= 增删改查 (CRUD) 操作 =================
  // 1. 增 (Insert)
  Future<void> addFavorite(WordPair pair) async {
    final db = await instance.database;
    // 把 WordPair 拆成字典存进去
    await db.insert('favorites', {
      'first': pair.first,
      'second': pair.second,
    });
  }

  // 2. 删 (Delete)
  Future<void> removeFavorite(WordPair pair) async {
    final db = await instance.database;
    // 根据first 和 second 的值来删除对应的数据
    await db.delete(
      'favorites',
      where: 'first = ? AND second = ?',
      whereArgs: [pair.first, pair.second],
    );
  }

  // 3.查（Query）
  Future<List<WordPair>> getAllFavorites() async {
    final db = await instance.database;
    // 查询表里所有数据
    final result = await db.query('favorites');

    // 把查出来的字典列表，转换回Dart认识的WordPair列表
    return result.map((json) {
      return WordPair(json['first'] as String, json['second'] as String);
    }).toList();
  }
}
