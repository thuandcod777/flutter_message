import 'package:chat/chat.dart';
import 'package:flutter_message/data/datasources/sqflite_datasource.dart';
import 'package:flutter_message/models/chat.dart';
import 'package:flutter_message/models/local_message..dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

class MockSqfliteDatabase extends Mock implements Database {}

class MockBatch extends Mock implements Batch {}

void main() {
  SqfliteDatasource sut;
  MockSqfliteDatabase database;
  MockBatch batch;

  setUp(() {
    database = MockSqfliteDatabase();
    batch = MockBatch();
    sut = SqfliteDatasource(database);
  });

  final message = Message.fromJson({
    'from': '111',
    'to': '111',
    'container': 'hey',
    'timestamp': DateTime.parse("2021-04-01"),
    'id': '4444',
  });

  test('should perform insert of chat to the database', () async {
    final chat = Chat('1234');
    when(database.insert('chats', chat.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .thenAnswer((_) async => 1);
    await sut.addChat(chat);

    verify(database.insert('chats', chat.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .called(1);
  });

  test('should perform insert of message to the database', () async {
    final localMessage = LocalMessage('1234', message, ReceiptStatus.sent);

    when(database.insert('messages', localMessage.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .thenAnswer((_) async => 1);

    await sut.addMessage(localMessage);

    verify(database.insert('messages', localMessage.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .called(1);
  });

  test('should perform a database query and return message', () async {
    final messageMap = [
      {
        'chat_id': '111',
        'id': '4444',
        'from': '111',
        'to': '222',
        'container': 'hey',
        'receipt': 'sent',
        'timestamp': DateTime.parse("2021-04-01"),
      }
    ];

    when(database.query('messages',
            where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
        .thenAnswer((_) async => messageMap);

    var messages = await sut.findMessages('111');

    expect(messages.length, 1);
    expect(messages.first.chatId, '111');
    verify(database.query('messages',
            where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
        .called(1);
  });

  test('should perform database batch delete of chat', () async {
    final chatId = '111';
    when(database.batch()).thenReturn(batch);

    await sut.deleteChat(chatId);

    verifyInOrder([
      database.batch(),
      batch.delete('message', where: anyNamed('where'), whereArgs: [chatId]),
      batch.delete('chats', where: anyNamed('where'), whereArgs: [chatId]),
      batch.commit(noResult: true)
    ]);
  });
}
