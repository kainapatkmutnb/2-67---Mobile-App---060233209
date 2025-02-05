import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  // Get the database instance
  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  // Initialize the database
  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'appDBbmi2.db');

    return await openDatabase(
      path,
      version: 3, // Update version to apply new schema changes
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Create the table (New Users)
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tbUsers (
        id INTEGER PRIMARY KEY,
        username TEXT,
        email TEXT,
        pwd TEXT,
        weight REAL,
        height REAL,
        bmi REAL,
        bmi_type TEXT,
        bmi_image TEXT
      )
    ''');
  }

  // Upgrade the database (Existing Users)
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE tbUsers ADD COLUMN bmi REAL');
      await db.execute('ALTER TABLE tbUsers ADD COLUMN bmi_type TEXT');
      await db.execute('ALTER TABLE tbUsers ADD COLUMN bmi_image TEXT');
      await updateAllBmi(); // Recalculate BMI for existing users
    }
  }

  // Insert a new user into the database
  Future<int> insertUser(User user) async {
    Database db = await instance.db;
    return await db.insert('tbUsers', user.toMap());
  }

  // Query all users from the database
  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    Database db = await instance.db;
    return await db.query('tbUsers');
  }

  // Convert query results to a list of User objects
  Future<List<User>> getUsers() async {
    List<Map<String, dynamic>> usersMap = await queryAllUsers();
    return usersMap.map((map) => User.fromMap(map)).toList();
  }

  // Update user information in the database
  Future<int> updateUser(User user) async {
    Database db = await instance.db;
    return await db.update(
      'tbUsers',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Delete user from the database
  Future<int> deleteUser(int id) async {
    Database db = await instance.db;
    return await db.delete('tbUsers', where: 'id = ?', whereArgs: [id]);
  }

  // Delete all users
  Future<void> deleteAllUsers() async {
    Database db = await instance.db;
    await db.delete('tbUsers');
  }

  // Update BMI for all users (after schema upgrade)
  Future<void> updateAllBmi() async {
    Database db = await instance.db;
    List<User> users = await getUsers();

    for (User user in users) {
      double bmi = User.calculateBmi(user.weight, user.height);
      String bmiType = User.determineBmiType(bmi);
      String bmiImage = User.determineBmiImage(bmi);

      await db.update(
        'tbUsers',
        {'bmi': bmi, 'bmi_type': bmiType, 'bmi_image': bmiImage},
        where: 'id = ?',
        whereArgs: [user.id],
      );
    }
  }

  // Initialize some default users in the database (Optional)
  Future<void> initializeUsers() async {
    List<User> usersToAdd = [
      User(
        username: 'John',
        email: 'john@example.com',
        pwd: '9999',
        weight: 80,
        height: 170,
      ),
      User(
        username: 'Jane',
        email: 'jane@example.com',
        pwd: '1234',
        weight: 55,
        height: 160,
      ),
    ];

    for (User user in usersToAdd) {
      await insertUser(user);
    }
  }
}