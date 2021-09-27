import 'package:db_application_1/place.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

 
class DatabaseHelper {
 
  static final _databaseName = "placedb.db";
  static final _databaseVersion = 1;
 
  static final table = 'places_table';
 
  static final columnId = 'id';
  static final columnName = 'name';
  static final columnMiles = 'miles';
 
  
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
 
  
  static Database ? _database;
Future <Database> get database async{
    return _database ??= await _initDatabase();
}
 
  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }
 
  // create table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnMiles INTEGER NOT NULL
          )
          ''');
  }
 
  
  Future<int> insert(Car car) async {
    Database db = await instance.database;
    return await db.insert(table, {'name': car.name, 'miles': car.miles});
  }
 
  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }
   
  
  Future<List<Map<String, dynamic>>> queryRows(name) async {
    Database db = await instance.database;
    return await db.query(table, where: "$columnName LIKE '%$name%'");
  }
 

  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    int? count= Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
    return count;
  }

 
  Future<int> update(Car car) async {
    Database db = await instance.database;
    int id = car.toMap()['id'];
    return await db.update(table, car.toMap(), where: '$columnId = ?', whereArgs: [id]);
  }
 

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}