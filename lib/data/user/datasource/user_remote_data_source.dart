import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dun_diary_app/core/services/app_logger.dart';
import '../model/user_profile.dart';

class UserRemoteDataSource {
  final FirebaseFirestore _firestore;

  UserRemoteDataSource(this._firestore);

  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserProfile.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      AppLogger.error("❌ Remote Get User Error: $e");
      rethrow;
    }
  }

  Future<void> saveUserProfile(UserProfile user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(user.toJson(), SetOptions(merge: true));
      AppLogger.debug("✅ Remote Save User Success");
    } catch (e) {
      AppLogger.error("❌ Remote Save User Error: $e");
      rethrow;
    }
  }

  /// ลบ user data ทั้งหมดจาก Firestore (ใช้ตอน Recovery cleanup)
  Future<void> deleteUserData(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      AppLogger.debug("✅ Deleted user data for $uid");
    } catch (e) {
      AppLogger.error("❌ Failed to delete user data: $e");
      rethrow;
    }
  }
}
