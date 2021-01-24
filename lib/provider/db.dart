import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:demo_list/model/country.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {

  // create  a private constructor (Prevent instatantiation)
  DBProvider._();
  static Database _db;
  //calling own constructor
  static final DBProvider dbProvider= DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_db != null) return _db;
    // If database don't exists, create one
    _db = await initDB();
    return _db;
  }
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'favourite_country.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE Countries('
              'code STRING PRIMARY KEY,'
              'country STRING,'
              'region STRING'
              ')');
        });
  }
  
  
  addCountry(CountryDetail countryDetail) async {
    final db = await database;
    final res = await db.insert('Countries', countryDetail.toJson());
    return res;
  }
  
  Future<List<CountryDetail>> getAllFavouriteCountry() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Countries");
    List<CountryDetail> list = res.isNotEmpty ? res.map((c) => CountryDetail.fromMap(c)).toList() : [];
    return list;
  }
  deleteCountry(String code) async{
    final db= await database;
    await db.delete('Countries',where: "code=?",whereArgs: [code]);
  }
  dropTable() async
  {
    final db= await database;
    db.rawDelete("delete from Countries");
  }
}