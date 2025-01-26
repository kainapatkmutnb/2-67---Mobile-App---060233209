import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  //------------------------
  // Database Initialization
  //------------------------

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'appDB.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tbUsers (
        id INTEGER PRIMARY KEY,
        username TEXT,
        email TEXT,
        password TEXT,     // Added password column
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP  // Added createdAt column
      )
    ''');
  }

  //------------------------
  // CRUD Operations
  //------------------------

  Future<int> insertUser(User user) async {
    Database db = await instance.db;
    return await db.insert('tbUsers', user.toMap());
  }

  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    Database db = await instance.db;
    return await db.query('tbUsers');
  }

  Future<int> updateUser(User user) async {
    Database db = await instance.db;
    return await db.update(
      'tbUsers', 
      user.toMap(), 
      where: 'id = ?', 
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    Database db = await instance.db;
    return await db.delete(
      'tbUsers', 
      where: 'id = ?', 
      whereArgs: [id],
    );
  }

  //------------------------
  // Utility Methods
  //------------------------

  Future<void> deleteAllUsers() async {
    Database db = await instance.db;
    await db.delete('tbUsers');
  }

  Future<void> initializeUsers() async {
    List<User> usersToAdd = [
      User(username: 'John', email: 'john@example.com'),
      User(username: 'Jane', email: 'jane@example.com'),
      User(username: 'Alice', email: 'alice@example.com'),
      User(username: 'Bob', email: 'bob@example.com'),
    ];

    for (User user in usersToAdd) {
      await insertUser(user);
    }
  }
}