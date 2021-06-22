import 'package:chat/src/models/receipt.dart';
import 'package:chat/src/models/user.dart';

abstract class IReceiptService {
  Future<bool> send(Receipt receipt);
  Stream<Receipt> receipt(User user);
  void dispose();
}
