part of 'typing_notification_bloc.dart';

abstract class TypingNotificationtEvent extends Equatable {
  const TypingNotificationtEvent();
  factory TypingNotificationtEvent.onSubscribed(User user,
          {List<String> userWithChat}) =>
      TypingNotificationtSubcribed(user);
  factory TypingNotificationtEvent.onMessageSent(TypingEvent event) =>
      TypingNotificationtRecived(event);

  @override
  List<Object> get props => [];
}

class TypingNotificationtSubcribed extends TypingNotificationtEvent {
  final User user;
  final List<String> userWithChat;

  const TypingNotificationtSubcribed(this.user, {this.userWithChat});

  @override
  List<Object> get props => [user];
}

class NotSubcribed extends TypingNotificationtEvent {}

class TypingNotificationtSent extends TypingNotificationtEvent {
  final TypingEvent event;
  TypingNotificationtSent(this.event);
  @override
  List<Object> get props => [event];
}

class TypingNotificationtRecived extends TypingNotificationtEvent {
  final TypingEvent event;
  TypingNotificationtRecived(this.event);
  @override
  List<Object> get props => [event];
}
