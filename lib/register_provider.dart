import 'package:dun_diary_app/core/core_providers.dart';
import 'package:dun_diary_app/feature/home/provider/feature_home_provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get appProviders {
  return [
    // 1. Core Services
    ...coreProviders,

    // 2. Feature: Home
    ...featureHomeProviders
  ];
}