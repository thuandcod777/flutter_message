import 'package:chat/src/models/message.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/encryption/encryption_service.dart';
import 'package:chat/src/services/message/message_service_impl.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'helper.dart';

void main() {
  Rethinkdb r = Rethinkdb();
  Connection connection;
  MessageService sut;

  setUp(() async {
    connection = await r.connect(host: '127.0.0.1', port: 8080);
    final encryption = EncryptionService(Encrypter(AES(Key.fromLength(32))));
    await createDb(r, connection);
    sut = MessageService(r, connection, encryption);
  });

  tearDown(() async {
    sut.disponse();
    await cleanDb(r, connection);
  });

  final user =
      User.fromJson({'id': '1234', 'active': true, 'lastseen': DateTime.now()});

  final user2 =
      User.fromJson({'id': '1111', 'active': true, 'lastseen': DateTime.now()});

  test('send message successfully', () async {
    Message message = Message(
        from: user.id,
        to: '3456',
        timestamp: DateTime.now(),
        container: 'this is a message');

    final res = await sut.send(message);
    expect(res, true);
  });

  test('successfully subcribe and recevie message', () async {
    final contents = 'this this is a message';
    sut.messages(activeUser: user2).listen(expectAsync1((message) {
          expect(message.to, user2.id);
          expect(message.id, isNotEmpty);
          expect(message.container, contents);
        }, count: 2));

    Message message = Message(
        from: user.id,
        to: user2.id,
        timestamp: DateTime.now(),
        container: contents);

    Message secondMessage = Message(
        from: user.id,
        to: user2.id,
        timestamp: DateTime.now(),
        container: contents);

    await sut.send(message);
    await sut.send(secondMessage);
  });

  test('successfully subcribe and recevie message', () async {
    Message message = Message(
        from: user.id,
        to: user2.id,
        timestamp: DateTime.now(),
        container: 'this this is a message');
    Message secondMessage = Message(
        from: user.id,
        to: user2.id,
        timestamp: DateTime.now(),
        container: 'this this is a message');

    await sut.send(message);
    await sut.send(secondMessage).whenComplete(
          () => sut.messages(activeUser: user2).listen(
                expectAsync1((message) {
                  expect(message.to, user2.id);
                }, count: 2),
              ),
        );
  });
}
