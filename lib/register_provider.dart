import 'package:dun_diary_app/feature/home/provider/user_providers.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get app_providers {
  // Import user_providers from user_provider.dart
  return [
    ...user_providers,
  ];
}

