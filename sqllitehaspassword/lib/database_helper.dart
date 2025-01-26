import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get db async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'databasesapp.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tbUsers (
        id INTEGER PRIMARY KEY,
        username TEXT,
        email TEXT,
        password TEXT,
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  // Insert a new user into the database
  Future<int> insertUser(User user) async {
    Database db = await this.db;
    return await db.insert('tbUsers', user.toMap());
  }

  // Query all users from the database
  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    Database db = await this.db;
    return await db.query('tbUsers');
  }

  // Update user information in the database
  Future<int> updateUser(User user) async {
    Database db = await this.db;
    return await db.update(
      'tbUsers',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Delete user from the database
  Future<int> deleteUser(int id) async {
    Database db = await this.db;
    return await db.delete(
      'tbUsers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all users from the database
  Future<void> deleteAllUsers() async {
    Database db = await this.db;
    await db.delete('tbUsers');
  }

  // Initialize some default users in the database
  Future<void> initializeUsers() async {
    List<User> usersToAdd = [
      User(
        username: 'John',
        email: 'john@example.com',
        password: 'password123',
        createdAt: DateTime.now().toString(),
      ),
      User(
        username: 'Jane',
        email: 'jane@example.com',
        password: 'password123',
        createdAt: DateTime.now().toString(),
      ),
    ];

    for (User user in usersToAdd) {
      await insertUser(user);
    }
  }
}