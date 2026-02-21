import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:dun_diary_app/core/services/app_logger.dart';

class QrEncryptorService {
  QrEncryptorService._();

  static final _key = encrypt.Key.fromUtf8('DunDiarySecretKey2026_SecureData');
  static final _iv = encrypt.IV.fromUtf8('DunDiaryInitVect');
  static final _encrypter = encrypt.Encrypter(
    encrypt.AES(_key, mode: encrypt.AESMode.cbc),
  );

  static String encryptData(String plainText) {
    try {
      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e, stackTrace) {
      AppLogger.error("❌ Encryption Error: $e", stackTrace);
      return "";
    }
  }

  static String? decryptData(String encryptedBase64) {
    try {
      final encrypted = encrypt.Encrypted.fromBase64(encryptedBase64);
      final decrypted = _encrypter.decrypt(encrypted, iv: _iv);
      return decrypted;
    } catch (e, stackTrace) {
      AppLogger.error("❌ Decryption Error: $e", stackTrace);
      return null;
    }
  }
}
