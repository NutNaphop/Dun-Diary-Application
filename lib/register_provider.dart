import 'package:dun_diary_app/core/core_providers.dart';
import 'package:dun_diary_app/feature/record/provider/feature_record_provider.dart';
import 'package:dun_diary_app/feature/stat/provider/feature_record_provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get appProviders {
  return [
    // 1. Core Services
    ...coreProviders,

    // 2. Feature: Record
    ...featureRecordProviders,
    ...featureStatProviders,
  ];
}
