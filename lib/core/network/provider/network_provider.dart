import 'package:dun_diary_app/core/network/network_client.dart';
import 'package:dun_diary_app/core/network/network_info.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

List<SingleChildWidget> get networkProviders {
  return [
    Provider<NetworkClient>(create: (_) => NetworkClient()),
    Provider<NetworkInfo>(
      create: (_) => NetworkInfoImpl(Connectivity()),
    ),
  ];
}
