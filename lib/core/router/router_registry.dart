import 'package:dun_diary_app/core/router/feature_router.dart';
import 'package:flutter/material.dart';

class RouterRegistry {
  static final RouterRegistry instance = RouterRegistry._();
  RouterRegistry._();

  final List<FeatureRouter> _routers = [];

  void register(FeatureRouter router) {
    _routers.add(router);
  }

  Route<dynamic>? generateRoute(RouteSettings settings) {
    for (final router in _routers) {
      final route = router.getRoute(settings);
      if (route != null) return route;
    }
    return null;
  }
}
