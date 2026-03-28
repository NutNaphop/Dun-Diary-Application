import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:dun_diary_app/core/network/network_client.dart';
import 'package:dun_diary_app/data/analyze_record/datasource/analyze_local_source.dart';
import 'package:dun_diary_app/data/analyze_record/datasource/analyze_remote_source.dart';
import 'package:dun_diary_app/data/analyze_record/repository/analyze_repository.dart';
import 'package:dun_diary_app/data/blood_pressure/datasource/blood_pressure_local_data_source.dart';
import 'package:dun_diary_app/data/blood_pressure/datasource/blood_pressure_remote_data_source.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:dun_diary_app/data/user/datasource/user_local_data_source.dart';
import 'package:dun_diary_app/data/user/datasource/user_remote_data_source.dart';
import 'package:dun_diary_app/data/user/repository/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get sharedRepositoryProviders {
  return [
    // =========================================================================
    // Blood Pressure Feature (Shared)
    // =========================================================================

    // 1. Data Sources
    Provider<BloodPressureLocalDataSource>(
      create: (_) => BloodPressureLocalDataSource(),
    ),

    ProxyProvider<NetworkClient, BloodPressureRemoteDataSource>(
      update: (_, client, __) =>
          BloodPressureRemoteDataSource(firestore: FirebaseFirestore.instance),
    ),

    // 2. Repository
    ProxyProvider3<
      BloodPressureLocalDataSource,
      BloodPressureRemoteDataSource,
      AuthService,
      BloodPressureRepository
    >(
      update: (_, local, remote, auth, __) => BloodPressureRepository(
        localDataSource: local,
        remoteDataSource: remote,
        authService: auth,
      ),
    ),

    // =========================================================================
    // Analyze Feature (Shared)
    // =========================================================================

    // 1. Data Sources
    Provider<AnalyzeLocalDataSource>(create: (_) => AnalyzeLocalDataSource()),

    ProxyProvider2<NetworkClient, AuthService, AnalyzeRemoteDataSource>(
      update: (_, client, auth, __) => AnalyzeRemoteDataSource(client, auth),
    ),

    // 2. Repository
    ProxyProvider2<
      AnalyzeLocalDataSource,
      AnalyzeRemoteDataSource,
      AnalyzeRepository
    >(update: (_, local, remote, __) => AnalyzeRepository(local, remote)),

    // =========================================================================
    // User Feature (Shared)
    // =========================================================================

    // 1. Data Sources
    Provider<UserLocalDataSource>(create: (_) => UserLocalDataSource()),
    Provider(create: (c) => UserRemoteDataSource(FirebaseFirestore.instance)),

    // 2. Repository
    ProxyProvider2<UserLocalDataSource, UserRemoteDataSource, UserRepository>(
      update: (_, local, remote, __) =>
          UserRepository(localDataSource: local, remoteDataSource: remote),
    ),
  ];
}
