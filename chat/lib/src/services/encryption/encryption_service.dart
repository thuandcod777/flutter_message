import 'package:chat/src/services/encryption/encryption_contract.dart';
import 'package:encrypt/encrypt.dart';

class EncryptionService implements IEncrytion {
  final Encrypter _encrypter;
  final iV = IV.fromLength(16);

  EncryptionService(this._encrypter);

  @override
  String decrypt(String encrytedText) {
    //final key = Key.fromBase64(encrytedText);
    //final encrypted = Encrypter(AES(key));
    final encrypted = Encrypted.fromBase64(encrytedText);

    ///final encrypted = decryptEncrypted.fromBase64(encrytedText);

    //final encrypted = decryptEncrypted.fromBase64(encrytedText);

    return _encrypter.decrypt(encrypted, iv: iV);
  }

  @override
  String encrypt(String text) {
    return _encrypter.encrypt(text, iv: iV).base64;
  }
}
