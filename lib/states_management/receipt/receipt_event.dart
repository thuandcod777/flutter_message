part of 'receipt_bloc.dart';

abstract class ReceiptEvent extends Equatable {
  const ReceiptEvent();
  factory ReceiptEvent.onSubscribed(User user) => ReceiptSubcribed(user);
  factory ReceiptEvent.onMessageSent(Receipt receipt) =>
      ReceiptRecived(receipt);

  @override
  List<Object> get props => [];
}

class ReceiptSubcribed extends ReceiptEvent {
  final User user;

  const ReceiptSubcribed(this.user);

  @override
  List<Object> get props => [user];
}

class ReceiptSent extends ReceiptEvent {
  final Receipt receipt;
  ReceiptSent(this.receipt);
  @override
  List<Object> get props => [receipt];
}

class ReceiptRecived extends ReceiptEvent {
  final Receipt receipt;
  ReceiptRecived(this.receipt);
  @override
  List<Object> get props => [receipt];
}
