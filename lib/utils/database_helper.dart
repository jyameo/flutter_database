import 'dart:async';
import 'dart:io';

import 'package:flutter_crud_database/models/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  final String tableName = "userTable";
  final String columnId = "id";
  final String columnUsername = "username";
  final String columnPassword = "password";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "maindb.db");

    var my_db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return my_db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(""
        "Create Table $tableName("
        "$columnId INTEGER PRIMARY KEY, "
        "$columnUsername TEXT, "
        "$columnPassword TEXT)");
  }

  //Create
  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert('$tableName', user.toMap());
    return res;
  }

  Future<List> getAllUsers() async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $tableName");
    return res;
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(""
        "SELECT COUNT(*) FROM $tableName"));
  }

  Future<User> getUser(int id) async {
    var dbClient = await db;

    var res = await dbClient.rawQuery(""
        "SELECT * FROM $tableName "
        "WHERE $columnId = $id");
    if (res.length == 0) return null;

    return new User.fromMap(res.first);
  }

  Future<int> deleteUser(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> updateUser(User user) async {
    var dbClient = await db;
    return dbClient.update(tableName, user.toMap(),
        where: "$columnId = ?", whereArgs: [user.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
