import 'dart:async';

import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/constant/app_routes.dart';
import 'package:dun_diary_app/core/error/network/error_mapper.dart';
import 'package:dun_diary_app/core/network/api_state.dart';
import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/core/services/dialog_service.dart';
import 'package:dun_diary_app/core/services/navigation_service.dart';
import 'package:dun_diary_app/feature/home/data/model/user.dart';
import 'package:dun_diary_app/feature/home/data/repository/user_repository.dart';
import 'package:flutter/foundation.dart';

class HomeViewmodel extends ChangeNotifier {
  final UserRepository _repository;
  final AuthService _authService;
  final NetworkInfo _networkInfo;

  StreamSubscription? _netSubscription; // ตัวดักฟัง

  HomeViewmodel({
    required UserRepository repo,
    required AuthService authService,
    required NetworkInfo networkInfo,
  }) : _repository = repo,
       _authService = authService,
       _networkInfo = networkInfo {
    _startAutoDetect();
  }

  ResourceLoading<List<User>> _state = Initial();
  ResourceLoading<List<User>> get state => _state;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  bool _hasRecords = false;
  bool get hasRecords => _hasRecords;

  @override
  void dispose() {
    _netSubscription?.cancel();
    super.dispose();
  }

  void _startAutoDetect() {
    _netSubscription = _networkInfo.onConnectivityChanged.listen((
      results,
    ) async {
      // ถ้ามีเน็ตทางใดทางหนึ่ง
      final hasNet = await _networkInfo.isConnected;

      if (hasNet) {
        print("📶 Internet Connected! Checking status...");

        // Step 1: ลอง Login (ถ้ายังไม่ได้ Login)
        // (signInAnonymously ฉลาดพอที่จะไม่ Login ซ้ำถ้ามี User อยู่แล้ว แต่เพื่อความชัวร์เช็คก่อนก็ได้)
        await _authService.signInAnonymously();

        // Step 2: สั่ง Migrate (Repo จะเช็คเองว่ามีข้อมูลต้องย้ายไหม)
        await _repository.migrateData();
        await _repository.syncAllPending();
        notifyListeners(); // รีเฟรชหน้าจอเผื่อข้อมูลเปลี่ยน
      }
    });
  }

  Future fetchUser() async {
    _state = Loading();
    notifyListeners();

    try {
      final users = await _repository.getUsers();
      _state = Success(users);
    } catch (e) {
      final errorMessage = ErrorMapper.map(e);
      _state = Error(errorMessage);
    } finally {
      notifyListeners();
    }
  }

  Future<void> addNewUser(String title) async {
    _isLoading = true;
    notifyListeners();

    await _repository.createUser(title);

    _isLoading = false;

    // รีเฟรชข้อมูลใหม่เพื่อให้ UI แสดงรายการที่เพิ่งเพิ่ม
    fetchUser();

    notifyListeners();
  }

  Future<void> connectOnline() async {
    notifyListeners();
    final user = await _authService.signInAnonymously();
    if (user != null) {
      await _repository.migrateData(); // ย้ายข้อมูล
      fetchUser(); // Refresh UI เผื่อมีอะไรเปลี่ยน
    }
  }

  void toggleHasRecord(){
    _hasRecords = !_hasRecords;
    print(_hasRecords);
    notifyListeners();
  }

  void redirectToRecord(){
    NavigationService.instance.pushNamed(AppRoutes.record); 
    notifyListeners();
  }

  void showDialog(){
    DialogService.instance.showConfirm("Hello", "World");
  }

  notifyListeners();
}
