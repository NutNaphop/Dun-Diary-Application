import 'package:dun_diary_app/feature/stat/provider/data_providers.dart';
import 'package:dun_diary_app/feature/stat/provider/repo_stat_provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get featureStatProviders {
  return [
    ...dataStatProviders,
    ...repositoryStatProviders,
  ];
}
