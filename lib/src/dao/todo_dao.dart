import 'dart:core';
import 'package:api_to_sqlite/src/providers/db_provider.dart';
import 'package:api_to_sqlite/src/models/information_model.dart';
import 'package:api_to_sqlite/db_provider.dart';

var informationTable = 'Information';

class InformationDao {
  final dbProvider = DBProvider.db;

  //Adds new Todo records
  Future<Future<int>?> createInformation(Information information) async {
    final db = await dbProvider.database;
    var result = db?.insert(informationTable, information.toJson());
    return result;
  }

  //Get All Todo items
  Future<List<Information>> getInformation() async {
    final database = await dbProvider.database;
    var result = await database?.rawQuery("select * from $informationTable");
    List<Information> infolist = result != null
        ? result.map((c) => Information.fromJson(c)).toList()
        : [];
    return infolist;
  }

  //Update Todo record
  //Update Todo record
  Future<int> updateTodo(Information todo) async {
    final db = await dbProvider.database;

    var result = await db?.update(informationTable, todo.toJson(),
        where: "id = ?", whereArgs: [todo.id]);

    return result ?? -1;
  }

  //Delete Todo records
  Future<int?> deleteInformation(int id) async {
    final db = await dbProvider.database;
    var result =
        await db?.delete(informationTable, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //Delete Todo records
  Future<int?> CreateInformation(int id) async {
    final db = await dbProvider.database;
    var result =
        await db?.delete(informationTable, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllTodos() async {
    final db = await dbProvider.database;
    var result = await db?.delete(
      informationTable,
    );
    return result;
  }
}
