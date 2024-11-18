import 'dart:developer';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

import 'global_handlers.dart';
import 'tbl_procession.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 20;
  final String table;

  DatabaseHelper({required this.table});

  late Database _db;

  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _loopCreate);
  }

  Future _onCreate(Database db, int version) async {
    tblFunc(db);
  }

  Future<bool> tableExists(Database db, String table) async {
    List exist =
        await db.query('sqlite_master', where: 'name = ?', whereArgs: [table]);
    if (exist.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future _loopCreate(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      tblFunc(db);
    }
  }

  Future tblFunc(Database db) async {
    explicit().forEach((key, value) async {
      try {
        if (await tableExists(db, key) == false) {
          await db.execute('''
          CREATE TABLE $key ( $value )''');
          log("table created$key");
        } else {
          log("table $key exists already");
        }
      } catch (e) {
        log("tbl create error:$e.toString()");
      }
    });

    procession().forEach(
      (key, value) async {
        try {
          String crtt = "";
          for (int i = 0; i < value.length; i++) {
            crtt += "${value[i]} TEXT NOT NULL";
            if (i < value.length - 1) {
              crtt += ",";
            }
          }
          if (await tableExists(db, key) == false) {
            await db.execute('''
          CREATE TABLE $key ( $crtt )''');
            logger("table created$key");
          } else {
            logger("table $key exists already");
          }
        } catch (e) {
          logger("tbl create error:${e.toString()}");
        }
      },
    );
  }
}
