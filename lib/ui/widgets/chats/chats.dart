import 'package:flutter/material.dart';
import 'package:flutter_message/colors.dart';
import 'package:flutter_message/models/chat.dart';
import 'package:flutter_message/states_management/home/chats_cutbit.dart';
import 'package:flutter_message/states_management/message/message_bloc.dart';
import 'package:flutter_message/theme.dart';
import 'package:flutter_message/ui/widgets/home/profile_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Chats extends StatefulWidget {
  const Chats();

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  var chats = [];
  @override
  void initState() {
    super.initState();
    _updateChatsOnMessageReceived();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, List<Chat>>(builder: (_, chats) {
      this.chats = chats;
      return buildListView();
    });
  }

  buildListView() {
    return ListView.separated(
      padding: EdgeInsets.only(top: 30.0, right: 16.0),
      itemBuilder: (_, index) => _chatItem(chats[index]),
      separatorBuilder: (_, __) => Divider(),
      itemCount: chats.length,
    );
  }

  _chatItem(Chat chat) => ListTile(
        leading: ProfileImage(
          imageUrl: chat.from.photoUrl,
          online: chat.from.active,
        ),
        title: Text(
          chat.from.username,
          style: Theme.of(context).textTheme.subtitle2.copyWith(
              fontWeight: FontWeight.bold,
              color: isLightTheme(context) ? Colors.black : Colors.white),
        ),
        subtitle: Text(
          chat.mostRecent.message.contents,
          maxLines: 2,
          style: Theme.of(context).textTheme.overline.copyWith(
              color: isLightTheme(context) ? Colors.black54 : Colors.white,
              fontWeight:
                  chat.unread > 0 ? FontWeight.bold : FontWeight.normal),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormat('h:mm a').format(chat.mostRecent.message.timestamp),
              style: Theme.of(context).textTheme.overline.copyWith(
                  color: isLightTheme(context) ? Colors.black54 : Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: chat.unread > 0
                    ? Container(
                        height: 15.0,
                        width: 15.0,
                        color: kPrimary,
                        alignment: Alignment.center,
                        child: Text(chat.unread.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .overline
                                .copyWith(color: Colors.white)),
                      )
                    : Container(),
              ),
            )
          ],
        ),
      );

  _updateChatsOnMessageReceived() {
    final chatsCubit = context.read<ChatsCubit>();
    context.read<MessageBloc>().stream.listen((state) async {
      if (state is MessageReceivedSucess) {
        await chatsCubit.viewModel.receivedMessage(state.message);
        chatsCubit.chats();
      }
    });
  }
}
