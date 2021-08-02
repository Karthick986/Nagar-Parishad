// ignore_for_file: prefer_const_declarations

import 'package:nagar_parishad/customer.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  
  static final _databaseName = "customers.db";

  static final _databaseVersion = 1;

  static final table = 'customer_list';

  static final surveyNo = 'survey_no';
  static final zoneNo = 'zone_no';
  static final wardNo = 'ward_no';
  static final plotNo = 'plot_no';
  static final propertyNoOld = 'propertyno_old';
  static final propertyNoNew = 'propertyno_new';
  static final address = 'address';
  static final totalAreaF = 'totalarea_foot';
  static final totalAreaM = 'totalarea_meter';
  static final rentAreaM = 'rentarea_meter';
  static final rentAreaF = 'rentarea_foot';
  static final propertyType = 'property_type';
  static final rentStatus = 'rent_status';

  // only have a single app-wide reference to the database
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    // ignore: unnecessary_null_comparison
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $surveyNo TEXT NOT NULL,
            $zoneNo TEXT NOT NULL,
            $wardNo TEXT NOT NULL
            $plotNo TEXT NOT NULL, 
            $propertyNoOld TEXT NOT NULL, 
            $propertyNoNew TEXT NOT NULL,
            $address TEXT NOT NULL, 
            $totalAreaF TEXT NOT NULL, 
            $totalAreaM TEXT NOT NULL, 
            $rentAreaF TEXT NOT NULL, 
            $rentAreaM TEXT NOT NULL, 
            $propertyType TEXT NOT NULL, 
            $rentStatus TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Customer customer) async {
    Database? db = await instance.database;
    return await db!.insert(table, {'survey_no': customer.surveyNo, 'zone_no': customer.zoneNo, 'ward_no': customer.wardNo});
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  // Queries rows based on the argument received
  // Future<List<Map<String, dynamic>>> queryRows(name) async {
  //   Database db = await instance.database;
  //   return await db.query(table, where: "$columnName LIKE '%$name%'");
  // }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  // Future<int?> queryRowCount() async {
  //   Database db = await instance.database;
  //   return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  // }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Customer customer) async {
    Database? db = await instance.database;
    int id = customer.toMap()['survey_no'];
    return await db!.update(table, customer.toMap(), where: '$surveyNo = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$surveyNo = ?', whereArgs: [id]);
  }
}