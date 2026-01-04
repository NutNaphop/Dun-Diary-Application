import 'package:dun_diary_app/feature/record/provider/data_providers.dart';
import 'package:dun_diary_app/feature/record/provider/repo_home_provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get featureRecordProviders {
  return [
    // Layer 2: Data Sources (ต้องการ Database/API)
    ...dataRecordProviders,

    // Layer 3: Repositories (ต้องการ Layer 1 และ 2)
    ...repositoryRecordProviders
  ];
}