import 'dart:async';
import 'dart:io';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/util/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper{

  DatabaseHelper.make();
  static final DatabaseHelper INSTANCE = new DatabaseHelper.make();

  factory DatabaseHelper() => INSTANCE;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, Constants.DBNAME);
    var myDb = openDatabase(path, version: Constants.DB_VERSION, onCreate: _onCreate);
    return myDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE ${Constants.TABLE_NAME} (${Constants.COLUM_ID} INTEGER PRIMARY KEY, "
            "${Constants.COLUM_NAME} TEXT, ${Constants.COLUM_DATE} TEXT );");
  }

  Future<int> insertNote(Note note) async {
    var dbClient = await db;
    int count = await dbClient.insert(Constants.TABLE_NAME, note.toMap());

    return count;
  }

  Future<List> getAllNotes() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT * FROM ${Constants.TABLE_NAME} ORDER BY ${Constants.COLUM_NAME} ASC");

    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    int count = Sqflite.firstIntValue(await dbClient
        .rawQuery("SELECT COUNT(*) FROM ${Constants.TABLE_NAME}"));
    return count;
  }

  Future<Note> getSingleItem(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT * FROM ${Constants.TABLE_NAME} WHERE ${Constants.COLUM_ID} = $id");
    if (result == null) return null;
    return new Note.fromMap(result.first);
  }


  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    int count = await dbClient.delete(Constants.TABLE_NAME,
        where: "${Constants.COLUM_ID} = ?", whereArgs: [id]);
    return count;
  }


  Future<int> updateItem(Note note) async {
    var dbClient = await db;
    int count = await dbClient.update(Constants.TABLE_NAME, note.toMap(),
        where: "${Constants.COLUM_ID} = ?", whereArgs: [note.id]);

    return count;
  }

}