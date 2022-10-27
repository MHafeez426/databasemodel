import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future <void> createTables(sql.Database database) async {
    await database.execute(""""create Table items(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    username TEXT,
    password TEXT,
    email TEXT,
    created At TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    
    )""");
  }

  static Future <sql.Database> db() async {
    return sql.openDatabase(
        'kindacode.db',
        version: 1,
        onCreate: (sql.Database database, int version) async {
          await createTables(database);
        }
    );
  }

  //
  static Future<int> createItem(String username, String password,
      String email) async {
    final db = await SQLHelper.db();
    final data = {'username': username, 'password': password, 'email': email};
    final id = await db.insert(
        'items', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //
  static Future <List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  //
  static Future <int> updateItem(int id, String username, String password, String email) async {
    final db = await SQLHelper.db();
    final data = {'username':username, 'password':password, 'email':email,
      'createdAt': DateTime.now().toString()
    };
    final result = await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  //
  static Future <void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id", whereArgs: [id]);
    } catch (err) {
      debugPrint("something went wrong:$err");
    }
  }
}