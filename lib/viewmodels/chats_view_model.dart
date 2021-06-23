import 'package:chat/chat.dart';
import 'package:flutter_message/data/datasources/datasource_contract.dart';
import 'package:flutter_message/models/chat.dart';
import 'package:flutter_message/models/local_message..dart';
import 'package:flutter_message/viewmodels/base_view_model.dart';

class ChatsViewModel extends BaseViewModel {
  IDatasource _datasource;

  ChatsViewModel(this._datasource) : super(_datasource);

  Future<List<Chat>> getChats() async => await _datasource.findAllChats();

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.from, message, ReceiptStatus.deliverred);
    await addMessage(localMessage);
  }
}
