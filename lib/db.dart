import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'Contact.dart';
class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._();

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'contacts.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE contacts(
            id INTEGER PRIMARY KEY,
            name TEXT,
            contact TEXT,
            email TEXT)
        ''');
      },
      version: 1,
    );
  }
//read
  Future<List<Map<String, dynamic>>> getContacts() async {
    final Database db = await database;
    return db.query('contacts');
  }
//insert
  Future<int> insertContact(Contact contact) async {
    final Database db = await database;
    return db.insert(
      'contacts',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
//update
  Future<int> updateContact(Contact contact) async {
    final Database db = await database;
    return db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }
//delete
  Future<int> deleteContact(int id) async {
    final Database db = await database;
    return db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}



