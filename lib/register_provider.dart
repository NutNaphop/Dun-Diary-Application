import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/core_providers.dart';
import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:dun_diary_app/core/services/sync_service.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/data/providers/repository_providers.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get appProviders {
  return [
    // 1. Core Services
    ...coreProviders,

    // 2. Shared Repositories (Data Layer)
    ...sharedRepositoryProviders,

    // 3. Global Services (depends on repos + core)
    ProxyProvider3<
      NetworkInfo,
      AuthService,
      BloodPressureRepository,
      SyncService
    >(
      update: (_, networkInfo, authService, repository, __) => SyncService(
        networkInfo: networkInfo,
        authService: authService,
        repository: repository,
      ),
      lazy: false, // Create immediately
    ),
  ];
}
