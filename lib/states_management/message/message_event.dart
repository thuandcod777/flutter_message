part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  factory MessageEvent.onSubcribed(User user) => Subcribed(user);
  factory MessageEvent.onMessageSent(Message message) => MessageSent(message);

  @override
  List<Object> get props => [];
}

class Subcribed extends MessageEvent {
  final User user;

  const Subcribed(this.user);

  @override
  List<Object> get props => [user];
}

class MessageSent extends MessageEvent {
  final Message message;
  const MessageSent(this.message);

  @override
  List<Object> get props => [message];
}

class MessageRecived extends MessageEvent {
  final Message message;
  const MessageRecived(this.message);

  @override
  List<Object> get props => [message];
}
