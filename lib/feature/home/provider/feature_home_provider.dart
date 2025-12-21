import 'package:dun_diary_app/feature/home/provider/data_providers.dart';
import 'package:dun_diary_app/feature/home/provider/repo_home_provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get featureHomeProviders {
  return [
    // Layer 2: Data Sources (ต้องการ Database/API)
    ...dataHomeProviders,

    // Layer 3: Repositories (ต้องการ Layer 1 และ 2)
    ...repositoryHomeProviders
  ];
}