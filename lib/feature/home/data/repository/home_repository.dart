import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/feature/home/data/datasource/user_local_data_source.dart';
import 'package:dun_diary_app/feature/home/data/datasource/user_remote_data_source.dart';

class HomeRepository {
  final AuthService _authService;
  final NetworkInfo _networkInfo;

  final UserLocalDataSource _localDataSource;
  final UserRemoteDataSource _remoteDataSource;

  HomeRepository({
    required AuthService authService,
    required NetworkInfo networkInfo,
    required UserLocalDataSource localDataSource,
    required UserRemoteDataSource remoteDataSource,
  }) : _authService = authService,
       _networkInfo = networkInfo,
       _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  void recordBloodPressure(){
    
  }
}
