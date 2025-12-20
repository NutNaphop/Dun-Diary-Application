import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/feature/home/data/datasource/user_local_data_source.dart';
import 'package:dun_diary_app/feature/home/data/datasource/user_remote_data_source.dart';
import 'package:dun_diary_app/feature/home/data/repository/user_repository.dart';
import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get repositoryHomeProviders {
  return [
    // User Repository
    ProxyProvider4<
      AuthService,
      NetworkInfo,
      UserLocalDataSource,
      UserRemoteDataSource,
      UserRepository
    >(
      update: (_, auth, net, local, remote, __) => UserRepository(
        authService: auth,
        networkInfo: net,
        localDataSource: local, 
        remoteDataSource: remote,
      ),
    ),
  ];
}
