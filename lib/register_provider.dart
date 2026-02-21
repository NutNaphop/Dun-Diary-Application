import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/auth/provider/global_user_provider.dart';
import 'package:dun_diary_app/core/core_providers.dart';
import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/core/services/sync_service.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/data/providers/repository_providers.dart';
import 'package:dun_diary_app/data/user/repository/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get appProviders {
  return [
    // 1. Core Services
    ...coreProviders,

    // 2. Shared Repositories (Data Layer)
    ...sharedRepositoryProviders,

    // 3. Global Services (depends on repos + core)
    ChangeNotifierProvider<GlobalUserProvider>(
      create: (context) =>
          GlobalUserProvider(userRepository: context.read<UserRepository>()),
    ),

    ProxyProvider4<
      NetworkInfo,
      AuthService,
      BloodPressureRepository,
      UserRepository,
      SyncService
    >(
      update: (_, networkInfo, authService, repository, userRepository, __) =>
          SyncService(
            networkInfo: networkInfo,
            authService: authService,
            repository: repository,
            userRepository: userRepository,
          ),
      lazy: false, // Create immediately
    ),
  ];
}
