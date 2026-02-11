import 'package:dun_diary_app/core/core_providers.dart';
import 'package:dun_diary_app/data/providers/repository_providers.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get appProviders {
  return [
    // 1. Core Services
    ...coreProviders,

    // 2. Shared Repositories (Data Layer)
    ...sharedRepositoryProviders,
  ];
}
