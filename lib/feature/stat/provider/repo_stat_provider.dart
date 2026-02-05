import 'package:dun_diary_app/core/network/network_client.dart';
import 'package:dun_diary_app/data/analyze_record/datasource/analyze_local_source.dart';
import 'package:dun_diary_app/data/analyze_record/datasource/analyze_remote_source.dart';
import 'package:dun_diary_app/data/analyze_record/repository/analyze_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get repositoryStatProviders {
  return [
    // 1. Data Sources
    Provider<AnalyzeLocalDataSource>(create: (_) => AnalyzeLocalDataSource()),

    ProxyProvider<NetworkClient, AnalyzeRemoteDataSource>(
      update: (_, client, __) => AnalyzeRemoteDataSource(client),
    ),

    // User Repository
    ProxyProvider2<
      AnalyzeLocalDataSource,
      AnalyzeRemoteDataSource,
      AnalyzeRepository
    >(update: (_, local, remote, __) => AnalyzeRepository(local, remote)),
  ];
}
