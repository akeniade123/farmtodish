import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  String? dbName;
  String? tableName;
  String? fieldString;
  Database? database;

/*
For the future me

there are sometimes that i initialized the DatabaseHelper class such that it doesnt neccesarily create a database or a table 
it is just to connect to the data base and do some modifications

and some times i run the 'CREATE IF NOT EXISTS ' COMMAND to make sure no error in fetching the datas


 */

  List<Map<String, String>> fieldData = [];
  DatabaseHelper(
      {this.tableName, this.dbName = 'userDetails.db', this.fieldString}) {
    initDatabase(tableName);
  }

  Future<Database> initDatabase(String? tableName) async {
    // String dbPath = await getDatabasesPath();

    // avoid_print(dbPath);

    database = await openDatabase(
      dbName!,
      version: 1,
      onCreate: (Database db, int version) async {
        if (tableName != null) {
          await db.execute('''          CREATE TABLE IF NOT EXISTS $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT, $fieldString )
        ''');
        }
      },
    );
    return database!;
  }

  // CRUD Operations
  Future<bool> columnExists(String tableNam, String column) async {
    final db = database ?? await initDatabase(tableName);
    final schema = await db.rawQuery('PRAGMA table_info($tableNam)');

    return schema.any((row) => row['name'] == column);
  }

  Future<int> insert(Map<String, dynamic> data, String tableNam) async {
    final Database db = database ?? await initDatabase(tableName);
    for (var i in data.keys) {
      if (!(await columnExists(tableNam, i))) {
        // i am presently ignoring the data type of the column being inserted
        await db.execute('ALTER TABLE $tableNam ADD COLUMN $i TEXT');
      }
    }
    return await db.insert(tableNam, data);
  }

  Future<bool> tableExists(Database db, String tableNam) async {
    final result = await db
        .query('sqlite_master', where: 'name = ?', whereArgs: [tableNam]);
    return result.isNotEmpty;
  }

  Future<List<Map<String, Object?>>> listTable() async {
    final Database db = database ?? await initDatabase(tableName);
    final result = await db.query('sqlite_master');
    return result;
  }

  Future<void> updateRow(
      String table, int id, Map<String, dynamic> values) async {
    // Update the row.
    final db = database ?? await initDatabase(tableName);
    await db.update(table, values, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> createTable(String SQLString) async {
    // Open a connection to the database.
    final db = database ?? await initDatabase(tableName);
    final tableExists = await this.tableExists(db, 'users');
    if (tableExists) {
    } else {
      await db.execute(SQLString);

      // Close the database connection.
    }

    // Execute the CREATE TABLE statement.
  }

  Future<List<Map<String, dynamic>>> getAll(String tableName) async {
    final Database db = database ?? await initDatabase(tableName);
    return await db.query(tableName);
  }

  Future<int> update(Map<String, dynamic> data, String tableName) async {
    final Database db = database ?? await initDatabase(tableName);
    return await db.update(
      tableName,
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }

  Future<int> delete(int id, String tableName) async {
    final Database db = database ?? await initDatabase(tableName);
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> clearTable(String tableName) async {
    final Database db = database ?? await initDatabase(tableName);
    return await db.delete(
      tableName,
    );
  }
}
