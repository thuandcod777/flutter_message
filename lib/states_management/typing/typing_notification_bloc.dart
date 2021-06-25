import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

part 'typing_notification_state.dart';
part 'typing_notification_event.dart';

class ReceiptBloc
    extends Bloc<TypingNotificationtEvent, TypingNotificationState> {
  final ITypingNotification _typingNotificationService;
  StreamSubscription _subscription;

  ReceiptBloc(this._typingNotificationService)
      : super(TypingNotificationState.initial());

  @override
  Stream<TypingNotificationState> mapEventToState(
      TypingNotificationtEvent typingEvent) async* {
    if (typingEvent is TypingNotificationtSubcribed) {
      if (typingEvent.userWithChat == null) {
        add(NotSubcribed());
        return;
      }
      await _subscription?.cancel();
      _subscription = _typingNotificationService
          .subscribe(typingEvent.user, typingEvent.userWithChat)
          .listen(
              (typingEvent) => add(TypingNotificationtRecived(typingEvent)));
    }

    if (typingEvent is TypingNotificationtRecived) {
      yield TypingNotificationState.received(typingEvent.event);
    }

    if (typingEvent is TypingNotificationtSent) {
      await _typingNotificationService.send(event: typingEvent.event);
      yield TypingNotificationState.sent();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _typingNotificationService.dispose();
    return super.close();
  }
}
