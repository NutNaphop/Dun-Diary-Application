import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dun_diary_app/core/network/network_client.dart';
import 'package:dun_diary_app/feature/home/data/model/user.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class UserRepository {
  final Box<User> _userBox = Hive.box<User>('userBox');
  final CollectionReference _firebaseRef = FirebaseFirestore.instance.collection('users');

  final NetworkClient _client = NetworkClient();

  Future<List<User>> getUsers() async {
    // 1. ดึงข้อมูล Local จาก Hive
    final localUsers = _userBox.values.toList();

    try {
      // 2. ดึงข้อมูล Remote (Limit ไว้หน่อยเพราะ /photos มี 5000 รายการ)
      final response = await _client.get('/photos');
      final remoteUsers = (response as List).take(20).map((e) => User.fromJson(e)).toList();
      
      // 3. รวมรายการ (Local + Remote)
      return [...localUsers, ...remoteUsers];
    } catch (e) {
      // ถ้าเน็ตหลุด ให้ส่งค่า Local กลับไปก่อน
      if (localUsers.isNotEmpty) return localUsers;
      rethrow;
    }
  }

  Future<void> createUser(String title, String imageUrl) async {
    // get id as int
    int localId = DateTime.now().millisecondsSinceEpoch;

    final newUser = User(
      id: localId,
      title: title,
      image: imageUrl,
      profile: 'default_profile.png', // ใส่ค่า Default ไปก่อน
      isSynced: false, // เริ่มต้นคือยังไม่ส่ง
    );

    // 1. บันทึกลง Hive ทันที (Offline First)
    await _userBox.add(newUser);
    print("💾 Saved to Hive (ID: $localId)");

    // 2. ลองส่งขึ้น Firebase เลย (ถ้ามีเน็ต)
    await syncUserToFirebase(newUser);
  }

  Future<void> syncUserToFirebase(User user) async {
    // ถ้าเคยส่งแล้ว หรือไม่มีเน็ต ก็ไม่ต้องทำอะไร
    if (user.isSynced) return; 

    try {
      // เช็คเน็ตก่อนนิดนึง (Optional)
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        print("⚠️ No Internet. Waiting for sync...");
        return;
      }

      // ส่งขึ้น Firebase (ใช้ id จากเครื่องเป็น Document ID เลยเพื่อง่ายต่อการหา)
      await _firebaseRef.doc(user.id.toString()).set(user.toJson());

      // ถ้าไม่ Error แปลว่าส่งผ่าน -> กลับมาแก้สถานะใน Hive
      user.isSynced = true;
      await user.save(); // คำสั่ง .save() ของ HiveObject จะอัปเดตตัวมันเองในกล่อง
      
      print("Synced to Firebase Success! (ID: ${user.id})");

    } catch (e) {
      print("Sync Failed: $e");
    }
  }

  Future<void> syncAllPending() async {
    var unsavedUsers = _userBox.values.where((u) => u.isSynced == false);

    if (unsavedUsers.isEmpty) return;

    print("🔄 Found ${unsavedUsers.length} pending items. Syncing...");
    for (var user in unsavedUsers) {
      await syncUserToFirebase(user);
    }
  }

}
