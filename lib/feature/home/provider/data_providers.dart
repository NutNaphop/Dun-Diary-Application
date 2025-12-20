import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dun_diary_app/core/network/network_client.dart';
import 'package:dun_diary_app/feature/home/data/datasource/user_local_data_source.dart';
import 'package:dun_diary_app/feature/home/data/datasource/user_remote_data_source.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get dataHomeProviders {
  return [
    // Local
        Provider<UserLocalDataSource>(
      create: (_) => UserLocalDataSource(Hive.box('userBox')),
    ),

    // Remote
    ProxyProvider<NetworkClient, UserRemoteDataSource>(
      update: (_, networkClient, __) => UserRemoteDataSource(
        firestore: FirebaseFirestore.instance,
        client: networkClient,
      ),
    ),
  ];
}