import 'package:dun_diary_app/data/blood_pressure/datasource/blood_pressure_local_data_source.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get dataRecordProviders {
  return [
    // Local
        Provider<BloodPressureLocalDataSource>(
      create: (_) => BloodPressureLocalDataSource(),
    ),
  ];
}