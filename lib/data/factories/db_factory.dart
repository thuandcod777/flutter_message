import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabaseFactory {
  Future<Database> createDatabase() async {
    String databasePath = await getDatabasesPath();
    String dbPath = join(databasePath, 'labalaba.db');

    var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
    return database;
  }

  void populateDb(Database db, int version) async {
    await _createChatTable(db);
    await _createMessagesTable(db);
  }

  _createChatTable(Database db) async {
    await db
        .execute(
          """create table chats(
            id text primary key,
            created_at timestamp default current_timestamp not null
          )""",
        )
        .then((_) => print('creating table chats...'))
        .catchError((e) => print('error creating chats table: $e'));
  }

  _createMessagesTable(Database db) async {
    await db
        .execute("""
          create table message(
            chat_id text not null,
            id text primary key,
            sender text not null,
            receiver text not null,
            contents text not null,
            receipt text not null,
            received_at timestamp not null,
            created_at timestamp default current_timestamp not null
          )
    """)
        .then((_) => print('creating table message'))
        .catchError((e) => print('error creating message table: $e'));
  }
}
