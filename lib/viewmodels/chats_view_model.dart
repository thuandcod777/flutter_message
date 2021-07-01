import 'package:chat/chat.dart';
import 'package:flutter_message/data/datasources/datasource_contract.dart';
import 'package:flutter_message/models/chat.dart';
import 'package:flutter_message/models/local_message..dart';
import 'package:flutter_message/viewmodels/base_view_model.dart';

class ChatsViewModel extends BaseViewModel {
  IDatasource _datasource;
  IUserService _userService;

  ChatsViewModel(this._datasource, this._userService) : super(_datasource);

  Future<List<Chat>> getChats() async {
    final chats = await _datasource.findAllChats();
    await Future.forEach(chats, (chat) async {
      final user = await _userService.fetch(chat.id);
      chat.from = user;
    });
    return chats;
  }

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.from, message, ReceiptStatus.deliverred);
    await addMessage(localMessage);
  }
}
