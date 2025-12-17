import 'package:dun_diary_app/core/error/network/error_mapper.dart';
import 'package:dun_diary_app/core/network/api_state.dart';
import 'package:dun_diary_app/feature/home/data/model/user.dart';
import 'package:dun_diary_app/feature/home/data/repository/user_repository.dart';
import 'package:flutter/foundation.dart';

class HomeViewmodel extends ChangeNotifier {
  final UserRepository _repository;

  HomeViewmodel({required UserRepository repository}) : _repository = repository {
    fetchUser();
    syncPendingData();
  }

  ResourceLoading<List<User>> _state = Initial();
  ResourceLoading<List<User>> get state => _state;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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

  Future<void> addNewUser(String title, String imageUrl) async {
    _isLoading = true;
    notifyListeners();

    await _repository.createUser(title, imageUrl);

    _isLoading = false;
    notifyListeners();

    // รีเฟรชข้อมูลใหม่เพื่อให้ UI แสดงรายการที่เพิ่งเพิ่ม
    fetchUser();
  }

  void syncPendingData() {
    _repository.syncAllPending();
  }


}
