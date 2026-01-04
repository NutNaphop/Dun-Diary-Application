import 'package:dun_diary_app/feature/record/data/datasource/record_local_data_source.dart';
import 'package:dun_diary_app/feature/record/data/repository/record_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get repositoryRecordProviders {
  return [
    // User Repository
    ProxyProvider<RecordLocalDataSource, RecordRepository>(
      update: (_, local, __) => RecordRepository(localDataSource: local),
    ),
  ];
}
