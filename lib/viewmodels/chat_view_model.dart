import 'package:chat/chat.dart';
import 'package:flutter_message/data/datasources/datasource_contract.dart';
import 'package:flutter_message/models/local_message..dart';
import 'package:flutter_message/viewmodels/base_view_model.dart';

class ChatViewModel extends BaseViewModel {
  IDatasource _datasource;

  String _chatId = '';
  int otherMessages = 0;

  ChatViewModel(this._datasource) : super(_datasource);

  Future<List<LocalMessage>> getMessages(String chatId) async {
    final messages = await _datasource.findMessages(chatId);
    if (messages.isNotEmpty) _chatId = chatId;
    return messages;
  }

  Future<void> sentMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.to, message, ReceiptStatus.sent);

    if (_chatId.isNotEmpty) return await _datasource.addMessage(localMessage);

    _chatId = localMessage.chatId;

    await addMessage(localMessage);
  }

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.from, message, ReceiptStatus.sent);

    if (localMessage.chatId != _chatId) otherMessages++;

    await addMessage(localMessage);
  }
}
