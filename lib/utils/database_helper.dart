import 'dart:io';
import 'package:jplatform/models/logicalref.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String _logicalRefTable = 'logical';
  String _columnRef = 'logicalRef';
  String _columnOk = 'ok';

  factory DatabaseHelper(){
      if(_databaseHelper == null){
        _databaseHelper = DatabaseHelper._internal();
        return _databaseHelper;
      }else {
        return _databaseHelper;
      }
  }
  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if(_database == null){
      _database = await _initializeDatabase();
      return _database;
    }else{
      return _database;
    }
  }
  _initializeDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String dbPath = join(folder.path, "logicalref.db");
    var logicalRefDB = openDatabase(dbPath, version: 1, onCreate: _createDB);
    return logicalRefDB;
  }
  Future<void> _createDB(Database db, int version) async {
     await db.execute("CREATE TABLE $_logicalRefTable ($_columnRef INTEGER, $_columnOk INTEGER) ");
  }

  Future<int> addRef(Logicalreff logicalref) async {
    var db = await _getDatabase();
    var id = await db.insert(_logicalRefTable, logicalref.toMap(), nullColumnHack: "$_columnRef");
    return id;
  }
  Future<List<Map<String, dynamic>>> allRef() async {
    var db = await _getDatabase();
    var result = await db.query(_logicalRefTable, orderBy: '$_columnRef DESC');
    return result;
  }

}
