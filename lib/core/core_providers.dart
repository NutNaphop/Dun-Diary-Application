import 'package:dun_diary_app/core/auth/provider/auth_provider.dart';
import 'package:dun_diary_app/core/media/provider/media_provider.dart';
import 'package:dun_diary_app/core/network/provider/network_provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get coreProviders {
  return [
    ...authProviders,
    ...networkProviders,
    ...mediaProviders
  ];
}