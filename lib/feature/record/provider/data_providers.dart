import 'package:dun_diary_app/feature/record/data/datasource/record_local_data_source.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get dataRecordProviders {
  return [
    // Local
        Provider<RecordLocalDataSource>(
      create: (_) => RecordLocalDataSource(),
    ),
  ];
}