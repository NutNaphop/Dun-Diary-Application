import 'package:dun_diary_app/core/network/network_client.dart';
import 'package:dun_diary_app/feature/home/data/model/user.dart';

class UserRepository {
  final NetworkClient _client = NetworkClient();

  Future<List<User>> getUsers() async {
    final response = await _client.get('/photos');
      return (response as List).map((e) => User.fromJson(e)).toList();
  }
}
