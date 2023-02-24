import 'dart:io';
import 'package:api_to_sqlite/src/models/information_model.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;
  //static final DBProvider db = DBProvider._();
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Information table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'information_manager.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE info('
          'id TEXT PRIMARY KEY,'
          'name TEXT,'
          'avatar TEXT,'
          'createdAt INTEGER'
          ')');
    });
  }

  // Insert information on database
  createInformation(Information newInformation) async {
    await deleteAllInformation();
    final db = await database;
    final res = await db?.insert('info', newInformation.toJson());
    return res;
  }

  // Delete all information
  Future<int?> deleteAllInformation() async {
    final db = await database;
    final res = await db?.rawDelete('DELETE FROM info');
    return res;
  }

  Future<List<Information?>> getAllInformation() async {
    final db = await database;
    final res = await db?.rawQuery("SELECT * FROM info");

    List<Information> list =
        res!.isNotEmpty ? res.map((c) => Information.fromJson(c)).toList() : [];

    return list;
  }
}
