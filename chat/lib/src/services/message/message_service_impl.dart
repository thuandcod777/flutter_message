import 'dart:async';

import 'package:chat/src/models/user.dart';
import 'package:chat/src/models/message.dart';
import 'package:chat/src/services/encryption/encryption_contract.dart';
import 'package:chat/src/services/message/message_service_contract.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class MessageService implements IMessageService {
  final Connection _connection;
  final Rethinkdb r;
  final IEncrytion _encrytion;

  final _controller = StreamController<Message>.broadcast();

  StreamSubscription _changefeed;

  MessageService(this.r, this._connection, {IEncrytion encrytion})
      : _encrytion = encrytion;

  @override
  disponse() {
    _controller?.close();
    _changefeed?.cancel();
  }

  @override
  Stream<Message> messages({User activeUser}) {
    _startReceivingMessages(activeUser);
    return _controller.stream;
  }

  @override
  Future<bool> send(Message message) async {
    var data = message.toJson();
    if (_encrytion != null)
      data['contents'] = _encrytion.encrypt(message.contents);
    Map record = await r.table('message').insert(data).run(_connection);
    return record['inserted'] == 1;
  }

  _startReceivingMessages(User user) {
    _changefeed = r
        .table('message')
        .filter({'to': user.id})
        .changes({'include_initial': true})
        .run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event
              .forEach((feedData) {
                if (feedData['new_val'] == null) return;

                final message = _messageFromFeed(feedData);

                _controller.sink.add(message);
                _removeDeliverredMessage(message);
              })
              .catchError((err) => print(err))
              .onError((error, stackTrace) => print(error));
        });
  }

  Message _messageFromFeed(feedData) {
    var data = feedData['new_val'];
    if (_encrytion != null)
      data['contents'] = _encrytion.decrypt(data['contents']);
    return Message.fromJson(data);
  }

  _removeDeliverredMessage(Message message) {
    r
        .table('message')
        .get(message.id)
        .delete({'return_changes': false}).run(_connection);
  }
}
