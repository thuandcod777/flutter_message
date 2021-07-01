import 'package:flutter_message/data/datasources/datasource_contract.dart';
import 'package:flutter_message/models/local_message..dart';
import 'package:flutter_message/models/chat.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatasource implements IDatasource {
  final Database _db;
  const SqfliteDatasource(this._db);

  @override
  Future<void> addChat(Chat chat) async {
    await _db.insert('chats', chat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> addMessage(LocalMessage message) async {
    await _db.insert('message', message.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final batch = _db.batch();
    batch.delete('message', where: 'chat_id = ?', whereArgs: [chatId]);
    batch.delete('chats', where: 'id = ?', whereArgs: [chatId]);
    await batch.commit(noResult: true);
  }

  @override
  Future<List<Chat>> findAllChats() {
    return _db.transaction((txn) async {
      final chatsWithLatestMessage = await txn.rawQuery('''select message.* from
      (select 
        chat_id, max(created_at) as created_at
       from message
       group by chat_id
      ) as latest_message
      inner join message
      on message.chat_id = latest_message.chat_id
      and message.created_at = latest_message.created_at
      order by message.created_at desc''');

      if (chatsWithLatestMessage.isEmpty) return [];

      final chatsWithUnreadMessages =
          await txn.rawQuery('''select chat_id, count(*) as unread 
          from message
          where receipt = ? 
          group by chat_id
          ''', ['deliverred']);

      return chatsWithLatestMessage.map<Chat>((row) {
        final int unread = chatsWithUnreadMessages.firstWhere(
            (element) => row['chat_id'] == element['chat_id'],
            orElse: () => {'unread': 0})['unread'];

        final chat = Chat.fromMap({"id": row['chat_id']});
        chat.unread = unread;
        chat.mostRecent = LocalMessage.fromMap(row);
        return chat;
      }).toList();
    });
  }

  @override
  Future<Chat> findChat(String chatId) async {
    return await _db.transaction((txn) async {
      final listOfChatMaps = await txn.query(
        'chats',
        where: 'id = ?',
        whereArgs: [chatId],
      );

      if (listOfChatMaps.isEmpty) return null;

      final unread = Sqflite.firstIntValue(await txn.rawQuery(
          'select count(*) from message where chat_id = ? and receipt = ?',
          [chatId, 'deliverred']));

      final mostRecentMessage = await txn.query('message',
          where: 'chat_id = ?',
          whereArgs: [chatId],
          orderBy: 'created_at desc',
          limit: 1);

      final chat = Chat.fromMap(listOfChatMaps.first);
      chat.unread = unread;
      chat.mostRecent = LocalMessage.fromMap(mostRecentMessage.first);
      return chat;
    });
  }

  @override
  Future<List<LocalMessage>> findMessages(String chatId) async {
    final listOfMaps =
        await _db.query('message', where: 'chat_id = ?', whereArgs: [chatId]);

    return listOfMaps
        .map<LocalMessage>((map) => LocalMessage.fromMap(map))
        .toList();
  }

  @override
  Future<void> updateMessage(LocalMessage message) async {
    await _db.update('message', message.toMap(),
        where: 'id = ?',
        whereArgs: [message.message.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
