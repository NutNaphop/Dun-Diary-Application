import 'package:dun_diary_app/core/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get authProviders {
  return [
    Provider<AuthService>(create: (_) => AuthService()),
  ];
}