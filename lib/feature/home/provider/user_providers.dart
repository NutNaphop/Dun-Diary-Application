import 'package:dun_diary_app/feature/home/data/repository/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';


List<SingleChildWidget> get user_providers {
  return [
    Provider<UserRepository>(
      create: (_) => UserRepository(),
    ),
  ];
}