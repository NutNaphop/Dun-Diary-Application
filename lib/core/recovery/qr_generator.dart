import 'package:dun_diary_app/core/recovery/qr_encryptor.dart';
import 'package:dun_diary_app/data/user/model/user_profile.dart';

class GenerateQrCodeService {
  GenerateQrCodeService._();

  static String generatePayload(UserProfile user) {
    return QrEncryptorService.encryptData(user.uid);
  }
}
