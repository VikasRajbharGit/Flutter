import 'dart:io';
import 'package:database/models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String table_name='userTable';

class DatabaseHelper{
  static final DatabaseHelper _instance=DatabaseHelper.internal();

  factory DatabaseHelper()=>_instance;

  static Database _db;
  Future<Database> get db async{
    if(_db!=null){
      return _db;
    }
    else{
      _db=await initDb();
      return _db;
    }
  }

  DatabaseHelper.internal();

  initDb() async{
    Directory DocumentDirectory=await getApplicationDocumentsDirectory();
    String path=join(DocumentDirectory.path,"maindb.db");
    var ourDb=await openDatabase(path,version: 1,onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db,int newVersion) async{   
    await db.execute(
      "CREATE TABLE $table_name('id' INTEGER PRIMARY KEY,'username' TEXT,'password' TEXT)"
    );
  }

  Future<int> SaveUser (User user) async{
    var dbClient = await db;
    var res = await dbClient.insert("$table_name", user.toMap());
    return res;

  }

  Future<List> getAllUsers() async{
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $table_name ");
    return result.toList();
  }

  Future<int> getCount() async{
    var dbClient = await db;
    return Sqflite.firstIntValue(
      await dbClient.rawQuery("SELECT COUNT(*) FROM $table_name")
    );
  }

  Future<User> getUser(int id) async{
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $table_name WHERE id=$id");
    if(result.length == 0) return null;
    return new User.fromMap(result.first);
  }

  Future<int> deleteUser(int id) async{
    var dbClient = await db;
    return await dbClient.delete(table_name, where: "id= ?", whereArgs: [id]);
  }

  Future<int> updateUser(User user) async{
    var dbClient = await db;
    return await dbClient.update(table_name, user.toMap(), where: "id= ?", whereArgs: [user.id]);
  }
  
  Future close() async{
    var dbClient= await db;
    dbClient.close();
  }
}