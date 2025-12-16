import 'package:dun_diary_app/core/error/network/error_mapper.dart';
import 'package:dun_diary_app/core/network/api_state.dart';
import 'package:dun_diary_app/feature/home/data/model/user.dart';
import 'package:dun_diary_app/feature/home/data/repository/user_repository.dart';
import 'package:flutter/foundation.dart';


class HomeViewmodel extends ChangeNotifier {
  ResourceLoading<List<User>> _state = Initial();
  ResourceLoading<List<User>> get state => _state;
  final UserRepository _userRepository = UserRepository();

  Future fetchUser() async {
    _state = Loading();
    notifyListeners();

    try {
      final users =  await _userRepository.getUsers();
      _state = Success(users);
    } catch (e) {
      final errorMessage = ErrorMapper.map(e);
      _state = Error(errorMessage);
    } finally {
      notifyListeners();
    }
  }
}
