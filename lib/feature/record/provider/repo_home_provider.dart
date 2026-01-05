import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dun_diary_app/core/network/network_client.dart';
import 'package:dun_diary_app/data/blood_pressure/datasource/blood_pressure_local_data_source.dart';
import 'package:dun_diary_app/data/blood_pressure/datasource/blood_pressure_remote_data_source.dart';
import 'package:dun_diary_app/data/blood_pressure/repository/blood_pressure_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get repositoryRecordProviders {
  return [
    // 1. Data Sources
    Provider<BloodPressureLocalDataSource>(
      create: (_) => BloodPressureLocalDataSource(),
    ),

    ProxyProvider<NetworkClient, BloodPressureRemoteDataSource>(
      update: (_, client, __) => BloodPressureRemoteDataSource(
        firestore: FirebaseFirestore.instance,
        client: client,
      ),
    ),
    
    // User Repository
    ProxyProvider2<BloodPressureLocalDataSource,BloodPressureRemoteDataSource, BloodPressureRepository>(
      update: (_, local,remote, __) => BloodPressureRepository(
        localDataSource: local,
        remoteDataSource: remote
        ),
    ),
  ];
}
